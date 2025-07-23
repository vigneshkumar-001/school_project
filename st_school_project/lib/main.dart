import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';

import 'Presentation/Admssion/Screens/student_info_screen.dart';
import 'Presentation/Onboarding/Screens/Home Screen/home_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // White background for status bar
      statusBarIconBrightness: Brightness.dark, // Black icons on status bar
      statusBarBrightness: Brightness.light, // For iOS (inverted logic)
      systemNavigationBarColor: Colors.white, // White background for nav bar
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: AppColor.white),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
