// firebase_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More Screen/Login_screen/controller/login_controller.dart';

class FirebaseService {
  // Avoid eager Get.put here if app not ready; guard usage.
  LoginController? _loginController() =>
      Get.isRegistered<LoginController>() ? Get.find<LoginController>() : null;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'flutter_notification',
    'flutter_notification_title',
    importance: Importance.high,
    enableLights: true,
    showBadge: true,
    playSound: true,
  );

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  Future<void> initializeFirebase() async {
    // ❌ DO NOT register onBackgroundMessage here (done in main)

    // Local notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, badge: true, sound: true, provisional: false,
      );
      AppLogger.log.i('🔔 Notification permission: ${settings.authorizationStatus}');
    } catch (e, st) {
      AppLogger.log.w('requestPermission failed: $e\n$st');
    }
  }

  // ---- Robust token fetch with backoff (handles SERVICE_NOT_AVAILABLE) ----
  Future<String?> _getTokenWithBackoff() async {
    const delays = [1, 2, 4, 8]; // seconds
    for (final s in delays) {
      try {
        final t = await FirebaseMessaging.instance.getToken();
        if (t != null && t.isNotEmpty) return t;
      } catch (e) {
        AppLogger.log.w('getToken failed (retry in ${s}s): $e');
      }
      await Future.delayed(Duration(seconds: s));
    }
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e, st) {
      AppLogger.log.e('getToken final failure: $e\n$st');
      return null;
    }
  }

  Future<void> fetchFCMTokenIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    _fcmToken = prefs.getString('fcmToken');

    if (_fcmToken != null) {
      AppLogger.log.i('ℹ️ Existing FCM Token: $_fcmToken');
      _loginController()?.sendFcmToken(_fcmToken!);
      return;
    }

    final token = await _getTokenWithBackoff();
    _fcmToken = token;

    if (token != null) {
      await prefs.setString('fcmToken', token);
      _loginController()?.sendFcmToken(token);
      AppLogger.log.i('✅ FCM Token: $token');
    } else {
      AppLogger.log.w('⚠️ No FCM token (device/config/network). Will retry later.');
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'flutter_notification','flutter_notification_title',
      channelDescription: 'your channel description',
      importance: Importance.max, priority: Priority.high, showWhen: false,
    );
    const details = NotificationDetails(android: androidDetails);
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await flutterLocalNotificationsPlugin.show(
      id, message.notification?.title ?? 'Notification',
      message.notification?.body ?? '', details,
      payload: message.data.isNotEmpty ? message.data.toString() : null,
    );
  }

  void listenToMessages({
    required void Function(RemoteMessage) onMessage,
    required void Function(RemoteMessage) onMessageOpenedApp,
  }) {
    FirebaseMessaging.onMessage.listen(onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
  }
}



// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:st_school_project/Core/Widgets/consents.dart';
// import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/Login_screen/controller/login_controller.dart';
//
// class FirebaseService {
//   final LoginController controller = Get.put(LoginController());
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   final AndroidNotificationChannel channel = const AndroidNotificationChannel(
//     'flutter_notification',
//     'flutter_notification_title',
//     importance: Importance.high,
//     enableLights: true,
//     showBadge: true,
//     playSound: true,
//   );
//
//   String? _fcmToken;
//   String? get fcmToken => _fcmToken;
//   @pragma('vm:entry-point')
//   Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     await Firebase.initializeApp();
//     AppLogger.log.i('🔕 [BG] messageId=${message.messageId}');
//   }
//
//   Future<void> initializeFirebase() async {
//     // App already called Firebase.initializeApp() in main; safe to skip here.
//     // Register background handler ONCE (top-level function)
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//
//     // Android local notifications init
//
//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initSettings = InitializationSettings(android: androidInit);
//     await flutterLocalNotificationsPlugin.initialize(initSettings);
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);
//
//     // Ask notification permission (Android 13+ & iOS)
//     await _requestNotificationPermission();
//   }
//
//   Future<void> _requestNotificationPermission() async {
//     final settings = await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );
//     AppLogger.log.i(
//       '🔔 Notification permission: ${settings.authorizationStatus}',
//     );
//   }
//
//   Future<void> fetchFCMTokenIfNeeded() async {
//     final prefs = await SharedPreferences.getInstance();
//     _fcmToken = prefs.getString('fcmToken');
//
//     if (_fcmToken == null) {
//       final messaging = FirebaseMessaging.instance;
//       final token = await messaging.getToken();
//       AppLogger.log.i('✅ FCM Token: $token'); // <-- printed here
//       AppLogger.log.i(
//         'Shared prfd _fcmToken: $_fcmToken',
//       ); // <-- printed here
//       _fcmToken = token;
//       if (token != null) {
//         await prefs.setString('fcmToken', token);
//         controller.sendFcmToken(token);
//       }
//     } else {
//       AppLogger.log.i('ℹ️ Existing FCM Token: $_fcmToken');
//       controller.sendFcmToken(_fcmToken!);
//     }
//   }
//
//   Future<void> showNotification(RemoteMessage message) async {
//     const androidDetails = AndroidNotificationDetails(
//       'flutter_notification',
//       'flutter_notification_title',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );
//     const details = NotificationDetails(android: androidDetails);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title,
//       message.notification?.body,
//       details,
//       payload: 'item x',
//     );
//   }
//
//   void listenToMessages({
//     required void Function(RemoteMessage) onMessage,
//     required void Function(RemoteMessage) onMessageOpenedApp,
//   }) {
//     FirebaseMessaging.onMessage.listen(onMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
//   }
// }
