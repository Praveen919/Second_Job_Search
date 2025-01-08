import 'package:flutter/material.dart';
import 'package:second_job_search/screens/employeers/company_links_screen.dart';

class CompanyDetailsScreen extends StatelessWidget {
  const CompanyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Company Details',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle Done action
            },
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: const AssetImage(
                          'assets/logo.png'), // Replace with actual image
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        // Handle Change Profile Photo action
                      },
                      child: const Text(
                        'Change Profile Photo',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ..._buildEditableRows([
                      {'label': 'Company Name', 'value': 'SAdf'},
                      {'label': 'Email', 'value': 'ujfythdth64@gmail.com'},
                      {'label': 'Company Website', 'value': '+91 9881678837'},
                      {'label': 'Company Address', 'value': 'Male'},
                      {'label': 'Company Index No.', 'value': 'India'},
                      {'label': 'Establishment Year', 'value': 'Dharavi'},
                      {'label': 'Contact Person No.', 'value': 'Dharavi'},
                      {'label': 'Official Email', 'value': 'Dharavi'},
                      {'label': 'Personal Email', 'value': 'Dharavi'},
                      {'label': 'Contact No.', 'value': 'Dharavi'},
                      {'label': 'Call Timings', 'value': 'Dharavi'},
                      {'label': 'Referral Code', 'value': 'Dharavi'},
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Next page action
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompanyLinksScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: Text(
                      'Next Page',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEditableRows(List<Map<String, String>> fields) {
    return fields.map((field) {
      return Column(
        children: [
          _buildEditableRow(
              label: field['label']!, initialValue: field['value']!),
          const Divider(),
        ],
      );
    }).toList();
  }

  Widget _buildEditableRow({
    required String label,
    required String initialValue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            initialValue: initialValue,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5),
            ),
          ),
        ),
      ],
    );
  }
}
