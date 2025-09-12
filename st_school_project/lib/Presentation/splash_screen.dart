import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/bottom_navigationbar.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Home%20Screen/controller/student_home_controller.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/Login_screen/controller/login_controller.dart';
import '../Core/Utility/app_color.dart';
import 'Onboarding/Screens/Announcements Screen/controller/announcement_controller.dart';
import 'Onboarding/Screens/Home Screen/home_tab.dart';
import 'Onboarding/Screens/More Screen/change_mobile_number.dart';
import 'package:get/get.dart';

import 'Onboarding/Screens/More Screen/profile_screen/controller/teacher_list_controller.dart';

/*
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  final StudentHomeController controller = Get.put(StudentHomeController());
  final LoginController loginController = Get.put(LoginController());
  final AnnouncementController announcementController = Get.put(
    AnnouncementController(),
  );
  final TeacherListController teacherListController = Get.put(
    TeacherListController(),
  );
  @override
  void initState() {
    super.initState();
    _startLoading();
    // _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final isLoggedIn = await loginController.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CommonBottomNavigation(initialIndex: 0),
        ),
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        teacherListController.teacherListData();
        announcementController.getAnnouncement();
      });

    }
  }

  void _startLoading() {
    Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        _progress += 0.1;
        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeMobileNumber(page: 'splash'),
            ),
          );
        }
      });
    });
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
                  padding: EdgeInsets.all(1.5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: _progress),
                      duration: Duration(milliseconds: 500),
                      builder: (context, value, _) {
                        return Stack(
                          children: [
                            Container(color: AppColor.white),
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: value,
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
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 35),
              Text(
                'V 1.2',
                style: GoogleFont.ibmPlexSans(
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
*/

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

  @override
  void initState() {
    super.initState();

    // Animation controller for 12 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    _controller.addListener(() {
      setState(() {
        _progress = _controller.value; // 0.0 -> 1.0
      });
    });

    _controller.forward(); // start animation

    // Check login after 12 seconds
    Future.delayed(const Duration(seconds: 12), () {
      _checkLoginStatus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkLoginStatus() async {
    final isLoggedIn = await loginController.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CommonBottomNavigation(initialIndex: 0),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ChangeMobileNumber(page: 'splash'),
        ),
      );
    }
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
                          widthFactor: _progress, // updated with controller
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
              Text(
                'V 1.2',
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

/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/bottom_navigationbar.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Home Screen/controller/student_home_controller.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More Screen/Login_screen/controller/login_controller.dart';
import '../Core/Utility/app_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final StudentHomeController controller = Get.put(StudentHomeController());
  final LoginController loginController = Get.put(LoginController());

  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startSlowLoading();
  }

  void _startSlowLoading() {
    // slow loader: total duration 6 seconds
    const totalDuration = Duration(seconds: 15);
    const interval = Duration(milliseconds: 50); // update every 50ms
    final increment = interval.inMilliseconds / totalDuration.inMilliseconds;

    _timer = Timer.periodic(interval, (timer) {
      setState(() {
        _progress += increment;
        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();
          _navigateNext();
        }
      });
    });
  }

  Future<void> _navigateNext() async {
    final isLoggedIn = await loginController.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CommonBottomNavigation(initialIndex: 0),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CommonBottomNavigation(initialIndex: 0),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

              // very slow linear progress bar
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
              Text(
                'V 1.2',
                style: GoogleFont.ibmPlexSans(
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
*/
