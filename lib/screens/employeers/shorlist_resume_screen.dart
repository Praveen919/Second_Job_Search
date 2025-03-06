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
                    Column(
                      children: [
                        SizedBox(height: 8),
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
                                (shortlistedCandidates.length / recordsPerPage)
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
        candidate['post_id'] ?? "Unknown",
        candidate['user_id'] ?? "Unkown",
        candidate['name'] ?? 'Unknown',
        candidate['jobTitle'] ?? 'Not Available',
        candidate['jobType'] ?? 'Not Specified',
      );
    }).toList();
  }

  Widget applicantCard(String postId, String userId, String name,
      String jobTitle, String jobType) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Profile Image
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.blue[100],
            child: const Icon(
              Icons.person,
              size: 32,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 16),

          // Candidate Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.work, size: 18, color: Colors.blueGrey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        jobTitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.business_center,
                        size: 18, color: Colors.blueGrey),
                    const SizedBox(width: 6),
                    Text(
                      jobType,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Button (Popup Menu)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.blueGrey, size: 30),
            onSelected: (value) {
              switch (value) {
                case 'Schedule Interview':
                  showAddSchedulePopup(userId, postId);
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
                        fontSize: screenWidth * 0.04, color: Colors.blue),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Unshortlist',
                  child: Text(
                    'Unshortlist',
                    style: TextStyle(
                        fontSize: screenWidth * 0.04, color: Colors.red),
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
    );
  }

  void showAddSchedulePopup(String userId, String postId) {
    final meetingDetailsController = TextEditingController();
    DateTime? meetingDateTime;
    Future<void> _scheduleJob() async {
      DateTime dateTime = DateTime.parse(
          meetingDateTime.toString()); // Convert string to DateTime

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String apiUrl = "${AppConfig.baseUrl}/api/interview";
      final body = {
        'postId': postId,
        'userId': userId,
        'employeeId': prefs.getString('userId'),
        'meetDetails': meetingDetailsController.text.toString(),
        'interviewTimestamp': dateTime.millisecondsSinceEpoch
      };
      print(body);
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final result = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Scheduled successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to schedule job")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("An error occurred while schedule the job")),
        );
      }
    }

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
                    _scheduleJob();
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
