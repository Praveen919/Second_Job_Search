import 'package:flutter/material.dart';

class SMSScreen extends StatelessWidget {
  const SMSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          'SMS will appear here.',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
