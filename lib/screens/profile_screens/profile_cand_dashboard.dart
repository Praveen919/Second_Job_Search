import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Profilescreen extends StatelessWidget {
  const Profilescreen({super.key});

  // Reusable Container Widget
  Widget _buildInfoContainer({
    required IconData icon,
    required String count,
    required String label,
    required Color iconColor,
    required double containerWidth,
    required Color backgroundColor,
  }) {
    return Container(
      width: containerWidth,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
            child: Icon(
              icon,
              size: 35,
              color: iconColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 15, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: iconColor),
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white, // White background for the entire screen
      appBar: AppBar(
        backgroundColor: Colors.white, // White background for AppBar
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Howdy User!!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Color.fromARGB(255, 5, 64, 146)),
              ),
              const Text(
                'Last login: 7th October 2024, 1:25 pm - Unknown',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildInfoContainer(
                      icon: Icons.work_outline_rounded,
                      count: '1',
                      label: 'Applied Jobs',
                      iconColor: Colors.black,
                      backgroundColor: Colors.purpleAccent,
                      containerWidth: screenWidth * 0.4, // Responsive width
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInfoContainer(
                      icon: Icons.sticky_note_2_outlined,
                      count: '4525',
                      label: 'Job Alerts',
                      iconColor: Colors.black,
                      backgroundColor: Colors.black26,
                      containerWidth: screenWidth * 0.4, // Responsive width
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildInfoContainer(
                      icon: Icons.message_outlined,
                      count: '0',
                      label: 'Messages',
                      iconColor: Colors.black,
                      backgroundColor: Colors.black26,
                      containerWidth: screenWidth * 0.4, // Responsive width
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInfoContainer(
                      icon: Icons.bookmark_outline,
                      count: '0',
                      label: 'Shortlist',
                      iconColor: Colors.black,
                      backgroundColor: Colors.black26,
                      containerWidth: screenWidth * 0.4, // Responsive width
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const ProfileViewsChart(),
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
  String? tooltipText;

  final List<FlSpot> dataPoints = [
    const FlSpot(0, 5),
    const FlSpot(1, 10),
    const FlSpot(2, 7),
    const FlSpot(3, 12),
    const FlSpot(4, 15),
    const FlSpot(5, 9),
    const FlSpot(6, 20),
    const FlSpot(7, 18),
    const FlSpot(8, 14),
    const FlSpot(9, 22),
    const FlSpot(10, 11),
    const FlSpot(11, 25),
  ];

  void onSpotTapped(FlSpot spot) {
    setState(() {
      tooltipText = 'Views: ${spot.y.toInt()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return Container(
      height: 400,
      padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
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
          Text(
            'Your Profile Views',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05, // Responsive font size
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: screenWidth * 0.3, // Responsive width
            height: 30,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 228, 228, 228),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              dropdownColor: Colors.white,
              value: selectedPeriod,
              items: <String>['Daily', 'Weekly', 'Monthly']
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
              style: const TextStyle(color: Colors.white), // Text color
              underline: const SizedBox(), // Remove underline
              alignment: Alignment.center, // Center align the dropdown text
            ),
          ),
          const SizedBox(height: 16),
          if (tooltipText != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.blue,
              child: Text(
                tooltipText!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false), // Remove grid lines
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text('Jan');
                          case 1:
                            return const Text('Feb');
                          case 2:
                            return const Text('Mar');
                          case 3:
                            return const Text('Apr');
                          case 4:
                            return const Text('May');
                          case 5:
                            return const Text('Jun');
                          case 6:
                            return const Text('Jul');
                          case 7:
                            return const Text('Aug');
                          case 8:
                            return const Text('Sep');
                          case 9:
                            return const Text('Oct');
                          case 10:
                            return const Text('Nov');
                          case 11:
                            return const Text('Dec');
                          default:
                            return const Text('');
                        }
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: Color(0xff37434d), width: 1),
                    bottom: BorderSide(color: Color(0xff37434d), width: 1),
                  ),
                ),
                minX: 0,
                maxX: 11.5,
                minY: 0,
                maxY: 30,
                lineBarsData: [
                  // Glow Effect: Add a semi-transparent, thicker line
                  LineChartBarData(
                    spots: dataPoints,
                    isCurved: true,
                    color: Colors.orange
                        .withOpacity(0.3), // Semi-transparent orange
                    barWidth: 8, // Thicker for glow
                    belowBarData: BarAreaData(show: false),
                    dotData: const FlDotData(show: false),
                  ),
                  // Main Line: Thin and bright
                  LineChartBarData(
                    spots: dataPoints,
                    isCurved: true,
                    color: Colors.orange, // Bright orange
                    barWidth: 4,
                    belowBarData: BarAreaData(show: false),
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileViewsChart1 extends StatefulWidget {
  const ProfileViewsChart1({super.key});

  @override
  _ProfileViewsChartState createState() => _ProfileViewsChartState();
}

class _ProfileViewsChartState1 extends State<ProfileViewsChart> {
  String selectedPeriod = 'Monthly';
  String? tooltipText;

  final List<FlSpot> dataPoints = [
    const FlSpot(0, 5),
    const FlSpot(1, 10),
    const FlSpot(2, 7),
    const FlSpot(3, 12),
    const FlSpot(4, 15),
    const FlSpot(5, 9),
    const FlSpot(6, 20),
    const FlSpot(7, 18),
    const FlSpot(8, 14),
    const FlSpot(9, 22),
    const FlSpot(10, 11),
    const FlSpot(11, 25),
  ];

  void onSpotTapped(FlSpot spot) {
    setState(() {
      tooltipText = 'Views: ${spot.y.toInt()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return Container(
      height: 400,
      padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
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
          Text(
            'Your Profile Views',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05, // Responsive font size
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: screenWidth * 0.3, // Responsive width
            height: 30,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 228, 228, 228),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              dropdownColor: Colors.white,
              value: selectedPeriod,
              items: <String>['Daily', 'Weekly', 'Monthly']
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
              style: const TextStyle(color: Colors.white), // Text color
              underline: const SizedBox(), // Remove underline
              alignment: Alignment.center, // Center align the dropdown text
            ),
          ),
          const SizedBox(height: 16),
          if (tooltipText != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.blue,
              child: Text(
                tooltipText!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color(0xffe7e7e7),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Color(0xffe7e7e7),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text('Jan');
                          case 1:
                            return const Text('Feb');
                          case 2:
                            return const Text('Mar');
                          case 3:
                            return const Text('Apr');
                          case 4:
                            return const Text('May');
                          case 5:
                            return const Text('Jun');
                          case 6:
                            return const Text('Jul');
                          case 7:
                            return const Text('Aug');
                          case 8:
                            return const Text('Sep');
                          case 9:
                            return const Text('Oct');
                          case 10:
                            return const Text('Nov');
                          case 11:
                            return const Text('Dec');
                          default:
                            return const Text('');
                        }
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: Color(0xff37434d), width: 1),
                    bottom: BorderSide(color: Color(0xff37434d), width: 1),
                  ),
                ),
                minX: 0,
                maxX: 11.5,
                minY: 0,
                maxY: 30,
                lineBarsData: [
                  LineChartBarData(
                    spots: dataPoints,
                    isCurved: false,
                    color: const Color.fromARGB(255, 18, 96, 214),
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
