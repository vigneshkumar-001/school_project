import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/communication_screen.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/parents_info_screen.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/required_photo_screens.dart';
import 'Core/Firebase_service/firebase_service.dart';
import 'Presentation/Admssion/Screens/admission_1.dart';
import 'Presentation/Admssion/Screens/check_admission_status.dart';
import 'Presentation/Admssion/Screens/siblings_form_screen.dart';
import 'Presentation/Admssion/Screens/student_info_screen.dart';
import 'Presentation/Onboarding/Screens/Home Screen/home_screen.dart';
import 'Presentation/splash_screen.dart';
import 'init_controller.dart';

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
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize Firebase service first (pure logic, no dialogs/UI)
  final firebaseService = FirebaseService();
  await firebaseService.initializeFirebase();
  await firebaseService.fetchFCMTokenIfNeeded();

  // Make sure we build the app *first*
  runApp(const MyApp());

  // Then initialize controllers that might trigger dialogs
  await initController();

  // Now set up listeners
  firebaseService.listenToMessages(
    onMessage: (msg) {
      AppLogger.log.i('📩 [FG] ${msg.messageId}');
      firebaseService.showNotification(msg);
    },
    onMessageOpenedApp: (msg) {
      AppLogger.log.i('📬 [OPENED] ${msg.messageId}');
    },
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColor.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColor.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: AppColor.white),
      debugShowCheckedModeBanner: false,
      // home: Admission1(),
      home: RequiredPhotoScreens(id: 5),
    );
  }
}
