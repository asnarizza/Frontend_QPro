import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  final int userQueueNumber;

  StatusScreen({required this.userQueueNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50), // To push content down, similar to padding from top
            Text(
              'Your ticket no. $userQueueNumber',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Consulting Service',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '( Level 1 )',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 40),
            Icon(
              Icons.notifications, // Bell icon, replace with the exact icon if needed
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              "It's your turn!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Please proceed to',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'counter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '3', // Assuming the counter number is static as per the provided image.
              style: TextStyle(
                color: Colors.white,
                fontSize: 100,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(), // To push the content above towards the center
          ],
        ),
      ),
    );
  }
}
