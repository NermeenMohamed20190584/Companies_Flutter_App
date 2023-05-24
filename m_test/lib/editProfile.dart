import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:m_test/profile.dart';

class EditProfileScreen extends StatefulWidget {
  String email;
  EditProfileScreen({Key? key, required this.email}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _locationController = TextEditingController();
  String? _companySize;
  final List<String> _companyIndustries = [];
  late String _password;

  File? _imageFile;

  get email => null;

  void _addCompanyIndustry(String industry) {
    setState(() {
      _companyIndustries.add(industry);
    });
  }

  void _removeCompanyIndustry(String industry) {
    setState(() {
      _companyIndustries.remove(industry);
    });
  }

  void _selectImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _selectImageFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Please select an image.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
        return;
      }

      // Convert image file to bytes
      List<int> imageBytes = await _imageFile!.readAsBytes();

      // Create multipart request for uploading image
      var uri = Uri.parse('http://192.168.1.5:8080/flutterAPI/editprofile.php');
      var request = http.MultipartRequest('POST', uri);
      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'image.jpg',
      );
      request.files.add(multipartFile);

      // Send profile data to server using http plugin
      final response = await request.send();
      if (response.statusCode == 200) {
        // handle successful response
        // e.g. navigate to a success page
        print('success');
      } else {
        // handle error response
        // e.g. show an error message to the user
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save profile. Please try again later.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Edit Profile'),
    ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 120.0,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Choose from Gallery'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _selectImageFromGallery();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Take a Photo'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _selectImageFromCamera();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 64.0,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : const AssetImage('assets/default_profile_photo.png') as ImageProvider,
                      child: Icon(
                        Icons.add_photo_alternate,
                        size: 48.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _companyNameController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
                  ),


                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _contactNameController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Person Name',
                  ),

                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Company Industry',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    CheckboxListTile(
                      title: const Text('Industry 1'),
                      value: _companyIndustries.contains('Industry 1'),
                      onChanged: (value) {
                        if (value!) {
                          _addCompanyIndustry('Industry 1');
                        } else {
                          _removeCompanyIndustry('Industry 1');
                        }
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Industry 2'),
                      value: _companyIndustries.contains('Industry 2'),
                      onChanged: (value) {
                        if (value!) {
                          _addCompanyIndustry('Industry 2');
                        } else {
                          _removeCompanyIndustry('Industry 2');
                        }
                      },
                    ),

                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Person Phone Number',
                  ),

                ),

                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),

                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                  ),

                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },

                ),


                const SizedBox(height: 24.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Save Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}