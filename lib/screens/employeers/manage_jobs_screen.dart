import 'package:flutter/material.dart';
import 'dart:math';

class ManageJobsScreen extends StatelessWidget {
  const ManageJobsScreen({super.key});

  // Reusable Container Widget
  Widget _buildInfoContainer({
    required IconData icon,
    required String count,
    required String label,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
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
          Icon(
            icon,
            size: 35,
            color: iconColor,
          ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFBFDBFE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  return Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: _buildInfoContainer(
                              icon: Icons.work_outline_rounded,
                              count: '4',
                              label: 'Active Jobs',
                              iconColor: Colors.black,
                              backgroundColor:
                                  const Color.fromARGB(255, 169, 210, 230),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: _buildInfoContainer(
                              icon: Icons.work_outline_outlined,
                              count: '4',
                              label: 'Inactive Jobs',
                              iconColor: Colors.black,
                              backgroundColor:
                                  const Color.fromARGB(255, 179, 233, 182),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Flexible(
                            child: _buildInfoContainer(
                              icon: Icons.work_outline_outlined,
                              count: '0',
                              label: 'Pending',
                              iconColor: Colors.black,
                              backgroundColor:
                                  const Color.fromARGB(255, 224, 189, 137),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: _buildInfoContainer(
                                icon: Icons.work_outline_outlined,
                                count: '0',
                                label: 'Total Jobs',
                                iconColor: Colors.black,
                                backgroundColor: Colors.pink[200]!),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              // Directly include JobManager here
              const JobManager()
            ],
          ),
        ),
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
  late List<Map<String, String>> jobListings;

  // Pagination variables
  int currentPage = 0;
  final int recordsPerPage = 5;

  @override
  void initState() {
    super.initState();
    // Generate job listings with random categories and locations
    jobListings = List.generate(
      12, // More than 10 records
      (index) {
        final random = Random();
        final category = categories[random.nextInt(categories.length)];
        final location = locations[random.nextInt(locations.length)];

        return {
          'title': 'Job Title ${index + 1}',
          'category': category,
          'location': location,
          'applications': '${(index + 1) * 5}', // Convert int to String
          'expiryDate':
              '11/${(index + 1).toString().padLeft(2, '0')}/2025', // Ensure expiry date is correctly formatted
        };
      },
    );
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
                  fontSize: screenWidth * 0.05,
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
