import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PlanPricingScreen extends StatelessWidget {
  PlanPricingScreen({super.key});

  final List<Map<String, String>> packages = [
    {
      'title': 'Basic Plan',
      'description': 'Perfect for job seekers getting started.',
      'price': '₹100/month',
      'feature1': '5 Paid Job Applications',
      'feature2': '2 Free Job Applications',
      'feature3': 'Basic Support',
    },
    {
      'title': 'Standard Plan',
      'description': 'Ideal for regular job seekers.',
      'price': '₹500/month',
      'feature1': '20 Paid Job Applications',
      'feature2': '10 Free Job Applications',
      'feature3': 'Priority Support',
    },
    {
      'title': 'Premium Plan',
      'description': 'Best for professionals seeking top opportunities.',
      'price': '₹800/month',
      'feature1': '30 Paid Job Applications',
      'feature2': '15 Free Job Applications',
      'feature3': '24/7 Premium Support',
    },
  ];

  void _subscribe(String plan) {
    Fluttertoast.showToast(
      msg: 'Subscribed to $plan successfully.',
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 100, 176, 238), // Matching AppBar color
        elevation: 0,
        title: const Text('Choose a Plan',
            style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children:
            packages.map((package) => _buildPackageCard(package)).toList(),
      ),
    );
  }

  Widget _buildPackageCard(Map<String, String> package) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan Title
            Text(
              package['title']!,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 5),

            // Plan Description
            Text(
              package['description']!,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            // Plan Price
            Text(
              package['price']!,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 12),

            // Features List
            _buildFeatureRow(Icons.check_circle, package['feature1']!),
            _buildFeatureRow(Icons.check_circle, package['feature2']!),
            _buildFeatureRow(Icons.check_circle, package['feature3']!),
            const SizedBox(height: 20),

            // Buy Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _subscribe(package['title']!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
