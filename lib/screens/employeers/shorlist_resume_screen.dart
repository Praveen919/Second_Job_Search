import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:second_job_search/Config/config.dart';
import 'package:intl/intl.dart'; // Import for formatting

class ShortlistedResumeScreen extends StatefulWidget {
  const ShortlistedResumeScreen({super.key});

  @override
  _ShortlistedResumeScreenState createState() =>
      _ShortlistedResumeScreenState();
}

class _ShortlistedResumeScreenState extends State<ShortlistedResumeScreen> {
  int currentPage = 0;
  final int recordsPerPage = 5;
  String selectedFilter = 'Newest';
  List<Map<String, dynamic>> shortlistedCandidates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShortlistedCandidates();
  }

  Future<void> fetchShortlistedCandidates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      print("Error: User ID is null");
      return;
    }

    try {
      final response = await http.get(Uri.parse(
          '${AppConfig.baseUrl}/api/applied-jobs/shortlisted/$userId'));

      print("Shortlisted Candidates API Status: ${response.statusCode}");
      print("Shortlisted Candidates API Response: ${response.body}");

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> fetchedCandidates =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        setState(() {
          shortlistedCandidates = fetchedCandidates;
          isLoading = false; // ✅ Ensure loading stops
        });

        print(
            "Shortlisted Candidates Updated: ${shortlistedCandidates.length} found");
      } else {
        setState(() {
          isLoading = false; // ✅ Even if no data, stop loading
        });
        print("Error fetching shortlisted candidates: ${response.body}");
      }
    } catch (error) {
      setState(() {
        isLoading = false; // ✅ Stop loading on error too
      });
      print("Exception while fetching shortlisted candidates: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
          'Shortlisted Resumes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      "Your Shortlisted Resumes!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.05,
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
                          Column(
                            children: _getPaginatedJobCards(),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (currentPage > 0)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      currentPage--;
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
                                    style:
                                        TextStyle(fontSize: screenWidth * 0.04),
                                  ),
                                ),
                              if (currentPage + 1 <
                                  (shortlistedCandidates.length /
                                          recordsPerPage)
                                      .ceil())
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      currentPage++;
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
                                    style:
                                        TextStyle(fontSize: screenWidth * 0.04),
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

  List<Widget> _getPaginatedJobCards() {
    int startIndex = currentPage * recordsPerPage;
    int endIndex = (startIndex + recordsPerPage) > shortlistedCandidates.length
        ? shortlistedCandidates.length
        : (startIndex + recordsPerPage);
    List<Map<String, dynamic>> paginatedList =
        shortlistedCandidates.sublist(startIndex, endIndex);

    return paginatedList.map((candidate) {
      return applicantCard(
        candidate['name'] ?? 'Unknown',
        candidate['email'] ?? 'No Email',
        candidate['jobTitle'] ?? 'Not Available',
        candidate['jobType'] ?? 'Not Specified',
      );
    }).toList();
  }

  Widget applicantCard(
      String name, String email, String jobTitle, String jobType) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
                radius: 27, backgroundImage: AssetImage('assets/logo.png')),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const SizedBox(height: 5),
                  Text("Email: $email",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  Text("Applied for: $jobTitle",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  Text("Job Type: $jobType",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.blueGrey,
                size: 30,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'Schedule Interview':
                    showAddSchedulePopup();
                    break;
                  case 'Unshortlist':
                    print('Unshortlist clicked');
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'Schedule Interview',
                    child: Text(
                      'Schedule Interview',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Unshortlist',
                    child: Text(
                      'Unshortlist',
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
      ),
    );
  }

  void showAddSchedulePopup() {
    final meetingDetailsController = TextEditingController();
    DateTime? meetingDateTime;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Interview Scheduling",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Meeting Date & Time Selection Button
                    TextButton(
                      onPressed: () async {
                        // Step 1: Select Date
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (selectedDate != null) {
                          // Step 2: Select Time
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (selectedTime != null) {
                            setState(() {
                              meetingDateTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );
                            });
                          }
                        }
                      },
                      child: const Text(
                        'Select Meeting Timing',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    // Display Selected Date & Time (Formatted)
                    if (meetingDateTime != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Timing: ${DateFormat('dd-MM-yyyy hh:mm a').format(meetingDateTime!)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    const SizedBox(height: 15),

                    // Meeting Details Input
                    TextField(
                      controller: meetingDetailsController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Meeting Details',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validation
                    if (meetingDateTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Please select a meeting date and time.")),
                      );
                      return;
                    }

                    if (meetingDetailsController.text.length < 100) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Meeting details must be at least 100 characters long.")),
                      );
                      return;
                    }

                    // Save the data
                    setState(() {
                      // Save meetingDateTime and details
                    });

                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Schedule',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
