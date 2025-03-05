import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:second_job_search/Config/config.dart';
import 'package:http/http.dart' as http;

class AppliedJobScreen extends StatefulWidget {
  const AppliedJobScreen({super.key});

  @override
  State<AppliedJobScreen> createState() => _AppliedJobScreenState();
}

class _AppliedJobScreenState extends State<AppliedJobScreen> {
  final List<Map<String, dynamic>> data = [
    {
      "_id": "678f605f225d5175b92d8105",
      "post_id": "677fa5e8428c76fadc9c96f1",
      "name": "Alok K",
      "jobTitle": "N/A",
      "jobType": "N/A",
      "timestamp": "2025-01-21T08:52:47.330Z",
    },
    {
      "_id": "67c2c623c7270b248628ca11",
      "post_id": "67bd90214e7f940552243064",
      "name": "Alok K",
      "jobTitle": "Data Analyst",
      "jobType": "Full-time",
      "timestamp": "2025-03-01T08:32:35.803Z",
    },
    {
      "_id": "67c2c874a238b7d3a0d84b23",
      "post_id": "677be53772819fd848a494d6",
      "name": "Alok K",
      "jobTitle": "Data Scientist",
      "jobType": "Full-time",
      "timestamp": "2025-03-01T08:42:28.350Z",
    },
  ];
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
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final job = data[index];

          return Card(
            elevation: 3,
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(job["jobTitle"],
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Type: ${job["jobType"]}"),
                  Text("Applied on: ${job["timestamp"]}"),
                  Text("Applicant: ${job["name"]}"),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        JobDescriptionScreen(postId: job["post_id"]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class JobDescriptionScreen extends StatelessWidget {
  final String postId;

  const JobDescriptionScreen({Key? key, required this.postId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job Description")),
      body: Center(
        child: Text("Job details for post ID: $postId"),
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

    if (userId == null) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/applied-jobs/user/$userId'),
      );

      if (response.statusCode == 200) {
        dynamic data = json.decode(response.body);
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (error) {
      print('Error fetching jobs: $error');
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
                'Applied Job Listings',
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
                            Text(
                              "Expiry Date: ${job['expiryDate']}",
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
