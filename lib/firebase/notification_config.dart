import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifn/firebase_options.dart';
@pragma('vm:entry-point')
class NotificationConfig {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await _initializeLocalNotification();
    await _showFlutterNotification(message);
  }

  static Future<void> initializeLocalNotification() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()!
        .requestNotificationsPermission();
    await _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((message) {
      _showFlutterNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("App open from background ${message.data}");
    });

    await _getFCMtoken();
    await _initializeLocalNotification();
    await _getInitNotification();
  }

  static Future<void> _initializeLocalNotification() async {
    const androidInit = AndroidInitializationSettings(
      '@drawable/launch_background',
    );
    const iOsInit = DarwinInitializationSettings();
    final initSetting = InitializationSettings(
      android: androidInit,
      iOS: iOsInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap when app is in the foreground
      },
      onDidReceiveBackgroundNotificationResponse:
          backgroundHandler, // Use the top-level function
    );
  }

  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic>? data = message.data;

    String title = notification?.title ?? data["title"] ?? "No Title";
    String body = notification?.body ?? data["body"] ?? "No body";

    var android = AndroidNotificationDetails(
      "channelId",
      "channelName",
      channelDescription: "Notification channel for the basic test",
      priority: Priority.high,
      importance: Importance.high,
    );
    var iOs = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var notificationDetails = NotificationDetails(android: android, iOS: iOs);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> _getInitNotification() async {
    var message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      print("App from terminated state via notification ${message.data}");
    }
  }

  static Future<void> _getFCMtoken() async {
    String? token = await _firebaseMessaging.getToken();
    print("FCM token : $token");
  }
}

@pragma('vm:entry-point')
void backgroundHandler(NotificationResponse notificationResponse) {
  // Handle the notification response here
}
