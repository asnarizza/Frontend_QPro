import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qpro/pages/authentication/login.dart';
import 'package:qpro/repository/api_constant.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:qpro/repository/notification_repo.dart';

class StaffHomePage extends StatefulWidget {
  final int userId; // Add a parameter for staff ID

  StaffHomePage({required this.userId});

  @override
  _StaffHomePageState createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  String department = "Loading...";
  int counter = 0;
  int departmentId = 0;
  int currentQueue = 0;
  bool _isLoading = false;
  List<int> queueNumbers = [];
  int? selectedQueueNumber;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  String? message;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchDepartmentAndCounter();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopWatchTimer.dispose();
    super.dispose();
  }

  Future<void> _fetchDepartmentAndCounter() async {
    final response = await http.get(Uri.parse(APIConstant.GetDeptCtrURL+"${widget.userId}"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        department = data['department_name'];
        departmentId = data['department_id'];
        counter = data['counter_id'];
        _fetchCurrentQueue();
      });
    } else {
      // Handle error
      setState(() {
        department = "Error loading data";
      });
    }
  }

  Future<void> _fetchCurrentQueue() async {
    try {
      final response = await http.get(
        Uri.parse(APIConstant.GetQueueByDptURL + "${departmentId}"),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData.containsKey('message')) {
          setState(() {
            message = responseData['message']; // Update state with message
            queueNumbers = []; // Clear queue numbers if there's a message
          });
          _startQueueRefreshTimer(); // Start the timer if no queues are found
        } else {
          // Process queues if available
          final queueNumbers = (responseData['queues'] ?? []).map<int>((item) => int.parse(item.toString())).toList();
          setState(() {
            // Update state with queue numbers
            this.queueNumbers = queueNumbers;
            message = null; // Clear message
          });
        }
      } else {
        setState(() {
          // Display error message if status code is not 200
          _showErrorDialog('Failed to fetch queue. Status code: ${response.statusCode}');
        });
      }
    } catch (e) {
      setState(() {
        // Handle other errors
        _showErrorDialog('Failed to fetch queue. Please try again.');
      });
    }
  }

  void _startQueueRefreshTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _fetchCurrentQueue(); // Fetch current queue every 3 seconds
    });
  }

  Future<void> _transferQueue(int queueNumber, int newDepartmentId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(APIConstant.TranferQueueURL+"$queueNumber"+"/$newDepartmentId"),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _isLoading = false;
          _showSuccessDialog('${data['message']}');
          _fetchCurrentQueue(); // Refresh the queue list
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Failed to transfer queue. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('An error occurred: $e. Please try again.');
    }
  }

  Future<void> _showDepartmentSelectionDialog(int queueNumber) async {
    final departments = await _fetchDepartments();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Department',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade900,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final department = departments[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    department['name'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(department['id']);
                  },
                  tileColor: Colors.teal.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              );
            },
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    ).then((selectedDepartmentId) {
      if (selectedDepartmentId != null) {
        _transferQueue(queueNumber, selectedDepartmentId);
      }
    });
  }


  Future<List<dynamic>> _fetchDepartments() async {
    try {
      final response = await http.get(Uri.parse(APIConstant.GetDepURL));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        _showErrorDialog('Failed to fetch departments. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e. Please try again.');
      return [];
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _callQueue(int queueNumber) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final queueResponse = await http.put(
        Uri.parse(APIConstant.CallQueueURL+"$queueNumber"+"/$departmentId"+"/$counter"),
      );

      if (queueResponse.statusCode == 200) {
        final data = json.decode(queueResponse.body);
        final updatedQueue = data['queue']; // Get updated queue details

        if (data['message'] != null && data['message'] == 'There are no queues yet for the new day.') {
          setState(() {
            _isLoading = false;
          });
          _showErrorDialog('There are no queues yet for the new day.');
        } else {
          setState(() {
            _fetchCurrentQueue(); // Refresh the queue list
            _isLoading = false;
            selectedQueueNumber = int.parse(updatedQueue['queue_number'].toString());
            _stopWatchTimer.onStartTimer();
            _showQueueActionDialog(queueNumber);
          });
          // Send notification about the queue number being called
          await sendQueueNotification(queueNumber);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Failed to call queue. Status code: ${queueResponse.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('An error occurred: $e. Please try again.');
    }
  }

  String _formatTime(int milliseconds) {
    final int seconds = (milliseconds / 1000).truncate();
    final int minutes = (seconds / 60).truncate();
    final int remainingSeconds = seconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showQueueActionDialog(int queueNumber) {
    const int MAX_TIME = 60000;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 200.0), // Add padding
        title: Center(
          child: Text(
            'Queue # $queueNumber',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade900,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.0), // Add space between title and timer
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: 0,
              builder: (context, snapshot) {
                final value = snapshot.data!;
                final displayTime = _formatTime(value);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Circular progress indicator
                        SizedBox(
                          height: 200.0, // Increase the height to make the circular progress indicator larger
                          width: 200.0,
                          child: CircularProgressIndicator(
                            value: value / MAX_TIME, // Assuming MAX_TIME is the maximum time for your timer
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              value >= MAX_TIME ? Colors.red : Colors.teal, // Change color after reaching max time
                            ),
                            strokeWidth: 10.0,
                          ),
                        ),
                        // Timer text
                        Text(
                          '$displayTime',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 70.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Reset timer
              _stopWatchTimer.onResetTimer();
              Navigator.of(context).pop();
            },
            child: Text('Done'),
          ),
          TextButton(
            onPressed: () {
              // Reset timer
              _stopWatchTimer.onResetTimer();
              Navigator.of(context).pop();
              _showDepartmentSelectionDialog(queueNumber);
            },
            child: Text('Transfer'),
          ),
        ],
      ),
    );
  }

// Function to show an error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }


  void _logout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchCurrentQueue(); // Refresh the queue list
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Homepage'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Department: $department',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Counter: $counter',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),
                    )
                  else if (message != null) // Display message if present
                    Center(
                      child: Text(
                        message!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.teal.shade900,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshData,
                        child: ListView.builder(
                          itemCount: queueNumbers.length,
                          itemBuilder: (context, index) {
                            final queueNumber = queueNumbers[index];
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                  color: Colors.teal,
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                title: Center(
                                  child: Text(
                                    '$queueNumber',
                                    style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.teal.shade800,
                                    ),
                                  ),
                                ),
                                tileColor: Colors.teal.shade50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                onTap: () => _callQueue(queueNumber),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}