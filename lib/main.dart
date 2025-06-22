import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifn/firebase/firebase.dart';
import 'package:notifn/firebase/notification_config.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   print("Handling a background message: ${message.messageId}");
// }
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize local notifications
  await NotificationConfig.initializeLocalNotification();

  // Register the background message handler
  FirebaseMessaging.onBackgroundMessage(
    NotificationConfig.firebaseMessagingBackgroundHandler,
  );

  // Run the app
  runApp(MyApp());
}
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   // Register background handler
//   await NotificationConfig.initializeLocalNotification();
//   FirebaseMessaging.onBackgroundMessage(
//     NotificationConfig.firebaseMessagingBackgroundHandler,
//   );

//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NotificationHome());
  }
}

class NotificationHome extends StatefulWidget {
  const NotificationHome({super.key});

  @override
  NotificationHomeState createState() => NotificationHomeState();
}

class NotificationHomeState extends State<NotificationHome> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    print("sdasdasdsd");

    _messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'Notification';
      final body = message.notification?.body ?? '';

      // Show Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title: $body'),
          duration: Duration(seconds: 5),
        ),
      );

      // FirebaseNotificationConfig.showTestNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked: ${message.notification?.title}");
    });

    _messaging.getToken().then((token) {
      print("FCM Token: $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () async {}, child: Text("Test")),
      ),
    );
  }
}
