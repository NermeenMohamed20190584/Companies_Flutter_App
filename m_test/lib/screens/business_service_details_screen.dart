import 'package:flutter/material.dart';
import 'package:m_test/models/company.dart';
import 'package:provider/provider.dart';
import '../models/business_service.dart';
import '../providers/business_services_provider.dart';
import 'CompanyProfileScreen.dart';


class BusinessServiceDetailsScreen extends StatelessWidget {
  final BusinessService service;

  final String email;
  const BusinessServiceDetailsScreen({Key? key, required this.service, required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessServicesProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(service.name),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               // Image.network(service.imageUrl),
                const SizedBox(height: 16.0),
                Text('Description: ${service.description}'),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Price: \$${service.price}'),
                    Row(
                      children: [
                        Text('Rating: ${service.rating}'),
                        const Icon(Icons.star, color: Colors.yellow),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(

                        builder: (context) => CompanyProfileScreen(service: service, email: this.email),
                      ),
                    );
                  },
                  child: Text(
                    'Company Name: ${service.companyId}',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
