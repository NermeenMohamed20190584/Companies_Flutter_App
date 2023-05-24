import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/business_service.dart';
import '../providers/business_services_provider.dart';
import 'business_service_details_screen.dart';
import 'favourite_services_screen.dart';
class DistanceScreen extends StatelessWidget {
  BusinessService service;
  final String email;
  DistanceScreen({required this.service, required this.email});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BusinessServicesProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Distance Screen'),
      ),
      body: Consumer<BusinessServicesProvider>(
        builder: (context, provider, child) {
          var distance = provider.calculateDistance(service.id, this.email);
          final distances = provider.distances;

          if (distances.isEmpty) {
            // Show a loading indicator while distances are being fetched
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final currentLocation0 = provider.currentLocation[0];
            final currentLocation1 = provider.currentLocation[1];

            final locationOfSelectedService0 = provider.locationOfSelectedService[0];
            final locationOfSelectedService1 = provider.locationOfSelectedService[1];

            final newLong = provider.newLongstr;
            final newLat = provider.newLatstr;

            return Container(
              width: double.infinity,
              height: double.infinity,
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 300,
                      height: 100,
                      child: Text(
                        'Current Location coordinates: $currentLocation0 , $currentLocation1',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 100,
                      child: Text(
                        'Location of Selected Service coordinates: $locationOfSelectedService0 , $locationOfSelectedService1',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      height: 80,
                      child: Text(
                        'Distance coordinates: $newLong , $newLat',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
