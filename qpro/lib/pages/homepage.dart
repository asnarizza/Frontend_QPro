import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Queue System'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Find a Hospital',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the page where users can select a hospital
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HospitalListPage()),
                );
              },
              child: Text('Find Hospitals'),
            ),
          ],
        ),
      ),
    );
  }
}

class HospitalListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy hospital list for demonstration
    List<String> hospitals = ['Hospital Melaka', 'Hospital Jasin', 'Hospital Alor Gajah'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Hospital'),
      ),
      body: ListView.builder(
        itemCount: hospitals.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(hospitals[index]),
            onTap: () {
              // Navigate to the page where users can view services at the selected hospital
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HospitalServicesPage(hospital: hospitals[index])),
              );
            },
          );
        },
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
                MaterialPageRoute(builder: (context) => QueueStatusPage(service: service)),
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

class QueueStatusPage extends StatelessWidget {
  final String service;

  QueueStatusPage({required this.service});

  @override
  Widget build(BuildContext context) {
    // Dummy queue status for demonstration
    int totalQueue = 10;
    int currentQueue = 5;
    int estimatedWaitingTime = 30; // in minutes

    return Scaffold(
      appBar: AppBar(
        title: Text('Queue Status for $service'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Total Queue: $totalQueue',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Current Queue: $currentQueue',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Estimated Waiting Time: $estimatedWaitingTime minutes',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement queuing logic here
                // This could navigate to a confirmation page with queue details
              },
              child: Text('Queue'),
            ),
          ],
        ),
      ),
    );
  }
}