import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:second_job_search/Config/config.dart';
import 'package:http/http.dart' as http;

class ManageJobsScreen extends StatefulWidget {
  const ManageJobsScreen({super.key});

  @override
  State<ManageJobsScreen> createState() => _ManageJobsScreenState();
}

class _ManageJobsScreenState extends State<ManageJobsScreen> {
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // Reusable Container Widget
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
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: iconColor),
                const SizedBox(width: 5),
                Text(
                  count,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Manage Jobs',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder<String?>(
        future: getUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('User ID not found.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoContainer(
                      icon: Icons.work_outline_rounded,
                      count: '1',
                      label: 'Active Jobs',
                      iconColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 169, 210, 230),
                    ),
                    const SizedBox(width: 8),
                    _buildInfoContainer(
                      icon: Icons.work_off_outlined,
                      count: '0',
                      label: 'Inactive Jobs',
                      iconColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 179, 233, 182),
                    ),
                    const SizedBox(width: 8),
                    _buildInfoContainer(
                      icon: Icons.hourglass_empty_rounded,
                      count: '0',
                      label: 'Pending',
                      iconColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 224, 189, 137),
                    ),
                    const SizedBox(width: 8),
                    _buildInfoContainer(
                      icon: Icons.list_alt_rounded,
                      count: '1',
                      label: 'Total Jobs',
                      iconColor: Colors.black,
                      backgroundColor: Colors.pink[200]!,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const JobManager(), // Assuming JobManager() exists
              ],
            ),
          );
        },
      ),
    );
  }
}

class JobManager extends StatefulWidget {
  const JobManager({super.key});

  @override
  _JobManagerState createState() => _JobManagerState();
}

class _JobManagerState extends State<JobManager> {
  // Lists of categories and locations
  final List<String> categories = [
    'IT',
    'Marketing',
    'Finance',
    'Sales',
    'HR',
    'Engineering',
    'Design',
    'Customer Service',
    'Administration',
    'Education'
  ];

  final List<String> locations = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Chennai',
    'Hyderabad',
    'Pune',
    'Kolkata',
    'Ahmedabad',
    'Chandigarh',
    'Goa'
  ];

  // List of job listings
  late List<Map<String, String>> jobListings = [];

  // Pagination variables
  int currentPage = 0;
  final int recordsPerPage = 5;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse(
            '${AppConfig.baseUrl}/api/applied-jobs/get-job-by-userid/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Map<String, String>> updatedJobListings = [];

        for (var job in data) {
          String postId =
              job['_id'].toString(); // Get post_id from API response
          String applicationCount =
              await fetchApplicationCount(postId); // Fetch application count

          updatedJobListings.add({
            'title': job['jobTitle'].toString(),
            'category': job['jobType'].toString(),
            'location': job['city'].toString(),
            'applications': applicationCount, // Add fetched count
          });
        }

        setState(() {
          jobListings = updatedJobListings;
        });
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (error) {
      print('Error fetching jobs: $error');
    }
  }

  Future<String> fetchApplicationCount(String postId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${AppConfig.baseUrl}/api/applied-jobs/job-applicant-count/$postId'),
      );

      if (response.statusCode == 200) {
        return response.body
            .trim(); // API returns just a number, so trim extra spaces
      } else {
        return '0';
      }
    } catch (error) {
      print('Error fetching application count for job $postId: $error');
      return '0';
    }
  }

  // Method to load the next set of jobs
  void loadMoreJobs() {
    setState(() {
      if (currentPage + 1 < (jobListings.length / recordsPerPage).ceil()) {
        currentPage++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Get the jobs for the current page
    final startIndex = currentPage * recordsPerPage;
    final endIndex = startIndex + recordsPerPage;
    final jobsToShow = jobListings.sublist(
      startIndex,
      endIndex > jobListings.length ? jobListings.length : endIndex,
    );

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Job Listings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.045,
                  color: Colors.black87,
                ),
              ),
              DropdownButton<String>(
                icon: const Icon(Icons.filter_list, color: Colors.blue),
                underline: const SizedBox(),
                items: <String>[
                  'Last 6 Months',
                  'Last 12 Months',
                  'Last 16 Months',
                  'Last 24 Months',
                  'Last 5 Years'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {},
                hint: Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // List of Job Cards
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: jobsToShow.length,
            itemBuilder: (context, index) {
              final job = jobsToShow[index];

              return Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/logo.png'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job['title']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 9,
                                    child: Text(
                                      job['category']!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.038,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    flex: 8,
                                    child: Text(
                                      " - ${job['location']}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.038,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                        //const Spacer(), // Push the 3 dots to the end of the row
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.blueGrey,
                            size: 30,
                          ),
                          onSelected: (value) {
                            switch (value) {
                              case 'View':
                                print('View clicked');
                                break;
                              case 'Update':
                                print('Update clicked');
                                break;
                              case 'Delete':
                                print('Delete clicked');
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem<String>(
                                value: 'View',
                                child: Text(
                                  'View',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'Update',
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'Delete',
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ];
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey, height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Applications: ${job['applications']}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.038,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          // Pagination Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // "Load Previous" Button
              if (currentPage > 0)
                TextButton(
                  onPressed: () {
                    setState(() {
                      currentPage--; // Decrease the current page index
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Load Previous',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                ),

              // "Load More" Button
              if (currentPage + 1 <
                  (jobListings.length / recordsPerPage).ceil())
                TextButton(
                  onPressed: () {
                    setState(() {
                      currentPage++; // Increase the current page index
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Load More',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
