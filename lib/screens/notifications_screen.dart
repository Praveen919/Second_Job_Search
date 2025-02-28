import 'package:flutter/material.dart';
import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:second_job_search/Config/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> jobs = [];
  List<Map<String, dynamic>> messages = [];
  bool isLoading = true;
  String errorMessage = '';
  String? userId;
  String? userRole;
  Timer? _timer; // Timer for auto-refresh

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _startAutoNotificationCheck();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop timer when screen is closed
    super.dispose();
  }

  // Load user ID and role from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      userRole = prefs.getString('role') ?? 'candidate'; // Default to candidate
    });

    print("✅ Retrieved userId: $userId");
    print("✅ Retrieved userRole: $userRole");

    if (userId != null) {
      _fetchNotifications();
    } else {
      setState(() {
        errorMessage = "User not logged in.";
        isLoading = false;
      });
    }
  }

  // Auto-Check for New Notifications Every 30 Seconds
  void _startAutoNotificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      checkForNewNotifications();
    });
  }

  // Fetch all notifications from backend
  Future<void> _fetchNotifications() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      String endpoint = userRole == 'candidate'
          ? '${AppConfig.baseUrl}/api/notifications/candidate/$userId'
          : '${AppConfig.baseUrl}/api/notifications/employer/$userId';

      print("📢 API URL: $endpoint");

      final response = await http.get(Uri.parse(endpoint));

      print("📢 Response Status: ${response.statusCode}");
      print("📢 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          jobs = List<Map<String, dynamic>>.from(data['data']['jobs']);
          messages = List<Map<String, dynamic>>.from(data['data']['messages']);
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load notifications. Error Code: ${response.statusCode}';
        });
      }
    } catch (error) {
      print("❌ Error fetching notifications: $error");
      setState(() {
        errorMessage = 'Failed to load notifications. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Check backend for new notifications
  Future<void> checkForNewNotifications() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/notifications/latest/$userId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.isNotEmpty) {
        showLocalNotification(data['title'], data['body']);
      }
    }
  }

  // Show Local Notification
  Future<void> showLocalNotification(String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFFBFDBFE),
      ),
      body: Column(
        children: [
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          if (isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (!isLoading && (jobs.isNotEmpty || messages.isNotEmpty))
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchNotifications,
                child: ListView(
                  children: [
                    if (jobs.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Jobs',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                    ...jobs.map((job) => _buildJobTile(job)).toList(),
                    if (messages.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Messages',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                    ...messages.map((message) => _buildMessageTile(message)).toList(),
                  ],
                ),
              ),
            ),
          if (!isLoading && jobs.isEmpty && messages.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No notifications found.'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildJobTile(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job["jobTitle"] ?? "No Title",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            job["jobDescription"] ?? "No Description",
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            "Posted on: ${job["postedDate"] ?? "No Date"}",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(Map<String, dynamic> message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "From: ${message["senderName"] ?? "Unknown Sender"}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message["content"] ?? "No Content",
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            "Received on: ${message["time"] ?? "No Time"}",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
