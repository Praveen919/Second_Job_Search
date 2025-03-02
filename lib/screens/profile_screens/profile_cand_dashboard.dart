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
        "${AppConfig.baseUrl}/api/applied-jobs//count/${prefs.getString("userId")}";
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
                'Last login: 7th October 2024, 1:25 pm - Unknown',
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
              const ProfileViewsChart1(),
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
