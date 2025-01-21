import 'package:flutter/material.dart';

class ShortlistedResumeScreen extends StatefulWidget {
  const ShortlistedResumeScreen({super.key});

  @override
  _ShortlistedResumeScreenState createState() =>
      _ShortlistedResumeScreenState();
}

class _ShortlistedResumeScreenState extends State<ShortlistedResumeScreen> {
  int currentPage = 0; // Track current page
  final int recordsPerPage = 5; // Maximum 5 applicants per page
  String selectedFilter = 'Newest'; // Default filter

  // Dummy list of 15 applicants data
  List<Map<String, String>> jobListings = [
    {
      'name': 'John Doe',
      'job': 'Software Engineer',
      'profilePic': 'assets/logo.png'
    },
    {
      'name': 'Jane Smith',
      'job': 'Product Manager',
      'profilePic': 'assets/logo.png'
    },
    {'name': 'Mark Lee', 'job': 'UX Designer', 'profilePic': 'assets/logo.png'},
    {
      'name': 'Alice Brown',
      'job': 'Project Manager',
      'profilePic': 'assets/logo.png'
    },
    {
      'name': 'Michael Green',
      'job': 'Backend Developer',
      'profilePic': 'assets/logo.png'
    },
    {
      'name': 'Sarah White',
      'job': 'UI Designer',
      'profilePic': 'assets/logo.png'
    },
    {
      'name': 'David Black',
      'job': 'DevOps Engineer',
      'profilePic': 'assets/logo.png'
    },
    {
      'name': 'Eva Parker',
      'job': 'Data Scientist',
      'profilePic': 'assets/logo.png'
    },
    {
      'name': 'Linda Harris',
      'job': 'QA Engineer',
      'profilePic': 'assets/logo.png'
    },
    {
      'name': 'George Miller',
      'job': 'Machine Learning Engineer',
      'profilePic': 'assets/logo.png'
    },
    {
      'name': 'Emma Lewis',
      'job': 'Database Administrator',
      'profilePic': 'assets/logo.png'
    },
    {
      'name': 'James Johnson',
      'job': 'Cloud Engineer',
      'profilePic': 'assets/logo.png'
    },
    {
      'name': 'Olivia Walker',
      'job': 'Business Analyst',
      'profilePic': 'assets/logo.png'
    },
    {
      'name': 'Daniel Harris',
      'job': 'Full Stack Developer',
      'profilePic': 'assets/logo.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Get the screen width using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Shortlisted Resumes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20), // Horizontal padding
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align the content to the left
            children: [
              const SizedBox(height: 8),
              Text(
                "Your Shortlisted Resumes!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05, // Use the screen width here
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
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
                child: Column(
                  children: [
                    // Search Bar with Icon Dropdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Ensure spacing between elements
                      children: [
                        // Search TextField
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search applicants...',
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.black),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Filter Icon with Dropdown Menu
                        IconButton(
                          icon: Icon(Icons.filter_list, color: Colors.black),
                          onPressed: () {
                            // Open a dialog or bottom sheet with the filter options
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        title: Text('Newest'),
                                        onTap: () {
                                          setState(() {
                                            selectedFilter = 'Newest';
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Last 12 Months'),
                                        onTap: () {
                                          setState(() {
                                            selectedFilter = 'Last 12 Months';
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Last 16 Months'),
                                        onTap: () {
                                          setState(() {
                                            selectedFilter = 'Last 16 Months';
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Last 24 Months'),
                                        onTap: () {
                                          setState(() {
                                            selectedFilter = 'Last 24 Months';
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: Text('5 Years'),
                                        onTap: () {
                                          setState(() {
                                            selectedFilter = '5 Years';
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Displaying the filtered job cards
                    Column(
                      children: _getPaginatedJobCards(),
                    ),

                    const SizedBox(height: 5),

                    // Pagination Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Load Previous Button
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

                        // Load More Button
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to create applicant card
  Widget applicantCard(String name, String job, String profilePic) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 27,
                  backgroundImage: AssetImage(
                      profilePic), // Ensure these image paths are valid
                ),
                const SizedBox(width: 20),
                // Applicant Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        job,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.visibility_outlined,
                      color: Colors.blue, size: 23),
                  onPressed: () {
                    // Add your view action here
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            // Skills Section
            Text(
              'Skills: Flutter, Dart, Firebase, API Integration',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get paginated job cards
  List<Widget> _getPaginatedJobCards() {
    int startIndex = currentPage * recordsPerPage;
    int endIndex = (startIndex + recordsPerPage) > jobListings.length
        ? jobListings.length
        : (startIndex + recordsPerPage);
    List<Map<String, String>> paginatedList =
        jobListings.sublist(startIndex, endIndex);

    return paginatedList.map((job) {
      return applicantCard(job['name']!, job['job']!, job['profilePic']!);
    }).toList();
  }
}
