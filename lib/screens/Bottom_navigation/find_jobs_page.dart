import 'package:flutter/material.dart';

class FindJobsPageScreen extends StatefulWidget {
  const FindJobsPageScreen({super.key});

  @override
  State<FindJobsPageScreen> createState() => _FindJobsPageScreenState();
}

class _FindJobsPageScreenState extends State<FindJobsPageScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Find Jobs",
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }
}
