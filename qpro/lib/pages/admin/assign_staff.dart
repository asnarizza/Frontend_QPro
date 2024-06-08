import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qpro/pages/admin/register_staff.dart';
import 'package:qpro/pages/admin/counter.dart';
import 'dart:convert';

import '../../repository/api_constant.dart';

class AssignStaffPage extends StatefulWidget {
  @override
  _AssignStaffPageState createState() => _AssignStaffPageState();
}

class _AssignStaffPageState extends State<AssignStaffPage> {
  List<dynamic> staffList = [];
  List<dynamic> departmentList = [];
  List<dynamic> counterList = [];
  String? selectedStaff;
  String? selectedDepartment;
  String? selectedCounter;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final staffResponse = await http.get(Uri.parse(APIConstant.StaffURL));
      final departmentResponse = await http.get(Uri.parse(APIConstant.GetDepURL));
      final counterResponse = await http.get(Uri.parse(APIConstant.GetCounterURL));

      if (staffResponse.statusCode == 200 && departmentResponse.statusCode == 200 && counterResponse.statusCode == 200) {
        setState(() {
          staffList = json.decode(staffResponse.body);
          departmentList = json.decode(departmentResponse.body);
          counterList = json.decode(counterResponse.body);
          _isLoading = false;
        });
      } else {
        _showErrorDialog('Failed to load data');
      }
    } catch (e) {
      _showErrorDialog('Network error occurred: $e');
    }
  }

  Future<void> _assignStaff() async {
    if (selectedStaff == null || selectedDepartment == null || selectedCounter == null) {
      _showErrorDialog('Please select all fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(APIConstant.AssignStaffURL);
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'staff_id': int.parse(selectedStaff!),
        'department_id': int.parse(selectedDepartment!),
        'counter_id': int.parse(selectedCounter!),
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      _showSuccessDialog('Staff has been successfully assigned.');
    } else {
      _showErrorDialog('Failed to assign staff. Please try again.');
    }
  }

  void _fetchCountersByDepartment(String departmentId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(APIConstant.GetCtrByDptURL + '$departmentId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          counterList = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        _showErrorDialog('Failed to load counters for the selected department');
      }
    } catch (e) {
      _showErrorDialog('Network error occurred: $e');
    }
  }

  // Future<void> _addCounter() async {
  //   if (selectedStaff == null || selectedDepartment == null) {
  //     _showErrorDialog('Please select all fields');
  //     return;
  //   }
  //
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   final url = Uri.parse(APIConstant.CounterURL); // Update this to your actual endpoint
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode({
  //       'staff_id': int.parse(selectedStaff!),
  //       'department_id': int.parse(selectedDepartment!),
  //     }),
  //   );
  //
  //   setState(() {
  //     _isLoading = false;
  //   });
  //
  //   if (response.statusCode == 201 || response.statusCode == 200) {
  //     _showSuccessDialog('Counter has been successfully added.');
  //   } else {
  //     _showErrorDialog('Failed to add counter. Please try again.');
  //   }
  // }

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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
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
        title: Text('Assign Staff'),
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
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
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
                          'Assign Staff to Department and Counter',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade900,
                          ),
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Staff',
                            border: OutlineInputBorder(),
                          ),
                          items: staffList.map((staff) {
                            return DropdownMenuItem<String>(
                              value: staff['id'].toString(),
                              child: Text(staff['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedStaff = value;
                            });
                          },
                          value: selectedStaff,
                        ),
                        SizedBox(height: 20),

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
                              // Fetch counters when department changes
                              _fetchCountersByDepartment(selectedDepartment!);
                            });
                          },
                          value: selectedDepartment,
                        ),
                        SizedBox(height: 20),
                        // DropdownButtonFormField for selecting counter
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Counter',
                            border: OutlineInputBorder(),
                          ),
                          items: counterList.map((counter) {
                            return DropdownMenuItem<String>(
                              value: counter['id'].toString(),
                              child: Text(counter['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCounter = value;
                            });
                          },
                          value: selectedCounter,
                        ),
                        SizedBox(height: 20),
                        _buildButton(
                          onPressed: _assignStaff,
                          label: 'Assign Staff',
                          icon: Icons.assignment,
                        ),
                        SizedBox(height: 20),
                        _buildButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RegisterStaffPage(),
                              ),
                            ).then((value) {
                              // This block will be executed when the RegisterStaffPage is popped
                              _fetchData();
                            });
                          },
                          label: 'Register Staff',
                          icon: Icons.person_add,
                        ),
                        SizedBox(height: 20),
                        _buildButton(
                          onPressed: () {
                            // Navigate to the AddCounterPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddCounterPage()),
                            ).then((value) {
                              // After adding a counter, update the data
                              _fetchData();
                            });
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
