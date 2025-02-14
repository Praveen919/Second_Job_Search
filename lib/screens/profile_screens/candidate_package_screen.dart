import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Config/config.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  Map<String, dynamic>? activePackage;

  @override
  void initState() {
    super.initState();
    _loadActivePackage();
  }

  Future<void> _loadActivePackage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
        Uri.parse(
            '${AppConfig.baseUrl}/api/plans/user/${prefs.getString("userId") ?? ""}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['plans'] != null &&
            data['plans'] is List &&
            data['plans'].isNotEmpty) {
          var plan = data['plans'][0];

          setState(() {
            activePackage = {
              "title": plan["plan_name"]?.toString() ?? "Unknown Plan",
              "price": "₹${plan["plan_price"]?.toString() ?? "0"}/month",
              "start_date": _extractDate(plan["start_date"]),
              "end_date": _extractDate(plan["end_date"]),
              "duration": "${plan["no_of_days"]?.toString() ?? "N/A"} days",
              "features": [
                "${plan["paid_jobs"]?.toString() ?? "0"} Paid Jobs",
                "${plan["free_jobs"]?.toString() ?? "0"} Free Jobs",
              ],
            };
          });
        }
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  // Extracts only the date part (YYYY-MM-DD) from a datetime string
  String _extractDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return "N/A";
    return dateTime
        .split("T")[0]; // Assumes date format is "YYYY-MM-DDTHH:MM:SS"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 100, 176, 238),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Package Details',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: activePackage != null
            ? _buildPackageCard(activePackage!)
            : _buildNoSubscriptionUI(),
      ),
    );
  }

  Widget _buildPackageCard(Map<String, dynamic> package) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Keeps container small
        children: [
          // Subscription Name and Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                package['title'] ?? 'Unknown Plan',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Subscription Price
          Text(
            package['price'] ?? '',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[300]),

          // Subscription Dates
          _buildDetailRow(
              Icons.calendar_today, "Bought at: ${package['start_date']}"),
          _buildDetailRow(
              Icons.event_busy, "Expries at: ${package['end_date']}"),
          _buildDetailRow(Icons.timelapse, "Duration: ${package['duration']}"),

          const SizedBox(height: 10),
          Divider(color: Colors.grey[300]),

          // Features List
          const SizedBox(height: 6),
          ...package['features']
              .map<Widget>(
                  (feature) => _buildFeatureRow(Icons.check_circle, feature))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSubscriptionUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cancel, color: Colors.red, size: 70),
          const SizedBox(height: 14),
          const Text(
            'No Active Subscription',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/planPricingScreen');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('View Plans', style: TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
