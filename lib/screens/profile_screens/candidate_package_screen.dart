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

  final List<Map<String, String>> packages1 = [
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Currently active packages',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ...packages1.map(
                      (package1) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 210, 210, 211)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    package1['title']!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    package1['price']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                package1['description']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                package1['feature1']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 71, 71, 71),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                package1['feature2']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 71, 71, 71),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                package1['feature3']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 71, 71, 71),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _subscribe(package1['title']!);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 159, 160, 160),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                      ),
                                      child: const Text(
                                        'Activatied',
                                        style: TextStyle(
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
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Choose a subscription package',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ...packages.map(
                      (package) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    package['title']!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    package['price']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                package['description']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                package['feature1']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 71, 71, 71),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                package['feature2']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 71, 71, 71),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                package['feature3']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 71, 71, 71),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _subscribe(package['title']!);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                      ),
                                      child: const Text(
                                        'Buy Now',
                                        style: TextStyle(
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
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
