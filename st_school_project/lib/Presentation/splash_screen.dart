import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/bottom_navigationbar.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Home%20Screen/controller/student_home_controller.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/Login_screen/controller/login_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Core/Utility/app_color.dart';
import 'Onboarding/Screens/Announcements Screen/controller/announcement_controller.dart';
import 'Onboarding/Screens/Home Screen/home_tab.dart';
import 'Onboarding/Screens/More Screen/change_mobile_number.dart';
import 'package:get/get.dart';

import 'Onboarding/Screens/More Screen/profile_screen/controller/teacher_list_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  late AnimationController _controller;
  final StudentHomeController controller = Get.put(StudentHomeController());
  final LoginController loginController = Get.put(LoginController());
  final AnnouncementController announcementController = Get.put(
    AnnouncementController(),
  );
  final TeacherListController teacherListController = Get.put(
    TeacherListController(),
  );

  final String latestVersion = "2.3.4";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _controller.addListener(() {
      setState(() {
        _progress = _controller.value;
      });
    });

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkAppVersion();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAppVersion() async {
    String currentVersion =
        controller.appVersionData.value?.android.latestVersion.toString() ?? '';

    if (currentVersion == latestVersion) {
      _checkLoginStatus();
    } else {
      _showUpdateBottomSheet();
    }
  }

  void _checkLoginStatus() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      final isApplicant = await loginController.checkTokenExpire();

      if (isApplicant) {
        // Already navigated inside getAdmissionDetails()
        return;
      }

      // Only navigate to CommonBottomNavigation if not applicant
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const CommonBottomNavigation(initialIndex: 0),
        ),
      );
    } else {
      // No token → navigate to login/change mobile
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ChangeMobileNumber(page: 'splash'),
        ),
      );
    }
  }

  // void _checkLoginStatus() async {
  //   if (!mounted) return;
  //
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //
  //   if (token != null && token.isNotEmpty) {
  //     await loginController.checkTokenExpire();
  //
  //
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => const CommonBottomNavigation(initialIndex: 0),
  //       ),
  //     );
  //   } else {
  //     // No token → navigate to login/change mobile
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => const ChangeMobileNumber(page: 'splash'),
  //       ),
  //     );
  //   }
  // }

  void openPlayStore() async {
    final storeUrl = controller.appVersionData.value?.android.storeUrl ?? '';

    if (storeUrl.isEmpty) {
      print('No URL available.');
      return;
    }

    final uri = Uri.parse(storeUrl);
    print('Trying to launch: $uri');

    // Try in-app or platform default mode
    final success = await launchUrl(
      uri,
      mode: LaunchMode.platformDefault, // or LaunchMode.inAppWebView
    );

    if (!success) {
      print('Could not open the link. Maybe no browser is installed.');
    }
  }

  void _showUpdateBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Update Available",
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),

              Text(
                "A new version of the app is available. Please update to continue.",
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSans(fontSize: 14),
              ),
              SizedBox(height: 24),
              AppButton.button(
                text: 'Update Now',
                onTap: () {
                  openPlayStore();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(AppImages.splashBackImage1),
                    Image.asset(AppImages.schoolLogo),
                    Image.asset(AppImages.splashBackImage2),
                  ],
                ),
              ),
              Container(
                width: width,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColor.blueG2, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Container(color: AppColor.white),
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progress,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [AppColor.blueG1, AppColor.blueG2],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              // ElevatedButton(
              //   onPressed: () {
              //     _showUpdateBottomSheet();
              //   },
              //   child: Text('data'),
              // ),
              Text(
                'V $latestVersion',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColor.lowGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
