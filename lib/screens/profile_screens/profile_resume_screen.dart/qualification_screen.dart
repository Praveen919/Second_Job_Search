import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

class QualificationScreen extends StatefulWidget {
  const QualificationScreen({super.key});

  @override
  State<QualificationScreen> createState() => _QualificationScreenState();
}

class _QualificationScreenState extends State<QualificationScreen> {
  String? selectedCategory;
  String? uploadedFileName;

  // List to store education details
  List<Map<String, String>> educationDetails = [];

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
  Future<void> pickFile() async {
    final result = await FlutterDocumentPicker.openDocument();

    if (result != null) {
      setState(() {
        uploadedFileName =
            result.split('/').last; // Extract file name from path
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
<<<<<<< HEAD
            BorderRadius.circular(20), // Rounded corners for elegance
=======
                BorderRadius.circular(20), // Rounded corners for elegance
>>>>>>> 29042d470f00dc2d08357d61f438ddbfb4d21578
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
<<<<<<< HEAD
    TextEditingController(text: educationDetails[index]['university']);
    final startYearController =
    TextEditingController(text: educationDetails[index]['startYear']);
    String? startMonth = educationDetails[index]['startMonth'];
    final endYearController =
    TextEditingController(text: educationDetails[index]['endYear']);
    String? endMonth = educationDetails[index]['endMonth'];
    final cgpaController =
    TextEditingController(text: educationDetails[index]['cgpa']);
=======
        TextEditingController(text: educationDetails[index]['university']);
    final startYearController =
        TextEditingController(text: educationDetails[index]['startYear']);
    String? startMonth = educationDetails[index]['startMonth'];
    final endYearController =
        TextEditingController(text: educationDetails[index]['endYear']);
    String? endMonth = educationDetails[index]['endMonth'];
    final cgpaController =
        TextEditingController(text: educationDetails[index]['cgpa']);
>>>>>>> 29042d470f00dc2d08357d61f438ddbfb4d21578

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
<<<<<<< HEAD
            BorderRadius.circular(20), // Rounded corners for elegance
=======
                BorderRadius.circular(20), // Rounded corners for elegance
>>>>>>> 29042d470f00dc2d08357d61f438ddbfb4d21578
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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

  bool showAllCards = false; // Flag to control if all cards should be shown

  @override
  Widget build(BuildContext context) {
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
          'Qualifications',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: Padding(
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
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Education Details:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: showAddEducationPopup,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                // Show only the first 2 cards initially
                ...(showAllCards
                    ? educationDetails.map((education) {
<<<<<<< HEAD
                  int index = educationDetails.indexOf(education);
                  return Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
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
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    showEditEducationPopup(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
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
                        margin: const EdgeInsets.symmetric(vertical: 10),
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
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    showEditEducationPopup(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
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
=======
                        int index = educationDetails.indexOf(education);
                        return Column(
                          children: [
                            Card(
                              margin: const EdgeInsets.symmetric(vertical: 10),
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
                                      icon: const Icon(Icons.edit),
                                      onPressed: () =>
                                          showEditEducationPopup(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
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
                              margin: const EdgeInsets.symmetric(vertical: 10),
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
                                      icon: const Icon(Icons.edit),
                                      onPressed: () =>
                                          showEditEducationPopup(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
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
>>>>>>> 29042d470f00dc2d08357d61f438ddbfb4d21578
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
            )
          ],
        ),
      ),
    );
  }
}