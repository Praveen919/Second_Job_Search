import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:second_job_search/Config/config.dart';

class CandidateInterviewScreen extends StatefulWidget {
  final String candidateId;

  CandidateInterviewScreen({required this.candidateId});

  @override
  _CandidateInterviewScreenState createState() =>
      _CandidateInterviewScreenState();
}

class _CandidateInterviewScreenState extends State<CandidateInterviewScreen> {
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
            '${AppConfig.baseUrl}/api/interview/user/${widget.candidateId}?page=$page&limit=10'),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);

        List<Map<String, dynamic>> newInterviews = responseData.map((data) {
          return {
            "postId": data["interview"]["postId"] ?? "Unknown",
            "meetDetails": data["interview"]["meetDetails"] ?? "No details",
            "interviewTimestamp": data["interview"]["interviewTimestamp"] ?? "",
            "companyName": data["job"]["companyName"] ?? "Unknown Company",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Interviews")),
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
                          // Job Title & Company
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

                          // Company Name
                          Row(
                            children: [
                              Icon(Icons.business, color: Colors.purple),
                              SizedBox(width: 8),
                              Text(
                                interview['companyName'],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
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