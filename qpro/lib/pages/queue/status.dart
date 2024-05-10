import 'package:flutter/material.dart';

import 'display.dart';

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
        backgroundColor: Colors.blue[700],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 400, // Set the maximum height here
          ),
          child: Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'TOTAL QUEUE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '$totalQueue',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'CURRENT QUEUE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '$currentQueue',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'ESTIMATED WAITING TIME',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '$estimatedWaitingTime minutes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the confirmation page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QueueDisplayPage(
                        userQueueNumber: 1, // Replace with actual user queue number
                        totalQueue: totalQueue,
                        currentQueue: currentQueue,
                        estimatedWaitingTime: estimatedWaitingTime,

                      )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                  ),
                  child: Text(
                    'QUEUE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

