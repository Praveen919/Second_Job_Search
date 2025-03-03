import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_job_search/screens/employeers/candidate_screen.dart';
import 'package:second_job_search/screens/employeers/company_details_screen.dart';
import 'package:second_job_search/screens/employeers/employee_dashbord.dart';
import 'package:second_job_search/screens/employeers/interview_screen.dart';
import 'package:second_job_search/screens/employeers/manage_jobs_screen.dart';
import 'package:second_job_search/screens/employeers/shorlist_resume_screen.dart';
import 'dart:io';
import 'package:second_job_search/screens/login.dart';
import 'package:second_job_search/screens/profile_screens/candidate_package_screen.dart';
import 'package:second_job_search/screens/profile_screens/password_update_screen.dart';
import 'package:second_job_search/screens/profile_screens/profile_cand_faq_screen.dart';
import 'package:second_job_search/screens/profile_screens/profile_resume_screen.dart/resume_screen.dart';
import 'package:second_job_search/screens/profile_screens/testinomials_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:second_job_search/screens/Candidate_Bottom_Navigation/my_profile_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:second_job_search/Config/config.dart'; // Ensure this import is correct

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  _EmployeeProfileScreenState createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  String profileName = "Alok Kushwaha";
  String location = "Mumbai, India";
  String? profileImagePath; // Updated to handle image URL
  final ImagePicker _picker = ImagePicker();



  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileName = prefs.getString('name') ?? profileName;
      String address = prefs.getString('address') ?? "Unknown Address";
      String country = prefs.getString('country') ?? "Unknown Country";
      location = "$address, $country";
      profileImagePath =
          prefs.getString('profileImage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Picture and Name
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _editProfilePicture();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: profileImagePath != null
                        ? NetworkImage("${AppConfig.baseUrl}$profileImagePath")
                        : const AssetImage('assets/logo.png') as ImageProvider,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  profileName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  location,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Resume Building Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  "Try resume building for easy apply",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Options
          Expanded(
            child: ListView(
              children: [
                _buildOption(
                  context,
                  icon: Icons.dashboard_outlined,
                  text: 'Employee Dashboard',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EmployeeDashboardscreen()));
                  },
                ),
                _buildOption(
                  context,
                  icon: Icons.person,
                  text: 'Edit Profile',
                  onTap: () async {
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(
                            userId: '${prefs.getString("userId")}'),
                      ),
                    );
                  },
                ),
                _buildOption(
                  context,
                  icon: Icons.person_2_outlined,
                  text: 'Company Details',
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompanyDetailsScreen(userId: '${prefs.getString("userId")}'),
                      ),
                    );
                  },
                ),
                _buildOption(
                  context,
                  icon: Icons.dashboard_customize_outlined,
                  text: 'Manage Jobs',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManageJobsScreen()));
                  },
                ),

                _buildOption(
                  context,
                  icon: Icons.sort_outlined,
                  text: 'Shortlisted Resumes',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const ShortlistedResumeScreen()));
                  },
                ),
                _buildOption(
                  context,
                  icon: Icons.person_2_outlined,
                  text: 'All Candidates',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const ManageCandidatesScreen()));
                  },
                ),
                _buildOption(
                  context,
                  icon: Icons.phone_in_talk_outlined,
                  text: 'Interviews',
                  onTap: () async {
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    String? employeeId = prefs
                        .getString("userId"); // Fetch from SharedPreferences

                    if (employeeId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InterviewSchedulingScreen(employeeId: employeeId),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Employee ID not found!")),
                      );
                    }
                  },
                ),
                _buildOption(
                  context,
                  icon: Icons.remove_red_eye_outlined,
                  text: 'Password Update',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const UpdatePasswordScreen()));
                  },
                ),
                _buildOption(
                  context,
                  icon: Icons.add_comment_outlined,
                  text: 'FAQ',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FAQScreen()));
                  },
                ),
                _buildOption(
                  context,
                  icon: Icons.ballot_outlined,
                  text: 'Testimonials',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TestimonialsScreen(),
                      ),
                    );
                  },
                ),
                _buildOption(
                  context,
                  icon: Icons.logout,
                  text: 'Log Out',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context,
      {required IconData icon,
        required String text,
        required VoidCallback onTap,
        bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.blue),
      title: Text(
        text,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Future<void> _editProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await uploadProfileImage(imageFile);
    }
  }

  Future<void> uploadProfileImage(File imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    if (userId == null) {
      print("User ID not found");
      return;
    }

    var uri = Uri.parse("${AppConfig.baseUrl}/api/users/update-image/$userId");
    var request = http.MultipartRequest("PUT", uri)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseData);

      if (jsonData['image'] != null && jsonData['image'] is String) {
        setState(() {
          profileImagePath = jsonData['image'];
        });

        prefs.setString(
            "profileImage", jsonData['image']); // Save to local storage
        print("Profile image updated successfully");
      } else {
        print("Invalid response: ${jsonData}");
      }
    } catch (e) {
      print("Error uploading profile image: $e");
    }
  }
}

