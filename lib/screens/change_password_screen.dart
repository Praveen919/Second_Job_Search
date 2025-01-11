import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFFBFDBFE),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Sky-blue background section (Logo part)
              Container(
                width: double.infinity,
                color: Color(0xFFBFDBFE), // Sky-blue color
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.png', // Replace with your logo asset
                        width: 300.0, // Logo ki width adjust karein
                        height: 200.0,
                        fit: BoxFit.cover, // Logo ki height adjust karein
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Rest of the screen (white background)
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Change Password Title
                      Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Email TextField
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 15),
                      // OTP TextField
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'OTP',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Password TextField
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Create New Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      // SignUp Button
                      ElevatedButton(
                        onPressed: () {
                          // Handle login action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // Button color
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text('Change Password'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
