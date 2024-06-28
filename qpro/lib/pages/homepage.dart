import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qpro/pages/queue/ticket.dart';
import 'package:qpro/repository/api_constant.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _hasJoinedQueue = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QPro'),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade100, Colors.teal.shade500],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(30.0),
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Scan a code',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade900,
                            ),
                          ),
                          SizedBox(height: 10),
                          Icon(
                            Icons.qr_code_scanner,
                            size: 40,
                            color: Colors.teal.shade900,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            ),
        ],
      ),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
        onPressed: () {
          setState(() {
            _hasJoinedQueue = false;
            _isLoading = false;
          });
          controller?.resumeCamera();
        },
        child: Icon(Icons.refresh),
        backgroundColor: Colors.white,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_hasJoinedQueue) {
        // If the user has already joined the queue, ignore further scans
        return;
      }

      // Set the flag immediately to prevent further processing
      setState(() {
        _hasJoinedQueue = true;
        _isLoading = true;
      });

      String? departmentId = scanData.code;
      print('Scanned data: $departmentId'); // Debug print

      if (departmentId != null) {
        String? token = await getTokenFromPreferences();
        int? userId = await getUserIdFromPreferences();
        print('Retrieved user ID: $userId'); // Debug print

        if (userId != null) {
          try {
            // Send a request to join the queue
            final response = await http.post(
              Uri.parse(APIConstant.GenerateURL),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer $token', // Use the user ID for authentication
              },
              body: jsonEncode(<String, int>{
                'user_id': userId,
                'department_id': int.parse(departmentId),
              }),
            );

            print('Response status: ${response.statusCode}'); // Debug print
            print('Response body: ${response.body}'); // Debug print

            if (response.statusCode == 201) {
              final jsonResponse = jsonDecode(response.body);
              String queueNumber = jsonResponse['queue_number'].toString();
              //String currentQueue = jsonResponse['current_queue']?.toString() ?? '0';
              int totalPeopleInQueue = jsonResponse['total_people_ahead'];
              int estimatedWaitingTime = jsonResponse['estimated_waiting_time']; // Get the estimated waiting time

              // // Navigate to QueueDisplayPage
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => QueueDisplayPage(
              //     userQueueNumber: int.parse(queueNumber),
              //     //currentQueue: int.parse(currentQueue),
              //   ),
              // ));

              // Navigate to QueueDisplayPage
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QueueDisplayPage(
                  userQueueNumber: int.parse(queueNumber),
                  totalPeopleInQueue: totalPeopleInQueue, // Add this line
                  estimatedWaitingTime: estimatedWaitingTime, // Add this line
                ),
              ));

              setState(() {
                _isLoading = false;
                _hasJoinedQueue = false;
              });
            } else {
              // Handle error and reset the flag
              setState(() {
                _isLoading = false;
                _hasJoinedQueue = false;
              });
              _showErrorDialog('Failed to join queue. Please try again.');
            }
          } catch (e) {
            // Handle exception and reset the flag
            setState(() {
              _isLoading = false;
              _hasJoinedQueue = false;
            });
            _showErrorDialog('Error joining queue: $e');
          }
        } else {
          print('User ID not found');
          // Reset the flag if user ID not found
          setState(() {
            _isLoading = false;
            _hasJoinedQueue = false;
          });
          _showErrorDialog('User ID not found. Please log in again.');
        }
      } else {
        // Handle the case where the QR code is null
        print('Scanned data is null');
        // Reset the flag if scanned data is null
        setState(() {
          _isLoading = false;
          _hasJoinedQueue = false;
        });
        _showErrorDialog('Invalid QR code. Please try again.');
      }
      // Pause the camera after processing the QR code
      controller.pauseCamera();
    });
  }

  Future<int?> getUserIdFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id'); // Retrieve the user ID
  }

  Future<String?> getTokenFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Retrieve the user ID
  }
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

