import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:m_test/editprofile.dart';


class ProfileScreen extends StatelessWidget {
  String email;
  ProfileScreen({Key? key , required this.email}) : super(key: key);
  String ? _companyname ;

  Future<dynamic> showProfile() async {
    try {
      Uri url = Uri.parse('http://192.168.1.5:8080/flutterAPI/showprofile.php');
      http.Response response = await http.post(
        url,
        body: {
          "email": email

        },
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": 'true',
          "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS",
        },
      );
      print(response.statusCode);
      print(response.body);
      var jsonString = response.body.substring(response.body.indexOf('{'));
      var data = jsonDecode(jsonString);

        return data;
    } catch (e) {
      print(e);
      // handle the exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder(
        future: showProfile(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var profileData = snapshot.data;
            if (profileData != null && profileData.containsKey('Company Name')) {
              String company = profileData['Company Name'];
              String name = profileData['User Name'];
              String profilePicture = profileData['image'];
              String email = profileData['Email'];
              String phone = profileData['Phone'];

              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     CircleAvatar(
                       radius: 50,
                       backgroundImage: profilePicture != null ? AssetImage(profilePicture) : null,
                     ),
                      const SizedBox(height: 20),
                      Text(
                        'User Name: $name',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Company Name: $company',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Phone: $phone',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Email: $email',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => EditProfileScreen(email:'email')),
                        );
                      },
                      child: const Text('Edit Profile'),
                    ),


                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text('No profile data available.'));
            }
          }
        },
      ),
    );
  }
}
