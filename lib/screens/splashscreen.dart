import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:second_job_search/screens/employeers/employer_main_home.dart';
import 'package:second_job_search/screens/login.dart';
import 'package:second_job_search/screens/main_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("role") == "candidate") {
      Future.delayed(const Duration(milliseconds: 4000), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    } else if (prefs.getString("role") == "employer") {
      Future.delayed(const Duration(milliseconds: 4000), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EmployerHomeScreen()),
        );
      });
    } else {
      Future.delayed(const Duration(milliseconds: 4000), () {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 250,
                height: 250,
              ),
              const Text(
                "Second Job Search",
                style: TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 5, 64, 146),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const SpinKitWave(
                color: Color.fromARGB(255, 5, 64, 146),
                size: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
