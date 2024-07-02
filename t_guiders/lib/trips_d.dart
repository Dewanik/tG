import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'db.dart';

class TripDetailPage extends StatefulWidget {
  final Map<String,dynamic> trip;

  const TripDetailPage({Key? key, required this.trip}) : super(key: key);

  @override
  _TripDetailPageState createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _tripDescriptionController = TextEditingController();
  final _packageIncludesController = TextEditingController();
  final _costPerPersonController = TextEditingController();
  final _numPeopleAllowedController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles = [];

  @override
  void initState() {
    super.initState();
    _tripDescriptionController.text = widget.trip['description'] ?? '';
    _packageIncludesController.text = widget.trip['includes'] ?? '';
    _costPerPersonController.text = widget.trip['cost_per_person'] ?? '';
    _numPeopleAllowedController.text = widget.trip['num_people_allowed'] ?? '';
  }

  void _updateTrip() {
    if (_formKey.currentState?.validate() ??  false) {
      List<Map<String, dynamic>> imageBlobs = _imageFiles!.map((file) => {'path': file.path}).toList();
      var tripDetails = {
        "name": widget.trip['name'],
        "description": _tripDescriptionController.text,
        "category": widget.trip['category'],
        "includes": _packageIncludesController.text,
        "cost_per_person": int.tryParse(_costPerPersonController.text) ?? 0,
        "num_people_allowed": int.tryParse(_numPeopleAllowedController.text) ?? 0,
        "images": imageBlobs,
      };

      var supabaseClient = SupabaseC();
      supabaseClient.updateData(
        'guide_trips',
        tripDetails,
        widget.trip['createdAt'],
        conditionColumn: 'name',
        conditionValue: widget.trip['name'],
      ).then((response) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Trip updated successfully!')));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update trip: $error')));
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
              ElevatedButton(onPressed: _selectImages, child: const Text('Select Trip Images')),
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

  @override
  void dispose() {
    _tripDescriptionController.dispose();
    _packageIncludesController.dispose();
    _costPerPersonController.dispose();
    _numPeopleAllowedController.dispose();
    super.dispose();
  }
}
