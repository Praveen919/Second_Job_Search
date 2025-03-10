import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:second_job_search/screens/login.dart'; // Import the employer login screen
import 'package:second_job_search/Config/config.dart';

class CreateAccountEmployerScreen extends StatefulWidget {
  const CreateAccountEmployerScreen({super.key});

  @override
  State<CreateAccountEmployerScreen> createState() =>
      _CreateAccountEmployerScreenState();
}

class _CreateAccountEmployerScreenState
    extends State<CreateAccountEmployerScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // Helper to show SnackBar
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // API Call for Sign Up (Employer Registration)
  Future<void> _signUp() async {
    final String email = _emailController.text.trim();
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String apiUrl = '${AppConfig.baseUrl}/api/users/register';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
          'role': 'employer', // Hardcoding the role as employer
        }),
      );

      if (response.statusCode == 201) {
        _showSnackBar('Registration successful!');
        // Redirect to the employer login screen after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        _showSnackBar(errorResponse['message'] ?? 'Failed to sign up',
            isError: true);
      }
    } catch (e) {
      _showSnackBar('Error: Unable to connect to the server', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Google Sign-In and send data to the same registration API
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        _showSnackBar('Google Sign-In canceled', isError: true);
        return;
      }

      // Extract user data from Google
      final String name = googleUser.displayName ?? "";
      final String email = googleUser.email;
      final String image = googleUser.photoUrl ?? "";

      // Show a dialog to create a password
      String? password = await _showPasswordDialog();

      if (password == null || password.isEmpty) {
        _showSnackBar('Password is required for registration', isError: true);
        return;
      }

      // Send data to backend using the register API
      final String apiUrl = '${AppConfig.baseUrl}/api/users/register';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': name,
          'image': image, // Optional
          'role': 'employer', // Default role
          'password': password, // Password entered by user
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar('Google Sign-Up successful!');

        // Navigate to the next screen (Modify as needed)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        _showSnackBar(errorResponse['message'] ?? 'Google Sign-Up failed',
            isError: true);
      }
    } catch (e) {
      _showSnackBar('Google Sign-In failed: $e', isError: true);
    }
  }

  Future<String?> _showPasswordDialog() async {
    String? password;
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();
    bool isPasswordVisible = false;

    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_passwordController.text.isEmpty ||
                        _confirmPasswordController.text.isEmpty) {
                      _showSnackBar('Both fields are required', isError: true);
                    } else if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      _showSnackBar('Passwords do not match', isError: true);
                    } else {
                      Navigator.pop(context, _passwordController.text);
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

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
                color: const Color(0xFFBFDBFE),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.png',
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
                      const Text(
                        'Create a free Second Job Search Account\nEmployer Registration',
                        textAlign: TextAlign.center,
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

                      // Username TextField
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'UserName',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Password TextField
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible, // Toggle visibility
                        decoration: InputDecoration(
                          labelText: 'Create New Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible =
                                    !_isPasswordVisible; // Toggle state
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sign Up Button
                      ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text('Register'),
                      ),
                      const SizedBox(height: 20),

                      const Text('Or Register with'),
                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _signInWithGoogle,
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
                            onPressed: () {},
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
