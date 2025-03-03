import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:second_job_search/Config/config.dart';

class InterviewSchedulingScreen extends StatefulWidget {
  final String employeeId;

  InterviewSchedulingScreen({required this.employeeId});

  @override
  _InterviewSchedulingScreenState createState() =>
      _InterviewSchedulingScreenState();
}

class _InterviewSchedulingScreenState extends State<InterviewSchedulingScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController postIdController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController meetDetailsController = TextEditingController();
  DateTime? selectedDateTime;

  List<Map<String, dynamic>> interviews = [];
  int page = 1;
  bool isLoading = false;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    fetchInterviews();
  }

  Future<void> fetchInterviews({bool isNewPage = false}) async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse(
            '${AppConfig.baseUrl}/api/interview/employee/${widget.employeeId}?page=$page&limit=10'),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);

        List<Map<String, dynamic>> newInterviews = responseData.map((data) {
          return {
            "id": data["interview"]["_id"] ?? "",
            "postId": data["interview"]["postId"] ?? "",
            "userId": data["interview"]["userId"] ?? "",
            "meetDetails": data["interview"]["meetDetails"] ?? "No details",
            "interviewTimestamp": data["interview"]["interviewTimestamp"] ?? "",
            "userEmail": data["user"]["email"] ?? "No email",
            "userName": data["user"]["name"] ?? "Unknown User",
            "jobTitle": data["job"]["jobTitle"] ?? "Unknown Job",
            "jobType": data["job"]["jobType"] ?? "Unknown Type",
          };
        }).toList();

        setState(() {
          if (isNewPage) {
            interviews.addAll(newInterviews);
          } else {
            interviews = newInterviews;
          }
          hasMoreData = newInterviews.length == 10;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch interviews");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> deleteInterview(String interviewId) async {
    final response = await http.delete(
      Uri.parse('${AppConfig.baseUrl}/api/interview/$interviewId'),
    );

    if (response.statusCode == 200) {
      setState(() => page = 1);
      fetchInterviews();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Interview deleted successfully")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to delete interview")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Interview Scheduling")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: interviews.length + 1,
                itemBuilder: (context, index) {
                  if (index == interviews.length) {
                    return hasMoreData
                        ? Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() => page++);
                          fetchInterviews(isNewPage: true);
                        },
                        child: Text("Load More"),
                      ),
                    )
                        : SizedBox();
                  }

                  final interview = interviews[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Job Title & Type
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                interview['jobTitle'],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Chip(
                                label: Text(interview['jobType']),
                                backgroundColor: Colors.blue.shade100,
                              ),
                            ],
                          ),

                          SizedBox(height: 8),

                          // Meet Details
                          Row(
                            children: [
                              Icon(Icons.video_call, color: Colors.green),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  interview['meetDetails'],
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 8),

                          // Interview Time
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.orange),
                              SizedBox(width: 8),
                              Text(
                                DateFormat.yMMMd().add_jm().format(
                                    DateTime.parse(
                                        interview['interviewTimestamp'])),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                            ],
                          ),

                          SizedBox(height: 8),

                          // User Information
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.blue),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "${interview['userName']} (${interview['userEmail']})",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),

                          Divider(thickness: 1, height: 16),

                          // Edit & Delete Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.edit, color: Colors.blue),
                                label: Text("Edit",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                              SizedBox(width: 8),
                              TextButton.icon(
                                onPressed: () =>
                                    deleteInterview(interview['id']),
                                icon: Icon(Icons.delete, color: Colors.red),
                                label: Text("Delete",
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}