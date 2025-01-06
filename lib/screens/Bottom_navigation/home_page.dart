import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:second_job_search/Config/config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> jobList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    final url = "${AppConfig.baseUrl}/api/jobs";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          jobList = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching jobs: $e"); // Debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFBFDBFE),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Hello Shakir, Good Day 👋",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05),
              const Text(
                "Search & Land on your dream job",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.1),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 90, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Recommendations",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle "See all" tap
                                },
                                child: const Text(
                                  "See all",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : jobList.isEmpty
                                  ? const Text(
                                      "Can't fetch jobs at the moment.",
                                      style: TextStyle(color: Colors.red))
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: jobList.length,
                                      itemBuilder: (context, index) {
                                        final job = jobList[index];
                                        return JobCard(job: job);
                                      },
                                    ),
                        ],
                      ),
                    ),
                  ),
                  SearchBox(
                      screenWidth: screenWidth, screenHeight: screenHeight),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const SearchBox(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.85,
      height: screenHeight * 0.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                labelText: "Search Job",
              ),
            ),
            SizedBox(height: 7),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.room_outlined),
                labelText: "Location",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final dynamic job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: ListTile(
        leading: const Icon(
          Icons.work_outline,
          color: Colors.blue,
          size: 30,
        ),
        title: Text(job['jobTitle'] ?? 'Job Title Not Available'),
        subtitle: Text(job['companyName'] ?? 'Company Name Not Available'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDescriptionPage(job: job),
            ),
          );
        },
      ),
    );
  }
}

class JobDescriptionPage extends StatefulWidget {
  final Map<String, dynamic> job;

  const JobDescriptionPage({super.key, required this.job});

  @override
  _JobDescriptionPageState createState() => _JobDescriptionPageState();
}

class _JobDescriptionPageState extends State<JobDescriptionPage> {
  bool _isApplied = false;

  void _applyForJob() {
    setState(() {
      _isApplied = true;
    });
    Fluttertoast.showToast(
      msg: "You have successfully applied for this job!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return Scaffold(
      appBar: AppBar(
        title: Text(job['jobTitle'] ?? 'Job Details'),
        backgroundColor: const Color.fromARGB(255, 251, 251, 252),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Header Section
              _buildJobHeader(job),

              const SizedBox(height: 16),

              // Job Details Section
              _buildCardSection("Job Details", [
                DetailItem(label: "Company", value: job['companyName']),
                DetailItem(label: "Category", value: job['jobCategory']),
                DetailItem(
                    label: "Location",
                    value: "${job['city']}, ${job['country']}"),
                DetailItem(label: "Career Level", value: job['careerLevel']),
                DetailItem(
                    label: "Employment Status", value: job['employmentStatus']),
                DetailItem(label: "Vacancies", value: "${job['vacancies']}"),
              ]),

              const SizedBox(height: 16),

              // Job Description Section with Read More
              _buildCardSection("Job Description", [
                ReadMoreText(
                  label: "Description",
                  value: job['jobDescription'] ?? "No description available.",
                ),
                ReadMoreText(
                  label: "Responsibilities",
                  value: (job['keyResponsibilities']?.join(', ') ??
                      "No responsibilities provided."),
                ),
              ]),

              const SizedBox(height: 16),

              // Skills & Requirements Section
              _buildCardSection("Skills & Requirements", [
                DetailItem(
                  label: "Skills",
                  value: job['skillsAndExperience']?.join(', '),
                ),
                DetailItem(label: "Qualification", value: job['qualification']),
              ]),

              const SizedBox(height: 16),

              // Salary & Industry Details
              _buildCardSection("Salary & Industry Details", [
                DetailItem(label: "Salary", value: "\$${job['offeredSalary']}"),
                DetailItem(label: "Industry", value: job['industry']),
                DetailItem(
                  label: "Application Deadline",
                  value: job['applicationDeadlineDate'],
                ),
              ]),

              const SizedBox(height: 30),

              // Apply Button
              Center(
                child: ElevatedButton(
                  onPressed: _isApplied ? null : _applyForJob,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 16.0,
                    ),
                    backgroundColor: _isApplied ? Colors.grey : Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _isApplied ? "Applied" : "Apply Now",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobHeader(Map<String, dynamic> job) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage:
                AssetImage('assets/logo.png'), // Placeholder for company logo
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['companyName'] ?? 'Company Name',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  job['jobCategory'] ?? 'Job Category',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  "${job['city']}, ${job['country']}",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final String label;
  final String? value;

  const DetailItem({super.key, required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value ?? "N/A"),
          ),
        ],
      ),
    );
  }
}

class ReadMoreText extends StatefulWidget {
  final String label;
  final String value;

  const ReadMoreText({super.key, required this.label, required this.value});

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final maxLines = _isExpanded ? null : 5;
    final overflow = _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.value,
            maxLines: maxLines,
            overflow: overflow,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? "View Less" : "Read More",
              style: const TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}
