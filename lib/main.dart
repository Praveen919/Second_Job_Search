import 'package:flutter/material.dart';
import 'package:second_job_search/screens/splashscreen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Awesome Notifications
  await AwesomeNotifications().initialize(
    null, // Use default icon
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for local notifications',
        defaultColor: Colors.teal,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ],
  );

  // Request Notification Permissions
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // Set up notification listeners
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: onActionReceivedMethod,
    onNotificationCreatedMethod: (ReceivedNotification notification) async {
      print('Notification created: ${notification.id}');
    },
    onNotificationDisplayedMethod: (ReceivedNotification notification) async {
      print('Notification displayed: ${notification.id}');
    },
    onDismissActionReceivedMethod: (ReceivedAction action) async {
      print('Notification dismissed: ${action.id}');
    },
  );

  runApp(const MyApp());
}

// Global function to handle notification actions
@pragma("vm:entry-point")
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  print('Notification tapped: ${receivedAction.id}');
  // You can handle navigation or other actions here
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
      home: const SplashScreen(), // Sets SplashScreen as the home screen
    );
  }
}
