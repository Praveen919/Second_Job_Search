import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_job_search/screens/employeers/allapplicant_screen.dart';
import 'package:second_job_search/screens/employeers/candidate_screen.dart';
import 'package:second_job_search/screens/employeers/company_details_screen.dart';
import 'package:second_job_search/screens/employeers/employee_dashbord.dart';
import 'package:second_job_search/screens/employeers/manage_jobs_screen.dart';
import 'package:second_job_search/screens/employeers/shorlist_resume_screen.dart';
import 'dart:io';

import 'package:second_job_search/screens/login.dart';
import 'package:second_job_search/screens/profile_screens/candidate_package_screen.dart';
import 'package:second_job_search/screens/profile_screens/password_update_screen.dart';
import 'package:second_job_search/screens/profile_screens/profile_cand_faq_screen.dart';
import 'package:second_job_search/screens/profile_screens/profile_resume_screen.dart/resume_screen.dart';
import 'package:second_job_search/screens/profile_screens/testinomials_screen.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});
  @override
  _EmployeeProfileScreenState createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  String profileName = "Alok Kushwaha";
  String location = "Mumbai, India";
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
        backgroundColor: const Color(0xFFBFDBFE),
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
                  icon: Icons.person_2_outlined,
                  text: 'Company Details',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CompanyDetailsScreen()));
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
                  icon: Icons.article_outlined,
                  text: 'All Applications',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ApplicantsDashboard()));
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
