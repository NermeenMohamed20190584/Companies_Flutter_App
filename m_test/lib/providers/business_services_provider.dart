import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/business_service.dart';
import '../models/company.dart';
import 'package:provider/provider.dart';

class BusinessServicesProvider with ChangeNotifier {

  String newLongstr = '';
  String newLatstr = '';
  List<String> currentLocation = [];
  List<String> locationOfSelectedService = [];
  List<BusinessService> _services = [];
  List<BusinessService> _services1 = [];
  List<BusinessService> _favoriteServices = [];
  List<Company> _companies = [];
  List<Company> _companies2 = [];
  List<String> _distances = [];
  List<String> get distances => _distances;
  List<Company> get companies => _companies;
  List<Company> get companies2 => _companies2;
  List<BusinessService> get services => _services;
  List<BusinessService> get services1 => _services1;
  List<BusinessService> get favoriteServices => _favoriteServices;

  List<String> _companies3 = [];



  List<String> get companies3 => _companies3;
  late String _selectedService = services[0].name;
  String get selectedService => _selectedService;
  set companies3(List<String> value) {
    _companies3 = value;
    notifyListeners();
  }

  void selectService(String value) {
    _selectedService = value;
    //searchbyservice(value, email);
    notifyListeners();
  }
  Future<void> loadConsumedServices(email) async {
    try {
      // Make an HTTP request to your API to fetch the services
      // Adjust the URL and request parameters according to your API
      final url = Uri.parse('http://192.168.1.5:8080/flutterAPI/allServices.php');
      final response = await http.post(url,body:{'email': email});
      var jsonString = response.body.substring(response.body.indexOf('['));
      dynamic data = jsonDecode(jsonString);
      print(response.statusCode);

      if (response.statusCode == 200) {

        //Parse the response data and update the services list
        _services = List<BusinessService>.from(
            data.map((item) => BusinessService.fromJson(item)));


        // Notify listeners about the change in services
        notifyListeners();
      } else {
        // Handle error response
        throw Exception('Failed to load services');
      }
    } catch (error) {
      // Handle network or API error
      throw Exception('Error: $error');
    }
  }

  Future<void> loadProvidedServices(email) async {
    try {
      // Make an HTTP request to your API to fetch the services
      // Adjust the URL and request parameters according to your API
      final url = Uri.parse('http://192.168.1.5:8080/flutterAPI/providedServices.php');
      final response = await http.post(url,body:{'email': email});
      var jsonString = response.body.substring(response.body.indexOf('['));
      dynamic data = jsonDecode(jsonString);
      print(response.statusCode);

      if (response.statusCode == 200) {

        //Parse the response data and update the services list
        _services1 = List<BusinessService>.from(
            data.map((item) => BusinessService.fromJson(item)));


        // Notify listeners about the change in services
        notifyListeners();
      } else {
        // Handle error response
        throw Exception('Failed to load services');
      }
    } catch (error) {
      // Handle network or API error
      throw Exception('Error: $error');
    }
  }



  Future<void> getCompany(id) async {
    try {
      // Make an HTTP request to your API to fetch the services
      // Adjust the URL and request parameters according to your API
      final url =
      Uri.parse('http://192.168.1.5:8080/flutterAPI/serviceofcompany.php');
      final response = await http.post(url, body: {'id': id});
      print(response.statusCode);
      var jsonString = response.body.substring(response.body.indexOf('['));
      var data = jsonDecode(jsonString);
      print(response.statusCode);

      if (response.statusCode == 200) {

        //Parse the response data and update the services list
        _companies = List<Company>.from(
            data.map((item) => Company.fromJson(item)));
        // Notify listeners about the change in services
        notifyListeners();
      } else {
        // Handle error response
        throw Exception('Failed to load companies');
      }
    } catch (error) {
      // Handle network or API error
      throw Exception('Error: $error');
    }
  }


  Company contactCompany(BusinessService service, Company company) {
    for (int i = 0; i < _companies.length; i++) {
      if (company.companyId == _companies[i].companyId) {
        return _companies[i];
      }
    }
    return company;
  }

