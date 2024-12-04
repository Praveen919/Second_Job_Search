import 'package:flutter/material.dart';
import 'package:second_job_search/screens/Bottom_navigation/find_jobs_page.dart';
import 'package:second_job_search/screens/Bottom_navigation/home_page.dart';
import 'package:second_job_search/screens/Bottom_navigation/my_blogs_page.dart';
import 'package:second_job_search/screens/Bottom_navigation/my_profile_page.dart';

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
          height: 105.0,
          width: 105.0,
          fit: BoxFit.cover,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 15.0, 0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                  child: Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                  child: Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 5.0, 0),
                  child: Icon(
                    Icons.sms,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
        backgroundColor: const Color(0xFFBFDBFE),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: const Row(
                children: [
                  Icon(
                    Icons.dashboard,
                    color: Colors.black,
                  ),
                  Text(
                    "  Dashboard",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () {},
            ),
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
