import 'package:flutter/material.dart';
import 'package:second_job_search/screens/Employee_Screens/post_new_job_screen.dart';
import 'package:second_job_search/screens/splashscreen.dart';
// import 'package:second_job_search/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'Second Job Search', // Title of the app
      theme: ThemeData(
        primarySwatch: Colors.blue, // Sets the primary color of your app
      ),
      home: const EmplpoyeerNewJob(), // Sets LoginScreen as the home screen
    );
  }
}
