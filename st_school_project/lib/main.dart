

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Core/Firebase_service/firebase_service.dart';
import 'Core/Widgets/consents.dart';
import 'Presentation/splash_screen.dart';
import 'Core/Utility/app_color.dart';
import 'init_controller.dart';

// TOP-LEVEL handler (outside any class)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AppLogger.log.i('🔕 [BG] messageId=${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ✅ Register once here (remove from the service)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final firebaseService = FirebaseService();
  await firebaseService.initializeFirebase();      // no BG registration inside
  await firebaseService.fetchFCMTokenIfNeeded();   // has retry below

  runApp(const MyApp());

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await initController();
    firebaseService.listenToMessages(
      onMessage: (msg) {
        AppLogger.log.i('📩 [FG] ${msg.messageId}');
        firebaseService.showNotification(msg);
      },
      onMessageOpenedApp: (msg) {
        AppLogger.log.i('📬 [OPENED] ${msg.messageId}');
      },
    );
  });

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColor.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppColor.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: AppColor.white),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Create and initialize the service
  final firebaseService = FirebaseService();
  await firebaseService.initializeFirebase();
  await firebaseService.fetchFCMTokenIfNeeded();

  // (Optional) foreground/opened handlers
  firebaseService.listenToMessages(
    onMessage: (msg) {
      AppLogger.log.i('📩 [FG] ${msg.messageId}');
      firebaseService.showNotification(msg);
    },
    onMessageOpenedApp: (msg) {
      AppLogger.log.i('📬 [OPENED] ${msg.messageId}');
    },
  );

  await initController();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColor.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColor.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}*/
