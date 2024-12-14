import 'package:flutter/material.dart';
import 'package:second_job_search/screens/Bottom_navigation/find_jobs_page.dart';
import 'package:second_job_search/screens/Bottom_navigation/home_page.dart';
import 'package:second_job_search/screens/Bottom_navigation/my_blogs_page.dart';
import 'package:second_job_search/screens/Bottom_navigation/my_profile_page.dart';
import 'package:second_job_search/screens/login.dart';
import 'package:second_job_search/screens/profile_screens/profile_cand_dashboard.dart';
import 'package:second_job_search/screens/saved_jobs_screen.dart';
import 'package:second_job_search/screens/notifications_screen.dart';
import 'package:second_job_search/screens/sms_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
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
          // Remove `const` from here
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15.0, 0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                  child: IconButton(
                    onPressed: () {
                      // Handle the button press action here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavedJobsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.bookmark_border,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                  child: IconButton(
                    onPressed: () {
                      // Handle the button press action here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                  child: IconButton(
                    onPressed: () {
                      // Handle the button press action here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SMSScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.sms,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: const Color(0xFFBFDBFE),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blueGrey[50],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header section for a more polished look
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFBFDBFE),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Dashboard ListTile
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: Icon(
                Icons.dashboard,
                color: Colors.blueGrey,
                size: 30,
              ),
              title: Text(
                "Dashboard",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // Your navigation logic here
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
                  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: Icon(
                Icons.login,
                color: const Color.fromARGB(255, 3, 79, 117),
                size: 24,
              ),
              title: Text(
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
            // Add other ListTiles with similar design
          ],
        ),
      ),
      backgroundColor: const Color(0xFFBFDBFE),
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
