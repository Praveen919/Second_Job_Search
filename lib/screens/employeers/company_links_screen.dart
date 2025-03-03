import 'package:flutter/material.dart';
import 'package:second_job_search/Config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:second_job_search/screens/employeers/company_contact_screen.dart'; // Import for navigation

class CompanyLinksScreen extends StatefulWidget {
  const CompanyLinksScreen({super.key, required this.userId});
  final String userId;

  @override
  State<CompanyLinksScreen> createState() => _CompanyLinksScreenState();
}

class _CompanyLinksScreenState extends State<CompanyLinksScreen> {
  final Map<String, String> socialLinks = {
    'linkedin': '',
    'github': '',
    'portfolio': '',
    'other': '',
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data on screen load
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // ✅ Debugging: Print SharedPreferences data
    print("Before Fetch - Email: ${prefs.getString("email")}");
    print("Before Fetch - Mobile1: ${prefs.getString("mobile1")}");
    print("Before Fetch - UserId: ${prefs.getString("userId")}");

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/users/details/${prefs.getString("userId")}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // ✅ Update SharedPreferences with fresh data
        await prefs.setString("email", data["email"]);
        await prefs.setString("mobile1", data["mobile1"] ?? "");
        await prefs.setString("userId", data["_id"]);

        setState(() {
          socialLinks['linkedin'] = data['linkedin'] ?? '';
          socialLinks['github'] = data['github'] ?? '';
          socialLinks['portfolio'] = data['portfolio'] ?? '';
          socialLinks['other'] = data['other'] ?? '';
          isLoading = false;
        });

        // ✅ Debugging: Print updated SharedPreferences
        print("After Fetch - Email: ${prefs.getString("email")}");
        print("After Fetch - Mobile1: ${prefs.getString("mobile1")}");
        print("After Fetch - UserId: ${prefs.getString("userId")}");

      } else {
        print('Failed to load user data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error in fetchUserData: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $e')),
      );
    }
  }

  Future<void> _updateUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email");
    final mobile1 = prefs.getString("mobile1");

    print('Email from SharedPreferences: $email');
    print('Mobile1 from SharedPreferences: $mobile1');

    // ✅ Ensure email & mobile1 exist
    if (email == null || mobile1 == null || email.isEmpty || mobile1.isEmpty) {
      print('❌ Email or mobile1 is missing');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email or mobile number is missing")),
      );
      return;
    }

    final apiUrl = '${AppConfig.baseUrl}/api/users/update-data-links/${prefs.getString("userId")}';

    // ✅ Print request body before sending
    final body = {
      "linkedin": socialLinks['linkedin']?.trim() ?? '',
      "github": socialLinks['github']?.trim() ?? '',
      "portfolio": socialLinks['portfolio']?.trim() ?? '',
      "other": socialLinks['other']?.trim() ?? '',
      "email": email,
      "mobileNumber": mobile1,
    };

    print("🔹 Request Body: $body");

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('✅ Social links updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Social links updated successfully")),
        );
      } else {
        print('❌ Failed to update social links. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('❌ Error in _updateUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred")),
      );
    }
  }


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
            onPressed: _updateUserData,
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                    ...socialLinks.keys.map((key) => Column(
                      children: [
                        _buildEditableRow(
                          label: key,
                          value: socialLinks[key]!,
                          onChanged: (newValue) {
                            setState(() {
                              socialLinks[key] = newValue;
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
                  onPressed: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.reload();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  CompanyContactScreen(userId: prefs.getString("userId") ?? ""),
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
