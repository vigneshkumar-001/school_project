import 'dart:async';

import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/bottom_navigationbar.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Home%20Screen/controller/student_home_controller.dart';
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

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  final StudentHomeController controller = Get.put(StudentHomeController());
  final AnnouncementController announcementController = Get.put(
    AnnouncementController(),
  );
  final TeacherListController teacherListController = Get.put(
    TeacherListController(),
  );
  @override
  void initState() {
    super.initState();
    controller.getStudentHome();
    teacherListController.teacherListData();
    announcementController.getAnnouncement();

    _startLoading();
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

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => CommonBottomNavigation(initialIndex: 0),
          //   ),
          // );
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