class EditProfileScreen extends StatefulWidget {
  final String userId;

  const EditProfileScreen({super.key, required this.userId});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  String? selectedGender = "Male";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data on screen load
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
          Uri.parse('${AppConfig.baseUrl}/api/users/${widget.userId}'),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          fullNameController.text = data['name'] ?? '';
          nicknameController.text = data['username'] ?? '';
          emailController.text = data['email'] ?? '';
          phoneController.text = data['mobile1'] ?? '';
          addressController.text = data['address'] ?? '';
          selectedGender = data['gender'] ?? 'Female';
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  Future<void> _updateUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apiUrl =
        '${AppConfig.baseUrl}/api/users/update-data/${widget.userId}';
    final body = {
      "name": fullNameController.text,
      "username": nicknameController.text,
      "email": emailController.text,
      "mobile1": phoneController.text,
      "address": addressController.text,
      "gender": selectedGender,
      "country": countryController.text,
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final updatedUser = jsonDecode(response.body);
        print("User updated successfully: $updatedUser");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
        prefs.setString("name", fullNameController.text);
        prefs.setString("address", addressController.text);
      } else {
        print("Failed to update user: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred ")),
      );
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    nicknameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    licenseController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildTextField(
                    label: "Full Name",
                    hintText: "Enter your full name",
                    controller: fullNameController,
                    icon: Icons.person),
                const SizedBox(height: 16),
                _buildTextField(
                    label: "Username",
                    hintText: "Enter your username",
                    controller: nicknameController,
                    icon: Icons.tag),
                const SizedBox(height: 16),
                _buildTextField(
                    label: "Email",
                    hintText: "Enter your email",
                    controller: emailController,
                    icon: Icons.email),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                          label: "Phone",
                          hintText: "Enter your phone number",
                          controller: phoneController,
                          icon: Icons.phone),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Gender",
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 12),
                        ),
                        value: selectedGender,
                        items: const [
                          DropdownMenuItem(value: "Male", child: Text("Male")),
                          DropdownMenuItem(
                              value: "Female", child: Text("Female")),
                          DropdownMenuItem(
                              value: "Other", child: Text("Other")),
                        ],
                        onChanged: (value) =>
                            setState(() => selectedGender = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                    label: "Address",
                    hintText: "Enter your address",
                    controller: addressController,
                    icon: Icons.location_on),
                const SizedBox(height: 16),
                _buildTextField(
                    label: "Country",
                    hintText: "Country",
                    controller: countryController,
                    icon: Icons.gps_fixed),
                const SizedBox(height: 16),
                _buildTextField(
                    label: "License Number: ",
                    hintText: "License Number",
                    controller: addressController,
                    icon: Icons.card_membership),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _updateUserData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("SUBMIT",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                  child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
