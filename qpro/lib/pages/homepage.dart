import 'package:flutter/material.dart';
import 'package:qpro/pages/queue/status.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<String> hospitals = [
      'Hospital Melaka', 'Hospital Jasin', 'Hospital Alor Gajah'];

    return Scaffold(
      appBar: AppBar(
        title: Text('QPro'),
        backgroundColor: Colors.blue[700],
      ),
      body: ListView.builder(
        itemCount: hospitals.length,
        itemBuilder: (context, index) {
          return HospitalCard(
            hospital: hospitals[index],
            onTap: () {
              // Navigate to the page where users can view services
              // at the selected hospital
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder:
                        (context) => HospitalServicesPage(
                            hospital: hospitals[index])),
              );
            },
          );
        },
      ),
    );
  }
}

class HospitalCard extends StatelessWidget {
  final String hospital;
  final VoidCallback onTap;

  HospitalCard({required this.hospital, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            hospital,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class HospitalServicesPage extends StatelessWidget {
  final String hospital;

  HospitalServicesPage({required this.hospital});

  @override
  Widget build(BuildContext context) {
    // Dummy service list for demonstration
    List<String> services = [
      'Emergency Department', 'Cardiology', 'Dental',
      'OB/GYN', 'Oncology', 'Outpatient', 'Orthopedics',
      'Pharmacy', 'Neurology', 'Psychiatry', 'ENT', 'Others'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Services at $hospital'),
        backgroundColor: Colors.blue[700],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        padding: EdgeInsets.all(16.0),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: services.map((service) {
          return ServiceCard(
            service: service,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QueueStatusPage(service: service)),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String service;
  final VoidCallback onTap;

  ServiceCard({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              service,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

