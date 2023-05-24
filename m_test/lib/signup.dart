import 'package:flutter/material.dart';
import 'package:m_test/login.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:core';
import 'dart:convert';

import 'package:m_test/map.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController e1 = new TextEditingController();
  TextEditingController e2 = new TextEditingController();
  TextEditingController e3 = new TextEditingController();
  TextEditingController e4 = new TextEditingController();
  TextEditingController e5 = new TextEditingController();
  TextEditingController e6 = new TextEditingController();
  TextEditingController e7 = new TextEditingController();
  TextEditingController e8 = new TextEditingController();
  TextEditingController e9 = new TextEditingController();


  String? _companyName;
  String? _contactPersonName;
  String? _contactPersonPhoneNumber;
  String? _email;
  String? _companyAddress;
  LatLng? _companyLocation;
  String? _companySize;
  String? _password;
  String? _confirmPassword;

  final List<String> _companyIndustries = [
    'Industry 1',
    'Industry 2',
    'Industry 3',
    'Industry 4',
    'Industry 5'
  ];
  final List<String> _selectedCompanyIndustries = [];

  void _handleCompanyIndustryCheckbox(bool value, String industry) {
    setState(() {
      if (value) {
        _selectedCompanyIndustries.add(industry);
        //return industry;
      } else {
        _selectedCompanyIndustries.remove(industry);
      }
    });




  }


  Future<bool> signup() async {
    try {
      var response = await http.post(Uri.parse("http://192.168.1.5:8080/flutterAPI/signup.php"), body: {
        "company_name": e1.text,
        "contact_person_name": e2.text,
        "contact_person_phone": e3.text,
        "email": e4.text,
        "company_address": e5.text,
        "company_location": e6.text,
        "password": e7.text,
        "company_size": _companySize,
        "company_industry": _selectedCompanyIndustries.toString(),
      });
      var jsonString = response.body.substring(response.body.indexOf('{'));
      var data = jsonDecode(jsonString);

      if (data != null && data.containsKey('result')) {
        if (data['result'] == true) {
          print("good");
          return true;
        } else {
          print("bad");
          return false;
        }
      } else {
        // Handle the case where data doesn't have the expected structure
        print("Invalid response data");
        return false;
      }
    } catch (e) {
      print(e);
      // handle the exception
      return false;
    }
  }


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Check the signup conditions


      // Stop the form submission
      signup();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return;
      // Add more conditions as needed
      // TODO: Submit the form data to the server and handle the response
      //print('Form submitted');
    }

  }
  LatLng? _selectedLocation;

  void _onLocationSelected(LatLng location) {
    setState(() {
      _selectedLocation = location;
      e6.text = "${location.longitude}, ${location.latitude}";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white, // Set background color
      appBar: AppBar(
        title: const Text('Signup Screen'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TextFormField(
                controller: e1,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Company Name is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _companyName = value!;
                },
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TextFormField(
                controller: e2,
                decoration: const InputDecoration(
                  labelText: 'Contact Person Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Contact Person Name is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contactPersonName = value!;
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text('Company Industry'),
            Wrap(
              children: _companyIndustries
                  .map(
                    (industry) =>
                    CheckboxListTile(
                      title: Text(industry),
                      value: _selectedCompanyIndustries.contains(industry),
                      onChanged: (value) =>
                          _handleCompanyIndustryCheckbox(value!, industry),
                    ),
              )
                  .toList(),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TextFormField(
                controller: e3,
                decoration: const InputDecoration(
                  labelText: 'Contact Person Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  final phoneRegex = RegExp(r'^\d{11}$');
                  if (value == null || value.isEmpty) {
                    return 'Contact Person Phone Number is required';
                  } else if (!phoneRegex.hasMatch(value)) {
                    return 'Invalid Phone Number';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSaved: (value) {
                  _contactPersonPhoneNumber = value!;
                },
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TextFormField(
                controller: e4,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  final emailRegex = RegExp(r'^\S+@\S+\.\S+$');
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  } else if (!emailRegex.hasMatch(value)) {
                    return 'Invalid Email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  _email = value!;
                },
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TextFormField(
                controller: e5,
                decoration: const InputDecoration(
                  labelText: 'Company Address',
                  prefixIcon: Icon(Icons.location_pin),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Company Address is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _companyAddress = value!;
                },
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TextFormField(
                controller: e6,
                decoration: InputDecoration(
                  labelText: 'Company Location [Long. - Lat.]',
                  prefixIcon: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => mapPage(onLocationSelected: _onLocationSelected)),
                      );
                    },
                    child: Icon(Icons.map),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Company Location is required';
                  } else {
                    final coordinates = value.split(', ');
                    if (coordinates.length != 2) {
                      return 'Invalid Company Location';
                    }
                    try {
                      final longitude = double.parse(coordinates[0]);
                      final latitude = double.parse(coordinates[1]);
                      _companyLocation = LatLng(latitude, longitude);
                    } catch (error) {
                      return 'Invalid Company Location';
                    }
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(

              borderRadius: BorderRadius.circular(10),
              child: DropdownButtonFormField<String>(

                decoration: const InputDecoration(
                  labelText: 'Company Size',
                  prefixIcon: Icon(Icons.people),
                ),
                value: _companySize,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Company Size is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _companySize = value;
                  });
                },
                items: <String>['Small', 'Medium', 'Large']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TextFormField(
                controller: e7,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                obscureText: true,
                onChanged: (value) {
                  _password = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm Password is required';
                  } else if (value != _password) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                obscureText: true,
                onChanged: (value) {
                  _confirmPassword = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
               onPressed: () {

                 _submitForm();

               },
              child: const Text('Signup'),
            ),
          ],
        ),
      ),

    );
  }

}