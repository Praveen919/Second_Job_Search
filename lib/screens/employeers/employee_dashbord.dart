import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:second_job_search/screens/notifications_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:second_job_search/Config/config.dart';
import 'package:intl/intl.dart';

class EmployeeDashboardscreen extends StatefulWidget {
  const EmployeeDashboardscreen({super.key});

  @override
  State<EmployeeDashboardscreen> createState() =>
      _EmployeeDashboardscreenState();
}

class _EmployeeDashboardscreenState extends State<EmployeeDashboardscreen> {
  String? name = "";
  String? lastLoginTime = "";
  String? posted_jobs_count = "";
  String? candidates_count = "";
  String? messages_count = "";
  String? shortlist_count = "";

  String convertMongoDBTimestamp(String mongoTimestamp) {
    // Parse the MongoDB timestamp to DateTime
    DateTime dateTime = DateTime.parse(mongoTimestamp);

    // Format the DateTime object
    String formattedDate = DateFormat('d MMMM yyyy, h:mm a').format(dateTime);

    return formattedDate;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiUrl =
        "${AppConfig.baseUrl}/api/users/${prefs.getString("userId")}";
    String apiForPostedJobsUrl =
        "${AppConfig.baseUrl}/api/jobs/posted-jobs/${prefs.getString(
        "userId")}";
    String apiForCandidatesUrl =
        "${AppConfig.baseUrl}/api/applied-jobs/applicants-count/${prefs.getString("userId")}";
    String apiForMessagesUrl =
        "${AppConfig.baseUrl}/api/messages/notify/${prefs.getString("userId")}";
    String apiForShortlistUrl =
        "${AppConfig.baseUrl}/api/applied-jobs/shortlisted-count/${prefs.getString("userId")}";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);

        setState(() {
          lastLoginTime =
              convertMongoDBTimestamp(data['registeredTimeStamp'].toString())
                  .toString();
        });
      } else {
        setState(() {
          lastLoginTime = "11th February 2025, 9:46 AM";
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
    setState(() {
      name = prefs.getString("name");
      name = name?.split(" ")[0];
    });
    try {
      final response = await http.get(Uri.parse(apiForPostedJobsUrl));

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        posted_jobs_count = data['jobCount'].toString();
      } else {
        posted_jobs_count = "0";
      }
    } catch (error) {
      print("Error fetching data: $error");
    }

    try {
      final response = await http.get(Uri.parse(apiForCandidatesUrl));
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        print("Total Applications: ${data['totalApplications']}"); // Debugging line

        setState(() { // Ensure UI updates
          candidates_count = data['totalApplications'].toString();
        });
      } else {
        setState(() {
          candidates_count = "0";
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }

    try {
      final response = await http.get(Uri.parse(apiForMessagesUrl));

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        setState(() {
          messages_count = data["readCount"].toString();
        });
      } else {
        setState(() {
          messages_count = "0";
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }

    try {
      final response = await http.get(Uri.parse(apiForShortlistUrl));

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        print(
            "Total Shortlisted: ${data['totalShortlisted']}"); // Debugging line

        setState(() { // Ensure UI updates
          shortlist_count = data['totalShortlisted'].toString();
        });
      } else {
        setState(() {
          shortlist_count = "0";
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  // Reusable Container Widget
  Widget _buildInfoContainer({
    required IconData icon,
    required String count,
    required String label,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 35,
            color: iconColor,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: iconColor,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 100, 176, 238),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Howdy $name',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Color.fromARGB(255, 5, 64, 146),
                ),
              ),
              Text(
                'Registered on: $lastLoginTime - Unknown',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;

                  return Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: _buildInfoContainer(
                              icon: Icons.work_outline_rounded,
                              count: '$posted_jobs_count',
                              label: 'Posted Jobs',
                              iconColor: Colors.black,
                              backgroundColor:
                              const Color.fromARGB(255, 77, 177, 223),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: _buildInfoContainer(
                              icon: Icons.sticky_note_2_outlined,
                              count: '$candidates_count',
                              label: 'Candidates',
                              iconColor: Colors.black,
                              backgroundColor:
                              const Color.fromARGB(255, 18, 149, 209),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Flexible(
                            child: _buildInfoContainer(
                              icon: Icons.message_outlined,
                              count: '$messages_count',
                              label: 'Messages',
                              iconColor: Colors.black,
                              backgroundColor:
                              const Color.fromARGB(255, 18, 149, 209),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: _buildInfoContainer(
                              icon: Icons.bookmark_outline,
                              count: '$shortlist_count',
                              label: 'Shortlist',
                              iconColor: Colors.black,
                              backgroundColor:
                              const Color.fromARGB(255, 77, 177, 223),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              const ProfileViewsChart(),
              const SizedBox(height: 10),
              const Notifications(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileViewsChart extends StatefulWidget {
  const ProfileViewsChart({super.key});

  @override
  _ProfileViewsChartState createState() => _ProfileViewsChartState();
}

class _ProfileViewsChartState extends State<ProfileViewsChart> {
  String selectedPeriod = 'Monthly';
  Map<int, int> monthData = {};

  @override
  void initState() {
    super.initState();
    _loadGraphDataPoints();
  }

  Map<int, int> extractMonthCount(dynamic jsonData) {
    List<dynamic> dataList = jsonDecode(jsonData);
    Map<int, int> monthFrequency = {};

    for (var item in dataList) {
      DateTime date = DateTime.parse(item['postedDate']);
      int month = date.month;
      monthFrequency[month] = (monthFrequency[month] ?? 0) + 1;
    }

    return monthFrequency;
  }

  Future<void> _loadGraphDataPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiUrl = "${AppConfig.baseUrl}/api/jobs/posted-jobs/${prefs.getString("userId")}";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        int jobCount = int.tryParse(data['jobCount'].toString()) ?? 0;

        setState(() {
          monthData = {1: jobCount};  // Month 1 (Jan) pe Job Count dikhao
        });

        print("Updated Month Data: $monthData");
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }


  List<FlSpot> getDataPoints() {
    return List.generate(12, (index) {
      return FlSpot(
          (index + 1).toDouble(), monthData[index + 1]?.toDouble() ?? 0);
    });

  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 400,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Post Job Stats',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: screenWidth * 0.3,
            child: DropdownButton<String>(
              isExpanded: true,
              dropdownColor: Colors.white,
              value: selectedPeriod,
              items: ['Daily', 'Weekly', 'Monthly']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPeriod = newValue!;
                });
              },
              style: const TextStyle(color: Colors.black),
              underline: const SizedBox(),
              alignment: Alignment.center,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec'
                          ];
                          return Text(
                            months[value.toInt() - 1],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  minX: 1,
                  maxX: 12,
                  minY: 0,
                  maxY: monthData.values.isNotEmpty
                      ? (monthData.values.reduce((a, b) => a > b ? a : b) + 5)
                      .toDouble()
                      : 10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: getDataPoints(),
                      isCurved: true,
                      color: Colors.blue.shade700,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade200.withOpacity(0.4),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                              radius: 4,
                              color: Colors.blue.shade900,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                ),
              ),
              TextButton(
                onPressed: () async {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  String? userId = prefs.getString('userId');
                  String? userRole = prefs.getString('role') ??
                      'candidate'; // Default to candidate

                  if (userId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationsScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User not logged in')),
                    );
                  }
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Notification list
          Column(
            children: List.generate(notificationData.length, (index) {
              final notification = notificationData[index];
              return NotificationTile(notification: notification);
            }),
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: screenWidth * 0.035,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  notification.time,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: screenWidth * 0.03,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            notification.icon,
            color: Colors.blue,
            size: screenWidth * 0.06,
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final String time;
  final IconData icon;

  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
  });
}

final List<NotificationItem> notificationData = [
  NotificationItem(
    title: 'New Comment',
    description:
    'Dennis Nedry commented on Isla Nublar SOC2 compliance report: "Oh, I finished de-bugging the phones..."',
    time: 'Last Wednesday at 9:42 AM',
    icon: Icons.comment,
  ),
  NotificationItem(
    title: 'File Uploaded',
    description:
    'Dennis Nedry uploaded "landing_page_ver2.fig (2MB)" to Isla Nublar report.',
    time: 'Last Wednesday at 10:00 AM',
    icon: Icons.attach_file,
  ),
  NotificationItem(
    title: 'New Mention',
    description: '@You were mentioned in "Isla Nublar SOC2 compliance report"',
    time: 'Yesterday at 3:15 PM',
    icon: Icons.alternate_email,
  ),
];
