import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Add this import
import 'db.dart';
import 'tG.dart';
import 'package:path/path.dart' as path;
class TripDetailPage extends StatelessWidget {
  final Map<String, dynamic> trip;

  const TripDetailPage({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TripDetailP(trip: trip));
  }
}

class TripDetailP extends ConsumerStatefulWidget {
  final Map<String, dynamic> trip;

  const TripDetailP({Key? key, required this.trip}) : super(key: key);

  @override
  _TripDetailPState createState() => _TripDetailPState();
}

class _TripDetailPState extends ConsumerState<TripDetailP> {
  final _formKey = GlobalKey<FormState>();
  final _tripDescriptionController = TextEditingController();
  final _packageIncludesController = TextEditingController();
  final _costPerPersonController = TextEditingController();
  final _numPeopleAllowedController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles = [];
  List<String> _currentImages = [];
  List<LatLng>? _initialMarkers;
  List<String> _toRemoveImages = [];
  


  @override
  void initState() {
    super.initState();
    _tripDescriptionController.text = widget.trip['description'] ?? '';
    _packageIncludesController.text = widget.trip['includes'] ?? '';
    _costPerPersonController.text = widget.trip['cost_per_person'].toString() ?? '';
    _numPeopleAllowedController.text = widget.trip['total_people_allowed'].toString() ?? '';

 // Initialize _currentImages correctly based on the actual format
  if (widget.trip['images'] != null || widget.trip['images'] is List) {
    _currentImages = List<String>.from(widget.trip['images'].map((image) {
      if (image is String) {
        return image;
      } else {
        throw Exception('Unexpected image format: $image');
      }
    }));
  } else {
    _currentImages = [];
  }

    if (widget.trip['markers'] != null) {
      _initialMarkers = List<LatLng>.from(widget.trip['markers'].map((marker) => LatLng(marker['latitude'], marker['longitude'])));
    }
  }

  Future<void> _updateTrip() async {
    if (_formKey.currentState?.validate() ?? false) {
      final supabaseClient = Supabase.instance.client;
      if(_toRemoveImages != null && _toRemoveImages!.isNotEmpty){
      // Remove images from storage
         supabaseClient.storage.from("storage").remove(_toRemoveImages);
      }
      
      // Upload new images to storage and get their URLs
      List<String> imageUrls = await Future.wait(_imageFiles!.map((file) async {
        final response = await supabaseClient.storage.from("storage").upload(file.path, File(file.path));
        return supabaseClient.storage.from("storage").getPublicUrl(path.basename(file.path));
      }));
      

       
       
      var tripDetails = {
        "name": widget.trip['name'],
        "description": _tripDescriptionController.text,
        "category": widget.trip['category'],
        "includes": _packageIncludesController.text,
        "cost_per_person": int.tryParse(_costPerPersonController.text) ?? 0,
        "total_people_allowed": int.tryParse(_numPeopleAllowedController.text) ?? 0,
        "images": imageUrls + _currentImages,
        "user_id": widget.trip['user_id'],
        "markers": ref.watch(markerProvider).map((marker) => {
        'latitude': marker.point.latitude,
        'longitude': marker.point.longitude,
      }).toList(),
      };

print(tripDetails);  
supabaseClient
  .from('guide_trips')
  .update({'trip_details':tripDetails})
  .eq('created_at', widget.trip['created_at'])
  .eq('user', widget.trip['user_id'])
  .contains('trip_details', {'name': widget.trip['name']})
  .then((response) {
    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trip updated successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update trip: ${response.error!.message}')));
    print(response);
    }
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update trip: $error')));
    print(error);
  });


    }
  }

  Future<void> _selectImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _imageFiles = selectedImages;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Images selected successfully!')));
    }
  }

  void _removeCurrentImage(int index) {
    setState(() {
      _toRemoveImages.add(_currentImages[index]);
      _currentImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildTextFormField(_tripDescriptionController, 'Trip Description'),
              _buildTextFormField(_packageIncludesController, 'Package Includes'),
              _buildTextFormField(_costPerPersonController, 'Cost per Person', isNumeric: true),
              _buildTextFormField(_numPeopleAllowedController, 'Number of People Allowed', isNumeric: true),
              SizedBox(height: 20.0),
              _buildCurrentImages(),
              SizedBox(height: 20.0),
              ElevatedButton(onPressed: _selectImages, child: const Text('Select Trip Images')),
              SizedBox(height: 20.0),
              SizedBox(height: 200, width: 200, child: TGMaps(initialMarkers: _initialMarkers)), // Add this line to include the map
              SizedBox(height: 20.0),
              ElevatedButton(onPressed: _updateTrip, child: const Text('Update Trip')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $label';
        if (isNumeric && int.tryParse(value) == null) return 'Please enter a valid number';
        return null;
      },
    );
  }

  Widget _buildCurrentImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Current Images:'),
        SizedBox(height: 10.0),
        Wrap(
          spacing: 10.0,
          children: List.generate(_currentImages.length, (index) {
            return Stack(
              children: [
                Image.network(_currentImages[index], width: 100, height: 100, fit: BoxFit.cover),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () => _removeCurrentImage(index),
                    child: Container(
                      color: Colors.black54,
                      child: Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tripDescriptionController.dispose();
    _packageIncludesController.dispose();
    _costPerPersonController.dispose();
    _numPeopleAllowedController.dispose();
    super.dispose();
  }
}
