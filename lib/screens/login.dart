import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:second_job_search/screens/create_account_screen.dart';
import 'package:second_job_search/screens/change_password_screen.dart';
import 'package:second_job_search/screens/main_home.dart';

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
  int otpTimer = 60; // Timer in seconds
  Timer? timer;

  void startOtpTimer() {
    setState(() {
      otpTimer = 60;
    });
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
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

  void handleLogin() {
    showOtpPopup();
  }

  void submitOtp() {
    closeOtpPopup();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
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
                            width: 300.0, // Adjust logo width
                            height: 200.0,
                            fit: BoxFit.cover, // Adjust logo height
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
                          // Login Title
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          // Email TextField
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 15),
                          // Password TextField
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          // Forgot Password Section
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangePasswordScreen(),
                                  ),
                                );
                              },
                              child: Text('Forgot Password?'),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Login Button
                          ElevatedButton(
                            onPressed: isLoading ? null : handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text('Log In'),
                          ),
                          SizedBox(height: 20),
                          // Or Continue Section
                          Text('Or continue with'),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: FaIcon(FontAwesomeIcons.google, size: 25.0, color: Colors.red),
                                label: Text('Google'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  side: BorderSide(color: Colors.grey),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.facebook, size: 25.0, color: Colors.blue),
                                label: Text('Facebook'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  side: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          // Create Account Section
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateAccountScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'Create now',
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
            // OTP Popup Overlay
            if (isOtpPopupVisible)
              Center(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  width: 300.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enter OTP',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'OTP',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Time remaining: ${otpTimer}s',
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: otpTimer == 0 ? startOtpTimer : null,
                        child: Text('Resend OTP'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: submitOtp,
                        child: Text('Submit OTP'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
