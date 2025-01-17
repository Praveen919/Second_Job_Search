import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:second_job_search/Config/config.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FindJobsPageScreen extends StatefulWidget {
  const FindJobsPageScreen({super.key});

  @override
  State<FindJobsPageScreen> createState() => _FindJobsPageScreenState();
}

class _FindJobsPageScreenState extends State<FindJobsPageScreen> {
  String selectedJob = "All Jobs";
  String selectedLocation = "Location";
  String selectedSalary = "Salary";

  final List<String> jobOptions = ["All Jobs", "Full-Time", "Part-Time", "Remote"];
  final List<String> locationOptions = ["Location", "Paris", "New York", "London"];
  final List<String> salaryOptions = ["Salary", "<\$5K", "\$5K-\$10K", ">\$10K"];

  List<dynamic> jobs = []; // List to store jobs data
  bool isLoading = true; // State for loading spinner

  @override
  void initState() {
    super.initState();
    fetchJobs(); // Fetch jobs from API
  }

  Future<void> fetchJobs() async {
    const apiUrl = '${AppConfig.baseUrl}/api/free-jobs'; // Update with your API URL
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          jobs = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching jobs: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFBFDBFE), // Light blue background
      child: Column(
        children: [
          // Search Bar and Filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Job',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDropdown(jobOptions, selectedJob, (newValue) {
                      setState(() {
                        selectedJob = newValue!;
                      });
                    }),
                    _buildDropdown(locationOptions, selectedLocation, (newValue) {
                      setState(() {
                        selectedLocation = newValue!;
                      });
                    }),
                    _buildDropdown(salaryOptions, selectedSalary, (newValue) {
                      setState(() {
                        selectedSalary = newValue!;
                      });
                    }),
                  ],
                ),
              ],
            ),
          ),

          // Job Cards
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator()) // Show loader
                : ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                return _buildJobCard(jobs[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(List<String> options, String selectedValue, ValueChanged<String?> onChanged) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedValue,
          underline: const SizedBox(), // Remove default underline
          icon: const Icon(Icons.arrow_drop_down),
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildJobCard(dynamic job) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 24,
                  child: Text(
                    'Logo',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['companyName'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      job['jobTitle'] ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  "\$${job['offeredSalary'] ?? ''}/mo",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.grey),
                    Text(job['city'] ?? '',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDescriptionPage(job: job),
                        ),
                        );
                        },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF2563EB), // Button blue
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Apply"),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.bookmark_border, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ],
        ),
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
                    style: const TextStyle(fontSize: 18),
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