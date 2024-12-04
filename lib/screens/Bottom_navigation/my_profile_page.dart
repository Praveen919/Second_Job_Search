import 'package:flutter/material.dart';

class MyProfilePageScreen extends StatefulWidget {
  const MyProfilePageScreen({super.key});

  @override
  State<MyProfilePageScreen> createState() => _MyProfilePageScreenState();
}

class _MyProfilePageScreenState extends State<MyProfilePageScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "My Profile",
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }
}
