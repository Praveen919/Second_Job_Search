import 'package:flutter/material.dart';
import 'package:second_job_search/screens/Candidate_Bottom_Navigation/find_jobs_page.dart';
import 'package:second_job_search/screens/Candidate_Bottom_Navigation/home_page.dart';
import 'package:second_job_search/screens/Candidate_Bottom_Navigation/my_blogs_page.dart';
import 'package:second_job_search/screens/Candidate_Bottom_Navigation/my_profile_page.dart';
import 'package:second_job_search/screens/employeers/company_details_screen.dart';
import 'package:second_job_search/screens/employeers/employee_profile_screen.dart';
import 'package:second_job_search/screens/employeers/manage_jobs_screen.dart';
import 'package:second_job_search/screens/login.dart';
import 'package:second_job_search/screens/notifications_screen.dart';
import 'package:second_job_search/screens/plan_pricing_screen.dart';
import 'package:second_job_search/screens/profile_screens/profile_cand_dashboard.dart';
import 'package:second_job_search/screens/saved_jobs_screen.dart';
import 'package:second_job_search/screens/sms_screen.dart';
import 'package:second_job_search/screens/wallet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const MyBlogsPageScreen(),
    const FindJobsPageScreen(),
    const MyProfilePageScreen(),
  ];

  // Function to get user role from SharedPreferences
  Future<String> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole') ?? 'candidate'; // Default to candidate
  }

  // Function to get user ID from SharedPreferences
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Returns null if not found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Image.asset(
          'assets/logo.png',
          height: 80.0,
          width: 80.0,
          fit: BoxFit.cover,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15.0, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SavedJobsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                ),
                IconButton(
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
                  icon:
                      const Icon(Icons.notifications_none, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SmsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.sms, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 100, 176, 238),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blueGrey[50],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 100, 176, 238),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading:
                  const Icon(Icons.dashboard, color: Colors.blueGrey, size: 30),
              title: const Text(
                "Dashboard",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profilescreen(),
                  ),
                );
              },
            ),
            // Register/Login ListTile with added styling
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: const Icon(
                Icons.login,
                color: Color.fromARGB(255, 3, 79, 117),
                size: 24,
              ),
              title: const Text(
                "Register / Login",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // Your navigation logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: const Icon(
                Icons.group_work_rounded,
                color: Color.fromARGB(255, 3, 79, 117),
                size: 24,
              ),
              title: const Text(
                "Pricing",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // Your navigation logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlanPricingScreen(userId: ''),
                  ),
                );
              },
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: const Icon(
                Icons.wallet,
                color: Color.fromARGB(255, 3, 79, 117),
                size: 24,
              ),
              title: const Text(
                "Wallet",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // Your navigation logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WalletScreen(),
                  ),
                );
              },
            ),
            // Add other ListTiles with similar design
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 100, 176, 238),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.import_contacts),
            label: "My Blogs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: "Find Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "My Profile",
          ),
        ],
      ),
    );
  }
}
