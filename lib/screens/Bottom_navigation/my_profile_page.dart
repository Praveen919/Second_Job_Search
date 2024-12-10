import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:second_job_search/screens/login.dart';
import 'package:second_job_search/screens/profile_screens/profile_cand_dashboard.dart';

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
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
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => EditProfileScreen()));
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
                  onTap: () {},
                ),
                _buildOption(
                  context,
                  icon: Icons.settings,
                  text: 'Account Settings',
                  onTap: () {},
                ),
                _buildOption(
                  context,
                  icon: Icons.notifications,
                  text: 'Notification Settings',
                  onTap: () {},
                ),
                _buildOption(
                  context,
                  icon: Icons.remove_red_eye_outlined,
                  text: 'Password Update',
                  onTap: () {},
                ),
                _buildOption(
                  context,
                  icon: Icons.add_comment_outlined,
                  text: 'FAQ',
                  onTap: () {},
                ),
                _buildOption(
                  context,
                  icon: Icons.ballot_outlined,
                  text: 'Testimonials',
                  onTap: () {},
                ),
                _buildOption(
                  context,
                  icon: Icons.logout,
                  text: 'Log Out',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
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

class EditProfileScreen extends StatelessWidget {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildTextField(
                label: "Full Name",
                hintText: "Enter your full name",
                icon: Icons.person,
                initialValue: "Puerto Rico",
              ),
              const SizedBox(height: 14.0),
              _buildTextField(
                label: "Nickname",
                hintText: "Enter your nickname",
                icon: Icons.tag,
                initialValue: "puerto.rico",
              ),
              const SizedBox(height: 14.0),
              _buildTextField(
                label: "Email",
                hintText: "Enter your email",
                icon: Icons.email,
                initialValue: "youremail@domain.com",
              ),
              const SizedBox(height: 14.0),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: "Phone",
                      hintText: "Enter your phone number",
                      icon: Icons.phone,
                      initialValue: "123-456-7890",
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
                      value: "Female",
                      items: const [
                        DropdownMenuItem(value: "Male", child: Text("Male")),
                        DropdownMenuItem(
                            value: "Female", child: Text("Female")),
                        DropdownMenuItem(value: "Other", child: Text("Other")),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14.0),
              _buildTextField(
                label: "Address",
                hintText: "Enter your address",
                icon: Icons.location_on,
                initialValue: "45 New Avenue, New York",
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle submit action
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    required IconData icon,
    String? initialValue,
  }) {
    return TextField(
      controller: TextEditingController(text: initialValue),
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
