import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // API Integration for SignUp
  Future<void> _signUp() async {
    final String email = _emailController.text.trim();
    final String name = _nameController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || name.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    try {
      // Replace with your backend URL
      const String apiUrl = 'http://192.168.0.104:8000/api/users/register';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'name': name,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        _showSnackBar('Account created successfully!');
        Navigator.pop(context); // Navigate back to login
      } else {
        final errorResponse = jsonDecode(response.body);
        _showSnackBar(errorResponse['message'] ?? 'Failed to sign up');
      }
    } catch (e) {
      _showSnackBar('Error: Unable to connect to the server');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
                        width: 300.0,
                        height: 200.0,
                        fit: BoxFit.cover,
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
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Your Name TextField
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Your Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Password TextField
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Create New Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // SignUp Button
                      ElevatedButton(
                        onPressed: _signUp,
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
                            icon: const FaIcon(
                              FontAwesomeIcons.google,
                              size: 25.0,
                              color: Colors.red,
                            ),
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
                            icon: const Icon(
                              Icons.facebook,
                              size: 25.0,
                              color: Colors.blue,
                            ),
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
