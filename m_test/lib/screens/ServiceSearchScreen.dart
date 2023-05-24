import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/business_service.dart';
import '../providers/business_services_provider.dart';

class ServiceSearchScreen extends StatefulWidget {
  final String email;
  ServiceSearchScreen({super.key, required this.email});
  @override
  _ServiceSearchScreenState createState() =>
      _ServiceSearchScreenState(email: this.email);
}

class _ServiceSearchScreenState extends State<ServiceSearchScreen> {
  final String email;
  _ServiceSearchScreenState({required this.email});

  Widget build(BuildContext context) {
    final provider =
    Provider.of<BusinessServicesProvider>(context, listen: false);
    bool isbool = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search by Service'),
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Service'),
              subtitle: Consumer<BusinessServicesProvider>(
                builder: (context, provider, child) {
                  final d = provider.loadConsumedServices(this.email);
                  final ser = provider.services;
                  var seen = Set<String>();
                  List<BusinessService> uniquelist = ser.where((serv) => seen.add(serv.name)).toList();
                  return DropdownButton<String>(
                    value: provider.selectedService,
                    items: uniquelist.map((BusinessService val) {
                      return DropdownMenuItem<String>(
                        value: val.name,
                        child: Text(val.name),
                      );
                    }).toList(),
                    onChanged: (value) =>
                    {provider.selectService(value!)},
                  );
                },
              ),
            ),
            const Divider(),
            Consumer<BusinessServicesProvider>(
              builder: (context, provider, child) {
                final co = provider.searchbyservice(provider.selectedService, this.email);
                final com = provider.companies2;
                if (com.isEmpty) {
                  return const Center(
                    child: Text('No companies found'),
                  );
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ListView.builder(
                      itemCount: com.length,
                      itemBuilder: (context, index) {
                        final comp = com[index];
                        return ListTile(
                          title: Text(comp.name),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}