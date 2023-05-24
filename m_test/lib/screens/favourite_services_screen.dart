import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/business_service.dart';
import '../providers/business_services_provider.dart';
import 'business_service_details_screen.dart';
import 'business_services_screen.dart';

class FavoriteServicesScreen extends StatelessWidget {
  @override
  final String email;
  const FavoriteServicesScreen({Key? key, required this.email});
  Widget build(BuildContext context) {
    return Consumer<BusinessServicesProvider>(
      builder: (context, provider, child) {
        var service = provider.loadfavouriteServices(this.email);
        final favoriteServices = provider.favoriteServices;
        if (favoriteServices.isEmpty) {
          // Display a message if there are no favorite services.
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Favorite Services'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: ListView.builder(
              itemCount: favoriteServices.length,
              itemBuilder: (context, index) {
                final service = favoriteServices[index];
                return ListTile(
                  title: Text(service.name),
                  subtitle: Text(service.description),
                  leading: Image.network(service.imageUrl),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BusinessServiceDetailsScreen(service: service , email: this.email,),
                      ),
                    );
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}