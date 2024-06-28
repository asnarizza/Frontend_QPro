
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../repository/api_constant.dart';

class DepartmentStatisticsPage extends StatefulWidget {
  @override
  _DepartmentStatisticsPageState createState() => _DepartmentStatisticsPageState();
}

class _DepartmentStatisticsPageState extends State<DepartmentStatisticsPage> {
  Future<List<dynamic>>? futureStatistics;

  @override
  void initState() {
    super.initState();
    futureStatistics = fetchStatistics();
  }

  Future<List<dynamic>> fetchStatistics() async {
    final response = await http.get(Uri.parse(APIConstant.StatisticURL));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['statistics'];
    } else {
      throw Exception('Failed to load statistics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Department Statistics'),
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
              child: FutureBuilder<List<dynamic>>(
                future: futureStatistics,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No statistics found'));
                  } else {
                    final statistics = snapshot.data!;
                    return ListView.builder(
                      itemCount: statistics.length,
                      itemBuilder: (context, index) {
                        final department = statistics[index];
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(department['department_name'],
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text('Total Counters',
                                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                                      Text(department['total_counters'].toString(),
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Total Customers Served',
                                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                                      Text(department['total_customers_served'].toString(),
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text('Average Service Time',
                                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                                      Text('${department['average_service_time']} mins',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Average Waiting Time',
                                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                                      Text('${department['average_waiting_time']} mins',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text('Peak Hours',
                                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                                      Text('${department['peak_hours']}:00',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


