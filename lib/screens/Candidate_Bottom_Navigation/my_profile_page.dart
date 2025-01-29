import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:second_job_search/screens/login.dart';
import 'package:second_job_search/screens/profile_screens/candidate_package_screen.dart';
import 'package:second_job_search/screens/profile_screens/password_update_screen.dart';
import 'package:second_job_search/screens/profile_screens/profile_cand_dashboard.dart';
import 'package:second_job_search/screens/profile_screens/profile_cand_faq_screen.dart';
import 'package:second_job_search/screens/profile_screens/profile_resume_screen.dart/resume_screen.dart';
import 'package:second_job_search/screens/profile_screens/testinomials_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfilePageScreen extends StatefulWidget {
  const MyProfilePageScreen({super.key});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<MyProfilePageScreen> {
  String profileName = "Raziul Shah";
  String location = "Dhaka, Bangladesh";
  File? profileImage; // Holds the uploaded image file

  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load the saved data on initialization
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileName = prefs.getString('name') ?? profileName;
      String address = prefs.getString('address') ?? "Unknown Address";
      String country = prefs.getString('country') ?? "Unknown Country";
      location = "$address, $country";
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
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!) as ImageProvider
                        : const AssetImage('assets/logo.png'),
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
                  icon: Icons.dashboard,
                  text: 'Dashboard',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profilescreen()));
                  },
                ),
                _buildOption(
                  context,
                  icon: Icons.article,
                  text: 'My Resume',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResumeScreen()));
                  },
                ),
                _buildOption(
                  context,
                  icon: Icons.settings,
                  text: 'Account Settings',
                  onTap: () {},
                ),
                _buildOption(
                  context,
                  icon: Icons.local_offer_outlined,
                  text: 'Packages',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SubscriptionScreen()));
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
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Take Photo"),
                onTap: () async {
                  final pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      profileImage = File(pickedFile.path);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  final pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      profileImage = File(pickedFile.path);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
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

  String? selectedGender = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data on screen load
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
          Uri.parse('http://localhost:8000/api/users/${widget.userId}'),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          fullNameController.text = data['name'] ?? '';
          nicknameController.text = data['username'] ?? '';
          emailController.text = data['email'] ?? '';
          phoneController.text = data['mobile1'] ?? '';
          addressController.text = data['address'] ?? '';
          selectedGender = data['gender'] ?? '';
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
    final apiUrl =
        'http://localhost:8000/api/users/update-data/${widget.userId}';
    final body = {
      "name": fullNameController.text,
      "username": nicknameController.text,
      "email": emailController.text,
      "mobile1": phoneController.text,
      "address": addressController.text,
      "gender": selectedGender,
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
      } else {
        print("Failed to update user: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred")),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildTextField(
                      label: "Full Name",
                      hintText: "Enter your full name",
                      controller: fullNameController,
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 14.0),
                    _buildTextField(
                      label: "Username",
                      hintText: "Enter your username",
                      controller: nicknameController,
                      icon: Icons.tag,
                    ),
                    const SizedBox(height: 14.0),
                    _buildTextField(
                      label: "Email",
                      hintText: "Enter your email",
                      controller: emailController,
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 14.0),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: "Phone",
                            hintText: "Enter your phone number",
                            controller: phoneController,
                            icon: Icons.phone,
                          ),
                        ),
                        const SizedBox(width: 14.0),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "Gender",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            value:
                                selectedGender, // Ensure this matches one of the DropdownMenuItem values exactly
                            items: const [
                              DropdownMenuItem(
                                  value: "Male", child: Text("Male")),
                              DropdownMenuItem(
                                  value: "Female", child: Text("Female")),
                              DropdownMenuItem(
                                  value: "Other", child: Text("Other")),
                            ],
                            onChanged: (value) {
                              // Handle gender selection change
                              selectedGender = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14.0),
                    _buildTextField(
                      label: "Address",
                      hintText: "Enter your address",
                      controller: addressController,
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle submit action
                          _updateUserData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          "SUBMIT",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
