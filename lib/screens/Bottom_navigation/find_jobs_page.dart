import 'package:flutter/material.dart';

class FindJobsPageScreen extends StatefulWidget {
  const FindJobsPageScreen({super.key});

  @override
  State<FindJobsPageScreen> createState() => _FindJobsPageScreenState();
}

class _FindJobsPageScreenState extends State<FindJobsPageScreen> {
  String selectedJob = "All Jobs";
  String selectedLocation = "Location";
  String selectedSalary = "Salary";

  final List<String> jobOptions = ["All Jobs", "Full-Time", "Part-Time", "Remote"];
  final List<String> locationOptions = ["Location", "Paris", "New York", "London"];
  final List<String> salaryOptions = ["Salary", "<\$5K", "\$5K-\$10K", ">\$10K"];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFBFDBFE), // Light blue background
      child: Column(
        children: [
          // Search Bar and Filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Job',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDropdown(jobOptions, selectedJob, (newValue) {
                      setState(() {
                        selectedJob = newValue!;
                      });
                    }),
                    _buildDropdown(locationOptions, selectedLocation, (newValue) {
                      setState(() {
                        selectedLocation = newValue!;
                      });
                    }),
                    _buildDropdown(salaryOptions, selectedSalary, (newValue) {
                      setState(() {
                        selectedSalary = newValue!;
                      });
                    }),
                  ],
                ),
              ],
            ),
          ),

          // Job Cards
          Expanded(
            child: ListView.builder(
              itemCount: 2, // Example count
              itemBuilder: (context, index) {
                return _buildJobCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(List<String> options, String selectedValue, ValueChanged<String?> onChanged) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedValue,
          underline: const SizedBox(), // Remove default underline
          icon: const Icon(Icons.arrow_drop_down),
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildJobCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 24,
                  child: Text(
                    'Logo',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "ESS Solutions Ltd.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Sr. Backend Developer",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  "\$12K/mo",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.location_on_outlined, color: Colors.grey),
                    Text("Paris, French (Remote)",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF2563EB), // Button blue
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Apply"),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.bookmark_border, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
