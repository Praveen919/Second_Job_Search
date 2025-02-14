import 'dart:convert';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../Config/config.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EmployerPostJobScreen extends StatefulWidget {
  const EmployerPostJobScreen({super.key});

  @override
  State<EmployerPostJobScreen> createState() => _EmployerPostJobScreenState();
}

class _EmployerPostJobScreenState extends State<EmployerPostJobScreen> {
  String? selectedCategory;

  List<Map<String, String>> jobDetails = [];
  List<Map<String, String>> applicationInfo = [];
  List<Map<String, String?>> locationInfo = [];
  List<Map<String, String>> companyDetails = [];
  List<Map<String, String>> additionalInfo = [];
  List<Map<String, DateTime?>> deadLine = [];

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // Function to pick file (PDF)
  Future<void> pickFile() async {}

  // Function to delete education details
  void deleteDetail(int n, int index) {
    if (n == 1) {
      setState(() {
        jobDetails.removeAt(index);
      });
    } else if (n == 2) {
      setState(() {
        applicationInfo.removeAt(index);
      });
    } else if (n == 3) {
      setState(() {
        locationInfo.removeAt(index);
      });
    } else if (n == 4) {
      setState(() {
        companyDetails.removeAt(index);
      });
    } else if (n == 5) {
      setState(() {
        additionalInfo.removeAt(index);
      });
    }
    // setState(() {
    //   jobDetails.removeAt(index);
    // });
  }

