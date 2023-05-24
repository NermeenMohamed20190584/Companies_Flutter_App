import 'dart:convert';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:m_test/screens/business_services_screen.dart';

import 'signup.dart';
import 'package:http/http.dart' as http;


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController e1 = new TextEditingController();
  TextEditingController e2 = new TextEditingController();
  String email = '';
  String password = '';
  Future<bool> login() async {
    try {
      Uri url = Uri.parse('http://192.168.1.5:8080/flutterAPI/login.php');
      http.Response response = await http.post(
        url,
        body: {
          "email": e1.text,
          "password": e2.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TextFormField(
                  controller: e1,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TextFormField(
                  obscureText: true,
                  controller: e2,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool loggedIn = await login();
                  if (loggedIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BusinessServicesListScreen(email : email)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                  );
                },
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}