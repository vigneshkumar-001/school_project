// import 'package:flutter/material.dart';
// import '../Announcements Screen/announcements_screen.dart';
// import '../Attendence Screen/attendence_screen.dart';
// import '../More Screen/more_screen.dart';
// import 'home_tab.dart';
// import '../Task Screen/task_screen.dart';
// import '../../../../Core/Widgets/common_bottom_navigation_bar.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final PageController _pageController = PageController();
//   int _currentIndex = 0;
//
//   final List<Widget> _screens = [
//     HomeTab(),
//     AnnouncementsScreen(),
//     TaskScreen(),
//     AttendenceScreen(),
//     MoreScreen(),
//   ];
//
//   void _onTabTapped(int index) {
//     if (index == _currentIndex) return;
//
//     final diff = (index - _currentIndex).abs();
//
//     if (diff == 1) {
//       _pageController.animateToPage(
//         index,
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       _pageController.jumpToPage(index);
//     }
//
//     setState(() => _currentIndex = index);
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: PageView(
//         controller: _pageController,
//         physics: const NeverScrollableScrollPhysics(),
//         children: _screens,
//       ),
//       bottomNavigationBar: CommonBottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTabSelected: _onTabTapped,
//       ),
//     );
//   }
// }
//
//
