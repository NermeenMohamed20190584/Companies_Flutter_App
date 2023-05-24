import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/business_service.dart';
import '../providers/business_services_provider.dart';
import 'business_service_details_screen.dart';
import 'distance.dart';
import 'favourite_services_screen.dart';
 // Import the DistanceScreen

class CompanyProfileScreen extends StatelessWidget {
  BusinessService service;
  final String email;
  CompanyProfileScreen({required this.service, required this.email});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BusinessServicesProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Company Profile'),
      ),
      body: Consumer<BusinessServicesProvider>(
        builder: (context, provider, child) {
          var company1 = provider.getCompany(service.id);
          final companies = provider.companies;
          if (companies.isEmpty) {
            // Show a loading indicator while services are being fetched
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final company = companies[0]; // Assuming only one company is fetched

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  'Name: ${company.name}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text('Address: ${company.address}',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                SizedBox(height: 8.0),
                Text('Phone: ${company.phone}',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                const SizedBox(height: 8.0),
                Text('Email: ${company.email}',
                    style: const TextStyle(
                      fontSize: 18,
                    )),
                const SizedBox(height: 16.0),
                const Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(company.description,
                    style: const TextStyle(
                      fontSize: 18,
                    )),
                SizedBox(height: 16.0),
                Text('Location: ${company.location}',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                SizedBox(height: 8.0),
                Text('Size: ${company.size}',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DistanceScreen(service: service, email: this.email)),
                    );
                  },
                  child: Text('Calculate Distance'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
