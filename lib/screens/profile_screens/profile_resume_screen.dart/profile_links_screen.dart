import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../Config/config.dart';

class ProfileLinksScreen extends StatefulWidget {
  const ProfileLinksScreen({super.key});

  @override
  State<ProfileLinksScreen> createState() => _ProfileLinksScreenState();
}

class _ProfileLinksScreenState extends State<ProfileLinksScreen> {
  final Map<String, TextEditingController> personalInfoControllers = {
    'Portfolio Link': TextEditingController(),
    'GitHub Link': TextEditingController(),
    'LinkedIn Link': TextEditingController(),
    'Facebook Link': TextEditingController(),
    'Twitter Link': TextEditingController(),
    'Other Links': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _loadProfileLinkData();
  }

  Future<void> _loadProfileLinkData() async {
    String apiUrl = "${AppConfig.baseUrl}/api/users/676000e686328df24d5ad2b7";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          personalInfoControllers['Portfolio Link']!.text =
              data['portfolio'] ?? '';
          personalInfoControllers['GitHub Link']!.text = data['github'] ?? '';
          personalInfoControllers['LinkedIn Link']!.text =
              data['linkedin'] ?? '';
          personalInfoControllers['Facebook Link']!.text =
              data['facebook'] ?? '';
          personalInfoControllers['Twitter Link']!.text = data['twitter'] ?? '';
          personalInfoControllers['Other Links']!.text =
              data['googlePlus'] ?? '';
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  @override
  void dispose() {
    for (var controller in personalInfoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFBFDBFE),
        elevation: 0,
        title: const Text(
          'Social Links',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
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
                        'Social Links',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      ...personalInfoControllers.entries.map((entry) => Column(
                            children: [
                              _buildEditableRow(
                                label: entry.key,
                                controller: entry.value,
                              ),
                              const Divider(),
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildButton(
                      label: 'Back',
                      color: Colors.grey,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildButton(
                      label: 'Save',
                      color: Colors.blue,
                      onTap: () {
                        final updatedLinks = personalInfoControllers.map(
                          (key, controller) => MapEntry(key, controller.text),
                        );
                        print(updatedLinks);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// **Editable Row (Prevents Overflow)**
  Widget _buildEditableRow({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2, // Adjusts label width dynamically
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          const SizedBox(width: 10), // Space between label and text field
          Expanded(
            flex: 3, // Adjusts text field width dynamically
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **Reusable Button**
  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
