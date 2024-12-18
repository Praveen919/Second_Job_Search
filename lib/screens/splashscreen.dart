import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:second_job_search/screens/main_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 4000), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
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
