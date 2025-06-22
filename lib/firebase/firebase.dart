import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifn/firebase_options.dart';

class FcmNotification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'order', // id
    'order', // title
    description: 'This channel is used for incoming order', // description
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound("alarm"),
  );

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.data["title"],
      message.data["body"],
      NotificationDetails(
        android: AndroidNotificationDetails(
          message.data["channel"],
          message.data["channel"],
          channelDescription: channel.description,
          icon: 'launch_background',
          sound: const RawResourceAndroidNotificationSound('alarm'),
        ),
      ),
    );
  }

  static Future<void> fcmInitial() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static void showNotification() {
    flutterLocalNotificationsPlugin.show(
      0,
      "Test notification title",
      "Test notification description",
      NotificationDetails(
        android: AndroidNotificationDetails(
          "order",
          "order",
          channelDescription: channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}