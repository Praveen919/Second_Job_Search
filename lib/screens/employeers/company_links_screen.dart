import 'package:flutter/material.dart';
import 'package:second_job_search/screens/employeers/company_contact_screen.dart';

class CompanyLinksScreen extends StatefulWidget {
  const CompanyLinksScreen({super.key});

  @override
  State<CompanyLinksScreen> createState() => _CompanyLinksScreenState();
}

class _CompanyLinksScreenState extends State<CompanyLinksScreen> {
  final Map<String, String> personalInfo = {
    'LinkedIn Link': 'https://linkedin.com',
    'Facebook Link': 'https://facebook.com',
    'Twitter Link': 'https://twitter.com',
    'Google Plus Link': 'https://google.com',
    'Other Links': 'https://others.com',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 100, 176, 238),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Company Links',
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
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
                      'Social Links',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ...personalInfo.keys.map((key) => Column(
                          children: [
                            _buildEditableRow(
                              label: key,
                              value: personalInfo[key]!,
                              onChanged: (newValue) {
                                setState(() {
                                  personalInfo[key] = newValue;
                                });
                              },
                            ),
                            const Divider(),
                          ],
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompanyContactScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
}
