import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:second_job_search/Config/config.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class AppliedJobScreen extends StatefulWidget {
  const AppliedJobScreen({super.key});

  @override
  State<AppliedJobScreen> createState() => _AppliedJobScreenState();
}

class _AppliedJobScreenState extends State<AppliedJobScreen> {
  List<Map<String, dynamic>> jobList = [];
  List<dynamic> data = [];
  List<String> postIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  List<String> extractPostIds(List<Map<String, dynamic>> data) {
    return data.map((item) => item['post_id'] as String).toList();
  }

  List<Map<String, dynamic>> filterJobsByIds(
      List<Map<String, dynamic>> jobs, List<String> ids) {
    return jobs.where((job) => ids.contains(job['_id'])).toList();
  }

  Future<void> fetchJobs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    const url = "${AppConfig.baseUrl}/api/jobs";
    String applicationUrl =
        "${AppConfig.baseUrl}/api/applied-jobs/user/${pref.getString("userId")}";

    try {
      // Fetch applied jobs
      final appliedResponse = await http.get(Uri.parse(applicationUrl));
      if (appliedResponse.statusCode == 200) {
        List<dynamic> appliedJobList = json.decode(appliedResponse.body);
        setState(() {
          postIds = extractPostIds(appliedJobList.cast<Map<String, dynamic>>());
          print(postIds);
        });
      } else {
        throw Exception('Failed to load applied jobs');
      }
    } catch (e) {
      print("Error fetching applied jobs: $e");
      return; // Exit early if applied jobs fetch fails
    }

    try {
      // Fetch all jobs
      final jobResponse = await http.get(Uri.parse(url));
      if (jobResponse.statusCode == 200) {
        List<dynamic> mydata = json.decode(jobResponse.body);
        setState(() {
          jobList = mydata.cast<Map<String, dynamic>>();
          data = filterJobsByIds(jobList, postIds);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      print("Error fetching jobs: $e");
    }
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
          'Applied Jobs',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
              ? const Text("There are no Applied Jobs",
                  style: TextStyle(color: Colors.red))
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final job = data[index];
                    return JobCard(job: job);
                  },
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
  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return Scaffold(
      appBar: AppBar(
        title: Text(job['jobTitle'] ?? 'Job Details'),
        backgroundColor: const Color.fromARGB(255, 251, 252, 252),
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
        color: const Color.fromARGB(255, 54, 155, 238),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
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
                  style: const TextStyle(fontSize: 16, color: Colors.black),
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
      color: const Color.fromARGB(255, 230, 231, 231),
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
                color: Color.fromARGB(255, 54, 155, 238),
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
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87),
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
              style: const TextStyle(
                color: Color.fromARGB(255, 54, 155, 238),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
