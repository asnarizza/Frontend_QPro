import 'package:flutter/material.dart';
import 'package:qpro/pages/admin/counter.dart';
import 'package:qpro/pages/admin/department.dart';
import 'package:qpro/pages/admin/counter.dart';

import '../authentication/login.dart';
import 'assign_staff.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String department = "Admin Department";

  void _viewStatistics() {
    // Implement view statistics logic here
  }

  // void _addDepartment() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => AddDepartmentPage()),
  //   );
  // }

  // void _addCounter() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => AddCounterPage()),
  //   );
  // }

  void _assignStaff() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AssignStaffPage()),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Homepage'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('View Statistics'),
              onTap: _viewStatistics,
            ),
            // ListTile(
            //   leading: Icon(Icons.add),
            //   title: Text('Add Department'),
            //   onTap: _addDepartment,
            // ),
            // ListTile(
            //   leading: Icon(Icons.add_circle_outline),
            //   title: Text('Add Counter'),
            //   onTap: _addCounter,
            // ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Assign Staff'),
              onTap: _assignStaff,
            ),
          ],
        ),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                'Department:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade900,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                department,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 100),
                        Column(
                          children: <Widget>[
                            _buildButton(
                              onPressed: _viewStatistics,
                              label: 'View Statistics',
                              icon: Icons.bar_chart,
                            ),
                            // SizedBox(height: 20),
                            // _buildButton(
                            //   onPressed: _addDepartment,
                            //   label: 'Add Department',
                            //   icon: Icons.add,
                            // ),
                            // SizedBox(height: 20),
                            // _buildButton(
                            //   onPressed: _addCounter,
                            //   label: 'Add Counter',
                            //   icon: Icons.add,
                            // ),
                            SizedBox(height: 20),
                            _buildButton(
                              onPressed: _assignStaff,
                              label: 'Assign Staff',
                              icon: Icons.person_add,
                            ),
                          ],
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
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.teal.shade900,
        ),
      ),
    );
  }
}
