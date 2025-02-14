import 'package:flutter/material.dart';
import 'package:second_job_search/screens/employeers/company_links_screen.dart';
import 'package:second_job_search/Config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompanyDetailsScreen extends StatefulWidget {
  const CompanyDetailsScreen({super.key, required this.userId});
  final String userId;

  @override
  _CompanyDetailsScreenState createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController indexNoController = TextEditingController();
  final TextEditingController establishmentYearController = TextEditingController();
  final TextEditingController contactPersonNameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController officialEmailController = TextEditingController();
  final TextEditingController personalEmailController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();
  final TextEditingController callTimingsController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data on screen load
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
          Uri.parse('${AppConfig.baseUrl}/api/users/details/${prefs.getString("userId")}'),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          companyNameController.text = data['companyName'] ?? '';
          emailController.text = data['email'] ?? '';
          websiteController.text = data['companyWebsite'] ?? '';
          addressController.text = data['companyAddress'] ?? '';
          indexNoController.text = data['companyIndexNo'] ?? '';
          establishmentYearController.text = data['companyEstablishmentYear'].toString() ?? '';
          contactPersonNameController.text = data['companyContactPerson']?['name'] ?? '';
          countryController.text = data['companyContactPerson']?['country'] ?? '';
          officialEmailController.text = data['companyContactPerson']?['officialEmail'] ?? '';
          personalEmailController.text = data['companyContactPerson']?['personalEmail'] ?? '';
          contactNoController.text = data['companyContactPerson']?['mobileNumber'] ?? '';
          callTimingsController.text = data['companyContactPerson']?['callTimings'] ?? '';
          referralCodeController.text = data['myrefcode'] ?? '';

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load company data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading company data: $e')),
      );
    }
  }

  Future<void> _updateUserData() async {
    final apiUrl = '${AppConfig.baseUrl}/api/users/update-companyData/${widget.userId}';
    final body = {
      "companyName": companyNameController.text,
      "email": emailController.text,
      "companyWebsite": websiteController.text,
      "companyAddress": addressController.text,
      "companyIndexNo": indexNoController.text,
      "companyEstablishmentYear": int.tryParse(establishmentYearController.text) ?? 0, // Ensuring it's an integer
      "companyContactPerson": {
        "name": contactPersonNameController.text,
        "country": countryController.text,
        "officialEmail": officialEmailController.text,
        "personalEmail": personalEmailController.text,
        "mobileNumber": contactNoController.text,
        "callTimings": callTimingsController.text,
      },
      "myrefcode": referralCodeController.text,
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Company details updated successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update company details")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Company Details',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        actions: [
          TextButton(
            onPressed: _updateUserData,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/logo.png'),
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
                      'Company Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ..._buildEditableRows([
                      {'label': 'Company Name', 'controller': companyNameController},
                      {'label': 'Email', 'controller': emailController},
                      {'label': 'Company Website', 'controller': websiteController},
                      {'label': 'Company Address', 'controller': addressController},
                      {'label': 'Company Index No.', 'controller': indexNoController},
                      {'label': 'Establishment Year', 'controller': establishmentYearController},
                      {'label': 'Contact Person Name.', 'controller': contactPersonNameController},
                      {'label': 'Country', 'controller': countryController},
                      {'label': 'Official Email', 'controller': officialEmailController},
                      {'label': 'Personal Email', 'controller': personalEmailController},
                      {'label': 'Contact No.', 'controller': contactNoController},
                      {'label': 'Call Timings', 'controller': callTimingsController},
                      {'label': 'Referral Code', 'controller': referralCodeController},
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
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

  List<Widget> _buildEditableRows(List<Map<String, dynamic>> fields) {
    return fields.map((field) {
      return Column(
        children: [
          _buildEditableRow(
              label: field['label']!, controller: field['controller']!),
          const Divider(),
        ],
      );
    }).toList();
  }

  Widget _buildEditableRow({
    required String label,
    required TextEditingController controller,
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
            controller: controller,
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