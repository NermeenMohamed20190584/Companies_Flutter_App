import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/business_service.dart';
import '../providers/business_services_provider.dart';
import 'business_service_details_screen.dart';



class ListScreen extends StatelessWidget {
  static const routeName = '/company-profile';
  final String email;

  const ListScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final provider =
    Provider.of<BusinessServicesProvider>(context, listen: false);

    // Call the loadServices function to fetch the services


    return Scaffold(
      appBar: AppBar(
        title: const Text('Provided Business Services'),

      ),
      body: Consumer<BusinessServicesProvider>(
        builder: (context, provider, child) {
          var service = provider.loadProvidedServices(this.email);
          final services = provider.services1;
          if (services.isEmpty) {
            // Show a loading indicator while services are being fetched
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return ListTile(
                  title: Text(service.name),
                  subtitle: Text(service.description),
                  //leading: Image.network(service.imageUrl),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BusinessServiceDetailsScreen(service: service, email: this.email),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}