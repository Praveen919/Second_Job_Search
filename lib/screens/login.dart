import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:second_job_search/screens/create_account_screen.dart';
import 'package:second_job_search/screens/create_account_employer_screen.dart';
import 'package:second_job_search/screens/employeers/employer_main_home.dart';
import 'package:second_job_search/screens/change_password_screen.dart';
import 'package:http/http.dart' as http;
import 'package:second_job_search/screens/main_home.dart';
import 'package:second_job_search/Config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final String userId;
  const LoginScreen({super.key,required this.userId});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  bool isOtpPopupVisible = false;
  int otpTimer = 60;
  Timer? timer;

  void startOtpTimer() {
    setState(() {
      otpTimer = 60;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (otpTimer > 0) {
          otpTimer--;
        } else {
          t.cancel();
        }
      });
    });
  }

  void showOtpPopup() {
    setState(() {
      isOtpPopupVisible = true;
    });
    startOtpTimer();
  }

  void closeOtpPopup() {
    setState(() {
      isOtpPopupVisible = false;
      otpController.clear();
    });
    timer?.cancel();
  }

  Future<void> handleLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });

    try {
      // Step 1: Request OTP (API 1)
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/users/request-login'), // Send OTP request
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );
      if (response.statusCode == 200) {
  final data = json.decode(response.body);
  final String userId = data['id'].toString();

  // Step 2: Fetch the user role (API 3)
  final String userEmail = emailController.text; 
  final roleResponse = await http.get(
    Uri.parse('${AppConfig.baseUrl}/api/users/email/$userEmail'),
    headers: {'Content-Type': 'application/json'},
  );

  if (roleResponse.statusCode == 200) {
    final roleData = json.decode(roleResponse.body);

    // Print the full role data to debug
    print("Role response data: $roleData"); // This will print the whole response object

    // Now print specific role details
    if (roleData != null) {
      print("Role fetched: ${roleData['role']}"); // Print the role
      print("User details fetched: ${roleData['name']}"); // Print user name or any other details
    }

    // Continue with the role
    final String role = roleData['role'].toString();

    // Show OTP Popup
    showOtpPopup();

    // Save user data and role to preferences for later use
    await prefs.setString('userId', userId);
    await prefs.setString('role', role);
    await prefs.setString('name', data['name'].toString());
    await prefs.setString('address', data['address'].toString());
    await prefs.setString('country', data['country'].toString());

  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to fetch user role')),
    );
  }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> submitOtp() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? role = prefs.getString('role'); // Ensure role is saved correctly

    if (role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Role not found in preferences')),
      );
      return;
    }

    try {
      // Step 2: Validate OTP (API 2)
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/users/login-otp'), // Validate OTP request
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailController.text,
          'otp': otpController.text,
        }),
      );

      if (response.statusCode == 200) {
        closeOtpPopup();

        // Navigate based on the role after OTP validation
        if (role == 'candidate') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (role == 'employer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const EmployerHomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unknown role')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    emailController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
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
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text('Forgot Password?'),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isLoading ? null : handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text('Log In'),
                          ),
                          const SizedBox(height: 20),
                          const Text('Or continue with'),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const FaIcon(FontAwesomeIcons.google,
                                    size: 25.0, color: Colors.red),
                                label: const Text('Google'),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const FaIcon(FontAwesomeIcons.apple,
                                    size: 25.0, color: Colors.black),
                                label: const Text('Apple'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateAccountScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'Register',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateAccountEmployerScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: "Don't have an employer account? ",
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'Register',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isOtpPopupVisible)
              Center(
                child: AlertDialog(
                  title: const Text('Enter OTP'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'OTP',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Time Remaining: $otpTimer seconds'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: closeOtpPopup,
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: isLoading ? null : submitOtp,
                      child: const Text('Submit OTP'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
