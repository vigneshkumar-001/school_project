import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';

import '../../Presentation/Onboarding/Screens/Announcements Screen/announcements_screen.dart';
import '../../Presentation/Onboarding/Screens/Attendence Screen/attendence_screen.dart';
import '../../Presentation/Onboarding/Screens/Home Screen/home_tab.dart';
import '../../Presentation/Onboarding/Screens/More Screen/more_screen.dart';
import '../../Presentation/Onboarding/Screens/Task Screen/task_screen.dart';
import '../Utility/app_color.dart';
import '../Utility/app_images.dart';

class CommonBottomNavigation extends StatefulWidget {
  final int initialIndex;
  const CommonBottomNavigation({super.key, this.initialIndex = 0});

  @override
  CommonBottomNavigationState createState() => CommonBottomNavigationState();
}

class CommonBottomNavigationState extends State<CommonBottomNavigation> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return HomeTab();
      case 1:
        return AnnouncementsScreen();
      case 2:
        return TaskScreen();
      case 3:
        return AttendenceScreen();
      case 4:
        return MoreScreen();
      default:
        return HomeTab();
    }
  }

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;

    final diff = (index - _selectedIndex).abs();

    if (diff == 1) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.jumpToPage(index);
    }

    setState(() => _selectedIndex = index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PageView.builder(
          controller: _pageController,
          itemCount: 5,
          itemBuilder: (context, index) => _getScreen(index),
          onPageChanged: (index) {
            setState(() => _selectedIndex = index);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColor.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          selectedItemColor: AppColor.blueG2,
          unselectedItemColor: AppColor.lightBlack,
          selectedLabelStyle: GoogleFont.ibmPlexSans(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFont.ibmPlexSans(
            fontWeight: FontWeight.w500,
            fontSize: 10,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(AppImages.bottum0, height: 26),
              activeIcon: Image.asset(AppImages.bottum0select, height: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AppImages.bottum3, height: 26),
              activeIcon: Image.asset(AppImages.bottum3select, height: 30),
              label: 'Announcements',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AppImages.bottum1, height: 26),
              activeIcon: Image.asset(AppImages.bottum1select, height: 30),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AppImages.bottum2, height: 26),
              activeIcon: Image.asset(AppImages.bottum2select, height: 30),
              label: 'Attendance',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(AppImages.moreSimage1, height: 26, width: 26),
              activeIcon: Image.asset(AppImages.moreSimage1, height: 30),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
