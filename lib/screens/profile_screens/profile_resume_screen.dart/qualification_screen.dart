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

  // Function to pick file (PDF)
  Future<void> pickFile() async {
    // Open the document picker and pick any document
    final result = await FlutterDocumentPicker.openDocument();

    if (result != null) {
      setState(() {
        uploadedFileName =
            result.split('/').last; // Extract file name from path
      });
    }
  }

  // Function to show the popup for adding education details
  void showAddEducationPopup() {
    final degreeController = TextEditingController();
    final universityController = TextEditingController();
    final yearController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Education Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: degreeController,
                decoration: const InputDecoration(labelText: 'Degree'),
              ),
              TextField(
                controller: universityController,
                decoration: const InputDecoration(labelText: 'University'),
              ),
              TextField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Year'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Save the education details
                setState(() {
                  educationDetails.add({
                    'degree': degreeController.text,
                    'university': universityController.text,
                    'year': yearController.text,
                  });
                });
                Navigator.of(context).pop();
              },
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
    final yearController =
        TextEditingController(text: educationDetails[index]['year']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Education Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: degreeController,
                decoration: const InputDecoration(labelText: 'Degree'),
              ),
              TextField(
                controller: universityController,
                decoration: const InputDecoration(labelText: 'University'),
              ),
              TextField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Year'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update the education details
                setState(() {
                  educationDetails[index] = {
                    'degree': degreeController.text,
                    'university': universityController.text,
                    'year': yearController.text,
                  };
                });
                Navigator.of(context).pop();
              },
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
            // Education details list and the + button
            Column(
              children: educationDetails.map((education) {
                int index = educationDetails.indexOf(education);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 5,
                  child: ListTile(
                    title: Text(
                        '${education['degree']} - ${education['university']}'),
                    subtitle: Text('Year: ${education['year']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showEditEducationPopup(index);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteEducationDetail(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
