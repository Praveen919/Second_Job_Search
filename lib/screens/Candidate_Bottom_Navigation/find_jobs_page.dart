import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:second_job_search/Config/config.dart';
import 'package:second_job_search/screens/Candidate_Bottom_Navigation/home_page.dart';

class FindJobsPageScreen extends StatefulWidget {
  const FindJobsPageScreen({super.key});

  @override
  State<FindJobsPageScreen> createState() => _FindJobsPageScreenState();
}

class _FindJobsPageScreenState extends State<FindJobsPageScreen> {
  String selectedJob = "All Jobs";
  String selectedLocation = "Location";
  String selectedSalary = "Salary";

  final List<String> jobOptions = [
    "All Jobs",
    "Full-time",
    "Part-time",
    "Flexible",
    "Contract",
    "Internship",
    "Temporary"
  ];
  List<String> locationOptions = [];
  List<String> salaryOptions = ["Salary"];

  List<dynamic> allJobs = []; // Stores all jobs from API
  List<dynamic> filteredJobs = []; // Stores filtered jobs
  bool isLoading = true;

  final TextEditingController searchController =
      TextEditingController(); // Search controller

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  List<String> extractCities(List<dynamic> jsonData) {
    List<dynamic> jobs = jsonData;
    Set<String> cities = {"Location"};

    for (var job in jobs) {
      if (job['city'] != null) {
        cities.add(job['city']);
      }
    }

    return cities.toList();
  }

  List<String> getSortedSalaries(List<dynamic> jobData) {
    // Extract offeredSalary values
    List<int> salaries = jobData.map((job) {
      // Cast each job to Map<String, dynamic>
      Map<String, dynamic> jobMap = job as Map<String, dynamic>;
      return jobMap['offeredSalary'] as int;
    }).toList();

    // Sort salaries in ascending order
    salaries.sort();

    // Convert sorted salaries to a list of strings
    List<String> sortedSalariesAsString =
        salaries.map((salary) => salary.toString()).toList();

    return sortedSalariesAsString;
  }

  Future<void> fetchJobs() async {
    const apiUrl = '${AppConfig.baseUrl}/api/jobs'; // Replace with your API URL
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          allJobs = jsonDecode(response.body);
          filteredJobs = allJobs; // Initially show all jobs
          locationOptions = extractCities(allJobs);
          salaryOptions = salaryOptions + getSortedSalaries(allJobs);

          isLoading = false;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching jobs: $error');
    }
  }

  // Filter jobs based on search input
  void _filterJobs(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredJobs = allJobs; // Show all jobs when search is empty
      });
      return;
    }

    setState(() {
      filteredJobs = allJobs.where((job) {
        final jobTitle = job['jobTitle']?.toLowerCase() ?? "";
        final companyName = job['companyName']?.toLowerCase() ?? "";
        final searchLower = query.toLowerCase();

        return jobTitle.contains(searchLower) ||
            companyName.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 100, 176, 238), // Light blue background
      child: Column(
        children: [
          // Search Bar and Filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: _filterJobs, // Call filter function on text change
                  decoration: InputDecoration(
                    hintText: 'Search Job by title or company',
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
                    _buildDropdown(locationOptions, selectedLocation,
                        (newValue) {
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
                ? const Center(
                    child: CircularProgressIndicator()) // Show loader
                : filteredJobs.isEmpty
                    ? const Center(child: Text("No jobs found"))
                    : ListView.builder(
                        itemCount: filteredJobs.length,
                        itemBuilder: (context, index) {
                          return _buildJobCard(filteredJobs[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(List<String> options, String selectedValue,
      ValueChanged<String?> onChanged) {
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
                        backgroundColor: const Color(0xFF2563EB),
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
