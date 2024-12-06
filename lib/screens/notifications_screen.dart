import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int selectedTabIndex = 0; // 0: All, 1: Unread, 2: Read

  // Dummy data for notifications
  final List<Map<String, String>> notifications = [
    {
      "title": "Dennis Nedry commented on Isla Nublar SOC2 compliance report",
      "description":
      "Oh, I finished de-bugging the phones, but the system's compiling for eighteen minutes, or twenty...",
      "time": "Last Wednesday at 9:42 AM",
      "type": "comment",
    },
    {
      "title": "Dennis Nedry attached a file to Isla Nublar SOC2 compliance report",
      "description": "landing_page_ver2.fig - 2MB",
      "time": "Last Wednesday at 9:42 AM",
      "type": "file",
    },
    {
      "title": "Dennis Nedry commented on Isla Nublar SOC2 compliance report",
      "description":
      "Oh, I finished de-bugging the phones, but the system's compiling for eighteen minutes, or twenty...",
      "time": "Last Wednesday at 9:42 AM",
      "type": "comment",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFFBFDBFE),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs for All, Unread, Read
          Container(
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabButton("All", 0),
                _buildTabButton("Unread", 1),
                _buildTabButton("Read", 2),
              ],
            ),
          ),
          // Notifications List
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationTile(notifications[index]);
              },
            ),
          ),
          // "Mark all as read" Button
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // Handle mark all as read
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Mark all as read",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Filter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFilterOption("All", 0),
              _buildFilterOption("Unread", 1),
              _buildFilterOption("Read", 2),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                  // Handle "Mark all as read"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Mark all as read",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String label, int index) {
    return ListTile(
      title: Text(label),
      trailing: Radio<int>(
        value: index,
        groupValue: selectedTabIndex,
        onChanged: (value) {
          setState(() {
            selectedTabIndex = value!;
          });
          Navigator.pop(context); // Close the bottom sheet
        },
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          label,
          style: TextStyle(
            color: selectedTabIndex == index ? Colors.blue : Colors.black,
            fontWeight: selectedTabIndex == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, String> notification) {
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
            notification["title"]!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Notification Description
          if (notification["type"] == "comment")
            Text(
              notification["description"]!,
              style: const TextStyle(color: Colors.black54),
            ),
          if (notification["type"] == "file")
            Row(
              children: [
                const Icon(Icons.insert_drive_file, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  notification["description"]!,
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
          const SizedBox(height: 8),
          // Notification Time
          Text(
            notification["time"]!,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
