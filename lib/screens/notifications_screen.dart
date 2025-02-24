import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:second_job_search/Config/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    _initializeNotificationListeners();
  }

  // Fetch notifications from the backend
  Future<void> _fetchNotifications() async {
    final response =
    await http.get(Uri.parse('${AppConfig.baseUrl}/api/notifications'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        notifications = List<Map<String, dynamic>>.from(data['notifications']);
      });
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  // Initialize notification listeners
  void _initializeNotificationListeners() {
    AwesomeNotifications().setListeners(
      onNotificationCreatedMethod: (ReceivedNotification notification) async {
        print('Notification created: ${notification.id}');
      },
      onNotificationDisplayedMethod: (ReceivedNotification notification) async {
        print('Notification displayed: ${notification.id}');
      },
      onActionReceivedMethod: (ReceivedAction action) async {
        print('Notification tapped: ${action.id}');
        // Navigate to the notifications screen when a notification is tapped
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsScreen(),
            ),
          );
        }
      },
      onDismissActionReceivedMethod: (ReceivedAction action) async {
        print('Notification dismissed: ${action.id}');
      },
    );
  }

  // Mark a notification as read
  Future<void> _markNotificationAsRead(String notificationId) async {
    final response = await http.put(
      Uri.parse(
          '${AppConfig.baseUrl}/api/notifications/$notificationId/mark-read'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'read': true}),
    );

    if (response.statusCode == 200) {
      _fetchNotifications(); // Refresh the list
    } else {
      throw Exception('Failed to mark notification as read');
    }
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
          // Notifications List
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationTile(notifications[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notification) {
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
          // Notification Title
          Text(
            notification["title"] ?? "No Title",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Notification Description
          if (notification["type"] == "comment")
            Text(
              notification["description"] ?? "No Description",
              style: const TextStyle(color: Colors.black54),
            ),
          if (notification["type"] == "file")
            Row(
              children: [
                const Icon(Icons.insert_drive_file, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  notification["description"] ?? "No File",
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
          const SizedBox(height: 8),
          // Notification Time
          Text(
            notification["time"] ?? "No Time",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          // Mark as Read Button
          if (!(notification["read"] ?? false))
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _markNotificationAsRead(notification["id"]),
                child: const Text(
                  "Mark as Read",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
