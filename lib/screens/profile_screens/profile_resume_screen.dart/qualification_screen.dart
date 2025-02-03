import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:second_job_search/screens/profile_screens/profile_resume_screen.dart/profile_links_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../Config/config.dart';

class QualificationScreen extends StatefulWidget {
  const QualificationScreen({super.key});

  @override
  State<QualificationScreen> createState() => _QualificationScreenState();
}

class _QualificationScreenState extends State<QualificationScreen> {
  String? selectedCategory;
  String? uploadedFileName;

  // List to store education details
  // Lists to store user details
  List<Map<String, dynamic>> educationDetails = [];
  List<Map<String, dynamic>> workExperienceDetails = [];
  List<Map<String, dynamic>> certificationDetails = [];
  List<Map<String, dynamic>> skillsDetails = [];

  @override
  void initState() {
    super.initState();
    _loadQualificationData();
  }

  Future<void> _loadQualificationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiUrl =
        "${AppConfig.baseUrl}/api/users/details/${prefs.getString("userId")}";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          if (data['resumeType'] == "non-technical") {
            selectedCategory = "Non-Technical";
          } else {
            selectedCategory = "Technical";
          }
          educationDetails = (data['education'] as List)
              .map((education) => {
                    "degree": education["course"],
                    "university": education["institution"],
                    "startYear": education["startDate"],
                    "endYear": education["endDate"]
                  })
              .toList();
          workExperienceDetails = (data['experience'] as List)
              .map((experience) => {
                    "jobTitle": experience["title"],
                    "companyName": experience["company"],
                    "startYear": experience["year"],
                    "description": experience["description"]
                  })
              .toList();
          certificationDetails = (data['awards'] as List)
              .map((certification) => {
                    "certificationName": certification["title"],
                    "issuingOrganization": certification["organization"],
                    "issueYear": certification["year"],
                    "description": certification["description"]
                  })
              .toList();