  Future<void> calculateDistance(id,email) async{
    try {
      // Make an HTTP request to your API to fetch the services
      // Adjust the URL and request parameters according to your API
      final url =
      Uri.parse('http://192.168.1.5:8080/flutterAPI/distance.php');
      final response = await http.post(url, body: {'id': id, 'email': email});
      print(response.statusCode);
      var jsonString = response.body.substring(response.body.indexOf('['));
      var data = jsonDecode(jsonString);
      print(data);
      print(response.statusCode);

      if (response.statusCode == 200) {

        currentLocation = data[0].split(',');
        locationOfSelectedService = data[1].split(',');
        List<double> currentLocationDoubles = currentLocation.map(double.parse).toList();
        List<double> locationOfSelectedServicesDoubles = locationOfSelectedService.map(double.parse).toList();

        double newLong = (currentLocationDoubles[0] - locationOfSelectedServicesDoubles[0]).abs();
        double newLat = (currentLocationDoubles[1] - locationOfSelectedServicesDoubles[1]).abs();
        newLongstr=newLong.toString();
        newLatstr=newLat.toString();
        newLat.toString();
        distances.add(newLongstr);
        distances.add(newLatstr);


        notifyListeners();
      } else {
        // Handle error response
        throw Exception('Failed to load companies');
      }
    } catch (error) {
      // Handle network or API error
      throw Exception('Error: $error');
    }
  }
  Future<void> loadfavouriteServices(email) async {
    try {
      final url =
      Uri.parse('http://192.168.1.5:8080/flutterAPI/allfavouriteofcompany.php');
      final response = await http.post(url, body: {'email' : email});
      var jsonString = response.body.substring(response.body.indexOf('['));
      var data = jsonDecode(jsonString);
      print(data);
      if (response.statusCode == 200) {

        _favoriteServices = List<BusinessService>.from(
            data.map((item) => BusinessService.fromJson(item)));
        // Notify listeners about the change in services
        notifyListeners();
      } else {
        // Handle error response
        throw Exception('Failed to load services');
      }
    } catch (error) {
      // Handle network or API error
      throw Exception('Error: $error');
    }
  }

  Future<void> addfavouriteServices(BusinessService service, email) async {
    try {
      // Make an HTTP request to your API to fetch the services
      // Adjust the URL and request parameters according to your API
      final url =
      Uri.parse('http://192.168.1.5:8080/flutterAPI/addinfavouritelist.php');
      final response = await http.post(url, body: {'id':  service.id, 'email' : email});
      print('llllllllllllllllllllllll');
      print(response.statusCode);
      _favoriteServices.add(service);
    } catch (error) {
      // Handle network or API error
      throw Exception('Error: $error');
    }
  }

  Future<void> deletefavouriteServices(id,email) async {
    try {
      // Make an HTTP request to your API to fetch the services
      // Adjust the URL and request parameters according to your API
      final url =
      Uri.parse('http://192.168.1.5:8080/flutterAPI/deleteinfavouritelist.php');
      final response = await http.post(url, body: {'id': id  , 'email' : email});
      print(response.statusCode);
    } catch (error) {
      // Handle network or API error
      throw Exception('Error: $error');
    }
  }
  void toggleFavorite(BusinessService service , String email) {
    service.isFavorite = !service.isFavorite;

    if (service.isFavorite) {
      addfavouriteServices(service,email);
      //_favoriteServices.add(service);

    } else {
      deletefavouriteServices(service.id,email);
      _favoriteServices.remove(service);
    }
    notifyListeners();
  }
  Future<void> searchbyservice(title , email) async {
    try {
      // Make an HTTP request to your API to fetch the services
      // Adjust the URL and request parameters according to your API
      final url =
      Uri.parse('http://192.168.1.5:8080/flutterAPI/searchbyservicetitle.php');
      final response = await http.post(url, body: {'title': title , 'email' : email});
      print(response.statusCode);
      var jsonString = response.body.substring(response.body.indexOf('['));
      var data = jsonDecode(jsonString);
      print(response.statusCode);
      print(data);
      if (response.statusCode == 200) {

        //Parse the response data and update the services list
        _companies2 = List<Company>.from(
            data.map((item) => Company.fromJson(item)));
        // Notify listeners about the change in services
        notifyListeners();
      } else {
        // Handle error response
        throw Exception('Failed to load companies');
      }
    } catch (error) {
      // Handle network or API error
      throw Exception('Error: $error');
    }
  }
}