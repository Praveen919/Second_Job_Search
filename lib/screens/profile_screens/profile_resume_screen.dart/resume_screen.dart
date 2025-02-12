import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:second_job_search/screens/profile_screens/profile_resume_screen.dart/qualification_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Config/config.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedGender = "Male"; // Default gender
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiUrl =
        "${AppConfig.baseUrl}/api/users/details/${prefs.getString("userId")}";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          _nameController.text = data["username"] ?? "";
          _emailController.text = data["email"] ?? "";
          _phoneController.text = data["mobile1"] ?? "";
          _selectedGender = data["gender"] ?? "Male";
          _nationalityController.text = data["nationality"] ?? "";
          _addressController.text = data["address"] ?? "";
          _isLoading = false;
        });
      } else {
        setState(() {
          _nameController.text = "John Doe";
          _emailController.text = "johndoe@example.com";
          _phoneController.text = "+1234567890";
          _selectedGender = "Male";
          _nationalityController.text = "American";
          _addressController.text = "123, Sample Street, New York, USA";
          _isLoading = false;
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 100, 176, 238),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Resume',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/logo.png')),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Change Profile Photo',
                              style: TextStyle(color: Colors.blue)),
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
                        const Text('Personal Information',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 15),
                        _buildEditableRow(
                            label: 'Full Name', controller: _nameController),
                        const Divider(),
                        _buildEditableRow(
                            label: 'Email', controller: _emailController),
                        const Divider(),
                        _buildEditableRow(
                            label: 'Phone', controller: _phoneController),
                        const Divider(),
                        _buildGenderDropdown(),
                        const Divider(),
                        _buildEditableRow(
                            label: 'Nationality',
                            controller: _nationalityController),
                        const Divider(),
                        _buildEditableRow(
                            label: 'Address', controller: _addressController),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Collect user data into a Map
                      Map<String, dynamic> userData = {
                        "Full Name": _nameController.text,
                        "Email": _emailController.text,
                        "Phone": _phoneController.text,
                        "Gender": _selectedGender,
                        "Nationality": _nationalityController.text,
                        "Address": _addressController.text,
                      };

                      // Navigate to QualificationScreen and pass userData
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QualificationScreen(userData: userData),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      child: Text('Next page',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEditableRow(
      {required String label, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100, // Fixed width for label
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          const SizedBox(width: 10), // Add spacing
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 100,
            child: Text("Gender",
                style: TextStyle(fontSize: 16, color: Colors.black54)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
              ),
              onChanged: (String? newValue) {
                setState(() => _selectedGender = newValue!);
              },
              items: ["Male", "Female", "Other"].map((String gender) {
                return DropdownMenuItem<String>(
                    value: gender, child: Text(gender));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
