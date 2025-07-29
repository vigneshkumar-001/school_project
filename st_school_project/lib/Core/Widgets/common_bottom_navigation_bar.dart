// import 'package:flutter/material.dart';
//
// import '../../Presentation/Onboarding/Screens/Announcements Screen/announcements_screen.dart';
// import '../../Presentation/Onboarding/Screens/Attendence Screen/attendence_screen.dart';
// import '../../Presentation/Onboarding/Screens/Home Screen/home_tab.dart';
// import '../../Presentation/Onboarding/Screens/More Screen/more_screen.dart';
// import '../../Presentation/Onboarding/Screens/Task Screen/task_screen.dart';
// import '../Utility/app_color.dart';
// import '../Utility/app_images.dart';
//
//
// class CommonBottomNavigation extends StatefulWidget {
//   final int initialIndex;
//   const CommonBottomNavigation({super.key, this.initialIndex = 0});
//
//   @override
//   CommonBottomNavigationState createState() => CommonBottomNavigationState();
// }
//
// class CommonBottomNavigationState extends State<CommonBottomNavigation> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _screens = <Widget>[
//     HomeTab(),
//     AnnouncementsScreen(),
//     TaskScreen(),
//     AttendenceScreen(),
//     MoreScreen(),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialIndex;
//   }
//
//   Widget _getScreen(int index) {
//     switch (index) {
//       case 0:
//         return HomeTab();
//       case 1:
//         return AnnouncementsScreen();
//       case 2:
//         return TaskScreen();
//       case 3:
//         return AttendenceScreen();
//       case 4:
//         return MoreScreen();
//       default:
//         return HomeTab();
//     }
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: _getScreen(_selectedIndex),
//         bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: AppColor.white,
//           type: BottomNavigationBarType.fixed,
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//
//           selectedItemColor: AppColor.blueG2,
//           unselectedItemColor: Color(0xFF93959F),
//           selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//           unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
//
//           items: [
//             BottomNavigationBarItem(
//               icon: Image.asset(AppImages.bottum0, height: 26),
//               activeIcon: Image.asset(AppImages.bottum0select, height: 30),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Image.asset(AppImages.bottum3, height: 26),
//               activeIcon: Image.asset(AppImages.bottum3select, height: 30),
//               label: 'Announcements',
//             ),
//             BottomNavigationBarItem(
//               icon: Image.asset(AppImages.bottum1, height: 26),
//               activeIcon: Image.asset(AppImages.bottum1select, height: 30),
//               label: 'Tasks',
//             ),
//             BottomNavigationBarItem(
//               icon: Image.asset(AppImages.bottum2, height: 26),
//               activeIcon: Image.asset(AppImages.bottum2select, height: 30),
//               label: 'Attendance',
//             ),
//             BottomNavigationBarItem(
//               icon: Image.asset(AppImages.moreSimage1, height: 26, width: 26),
//               activeIcon: Image.asset(AppImages.moreSimage1, height: 30),
//               label: 'More',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }