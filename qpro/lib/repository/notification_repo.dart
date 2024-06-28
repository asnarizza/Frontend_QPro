import 'dart:convert'; // Add this import
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/queue/status.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


Future<void> sendQueueNotification(int queueNumber) async {
  const String oneSignalAppId = '8720edb2-97e5-45eb-b551-552c92cc8834';
  const String oneSignalRestApiKey = 'MzdmNWM2NjctNTkyMC00NThlLWFlNzctNDllNDllOTliYmRh'; // Replace with your OneSignal REST API Key
  //var pref = await SharedPreferences.getInstance();
  //String? email = pref.getString("email");
  final Map<String, dynamic> notification = {
    'app_id': oneSignalAppId,
    'include_external_user_ids': [queueNumber.toString()],
    'headings': {'en': 'Queue Number Called'},
    'contents': {'en': 'Queue number $queueNumber is being called.'},
    'data': {'queueNumber': queueNumber}
  };

  final response = await http.post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Basic $oneSignalRestApiKey',
    },
    body: jsonEncode(notification),
  );

  // if (response.statusCode != 200) {
  //   print('Failed to send notification. Status code: ${response.statusCode}');
  // }

  if (response.statusCode == 200) {
    // Navigate to the StatusScreen
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) => StatusScreen(userQueueNumber: queueNumber),
    ));
  } else {
    print('Failed to send notification. Status code: ${response.statusCode}');
  }
}
