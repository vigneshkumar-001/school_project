import 'package:flutter/material.dart';

import '../../Presentation/Onboarding/Screens/home_screen.dart' show HomeScreen;
import '../../Presentation/Onboarding/Screens/task_screen.dart' show TaskScreen;
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
          icon: const Icon(Icons.home_sharp, size: 26),
          activeIcon: Icon(Icons.task_alt, color: AppColor.blue),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(AppImages.bottum3, height: 26),
          activeIcon: Icon(Icons.task_alt, color: AppColor.blue),
          label: 'Announcements',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(AppImages.bottum1, height: 26),
          activeIcon: Icon(Icons.task_alt, color: AppColor.blue),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(AppImages.bottum2, height: 26),
          activeIcon: Icon(Icons.task_alt, color: AppColor.blue),
          label: 'Attendance',
        ),

        BottomNavigationBarItem(
          icon: Image.asset(AppImages.bottum4, height: 26),
          activeIcon: Icon(Icons.task_alt, color: AppColor.blue),
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
