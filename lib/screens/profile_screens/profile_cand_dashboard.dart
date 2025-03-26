import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:second_job_search/Config/config.dart';
import 'package:second_job_search/screens/employeers/employee_dashbord.dart';
import 'package:second_job_search/screens/notifications_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  _ProfilescreenState createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  String? name = "";
  String? applied_count = "";
  String? job_count = "";
  String? message_count = "";
  String? saved_job_count = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiForAppliedJobsUrl =
        "${AppConfig.baseUrl}/api/applied-jobs/count/${prefs.getString("userId")}";
    String apiForUnreadMessagesUrl =
        "${AppConfig.baseUrl}/api/messages/notify/${prefs.getString("userId")}";
    String apiForJobsUrl = "${AppConfig.baseUrl}/api/jobs/jobCount";
    String apiForSaveJobsUrl =
        "${AppConfig.baseUrl}/api/users/save-jobs/${prefs.getString("userId")}";

    try {
      final response = await http.get(Uri.parse(apiForAppliedJobsUrl));

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        setState(() {
          applied_count = data["applied_jobs_count"].toString();
        });
      } else {
        setState(() {
          applied_count = "0";
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }

    try {
      final response = await http.get(Uri.parse(apiForJobsUrl));

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        setState(() {
          print(data);
          job_count = data["total_jobs"].toString();
        });
      } else {
        setState(() {
          job_count = "0";
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }

    try {
      final response = await http.get(Uri.parse(apiForUnreadMessagesUrl));

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        setState(() {
          message_count = data["readCount"].toString();
        });
      } else {
        setState(() {
          applied_count = "0";
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }

    try {
      final response = await http.get(Uri.parse(apiForSaveJobsUrl));

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        setState(() {
          saved_job_count = data["count"].toString();
        });
      } else {
        setState(() {
          saved_job_count = "0";
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }

    setState(() {
      name = prefs.getString("name");
      name = name?.split(" ")[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 100, 176, 238),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Howdy $name!!',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Color.fromARGB(255, 5, 64, 146),
                ),
              ),
              const Text(
                'Registered on: 7th October 2024, 1:25 pm - Unknown',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          _buildInfoContainer(
                            icon: Icons.work_outline_rounded,
                            count: '$applied_count',
                            label: 'Applied',
                            iconColor: Colors.black,
                            backgroundColor:
                                const Color.fromARGB(255, 77, 177, 223),
                          ),
                          const SizedBox(width: 10),
                          _buildInfoContainer(
                            icon: Icons.sticky_note_2_outlined,
                            count: '$job_count',
                            label: 'Job Alerts',
                            iconColor: Colors.black,
                            backgroundColor:
                                const Color.fromARGB(255, 18, 149, 209),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildInfoContainer(
                            icon: Icons.message_outlined,
                            count: '$message_count',
                            label: 'Messages',
                            iconColor: Colors.black,
                            backgroundColor:
                                const Color.fromARGB(255, 18, 149, 209),
                          ),
                          const SizedBox(width: 10),
                          _buildInfoContainer(
                            icon: Icons.bookmark_outline,
                            count: '$saved_job_count',
                            label: 'Saved',
                            iconColor: Colors.black,
                            backgroundColor:
                                const Color.fromARGB(255, 77, 177, 223),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
               ProfileViewsChart(),
              const SizedBox(height: 10),
              const Notifications(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoContainer({
    required IconData icon,
    required String count,
    required String label,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 35, color: iconColor),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: iconColor,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class ProfileViewsChart extends StatefulWidget {
  @override
  _ProfileViewsChartState createState() => _ProfileViewsChartState();
}

class _ProfileViewsChartState extends State<ProfileViewsChart> {
  String selectedPeriod = 'Monthly';
  Map<int, int> monthData = {};

  @override
  void initState() {
    super.initState();
    _loadGraphDataPoints();
  }

  Map<int, int> extractMonthCount(dynamic jsonData) {
    List<dynamic> dataList = jsonDecode(jsonData);
    Map<int, int> monthFrequency = {};

    for (var item in dataList) {
      DateTime date = DateTime.parse(item['timestamp']);
      int month = date.month;
      monthFrequency[month] = (monthFrequency[month] ?? 0) + 1;
    }
    return monthFrequency;
  }

  Future<void> _loadGraphDataPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiUrl =
        "${AppConfig.baseUrl}/api/applied-jobs/${prefs.getString("userId")}";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          monthData = extractMonthCount(response.body);
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  List<FlSpot> getDataPoints() {
    return List.generate(12, (index) {
      return FlSpot(
          (index + 1).toDouble(), monthData[index + 1]?.toDouble() ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Applied Job Stats',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blue.shade900,
            ),
          ),
          SizedBox(height: 10),
          DropdownButton<String>(
            value: selectedPeriod,
            items: ['Daily', 'Weekly', 'Monthly']
                .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
                .toList(),
            onChanged: (newValue) {
              setState(() {
                selectedPeriod = newValue!;
              });
            },
            underline: SizedBox(),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(12),
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Text(
                              '${value.toInt()}',
                              style: TextStyle(
                                  color: Colors.blue.shade700, fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec'
                          ];
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              months[value.toInt() - 1],
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 1,
                  maxX: 12,
                  minY: 0,
                  maxY: monthData.values.isNotEmpty
                      ? (monthData.values.reduce((a, b) => a > b ? a : b) + 5)
                      .toDouble()
                      : 10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: getDataPoints(),
                      isCurved: true,
                      color: Colors.blueAccent,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blueAccent.withOpacity(0.4),
                            Colors.transparent
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: Colors.blueAccent,
                            strokeWidth: 3,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
