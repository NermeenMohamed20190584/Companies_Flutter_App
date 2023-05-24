import 'package:flutter/material.dart';
import 'package:m_test/screens/view_list.dart';

import 'package:provider/provider.dart';
import '../models/business_service.dart';
import '../profile.dart';
import '../providers/business_services_provider.dart';
import 'ServiceSearchScreen.dart';
import 'business_service_details_screen.dart';
import 'favourite_services_screen.dart';


class BusinessServicesListScreen extends StatelessWidget {
  static const routeName = '/company-profile';
  final String email;

  const BusinessServicesListScreen({Key? key, required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider =
    Provider.of<BusinessServicesProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteServicesScreen(email: email),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.cable),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListScreen(email: email),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceSearchScreen(email: email),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(email: email),
                ),
              );
            },
          ),
        ],
      ),

      body: Consumer<BusinessServicesProvider>(
        builder: (context, provider, child) {
          provider.loadConsumedServices(this.email);
          final services = provider.services;
          if (services.isEmpty) {
            return Center(
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
                  trailing: IconButton(
                    icon: Icon(
                      service.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      provider.toggleFavorite(service, email);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusinessServiceDetailsScreen(
                            service: service, email: email),
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