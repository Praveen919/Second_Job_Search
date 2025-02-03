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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            '${AppConfig.baseUrl}/api/users/login'), // Updated endpoint for simplicity
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );
// Print the response body for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract the role from the response
        final String role = data['role'];

        // Navigate based on role
        if (role == 'candidate') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (role == 'employer') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmployerHomeScreen()),
          );
        } else {
          // Handle unexpected roles or errors
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unknown role')),
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

/*  Future<void> submitOtp() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/users/login-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailController.text,
          'otp': otpController.text,
        }),
      );

      if (response.statusCode == 200) {
        closeOtpPopup();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
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
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Sky-blue background section
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
                  // Login Form  [Rest of the screen (white background)]
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(color: Colors.grey),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {},
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
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
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
                                text: "Don't have a candidate account? ",
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
                          const SizedBox(height: 5),
                          TextButton(
                            onPressed: () {
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
                                text: "Don't have a employer account? ",
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
            /*  // OTP Popup Overlay
            if (isOtpPopupVisible)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  width: 320.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Verify Your Identity',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Enter the OTP sent to your email.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'OTP',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0), // Correct way to set borderRadius
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: submitOtp,
                        child: const Text('Submit OTP'),
                      ),
                    ],
                  ),
                ),
              ),*/
          ],
        ),
      ),
    );
  }
}
