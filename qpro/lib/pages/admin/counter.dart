import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../repository/api_constant.dart';

class AddCounterPage extends StatefulWidget {
  @override
  _AddCounterPageState createState() => _AddCounterPageState();
}

class _AddCounterPageState extends State<AddCounterPage> {
  TextEditingController counterNameController = TextEditingController();
  bool _isLoading = false; // Add loading state
  List<dynamic> departmentList = [];
  String? selectedDepartment;

  @override
  void initState() {
    super.initState();
    // Fetch departments when the widget is initialized
    _fetchDepartments();
  }

  Future<void> _fetchDepartments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(APIConstant.GetDepURL));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          departmentList = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        _showErrorDialog('Failed to load data');
      }
    } catch (e) {
      _showErrorDialog('Network error occurred: $e');
    }
  }

  Future<void> _sendAddCounterRequest(String? selectedDepartment) async {
    if (selectedDepartment == null ) {
      _showErrorDialog('Please select department');
      return;
    }

    setState(() {
      _isLoading = true; // Set loading state to true
    });

    final url = Uri.parse(APIConstant.CounterURL);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'department_id': int.parse(selectedDepartment!),
      }),
    );

    setState(() {
      _isLoading = false; // Set loading state to false after request completes
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      _showSuccessDialog('Counter has been successfully added.');
    } else {
      _showErrorDialog('Failed to add counter. Please try again.');
    }
  }

  void _showSuccessDialog(String counterName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Counter added: $counterName'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the add counter page
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Counter'),
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Department',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade900,
                          ),
                        ),
                        SizedBox(height: 10),
                        // DropdownButtonFormField for selecting department
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Department',
                            border: OutlineInputBorder(),
                          ),
                          items: departmentList.map((department) {
                            return DropdownMenuItem<String>(
                              value: department['id'].toString(),
                              child: Text(department['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDepartment = value;
                            });
                          },
                          value: selectedDepartment,
                        ),
                        SizedBox(height: 20),
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : _buildButton(
                          onPressed: () async {
                            await _sendAddCounterRequest(selectedDepartment);
                          },
                          label: 'Add Counter',
                          icon: Icons.add,
                        ),
                      ],
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

  Widget _buildButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 30),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: Colors.teal.shade900,
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.teal.shade900,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }
}
