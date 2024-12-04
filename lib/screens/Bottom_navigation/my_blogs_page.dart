import 'package:flutter/material.dart';

class MyBlogsPageScreen extends StatefulWidget {
  const MyBlogsPageScreen({super.key});

  @override
  State<MyBlogsPageScreen> createState() => _MyBlogsPageScreenState();
}

class _MyBlogsPageScreenState extends State<MyBlogsPageScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "My Blogs",
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }
}
