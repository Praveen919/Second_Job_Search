import 'package:flutter/material.dart';
import 'package:second_job_search/screens/splashscreen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:second_job_search/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Awesome Notifications
  await AwesomeNotifications().initialize(
    null, // Use default icon for notifications
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.teal,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'Second Job Search', // Title of the app
      theme: ThemeData(
        primarySwatch: Colors.blue, // Sets the primary color of your app
      ),
      home: const SplashScreen(), // Sets LoginScreen as the home screen
    );
  }
}