  void showAddJobDetailsPopup() {
    final jobTitleController = TextEditingController();
    final jobDescriptionController = TextEditingController();
    String? jobType;
    final keyResponsibilitiesController = TextEditingController();
    final skillsExperienceController = TextEditingController();
    final offeredSalaryController = TextEditingController();
    String? careerLevel;
    final experienceYearsController = TextEditingController();
    final experienceMonthsController = TextEditingController();
    String? employmentStatus;
    final vacanciesController =
        TextEditingController(text: '1'); // Default value

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          title: const Text(
            "Add Job Details",
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
                // Job Title
                TextField(
                  controller: jobTitleController,
                  decoration: InputDecoration(
                    labelText: 'Job Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Job Description
                TextField(
                  controller: jobDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Job Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 15),

                // Job Type Dropdown
                DropdownButtonFormField<String>(
                  value: jobType,
                  onChanged: (value) {
                    setState(() {
                      jobType = value;
                    });
                  },
                  items: [
                    'Full-time',
                    'Part-time',
                    'Flexible',
                    'Contract',
                    'Internship',
                    'Temporary'
                  ]
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Job Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Key Responsibilities
                TextField(
                  controller: keyResponsibilitiesController,
                  decoration: InputDecoration(
                    labelText: 'Key Responsibilities',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 15),

                // Skills and Experience
                TextField(
                  controller: skillsExperienceController,
                  decoration: InputDecoration(
                    labelText: 'Skills and Experience',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 15),

                // Offered Salary
                TextField(
                  controller: offeredSalaryController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Offered Salary',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Career Level Dropdown
                DropdownButtonFormField<String>(
                  value: careerLevel,
                  onChanged: (value) {
                    setState(() {
                      careerLevel = value;
                    });
                  },
                  items: [
                    'Entry-Level',
                    'Associate',
                    'Senior',
                    'Manager',
                    'Director',
                    'Vice-President',
                    'C-Level(CEO,CFO)'
                  ]
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Career Level',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Experience (Years and Months)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: experienceYearsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Years',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: experienceMonthsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Months',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Employment Status Dropdown
                DropdownButtonFormField<String>(
                  value: employmentStatus,
                  onChanged: (value) {
                    setState(() {
                      employmentStatus = value;
                    });
                  },
                  items: ['Contractual', 'Permanent', 'Freelance']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Employment Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Vacancies
                TextField(
                  controller: vacanciesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Vacancies',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
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
                setState(() {
                  jobDetails.add({
                    'title': jobTitleController.text,
                    'description': jobDescriptionController.text,
                    'type': jobType ?? '', // Default to an empty string if null
                    'responsibilities': keyResponsibilitiesController.text,
                    'skills': skillsExperienceController.text,
                    'salary': offeredSalaryController.text,
                    'careerLevel':
                        careerLevel ?? '', // Default to an empty string if null
                    'experienceYears': experienceYearsController.text,
                    'experienceMonths': experienceMonthsController.text,
                    'status': employmentStatus ??
                        '', // Default to an empty string if null
                    'vacancies': vacanciesController.text,
                  });
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showEditJobPopup(int index) {
    final jobTitleController =
        TextEditingController(text: jobDetails[index]['title']);
    final jobDescriptionController =
        TextEditingController(text: jobDetails[index]['description']);
    String? jobType = jobDetails[index]['type'];
    final keyResponsibilitiesController =
        TextEditingController(text: jobDetails[index]['responsibilities']);
    final skillsExperienceController =
        TextEditingController(text: jobDetails[index]['skills']);
    final offeredSalaryController =
        TextEditingController(text: jobDetails[index]['salary']);
    String? careerLevel = jobDetails[index]['careerLevel'];
    final experienceYearsController =
        TextEditingController(text: jobDetails[index]['experienceYears']);
    final experienceMonthsController =
        TextEditingController(text: jobDetails[index]['experienceMonths']);
    String? employmentStatus = jobDetails[index]['status'];
    final vacanciesController = TextEditingController(
        text: jobDetails[index]['vacancies']); // Default value

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          title: const Text(
            "Edit Job Details",
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
                // Job Title
                TextField(
                  controller: jobTitleController,
                  decoration: InputDecoration(
                    labelText: 'Job Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Job Description
                TextField(
                  controller: jobDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Job Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 15),

                // Job Type Dropdown
                DropdownButtonFormField<String>(
                  value: jobType,
                  onChanged: (value) {
                    setState(() {
                      jobType = value;
                    });
                  },
                  items: [
                    'Full-time',
                    'Part-time',
                    'Flexible',
                    'Contract',
                    'Internship',
                    'Temporary'
                  ]
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Job Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Key Responsibilities
                TextField(
                  controller: keyResponsibilitiesController,
                  decoration: InputDecoration(
                    labelText: 'Key Responsibilities',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 15),

                // Skills and Experience
                TextField(
                  controller: skillsExperienceController,
                  decoration: InputDecoration(
                    labelText: 'Skills and Experience',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 15),

                // Offered Salary
                TextField(
                  controller: offeredSalaryController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Offered Salary',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Career Level Dropdown
                DropdownButtonFormField<String>(
                  value: careerLevel,
                  onChanged: (value) {
                    setState(() {
                      careerLevel = value;
                    });
                  },
                  items: [
                    'Entry-Level',
                    'Associate',
                    'Senior',
                    'Manager',
                    'Director',
                    'Vice-President',
                    'C-Level(CEO,CFO)'
                  ]
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Career Level',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Experience (Years and Months)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: experienceYearsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Years',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: experienceMonthsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Months',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Employment Status Dropdown
                DropdownButtonFormField<String>(
                  value: employmentStatus,
                  onChanged: (value) {
                    setState(() {
                      employmentStatus = value;
                    });
                  },
                  items: ['Contractual', 'Permanent', 'Freelance']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Employment Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Vacancies
                TextField(
                  controller: vacanciesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Vacancies',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
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
                setState(() {
                  jobDetails[index] = {
                    'title': jobTitleController.text,
                    'description': jobDescriptionController.text,
                    'type': jobType ?? '', // Default to an empty string if null
                    'responsibilities': keyResponsibilitiesController.text,
                    'skills': skillsExperienceController.text,
                    'salary': offeredSalaryController.text,
                    'careerLevel':
                        careerLevel ?? '', // Default to an empty string if null
                    'experienceYears': experienceYearsController.text,
                    'experienceMonths': experienceMonthsController.text,
                    'status': employmentStatus ??
                        '', // Default to an empty string if null
                    'vacancies': vacanciesController.text,
                  };
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showAddApplicationInfoPopup() {
    final emailController = TextEditingController();
    final usernameController = TextEditingController();
    DateTime? deadlineDate;

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
                "Add Application Information",
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
                    // Application Deadline Button
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            deadlineDate = selectedDate;
                          });
                        }
                      },
                      child: const Text(
                        'Select Application Deadline',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Display Selected Date
                    if (deadlineDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Selected Deadline: ${deadlineDate!.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    const SizedBox(height: 15),

                    // Email Input
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Username Input
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                      ),
                    ),
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
                    if (deadlineDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please select a deadline date.")),
                      );
                      return;
                    }
                    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                        .hasMatch(emailController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Please enter a valid email address.")),
                      );
                      return;
                    }
                    if (usernameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Username cannot be empty.")),
                      );
                      return;
                    }

                    // Save the data
                    setState(() {
                      applicationInfo.add({
                        'deadlineDate':
                            deadlineDate!.toLocal().toString().split(' ')[0],
                        'email': emailController.text,
                        'username': usernameController.text,
                      });
                      deadLine.add({'date': deadlineDate});
                    });

                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showEditApplicationInfoPopup(int index) {
    final emailController =
        TextEditingController(text: applicationInfo[index]['email']);
    final usernameController =
        TextEditingController(text: applicationInfo[index]['username']);
    DateTime? deadlineDate = deadLine[index]['date'];

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
                "Edit Application Information",
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
                    // Application Deadline Button
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            deadlineDate = selectedDate;
                          });
                        }
                      },
                      child: const Text(
                        'Select Application Deadline',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Display Selected Date
                    if (deadlineDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Selected Deadline: ${deadlineDate!.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    const SizedBox(height: 15),

                    // Email Input
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Username Input
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                      ),
                    ),
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
                    if (deadlineDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please select a deadline date.")),
                      );
                      return;
                    }
                    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                        .hasMatch(emailController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Please enter a valid email address.")),
                      );
                      return;
                    }
                    if (usernameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Username cannot be empty.")),
                      );
                      return;
                    }

                    // Save the data
                    setState(() {
                      applicationInfo[index] = {
                        'deadlineDate':
                            deadlineDate!.toLocal().toString().split(' ')[0],
                        'email': emailController.text,
                        'username': usernameController.text,
                      };
                      deadLine[index] = {'date': deadlineDate!};
                    });

                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //Location Information
  void showAddLocationPopup(BuildContext context) {
    String selectedCountry = "";
    String selectedState = "";
    String selectedCity = "";

    final Map<String, String> contactInfo = {
      'Address': '',
      'Latitude': '',
      'Longitude': '',
    };

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
                "Add Location Information",
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
                    CSCPicker(
                      layout: Layout.vertical,
                      onCountryChanged: (value) {
                        setState(() {
                          selectedCountry = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          selectedState = value ?? "";
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          selectedCity = value ?? "";
                        });
                      },
                    ),
                    const Divider(),
                    ...contactInfo.keys.map(
                      (key) => Column(
                        children: [
                          _buildEditableRow(
                            label: key,
                            value: contactInfo[key]!,
                            onChanged: (newValue) {
                              setState(() {
                                contactInfo[key] = newValue;
                              });
                            },
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    locationInfo.add({
                      'address': contactInfo['Address'],
                      'latitude': contactInfo['Latitude'],
                      'longitude': contactInfo['Longitude'],
                      'city': selectedCity,
                      'state': selectedState,
                      'country': selectedCountry,
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEditableRow({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        SizedBox(
          width: 180,
          child: TextFormField(
            initialValue: value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }

  //Location Information For Edit
  void showEditLocationPopup(BuildContext context, int index) {
    String? selectedCountry = companyDetails[index]['country'];
    String? selectedState = companyDetails[index]['state'];
    String? selectedCity = companyDetails[index]['city'];

    final Map<String, String?> contactInfo = {
      'Address': companyDetails[index]['address'],
      'Latitude': companyDetails[index]['latitude'],
      'Longitude': companyDetails[index]['longitude'],
    };

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
                "Edit Location Information",
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
                    CSCPicker(
                      layout: Layout.vertical,
                      onCountryChanged: (value) {
                        setState(() {
                          selectedCountry = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          selectedState = value ?? "";
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          selectedCity = value ?? "";
                        });
                      },
                    ),
                    const Divider(),
                    ...contactInfo.keys.map(
                      (key) => Column(
                        children: [
                          _buildEditableRow2(
                            label: key,
                            value: contactInfo[key]!,
                            onChanged: (newValue) {
                              setState(() {
                                contactInfo[key] = newValue;
                              });
                            },
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    locationInfo[index] = {
                      'address': contactInfo['Address'],
                      'latitude': contactInfo['Latitude'],
                      'longitude': contactInfo['Longitude'],
                      'city': selectedCity,
                      'state': selectedState,
                      'country': selectedCountry,
                    };
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEditableRow2({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        SizedBox(
          width: 200,
          child: TextFormField(
            initialValue: value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }

  void showAddCompanyDetailsPopup() {
    final companyNameController = TextEditingController();
    final companyWebsiteController = TextEditingController();
    final industryController = TextEditingController();
    final contactPersonNameController = TextEditingController();
    final contactPhoneController = TextEditingController();
    final contactEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Add Company Details",
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
                // Company Name Input
                TextField(
                  controller: companyNameController,
                  decoration: InputDecoration(
                    labelText: 'Company Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Company Website Input
                TextField(
                  controller: companyWebsiteController,
                  decoration: InputDecoration(
                    labelText: 'Company Website',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Industry Input
                TextField(
                  controller: industryController,
                  decoration: InputDecoration(
                    labelText: 'Industry',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Contact Person Name Input
                TextField(
                  controller: contactPersonNameController,
                  decoration: InputDecoration(
                    labelText: 'Contact Person Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Contact Phone Input (with country code validation)
                TextField(
                  controller: contactPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Contact Phone (Country Code, Number)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Contact Email Input
                TextField(
                  controller: contactEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Contact Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
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
                // Validation for each field
                if (companyNameController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Company Name cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (companyWebsiteController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Company Website cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (industryController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Industry cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (contactPersonNameController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Contact Person Name cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (contactPhoneController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Contact Phone cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                    .hasMatch(contactEmailController.text)) {
                  Fluttertoast.showToast(
                    msg: "Please enter a valid email address.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }

                // Save the data if validation is successful
                setState(() {
                  companyDetails.add({
                    'companyName': companyNameController.text,
                    'companyWebsite': companyWebsiteController.text,
                    'industry': industryController.text,
                    'contactPersonName': contactPersonNameController.text,
                    'contactPhone': contactPhoneController.text,
                    'contactEmail': contactEmailController.text,
                  });
                });

                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showEditCompanyDetailsPopup(int index) {
    final companyNameController =
        TextEditingController(text: companyDetails[index]['companyName']);
    final companyWebsiteController =
        TextEditingController(text: companyDetails[index]['companyWebsite']);
    final industryController =
        TextEditingController(text: companyDetails[index]['industry']);
    final contactPersonNameController =
        TextEditingController(text: companyDetails[index]['contactPersonName']);
    final contactPhoneController =
        TextEditingController(text: companyDetails[index]['contactPhone']);
    final contactEmailController =
        TextEditingController(text: companyDetails[index]['contactEmail']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Edit Company Details",
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
                // Company Name Input
                TextField(
                  controller: companyNameController,
                  decoration: InputDecoration(
                    labelText: 'Company Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Company Website Input
                TextField(
                  controller: companyWebsiteController,
                  decoration: InputDecoration(
                    labelText: 'Company Website',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Industry Input
                TextField(
                  controller: industryController,
                  decoration: InputDecoration(
                    labelText: 'Industry',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Contact Person Name Input
                TextField(
                  controller: contactPersonNameController,
                  decoration: InputDecoration(
                    labelText: 'Contact Person Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Contact Phone Input (with country code validation)
                TextField(
                  controller: contactPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Contact Phone (Country Code, Number)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Contact Email Input
                TextField(
                  controller: contactEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Contact Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
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
                // Validation for each field
                if (companyNameController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Company Name cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (companyWebsiteController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Company Website cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (industryController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Industry cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (contactPersonNameController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Contact Person Name cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (contactPhoneController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Contact Phone cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                    .hasMatch(contactEmailController.text)) {
                  Fluttertoast.showToast(
                    msg: "Please enter a valid email address.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }

                // Save the data if validation is successful
                setState(() {
                  companyDetails[index] = {
                    'companyName': companyNameController.text,
                    'companyWebsite': companyWebsiteController.text,
                    'industry': industryController.text,
                    'contactPersonName': contactPersonNameController.text,
                    'contactPhone': contactPhoneController.text,
                    'contactEmail': contactEmailController.text,
                  };
                });

                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showAddAdditionalInfoPopup() {
    final specialismController = TextEditingController();
    final qualificationController = TextEditingController();
    final benefitsController = TextEditingController();
    final languagesController = TextEditingController();

    String? specialism;
    String? gender;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Add Additional Information",
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
                // Specialisms (Dropdown)
                DropdownButtonFormField<String>(
                  value: specialism,
                  onChanged: (value) {
                    setState(() {
                      specialism = value;
                    });
                  },
                  items: [
                    'Banking',
                    'Human Resources',
                    'Management',
                    'Digital & Creative',
                    'Retail',
                    'Accounting & Finance',
                    'Digital',
                    'Creative Art'
                  ].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Specialisms',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Qualification (Text field)
                TextField(
                  controller: qualificationController,
                  decoration: InputDecoration(
                    labelText: 'Qualification',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Gender (Dropdown)
                DropdownButtonFormField<String>(
                  value: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                  items:
                      ['Male', 'Female', 'Others'].map((String genderOption) {
                    return DropdownMenuItem<String>(
                      value: genderOption,
                      child: Text(genderOption),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Benefits (Text field)
                TextField(
                  controller: benefitsController,
                  decoration: InputDecoration(
                    labelText: 'Benefits',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Languages Required (Text field)
                TextField(
                  controller: languagesController,
                  decoration: InputDecoration(
                    labelText: 'Languages Required',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
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
                if (specialism == null || specialism!.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please select a specialism.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (qualificationController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Qualification cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (gender == null || gender!.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please select a gender.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (benefitsController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Benefits cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (languagesController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Languages Required cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }

                // Save the data if validation is successful
                setState(() {
                  additionalInfo.add({
                    'specialism': specialism!,
                    'qualification': qualificationController.text,
                    'gender': gender!,
                    'benefits': benefitsController.text,
                    'languagesRequired': languagesController.text,
                  });
                });

                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showEditAdditionalInfoPopup(int index) {
    final qualificationController =
        TextEditingController(text: additionalInfo[index]['qualification']);
    final benefitsController =
        TextEditingController(text: additionalInfo[index]['benefits']);
    final languagesController =
        TextEditingController(text: additionalInfo[index]['languagesRequired']);

    String? specialism = additionalInfo[index]['specialism'];
    String? gender = additionalInfo[index]['gender'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Edit Additional Information",
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
                // Specialisms (Dropdown)
                DropdownButtonFormField<String>(
                  value: specialism,
                  onChanged: (value) {
                    setState(() {
                      specialism = value;
                    });
                  },
                  items: [
                    'Banking',
                    'Human Resources',
                    'Management',
                    'Digital & Creative',
                    'Retail',
                    'Accounting & Finance',
                    'Digital',
                    'Creative Art'
                  ].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Specialisms',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Qualification (Text field)
                TextField(
                  controller: qualificationController,
                  decoration: InputDecoration(
                    labelText: 'Qualification',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Gender (Dropdown)
                DropdownButtonFormField<String>(
                  value: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                  items:
                      ['Male', 'Female', 'Others'].map((String genderOption) {
                    return DropdownMenuItem<String>(
                      value: genderOption,
                      child: Text(genderOption),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Benefits (Text field)
                TextField(
                  controller: benefitsController,
                  decoration: InputDecoration(
                    labelText: 'Benefits',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                const SizedBox(height: 15),

                // Languages Required (Text field)
                TextField(
                  controller: languagesController,
                  decoration: InputDecoration(
                    labelText: 'Languages Required',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
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
                if (specialism == null || specialism!.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please select a specialism.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (qualificationController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Qualification cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (gender == null || gender!.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please select a gender.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (benefitsController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Benefits cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }
                if (languagesController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Languages Required cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  return;
                }

                // Save the data if validation is successful
                setState(() {
                  additionalInfo[index] = {
                    'specialism': specialism!,
                    'qualification': qualificationController.text,
                    'gender': gender!,
                    'benefits': benefitsController.text,
                    'languagesRequired': languagesController.text,
                  };
                });

                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  bool showAllSkillCards =
      false; // Flag to control if all cards should be shown

  bool showAllJobCards = false;

  bool showAllApplicationCards = false;

  bool showAllLocationCards = false;

  bool showAllCompanyCards = false;

  bool showAllAdditionalCards = false;

  Future<void> _postingNewJob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiUrl = "${AppConfig.baseUrl}/api/jobs";

    final body = {
      "user_id": prefs.getString("userId") ?? "",
      "jobTitle": jobDetails.isNotEmpty ? jobDetails[0]['title'] ?? '' : '',
      "jobCategory": selectedCategory ?? '',
      "jobDescription":
          jobDetails.isNotEmpty ? jobDetails[0]['description'] ?? '' : '',
      "email":
          applicationInfo.isNotEmpty ? applicationInfo[0]['email'] ?? '' : '',
      "username": applicationInfo.isNotEmpty
          ? applicationInfo[0]['username'] ?? ''
          : '',
      "specialisms": additionalInfo.isNotEmpty
          ? additionalInfo[0]['specialism']?.split(',') ?? []
          : [],
      "jobType": jobDetails.isNotEmpty ? jobDetails[0]['type'] ?? '' : '',
      "offeredSalary": jobDetails.isNotEmpty ? jobDetails[0]['salary'] : '0',
      "careerLevel":
          jobDetails.isNotEmpty ? jobDetails[0]['careerLevel'] ?? '' : '',
      "experienceYears":
          jobDetails.isNotEmpty ? jobDetails[0]['experienceYears'] ?? '0' : '0',
      "experienceMonths": jobDetails.isNotEmpty
          ? jobDetails[0]['experienceMonths'] ?? '0'
          : '0',
      "gender":
          additionalInfo.isNotEmpty ? additionalInfo[0]['gender'] ?? '' : '',
      "industry":
          companyDetails.isNotEmpty ? companyDetails[0]['industry'] ?? '' : '',
      "qualification": additionalInfo.isNotEmpty
          ? additionalInfo[0]['qualification'] ?? ''
          : '',
      "applicationDeadlineDate":
          deadLine.isNotEmpty ? deadLine[0]['date'].toString() ?? '' : '',
      "country":
          locationInfo.isNotEmpty ? locationInfo[0]['country'] ?? '' : '',
      "city": locationInfo.isNotEmpty ? locationInfo[0]['city'] ?? '' : '',
      "completeAddress":
          locationInfo.isNotEmpty ? locationInfo[0]['address'] ?? '' : '',
      "latitude":
          locationInfo.isNotEmpty ? locationInfo[0]['latitude'] ?? '0' : '0',
      "longitude":
          locationInfo.isNotEmpty ? locationInfo[0]['longitude'] ?? '0' : '0',
      "companyName": companyDetails.isNotEmpty
          ? companyDetails[0]['companyName'] ?? ''
          : '',
      "companyWebsite": companyDetails.isNotEmpty
          ? companyDetails[0]['companyWebsite'] ?? ''
          : '',
      "plan_id": "67ab0c695d26342441c9ea08", // Add this if needed
      "benefits": additionalInfo.isNotEmpty
          ? additionalInfo[0]['benefits']?.split(',') ?? []
          : [],
      "languagesRequired": additionalInfo.isNotEmpty
          ? additionalInfo[0]['languagesRequired']?.split(',') ?? []
          : [],
      "vacancies":
          jobDetails.isNotEmpty ? jobDetails[0]['vacancies'] ?? '0' : '0',
      "employmentStatus":
          jobDetails.isNotEmpty ? jobDetails[0]['status'] ?? '' : '',
      "contactPersonName": companyDetails.isNotEmpty
          ? companyDetails[0]['contactPersonName'] ?? ''
          : '',
      "contactPhone": companyDetails.isNotEmpty
          ? companyDetails[0]['contactPhone'] ?? ''
          : '',
      "contactEmail": companyDetails.isNotEmpty
          ? companyDetails[0]['contactEmail'] ?? ''
          : '',
      "keyResponsibilities": jobDetails.isNotEmpty
          ? jobDetails[0]['responsibilities']?.split(',') ?? []
          : [],
      "skillsAndExperience": jobDetails.isNotEmpty
          ? jobDetails[0]['skills']?.split(',') ?? []
          : [],
      "seen": false,
      "postedDate": DateTime.now().toIso8601String().toString(),
      "updatedDate": DateTime.now().toIso8601String().toString(),
      "__v": 0
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
        print("Job posted successfully: $result");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Job posted successfully")),
        );
      } else {
        print("Failed to post job: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to post job")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("An error occurred while posting the job")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        title: const Text(
          'Post Jobs',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Post a New Job!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Column(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 8,
                    child: SizedBox(
                      height: 80,
                      width: 350,
                      child: Row(
                        children: [
                          Card(
                            margin: EdgeInsets.all(15),
                            color: Color.fromARGB(255, 221, 244, 248),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  size: 27,
                                  Icons.work_outline,
                                  color: Color.fromARGB(255, 0, 136, 248),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "15",
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 0, 136, 248)),
                              ),
                              Text(
                                "Total Free Jobs Available",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 10,
                    child: SizedBox(
                      height: 80,
                      width: 350,
                      child: Row(
                        children: [
                          Card(
                            margin: EdgeInsets.all(15),
                            color: Color.fromARGB(255, 248, 184, 184),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  size: 30,
                                  Icons.work_outline,
                                  color: Color.fromARGB(255, 248, 0, 0),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "15",
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 248, 0, 0)),
                              ),
                              Text(
                                "Total Free Jobs Available",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 10,
                    child: SizedBox(
                      height: 80,
                      width: 350,
                      child: Row(
                        children: [
                          Card(
                            margin: EdgeInsets.all(15),
                            color: Color.fromARGB(255, 192, 248, 184),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  size: 30,
                                  Icons.work_outline,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "15",
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green),
                              ),
                              Text(
                                "Total Free Jobs Available",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Select your job type:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Technical',
                          style: TextStyle(fontSize: 14)),
                      value: 'Technical',
                      groupValue: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Non-Technical',
                          style: TextStyle(fontSize: 14)),
                      value: 'Non-Technical',
                      groupValue: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Job Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: showAddJobDetailsPopup,
                  ),
                ],
              ),
              Column(
                children: [
                  // Show only the first 2 cards initially
                  ...(showAllJobCards
                      ? jobDetails.map((job) {
                          int index = jobDetails.indexOf(job);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    '${job['title']} - ${job['description']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Year: ${job['skills']} - ${job['salary']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () =>
                                            showEditJobPopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => deleteDetail(1, index),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.black26,
                                thickness: 1,
                              ),
                            ],
                          );
                        }).toList()
                      : jobDetails.take(2).map((job) {
                          int index = jobDetails.indexOf(job);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    '${job['title']} - ${job['description']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Year: ${job['skills']} - ${job['salary']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () =>
                                            showEditJobPopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => deleteDetail(1, index),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.black26,
                                thickness: 1,
                              ),
                            ],
                          );
                        }).toList()),
                  // Button to toggle between showing all cards and the first 2 cards
                  if (jobDetails.length > 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllJobCards =
                              !showAllJobCards; // Toggle the view mode
                        });
                      },
                      child: Text(
                        showAllJobCards ? 'View Less' : 'View All',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Application Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: showAddApplicationInfoPopup,
                  ),
                ],
              ),
              Column(
                children: [
                  // Show only the first 2 cards initially
                  ...(showAllApplicationCards
                      ? applicationInfo.map((application) {
                          int index = applicationInfo.indexOf(application);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    '${application['username']} - ${application['email']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Date: ${application['deadlineDate']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () =>
                                            showEditApplicationInfoPopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => deleteDetail(2, index),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.black26,
                                thickness: 1,
                              ),
                            ],
                          );
                        }).toList()
                      : applicationInfo.take(2).map((application) {
                          int index = applicationInfo.indexOf(application);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    '${application['username']} - ${application['email']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Date: ${application['deadlineDate']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () =>
                                            showEditApplicationInfoPopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => deleteDetail(2, index),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.black26,
                                thickness: 1,
                              ),
                            ],
                          );
                        }).toList()),
                  // Button to toggle between showing all cards and the first 2 cards
                  if (applicationInfo.length > 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllApplicationCards =
                              !showAllApplicationCards; // Toggle the view mode
                        });
                      },
                      child: Text(
                        showAllApplicationCards ? 'View Less' : 'View All',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Location Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () {
                      showAddLocationPopup(context);
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  // Show only the first 2 cards initially
                  ...(showAllLocationCards
                      ? locationInfo.map((location) {
                          int index = locationInfo.indexOf(location);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: const Text(
                                    'Complete Address-',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    '${location['address']}, ${location['latitude']}, ${location['longitude']}, ${location['city']}, ${location['state']}, ${location['country']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () => showEditLocationPopup(
                                            context, index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => deleteDetail(3, index),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.black26,
                                thickness: 1,
                              ),
                            ],
                          );
                        }).toList()
                      : locationInfo.take(2).map((location) {
                          int index = locationInfo.indexOf(location);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: const Text(
                                    'Complete Address-',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    '${location['address']}, ${location['latitude']}, ${location['longitude']}, ${location['city']}, ${location['state']}, ${location['country']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () => showEditLocationPopup(
                                            context, index),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => deleteDetail(3, index),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.black26,
                                thickness: 1,
                              ),
                            ],
                          );
                        }).toList()),
                  // Button to toggle between showing all cards and the first 2 cards
                  if (locationInfo.length > 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllLocationCards =
                              !showAllLocationCards; // Toggle the view mode
                        });
                      },
                      child: Text(
                        showAllLocationCards ? 'View Less' : 'View All',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Company Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: showAddCompanyDetailsPopup,
                  ),
                ],
              ),
              Column(
                children: [
                  ...(showAllCompanyCards
                      ? companyDetails.map((detail) {
                          int index = companyDetails.indexOf(detail);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    '${detail['companyName']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Company Website: ${detail['companyWebsite']} Industry: ${detail['industry']} \nContact Details.\nName: ${detail['contactPersonName']}, Phone: ${detail['contactPhone']}\nEmail: ${detail['contactEmail']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () =>
                                            showEditCompanyDetailsPopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => deleteDetail(4, index),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.black26,
                                thickness: 1,
                              ),
                            ],
                          );
                        }).toList()
                      : companyDetails.take(2).map((detail) {
                          int index = companyDetails.indexOf(detail);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    '${detail['companyName']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Company Website: ${detail['companyWebsite']} Industry: ${detail['industry']} \nContact Details.\nName: ${detail['contactPersonName']}, Phone: ${detail['contactPhone']}\nEmail: ${detail['contactEmail']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () =>
                                            showEditCompanyDetailsPopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => deleteDetail(4, index),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.black26,
                                thickness: 1,
                              ),
                            ],
                          );
                        }).toList()),
                  // Button to toggle between showing all cards and the first 2 cards
                  if (companyDetails.length > 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllCompanyCards =
                              !showAllCompanyCards; // Toggle the view mode
                        });
                      },
                      child: Text(
                        showAllCompanyCards ? 'View Less' : 'View All',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Additional Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: showAddAdditionalInfoPopup,
                  ),
                ],
              ),
              Column(
                children: [
                  ...(showAllAdditionalCards
                      ? additionalInfo.map((detail) {
                          int index = additionalInfo.indexOf(detail);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    'Specialism: ${detail['specialism']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Qualification:  ${detail['qualification']}\nGender: ${detail['gender']}\nBenefits: ${detail['benefits']}\nLanguage Required: ${detail['languagesRequired']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () =>
                                            showEditAdditionalInfoPopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => deleteDetail(5, index),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.black26,
                                thickness: 1,
                              ),
                            ],
                          );
                        }).toList()
                      : additionalInfo.take(2).map((detail) {
                          int index = additionalInfo.indexOf(detail);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    'Specialism: ${detail['specialism']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Qualification:  ${detail['qualification']}\nGender: ${detail['gender']}\nBenefits: ${detail['benefits']}\nLanguage Required: ${detail['languagesRequired']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () =>
                                            showEditAdditionalInfoPopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => deleteDetail(5, index),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.black26,
                                thickness: 1,
                              ),
                            ],
                          );
                        }).toList()),
                  // Button to toggle between showing all cards and the first 2 cards
                  if (additionalInfo.length > 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllAdditionalCards =
                              !showAllAdditionalCards; // Toggle the view mode
                        });
                      },
                      child: Text(
                        showAllAdditionalCards ? 'View Less' : 'View All',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Back',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      _postingNewJob();
                    },
                    child: const Text(
                      'Post',
                      style: TextStyle(color: Colors.white),
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
