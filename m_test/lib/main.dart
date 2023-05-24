import 'package:flutter/material.dart';

import 'package:m_test/providers/business_services_provider.dart';
import 'package:provider/provider.dart';


import 'login.dart';

void main() async {
  final provider = BusinessServicesProvider();
  runApp(
    ChangeNotifierProvider<BusinessServicesProvider>.value(
      value: provider,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => BusinessServicesProvider(),
      child: MaterialApp(
        title: 'Your App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}