          skillsDetails = (data['skills'] as List)
              .map((skill) => {
                    "skillName": skill["skillName"],
                    "knowledgeLevel": skill["knowledgeLevel"],
                    "experienceWeeks": skill["experienceWeeks"]
                  })
              .toList();
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

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

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        uploadedFileName = result.files.single.name; // Get the file name
      });
    }
  }

  void showAddEducationPopup() {
    final degreeController = TextEditingController();
    final universityController = TextEditingController();
    final startYearController = TextEditingController();
    String? startMonth;
    final endYearController = TextEditingController();
    String? endMonth;
    final cgpaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Rounded corners for elegance
          ),
          title: const Text(
            "Add Education Details",
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
                TextField(
                  controller: degreeController,
                  decoration: InputDecoration(
                    labelText: 'Degree',
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
                TextField(
                  controller: universityController,
                  decoration: InputDecoration(
                    labelText: 'University',
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: startYearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Start Year',
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
                      child: DropdownButtonFormField<String>(
                        value: startMonth,
                        onChanged: (value) {
                          setState(() {
                            startMonth = value;
                          });
                        },
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Start Month',
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: endYearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'End Year',
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
                      child: DropdownButtonFormField<String>(
                        value: endMonth,
                        onChanged: (value) {
                          setState(() {
                            endMonth = value;
                          });
                        },
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'End Month',
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
                TextField(
                  controller: cgpaController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: "CGPA or Percentage",
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
                if (startMonth != null && endMonth != null) {
                  setState(() {
                    educationDetails.add({
                      'degree': degreeController.text,
                      'university': universityController.text,
                      'startYear': startYearController.text,
                      'startMonth': startMonth!,
                      'endYear': endYearController.text,
                      'endMonth': endMonth!,
                      'cgpa': cgpaController.text,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded button
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to edit education details
  void showEditEducationPopup(int index) {
    final degreeController =
        TextEditingController(text: educationDetails[index]['degree']);
    final universityController =
        TextEditingController(text: educationDetails[index]['university']);
    final startYearController =
        TextEditingController(text: educationDetails[index]['startYear']);
    String? startMonth = educationDetails[index]['startMonth'];
    final endYearController =
        TextEditingController(text: educationDetails[index]['endYear']);
    String? endMonth = educationDetails[index]['endMonth'];
    final cgpaController =
        TextEditingController(text: educationDetails[index]['cgpa']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Rounded corners for elegance
          ),
          title: const Text(
            "Edit Education Details",
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
                TextField(
                  controller: degreeController,
                  decoration: InputDecoration(
                    labelText: 'Degree',
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
                TextField(
                  controller: universityController,
                  decoration: InputDecoration(
                    labelText: 'University',
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: startYearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Start Year',
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
                      child: DropdownButtonFormField<String>(
                        value: startMonth,
                        onChanged: (value) {
                          setState(() {
                            startMonth = value;
                          });
                        },
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Start Month',
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: endYearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'End Year',
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
                      child: DropdownButtonFormField<String>(
                        value: endMonth,
                        onChanged: (value) {
                          setState(() {
                            endMonth = value;
                          });
                        },
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'End Month',
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
                TextField(
                  controller: cgpaController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'CGPA or Percentage',
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
                if (startMonth != null && endMonth != null) {
                  setState(() {
                    educationDetails[index] = {
                      'degree': degreeController.text,
                      'university': universityController.text,
                      'startYear': startYearController.text,
                      'startMonth': startMonth!,
                      'endYear': endYearController.text,
                      'endMonth': endMonth!,
                      'cgpa': cgpaController.text,
                    };
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded button
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete education details
  void deleteEducationDetail(int index) {
    setState(() {
      educationDetails.removeAt(index);
    });
  }

  void showAddWorkExperiencePopup() {
    final jobTitleController = TextEditingController();
    final companyNameController = TextEditingController();
    final startYearController = TextEditingController();
    String? startMonth;
    final endYearController = TextEditingController();
    String? endMonth;
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          title: const Text(
            "Add Work Experience Details",
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: startYearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Start Year',
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
                      child: DropdownButtonFormField<String>(
                        value: startMonth,
                        onChanged: (value) {
                          setState(() {
                            startMonth = value;
                          });
                        },
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Start Month',
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: endYearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'End Year',
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
                      child: DropdownButtonFormField<String>(
                        value: endMonth,
                        onChanged: (value) {
                          setState(() {
                            endMonth = value;
                          });
                        },
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'End Month',
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
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
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
                if (startMonth != null && endMonth != null) {
                  setState(() {
                    workExperienceDetails.add({
                      'jobTitle': jobTitleController.text,
                      'companyName': companyNameController.text,
                      'startYear': startYearController.text,
                      'startMonth': startMonth!,
                      'endYear': endYearController.text,
                      'endMonth': endMonth!,
                      'description': descriptionController.text,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded button
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to edit work experience details
  void showEditWorkExperiencePopup(int index) {
    final jobTitleController =
        TextEditingController(text: workExperienceDetails[index]['jobTitle']);
    final companyController = TextEditingController(
        text: workExperienceDetails[index]['companyName']);
    final startYearController =
        TextEditingController(text: workExperienceDetails[index]['startYear']);
    String? startMonth = workExperienceDetails[index]['startMonth'];
    final endYearController =
        TextEditingController(text: workExperienceDetails[index]['endYear']);
    String? endMonth = workExperienceDetails[index]['endMonth'];
    final descriptionController = TextEditingController(
        text: workExperienceDetails[index]['description']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Rounded corners for elegance
          ),
          title: const Text(
            "Edit Work Experience Details",
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
                TextField(
                  controller: companyController,
                  decoration: InputDecoration(
                    labelText: 'Company',
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: startYearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Start Year',
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
                      child: DropdownButtonFormField<String>(
                        value: startMonth,
                        onChanged: (value) {
                          setState(() {
                            startMonth = value;
                          });
                        },
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Start Month',
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: endYearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'End Year',
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
                      child: DropdownButtonFormField<String>(
                        value: endMonth,
                        onChanged: (value) {
                          setState(() {
                            endMonth = value;
                          });
                        },
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'End Month',
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
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
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
                if (startMonth != null && endMonth != null) {
                  setState(() {
                    workExperienceDetails[index] = {
                      'jobTitle': jobTitleController.text,
                      'companyName': companyController.text,
                      'startYear': startYearController.text,
                      'startMonth': startMonth!,
                      'endYear': endYearController.text,
                      'endMonth': endMonth!,
                      'description': descriptionController.text,
                    };
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded button
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete education details
  void deleteWorkExperienceDetail(int index) {
    setState(() {
      workExperienceDetails.removeAt(index);
    });
  }

  void showAddCertificationPopup() {
    final certificationNameController = TextEditingController();
    final issuingOrganizationController = TextEditingController();
    final issueYearController = TextEditingController();
    String? issueMonth;
    final expireYearController = TextEditingController();
    String? expireMonth;
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          title: const Text(
            "Add Certification Details",
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
                TextField(
                  controller: certificationNameController,
                  decoration: InputDecoration(
                    labelText: 'Certification Name',
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
                TextField(
                  controller: issuingOrganizationController,
                  decoration: InputDecoration(
                    labelText: 'Issuing Organization',
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: issueYearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Issue Year',
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
                      child: DropdownButtonFormField<String>(
                        value: issueMonth,
                        onChanged: (value) {
                          setState(() {
                            issueMonth = value;
                          });
                        },
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Issue Month',
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: expireYearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Expire Year',
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
                      child: DropdownButtonFormField<String>(
                        value: expireMonth,
                        onChanged: (value) {
                          setState(() {
                            expireMonth = value;
                          });
                        },
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Expire Month',
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
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
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
                if (issueMonth != null && expireMonth != null) {
                  setState(() {
                    certificationDetails.add({
                      'certificationName': certificationNameController.text,
                      'issuingOrganization': issuingOrganizationController.text,
                      'issueYear': issueYearController.text,
                      'issueMonth': issueMonth!,
                      'expireYear': expireYearController.text,
                      'expireMonth': expireMonth!,
                      'description': descriptionController.text,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded button
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to edit certification details
  void showEditCertificationPopup(int index) {
    final certificationNameController = TextEditingController(
        text: certificationDetails[index]['certificationName']);
    final issuingOrganizationController = TextEditingController(
        text: certificationDetails[index]['issuingOrganization']);
    final issueYearController =
        TextEditingController(text: certificationDetails[index]['issueYear']);
    String? issueMonth = certificationDetails[index]['issueMonth'];
    final expireYearController =
        TextEditingController(text: certificationDetails[index]['expireYear']);
    String? expireMonth = certificationDetails[index]['expireMonth'];
    final descriptionController =
        TextEditingController(text: certificationDetails[index]['description']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Rounded corners for elegance
          ),
          title: const Text(
            "Edit Certification Details",
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
                TextField(
                  controller: certificationNameController,
                  decoration: InputDecoration(
                    labelText: 'Certification Name',
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
                TextField(
                  controller: issuingOrganizationController,
                  decoration: InputDecoration(
                    labelText: 'Issuing Organization',
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: issueYearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Issue Year',
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
                      child: DropdownButtonFormField<String>(
                        value: issueMonth,
                        onChanged: (value) {
                          setState(() {
                            issueMonth = value;
                          });
                        },
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Issue Month',
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: expireYearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Expire Year',
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
                      child: DropdownButtonFormField<String>(
                        value: expireMonth,
                        onChanged: (value) {
                          setState(() {
                            expireMonth = value;
                          });
                        },
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Expire Month',
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
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
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
                if (issueMonth != null && expireMonth != null) {
                  setState(() {
                    certificationDetails[index] = {
                      'certificationName': certificationNameController.text,
                      'issuingOrganization': issuingOrganizationController.text,
                      'issueYear': issueYearController.text,
                      'issueMonth': issueMonth!,
                      'expireYear': expireYearController.text,
                      'expireMonth': expireMonth!,
                      'description': descriptionController.text,
                    };
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded button
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete education details
  void deleteCertificationsDetail(int index) {
    setState(() {
      certificationDetails.removeAt(index);
    });
  }

  void showAddSkillPopup() {
    final skillNameController = TextEditingController();
    final experienceController = TextEditingController();
    String? skillLevel; // Dropdown for skill level

    // Skill levels
    List<String> skillLevels = ['beginner', 'intermediate', 'advanced'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          title: const Text(
            "Add Skill Details",
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
                TextField(
                  controller: skillNameController,
                  decoration: InputDecoration(
                    labelText: 'Skill Name',
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
                TextField(
                  controller: experienceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Experience (in Weeks)',
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
                DropdownButtonFormField<String>(
                  value: skillLevel,
                  onChanged: (value) {
                    setState(() {
                      skillLevel = value;
                    });
                  },
                  items: skillLevels.map((String level) {
                    return DropdownMenuItem<String>(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Skill Level',
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
                if (skillLevel != null) {
                  setState(() {
                    skillsDetails.add({
                      'skillName': skillNameController.text,
                      'experienceWeeks': experienceController.text,
                      'knowledgeLevel': skillLevel!,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded button
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to edit skills details
  void showEditSkillPopup(int index) {
    final skillNameController =
        TextEditingController(text: skillsDetails[index]['skillName']);
    final experienceController = TextEditingController(
        text: skillsDetails[index]['experienceWeeks'].toString());
    String? level = skillsDetails[index]['knowledgeLevel'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Rounded corners for elegance
          ),
          title: const Text(
            "Edit Skill Details",
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
                TextField(
                  controller: skillNameController,
                  decoration: InputDecoration(
                    labelText: 'Skill Name',
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
                TextField(
                  controller: experienceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Experience (in Weeks)',
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
                DropdownButtonFormField<String>(
                  value: level,
                  onChanged: (value) {
                    setState(() {
                      level = value;
                    });
                  },
                  items: ['beginner', 'intermediate', 'advanced']
                      .map((String level) {
                    return DropdownMenuItem<String>(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Skill Level',
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
                if (level != null) {
                  setState(() {
                    skillsDetails[index] = {
                      'skillName': skillNameController.text,
                      'experienceWeeks': experienceController.text,
                      'knowledgeLevel': level!,
                    };
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded button
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete education details
  void deleteSkillDetail(int index) {
    setState(() {
      skillsDetails.removeAt(index);
    });
  }

  bool showAllCards = false; // Flag to control if all cards should be shown

  bool showAllWorkCards = false; // Flag to control if all cards should be shown

  bool showAllCertificationCards =
      false; // Flag to control if all cards should be shown

  bool showAllSkillCards =
      false; // Flag to control if all cards should be shown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFBFDBFE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Qualifications',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle Done action
            },
            child: const Text('Done',
                style: TextStyle(color: Colors.blue, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select your job type:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Technical'),
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
                      title: const Text('Non-Technical'),
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
              const Text(
                'Upload your resume:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(
                    'Upload PDF File',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (uploadedFileName != null)
                Row(
                  children: [
                    const Icon(Icons.insert_drive_file, color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        uploadedFileName!,
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Education Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: showAddEducationPopup,
                  ),
                ],
              ),
              Column(
                children: [
                  // Show only the first 2 cards initially
                  ...(showAllCards
                      ? educationDetails.map((education) {
                          int index = educationDetails.indexOf(education);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    '${education['degree']} - ${education['university']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Year: ${education['startYear']} - ${education['endYear']}',
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
                                            showEditEducationPopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            deleteEducationDetail(index),
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
                      : educationDetails.take(2).map((education) {
                          int index = educationDetails.indexOf(education);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    '${education['degree']} - ${education['university']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Year: ${education['startYear']} - ${education['endYear']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () =>
                                            showEditEducationPopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            deleteEducationDetail(index),
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
                  if (educationDetails.length > 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllCards = !showAllCards; // Toggle the view mode
                        });
                      },
                      child: Text(
                        showAllCards ? 'View Less' : 'View All',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Work Experience',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: showAddWorkExperiencePopup,
                  ),
                ],
              ),
              Column(
                children: [
                  // Show only the first 2 cards initially
                  ...(showAllWorkCards
                      ? workExperienceDetails.map((workExperience) {
                          int index =
                              workExperienceDetails.indexOf(workExperience);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    '${workExperience['jobTitle']} - ${workExperience['companyName']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Year: ${workExperience['startYear']} - ${workExperience['endYear']}\n${workExperience['description']}',
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
                                            showEditWorkExperiencePopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            deleteWorkExperienceDetail(index),
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
                      : workExperienceDetails.take(2).map((workExperience) {
                          int index =
                              workExperienceDetails.indexOf(workExperience);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    '${workExperience['jobTitle']} - ${workExperience['companyName']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Year: ${workExperience['startYear']} - ${workExperience['endYear']}\n${workExperience['description']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () =>
                                            showEditWorkExperiencePopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            deleteWorkExperienceDetail(index),
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
                  if (workExperienceDetails.length > 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllWorkCards =
                              !showAllWorkCards; // Toggle the view mode
                        });
                      },
                      child: Text(
                        showAllWorkCards ? 'View Less' : 'View All',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Certifications Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: showAddCertificationPopup,
                  ),
                ],
              ),
              Column(
                children: [
                  // Show only the first 2 cards initially
                  ...(showAllCertificationCards
                      ? certificationDetails.map((certification) {
                          int index =
                              certificationDetails.indexOf(certification);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    '${certification['certificationName']} - ${certification['issuingOrganization']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Issued: ${certification['issueMonth']} ${certification['issueYear']}'
                                    '${certification['expireYear'] != null ? '\nExpires: ${certification['expireMonth']} ${certification['expireYear']}' : ''}\n'
                                    '${certification['description']}',
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
                                            showEditCertificationPopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            deleteCertificationsDetail(index),
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
                      : certificationDetails.take(2).map((certification) {
                          int index =
                              certificationDetails.indexOf(certification);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    '${certification['certificationName']} - ${certification['issuingOrganization']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Issued: ${certification['issueMonth']} ${certification['issueYear']}'
                                    '${certification['expireYear'] != null ? '\nExpires: ${certification['expireMonth']} ${certification['expireYear']}' : ''}\n'
                                    '${certification['description']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () =>
                                            showEditCertificationPopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            deleteCertificationsDetail(index),
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
                  if (certificationDetails.length > 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllCertificationCards =
                              !showAllCertificationCards; // Toggle the view mode
                        });
                      },
                      child: Text(
                        showAllCertificationCards ? 'View Less' : 'View All',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Skills',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: showAddSkillPopup,
                  ),
                ],
              ),
              Column(
                children: [
                  // Show only the first 2 cards initially
                  ...(showAllSkillCards
                      ? skillsDetails.map((skill) {
                          int index = skillsDetails.indexOf(skill);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    '${skill['skillName']} - ${skill['knowledgeLevel']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Experience: ${skill['experienceWeeks']} weeks',
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
                                            showEditSkillPopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            deleteSkillDetail(index),
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
                      : skillsDetails.take(2).map((skill) {
                          int index = skillsDetails.indexOf(skill);
                          return Column(
                            children: [
                              Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                elevation: 0,
                                child: ListTile(
                                  title: Text(
                                    '${skill['skillName']} - ${skill['knowledgeLevel']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    'Experience: ${skill['experienceWeeks']} weeks',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () =>
                                            showEditSkillPopup(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            deleteSkillDetail(index),
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
                  if (skillsDetails.length > 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllSkillCards =
                              !showAllSkillCards; // Toggle the view mode
                        });
                      },
                      child: Text(
                        showAllSkillCards ? 'View Less' : 'View All',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton(
                    label: 'Back',
                    color: Colors.grey,
                    navigateTo: null, // Back button just pops the page
                    context: context,
                  ),
                  _buildButton(
                    label: 'Next Page',
                    color: Colors.blue,
                    navigateTo:
                        ProfileLinksScreen(), // Replace with your actual next screen
                    context: context,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required BuildContext context,
    Widget? navigateTo, // Nullable: If null, it pops; otherwise, it navigates
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (navigateTo == null) {
            Navigator.pop(context); // Go back
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => navigateTo),
            ); // Navigate to next page
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
