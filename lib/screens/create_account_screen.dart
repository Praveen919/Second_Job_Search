import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Sky-blue background section (Logo part)
              Container(
                width: double.infinity,
                color: const Color(0xFFBFDBFE), // Sky-blue color
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
                      const SizedBox(height: 30),
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
                      // Get started for free Title
                      const Text(
                        'Get Started for free',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Email TextField
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Your Name TextField
                      const TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Password TextField
                      const TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Create New Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // SignUp Button
                      ElevatedButton(
                        onPressed: () {
                          // Handle login action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // Button color
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Sign Up'),
                      ),
                      const SizedBox(height: 20),
                      // Or Continue Section
                      const Text('Or SignUp with'),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // Handle Google Login
                            },
                            icon: const FaIcon(FontAwesomeIcons.google,
                                size: 25.0, color: Colors.red),
                            label: const Text('Google'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Handle Facebook Login
                            },
                            icon: const Icon(Icons.facebook,
                                size: 25.0, color: Colors.blue),
                            label: const Text('Facebook'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ],
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
