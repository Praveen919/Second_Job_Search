import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:second_job_search/screens/login.dart';
import 'package:second_job_search/Config/config.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool isLoading = false;
  bool isDndEnabled = false;
  int dndDuration = 0;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadDndPreference();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  Future<void> _loadDndPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDndEnabled = prefs.getBool('dndMode') ?? false;
      dndDuration = prefs.getInt('dndDuration') ?? 0;
    });
  }

  Future<void> _setDnd(int days) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dndMode', true);
    await prefs.setInt('dndDuration', days);
    setState(() {
      isDndEnabled = true;
      dndDuration = days;
    });
  }

  void _showDndPopup() {
    int selectedDays = 7;
    TextEditingController customDaysController = TextEditingController();
    bool isCustom = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Do Not Disturb'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Choose duration for Do Not Disturb mode:'),
                  DropdownButton<int>(
                    value: isCustom ? null : selectedDays,
                    isExpanded: true,
                    hint: const Text("Select Duration"),
                    onChanged: (value) {
                      setDialogState(() {
                        if (value == -1) {
                          isCustom = true;
                        } else {
                          isCustom = false;
                          selectedDays = value ?? 7;
                        }
                      });
                    },
                    items: const [
                      DropdownMenuItem(value: 7, child: Text('1 Week')),
                      DropdownMenuItem(value: 30, child: Text('1 Month')),
                      DropdownMenuItem(value: -1, child: Text('Custom')),
                    ],
                  ),
                  if (isCustom)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: customDaysController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Enter days (max 60)'),
                        onChanged: (value) {
                          int days = int.tryParse(value) ?? 0;
                          if (days > 60) days = 60;
                          setDialogState(() {
                            selectedDays = days;
                          });
                        },
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isCustom) {
                      int days = int.tryParse(customDaysController.text) ?? 0;
                      if (days <= 0 || days > 60) {
                        _showSnackbar('Enter a valid number between 1 and 60',
                            Colors.red);
                        return;
                      }
                      _setDnd(days);
                    } else {
                      _setDnd(selectedDays);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Enable'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _confirmAction(
      String title, String message, Function(String) onConfirm) {
    TextEditingController passwordController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Enter your password'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm(passwordController.text);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _deactivateAccount() async {
    _confirmAction('Deactivate Account',
        'Are you sure you want to deactivate your account?', (password) async {
      setState(() => isLoading = true);
      final response = await http.patch(
        Uri.parse('${AppConfig.baseUrl}/api/users/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: '{"password": "$password"}',
      );
      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        _showSnackbar('Incorrect password or failed to deactivate', Colors.red);
      }
    });
  }

  Future<void> _deleteAccount() async {
    _confirmAction('Delete Account', 'Are you sure? This cannot be undone!',
        (password) async {
      setState(() => isLoading = true);
      final response = await http.delete(
        Uri.parse('${AppConfig.baseUrl}/api/users/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: '{"password": "$password"}',
      );
      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        _showSnackbar('Incorrect password or failed to delete', Colors.red);
      }
    });
  }

  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: const Text(
              'Privacy Policy: We collect minimal data and do not share it. '
              'You have full control over your information and can delete it at any time.',
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSettingTile(
                  'Do Not Disturb', Icons.notifications_off, _showDndPopup),
              _buildSettingTile('Deactivate Account',
                  Icons.pause_circle_outline, _deactivateAccount),
              _buildSettingTile(
                  'Delete Account', Icons.delete_forever, _deleteAccount),
              _buildSettingTile(
                  'Privacy Policy', Icons.privacy_tip, _showPrivacyPolicy),
            ],
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
