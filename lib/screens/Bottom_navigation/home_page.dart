import 'dart:convert';
import 'package:flutter/material.dart';
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
      print("Error fetching jobs: $e");
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
            children: [
              const SizedBox(height: 20),
              const Text(
                "Hello Shakir, Good Day 👋",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              const Text(
                "Search & Land on your dream job",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
                              ? const CircularProgressIndicator()
                              : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: jobList.length,
                            itemBuilder: (context, index) {
                              final job = jobList[index];
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
                                  title: Text(job['jobTitle']),
                                  subtitle: Text(job['companyName']),
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
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JobDescriptionPage extends StatelessWidget {
  final dynamic job;

  const JobDescriptionPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job['jobTitle']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Company: ${job['companyName']}", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Category: ${job['jobCategory']}"),
            Text("Description: ${job['jobDescription']}"),
            Text("Responsibilities: ${job['keyResponsibilities']?.join(', ') ?? 'N/A'}"),
            Text("Skills: ${job['skillsAndExperience']?.join(', ') ?? 'N/A'}"),
            Text("Salary: \$${job['offeredSalary']}"),
            Text("Career Level: ${job['careerLevel']}"),
            Text("Location: ${job['city']}, ${job['country']}"),
            Text("Vacancies: ${job['vacancies']}"),
            Text("Employment Status: ${job['employmentStatus']}"),
            Text("Gender Preference: ${job['gender']}"),
            Text("Qualification: ${job['qualification']}"),
            Text("Industry: ${job['industry']}"),
            Text("Application Deadline: ${job['applicationDeadlineDate']}"),
          ],
        ),
      ),
    );
  }
}
