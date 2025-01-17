import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final List<Map<String, String>> packages = [
    {
      'title': 'Basic Plan',
      'description': 'Access to basic features',
      'price': '₹100/monthly',
      'feature1': '5 paid job applied',
      'feature2': '2 free job applied',
      'feature3': 'Premium Support 24/7',
    },
    {
      'title': 'Standard Plan',
      'description': 'Access to all standard features',
      'price': '₹500/monthly',
      'feature1': '20 paid job applied',
      'feature2': '10 free job applied',
      'feature3': 'Premium Support 24/7',
    },
    {
      'title': 'Premium Plan',
      'description': 'All features included + priority support',
      'price': '₹800/monthly',
      'feature1': '30 paid job applied',
      'feature2': '15 free job applied',
      'feature3': 'Premium Support 24/7',
    },
  ];

  final List<Map<String, String>> activePackages = [
    {
      'title': 'Basic Plan',
      'description': 'Access to basic features',
      'price': '₹100/monthly',
      'feature1': '5 paid job applied',
      'feature2': '2 free job applied',
      'feature3': 'Premium Support 24/7',
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Subscription Packages',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Packages Section
              if (activePackages.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Currently Active Package',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...activePackages.map((package) => _buildPackageCard(
                      package,
                      screenWidth,
                      isActive: true,
                    )),
                    const SizedBox(height: 30),
                  ],
                ),
              // Subscription Packages Section
              const Text(
                'Choose a Subscription Package',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...packages.map((package) => _buildPackageCard(
                package,
                screenWidth,
                isActive: false,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard(Map<String, String> package, double screenWidth, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? Colors.grey[200] : Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    package['title']!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  package['price']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              package['description']!,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            ...['feature1', 'feature2', 'feature3']
                .map((key) => Text(
              package[key]!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ))
                ,
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isActive) _subscribe(package['title']!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isActive ? Colors.grey : Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      isActive ? 'Activated' : 'Buy Now',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
