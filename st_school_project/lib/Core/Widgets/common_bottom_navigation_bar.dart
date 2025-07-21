import 'package:flutter/material.dart';

import '../../Presentation/Onboarding/Screens/Home Screen/home_screen.dart'
    show HomeScreen;
import '../../Presentation/Onboarding/Screens/Task Screen/task_screen.dart'
    show TaskScreen;
import '../Utility/app_color.dart' show AppColor;
import '../Utility/app_images.dart' show AppImages;

class CommonBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const CommonBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  State<CommonBottomNavigationBar> createState() =>
      _CommonBottomNavigationBarState();
}

class _CommonBottomNavigationBarState extends State<CommonBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColor.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: widget.onTabSelected,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      selectedFontSize: 15,
      selectedItemColor: AppColor.blue,
      unselectedItemColor: AppColor.grey,
      unselectedLabelStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
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
          icon: Image.asset(AppImages.moreSimage1, height: 26),
          activeIcon: Image.asset(AppImages.moreSimage1, height: 30),
          label: 'More',
        ),
      ],

      // onTap: (currentIndex) {
      //   setState(() {
      //     index = currentIndex;
      //   });
      // },
    );
  }
}
