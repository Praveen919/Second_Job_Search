import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:second_job_search/Config/config.dart';

class PlanPricingScreen extends StatefulWidget {
  final String userId;

  const PlanPricingScreen({super.key, required this.userId});

  @override
  _PlanPricingScreenState createState() => _PlanPricingScreenState();
}

class _PlanPricingScreenState extends State<PlanPricingScreen> {
  late Future<List<Plan>> futurePlans;

  @override
  void initState() {
    super.initState();
    futurePlans = fetchPlans();
  }

  Future<List<Plan>> fetchPlans() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/dynamic-plan'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((plan) => Plan.fromJson(plan)).toList();
    } else {
      throw Exception('Failed to load plans');
    }
  }

  Future<void> purchasePlan(String planName) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/plans/purchase');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "user_id": widget.userId,
        "plan_name": planName,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Plan Purchased Successfully!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Failed to purchase plan",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Soft neutral background
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 100, 176, 238),
        elevation: 2,
        title: const Text(
          'Choose a Plan',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: FutureBuilder<List<Plan>>(
        future: futurePlans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No plans available'));
          } else {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: snapshot.data!
                  .map((plan) => _buildPackageCard(plan))
                  .toList(),
            );
          }
        },
      ),
    );
  }

  Widget _buildPackageCard(Plan plan) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, // White background for contrast
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            plan.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            plan.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "\₹${plan.price}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 15),
          _buildFeatureRow(Icons.check_circle, plan.feature1),
          _buildFeatureRow(Icons.check_circle, plan.feature2),
          _buildFeatureRow(Icons.check_circle, plan.feature3),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => purchasePlan(plan.title),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
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

// Model Class for Plan
class Plan {
  final String title;
  final String description;
  final String price;
  final String feature1;
  final String feature2;
  final String feature3;

  Plan({
    required this.title,
    required this.description,
    required this.price,
    required this.feature1,
    required this.feature2,
    required this.feature3,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      title: json['plan_name'] ?? 'No Title',
      description: 'Subscription Plan',
      price: (json['plan_price'] ?? '0').toString(),
      feature1: '${json['no_of_days'] ?? 0} Days',
      feature2: '${json['paid_jobs'] ?? 0} Premium Jobs',
      feature3: '${json['free_jobs'] ?? 0} Free Jobs',
    );
  }
}
