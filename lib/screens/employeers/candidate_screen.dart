import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class ManageCandidatesScreen extends StatelessWidget {
  const ManageCandidatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        backgroundColor:
            const Color(0xFFBFDBFE), // Set the AppBar background color to white
        elevation: 0, // Remove the AppBar shadow
        title: const Text(
          'Candidate',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title for Pie Chart
              Text(
                'Skillset Analysis',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // Pie Chart with fixed height
              SizedBox(
                height: 250, // Set a fixed height for the pie chart
                child: PieChart(
                  PieChartData(
                    sections: showingSections(),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 50,
                  ),
                ),
              ),
              // Job Manager Container
              Container(
                padding: const EdgeInsets.all(15),
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
                child: Candidate(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: 30,
        title: 'Flutter\n30%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 20,
        title: 'Dart\n20%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: 25,
        title: 'JavaScript\n25%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: 15,
        title: 'Java\n15%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.purple,
        value: 10,
        title: 'Python\n10%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }
}

class Candidate extends StatefulWidget {
  const Candidate({super.key});

  @override
  _CandidateState createState() => _CandidateState();
}

class _CandidateState extends State<Candidate> {
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

  final List<String> emailList = [
    'it@yahoo.com',
    'marketing@gmail.com',
    'finance@microsoft.com',
    'sales@yahoo.com',
    'hr@gmail.com',
    'engineering@microsoft.com',
    'design@yahoo.com',
    'customerservice@gmail.com',
    'administration@microsoft.com',
    'education@yahoo.com'
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

  final List<String> skillsList = [
    'coding, debugging',
    'seo, marketing',
    'accounting, budgeting',
    'negotiation, sales',
    'recruitment, HR',
    'problem-solving, decision-making',
    'design, branding',
    'customer support, CRM',
    'administration, multitasking',
    'teaching, e-learning'
  ];

  late List<Map<String, String>> jobListings;
  int currentPage = 0;
  final int recordsPerPage = 5;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    jobListings = List.generate(
      12,
      (index) {
        final random = Random();
        final category = categories[random.nextInt(categories.length)];
        final location = locations[random.nextInt(locations.length)];
        final skill = skillsList[random.nextInt(skillsList.length)];
        final email = emailList[random.nextInt(emailList.length)];

        return {
          'title': 'Developer ${index + 1}',
          'category': category,
          'location': location,
          'email': email,
          'skill': skill,
        };
      },
    );
  }

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

    // Filter job listings based on search query
    final filteredJobs = jobListings.where((job) {
      return job['title']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          job['category']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          job['location']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          job['email']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          job['skill']!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    final startIndex = currentPage * recordsPerPage;
    final endIndex = startIndex + recordsPerPage;
    final jobsToShow = filteredJobs.sublist(
      startIndex,
      endIndex > filteredJobs.length ? filteredJobs.length : endIndex,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "My Job Listings" Header
        Text(
          'All Candidates',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for a job...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Job Listings
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: jobsToShow.length,
          itemBuilder: (context, index) {
            final job = jobsToShow[index];

            return GestureDetector(
              onTap: () {
                // Navigate to the job details page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CandidateDetailsScreen(
                            job: job,
                          )
                      // Navigate to the JobDetailsPage
                      ),
                );
              },
              child: Container(
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
                      ],
                    ),
                    const Divider(color: Colors.grey, height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Email: ' + (job['email'] ?? 'No email provided'),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: screenWidth * 0.038,
                                color: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Skills: ' +
                                  (job['skill'] ?? 'No skill provided'),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: screenWidth * 0.038,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: 5,
        ),
        // Load More Button Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (currentPage > 0)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentPage--;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Load Previous',
                  style: TextStyle(
                      fontSize: screenWidth * 0.04, color: Colors.white),
                ),
              ),
            if (currentPage + 1 < (filteredJobs.length / recordsPerPage).ceil())
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentPage++;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Load More',
                  style: TextStyle(
                      fontSize: screenWidth * 0.04, color: Colors.white),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class CandidateDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const CandidateDetailsScreen({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job['name'] ?? 'Candidate Details'),
        backgroundColor: const Color(0xFFBFDBFE),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image and Candidate Name Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(job['profileImage'] ??
                        'https://via.placeholder.com/150'),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job['name'] ?? 'No name',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Location: ${job['location'] ?? 'Not available'}',
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Resume Download Button
              ElevatedButton(
                onPressed: () {
                  // Add your resume download functionality here
                  print('Download resume clicked');
                },
                child: Text('Download Resume'),
              ),
              SizedBox(height: 20),

              // Candidate Information Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Candidate Information',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              _buildRowWithIcon(Icons.work, 'Experience', job['experience']),
              _buildRowWithIcon(Icons.school, 'Education', job['education']),
              _buildRowWithIcon(Icons.monetization_on, 'Expected Salary',
                  job['expected_salary']),
              _buildRowWithIcon(Icons.monetization_on, 'Current Salary',
                  job['current_salary']),
              _buildRowWithIcon(Icons.person, 'Role', job['role']),
              _buildRowWithIcon(
                  Icons.sell, 'Professional Skills', job['skills']),
              SizedBox(height: 20),

              // Divider
              Divider(),

              // Other Related Candidates Section (in cards)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Other Related Candidates',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3, // Just a placeholder count for related candidates
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to related candidate details (if required)
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                'https://via.placeholder.com/150'), // Placeholder image
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Candidate ${index + 1}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Location: Some Location',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.blueGrey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build rows with icons and text
  Widget _buildRowWithIcon(IconData icon, String title, String? value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            '$title: ${value ?? 'Not available'}',
            style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
