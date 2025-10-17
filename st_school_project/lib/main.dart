import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/parents_info_screen.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'Core/Firebase_service/firebase_service.dart';
import 'Presentation/Admssion/Screens/student_info_screen.dart';
import 'Presentation/Onboarding/Screens/Home Screen/home_screen.dart';
import 'Presentation/splash_screen.dart';
import 'init_controller.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await FirebaseService();
//   // await NotificationService.instance.initialize();
//   await initController();
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: AppColor.white,
//       statusBarIconBrightness: Brightness.dark,
//       statusBarBrightness: Brightness.light,
//       systemNavigationBarColor: AppColor.white,
//       systemNavigationBarIconBrightness: Brightness.dark,
//     ),
//   );
//
//   runApp(const MyApp());
// }
Future<void> main() async {
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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: AppColor.white),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
