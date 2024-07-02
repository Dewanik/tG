import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageTripsPage extends StatefulWidget {
  @override
  _ManageTripsPageState createState() => _ManageTripsPageState();
}

class _ManageTripsPageState extends State<ManageTripsPage> {
  final user_id = Supabase.instance.client.auth.currentUser?.id;
  final _formKey = GlobalKey<FormState>();
  final _tripNameController = TextEditingController();
  final _tripDescriptionController = TextEditingController();
  final _packageIncludesController = TextEditingController();
  final _costPerPersonController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? _selectedCategory;
  List<String> _categories = ['Adventure', 'Leisure', 'Business', 'Cultural'];
  List<XFile>? _imageFiles = [];

  final supabaseClient = Supabase.instance.client;

  Future<void> _addTrip() async {
    var user = supabaseClient.auth.currentUser;

    if (user == null) {
      user = await _authenticateUser();
      if (user == null) {
        return; // If authentication failed, do not proceed
      }
    }

    if (_formKey.currentState?.validate() ?? false) {
      List<Map<String, dynamic>> imageBlobs = [];
      for (var file in _imageFiles!) {
        String fileName = path.basename(file.path);
        File fileToUpload = File(file.path);
        try {
          print(fileName);
          final response = supabaseClient.storage.from("storage").upload(fileName, fileToUpload);
          if (response == null) {
            final publicUrlResponse = supabaseClient.storage.from('storage').getPublicUrl(fileName);
            
            if (publicUrlResponse == null){
              imageBlobs.add({'path':"Error not found !"});
            }else{
            imageBlobs.add({'path': publicUrlResponse});
            }
          } else {
            print('Error uploading file: ${response}');
          }
        } catch (e) {
          print('Exception during file upload: $e');
        }
      }

      var tripDetails = {
        "name": _tripNameController.text,
        "description": _tripDescriptionController.text,
        "category": _selectedCategory,
        "includes": _packageIncludesController.text,
        "cost_per_person": int.parse(_costPerPersonController.text),
        "images": imageBlobs,
        "user_id": user.id,  // Add user ID here
      };

      var dataToSend = {
        'trip_details': tripDetails,
        'user': user_id
      };

      print("Data being sent to Supabase: ${jsonEncode(dataToSend)}");

      try {
        final response = await supabaseClient.from('guide_trips').insert(dataToSend);
        if (response.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trip added successfully!')),
          );
        } else {
          print("Error adding trip: ${response.error?.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add trip: ${response.error?.message}')),
          );
        }
      } catch (error) {
        print("Error adding trip: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add trip: $error')),
        );
      }
    }
  }

  Future<User?> _authenticateUser() async {
    try {
      // Prompt user for email and password (this is a simple example, consider a better UI for real applications)
      String? email = "kdewanik@gmail.com";
      String? password = "abcdefgh";

      if (email != null && password != null) {
        final response = await supabaseClient.auth.signInWithPassword(email: email, password: password);
        if (response.user != null) {
          return response.user;
        } else {
          print('Error signing in: ${response}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to sign in: ${response}')),
          );
        }
      }
    } catch (e) {
      print('Exception during authentication: $e');
    }
    return null;
  }

  Future<void> _selectImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _imageFiles = selectedImages;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Images selected successfully!')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles?.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Trips'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _tripNameController,
                decoration: InputDecoration(labelText: 'Trip Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter trip name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Category'),
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tripDescriptionController,
                decoration: InputDecoration(labelText: 'Trip Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter trip description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _packageIncludesController,
                decoration: InputDecoration(labelText: 'Package Includes'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter package details';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _costPerPersonController,
                decoration: InputDecoration(labelText: 'Cost per Person'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cost per person';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _selectImages,
                child: Text('Select Trip Images'),
              ),
              SizedBox(height: 20.0),
              _imageFiles != null && _imageFiles!.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _imageFiles!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.file(
                            File(_imageFiles![index].path),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(path.basename(_imageFiles![index].path)),
                          trailing: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => _removeImage(index),
                          ),
                        );
                      },
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _addTrip,
                child: Text('Add Trip'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tripNameController.dispose();
    _tripDescriptionController.dispose();
    _packageIncludesController.dispose();
    _costPerPersonController.dispose();
    super.dispose();
  }
}
