import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/app_loader.dart';
import 'package:st_school_project/Core/Widgets/bottom_navigationbar.dart';
import 'package:st_school_project/Core/Widgets/swicth_profile_sheet.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/Login_screen/controller/login_controller.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Task%20Screen/controller/task_controller.dart';

import 'package:st_school_project/Presentation/Onboarding/Screens/Task%20Screen/task_detail.dart';

import '../../../../Core/Utility/google_font.dart' show GoogleFont;

import '../../../../Core/Widgets/custom_container.dart';
import '../../../../Core/Widgets/date_and_time_convert.dart';
import '../../../Admssion/Screens/admission_1.dart';
import '../../../Admssion/Screens/check_admission_status.dart';
import '../Attendence Screen/attendence_screen.dart';
import 'package:get/get.dart';

import '../More Screen/Quiz Screen/controller/quiz_controller.dart';
import '../More Screen/more_screen.dart';
import '../More Screen/profile_screen/controller/teacher_list_controller.dart';
import '../More Screen/quiz_result.dart';
import '../More Screen/quiz_screen.dart';
import 'controller/student_home_controller.dart';
import 'message_screen.dart';
import 'model/student_home_response.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Two-avatar stack helpers
// ─────────────────────────────────────────────────────────────────────────────

const List<double> _kGrayscaleMatrix = <double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
];

Widget _avatarBox({
  required String? url,
  required double size,
  required bool isActive,
  required bool grayscale,
  required String fallbackAsset,
  required Color activeBorderColor,
}) {
  final img =
      (url != null && url.isNotEmpty)
          ? Image.network(
            url,
            height: size,
            width: size,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => Image.asset(
                  fallbackAsset,
                  height: size,
                  width: size,
                  fit: BoxFit.cover,
                ),
          )
          : Image.asset(
            fallbackAsset,
            height: size,
            width: size,
            fit: BoxFit.cover,
          );

  final filtered =
      grayscale
          ? ColorFiltered(
            colorFilter: const ColorFilter.matrix(_kGrayscaleMatrix),
            child: img,
          )
          : img;

  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isActive ? activeBorderColor : Colors.white,
        width: isActive ? 2 : 1.5,
      ),
      boxShadow: [
        if (isActive)
          BoxShadow(
            color: activeBorderColor.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
      ],
    ),
    child: ClipRRect(borderRadius: BorderRadius.circular(10), child: filtered),
  );
}

class TwoProfileStack extends StatelessWidget {
  final dynamic active; // expects .avatar, .id
  final dynamic other; // expects .avatar, .id (can be null)
  final double size; // front(active) size
  final double? backSize; // <-- NEW: grayscale(back) size
  final double overlapFraction; // 0..1 overlap based on min(front, back)
  final VoidCallback? onTap;
  final String fallbackAsset;
  final Color activeBorderColor;

  const TwoProfileStack({
    super.key,
    required this.active,
    required this.other,
    this.size = 49,
    this.backSize, // if null -> size * 0.86
    this.overlapFraction = 0.45,
    this.onTap,
    required this.fallbackAsset,
    required this.activeBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final double _back = backSize ?? size * 0.86; // default slightly smaller
    final double h = math.max(size, _back); // stack height
    final double overlapPx = math.min(size, _back) * overlapFraction;

    // total width: if no other -> just front width
    final double w = (other == null) ? size : math.max(_back, overlapPx + size);

    // vertically center both when sizes differ
    final double frontTop = (h - size) / 2;
    final double backTop = (h - _back) / 2;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: w,
        height: h,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (other != null)
              Positioned(
                right: 0,
                top: backTop,
                child: _avatarBox(
                  url: other.avatar,
                  size: _back,
                  isActive: false,
                  grayscale: true, // back one is B/W
                  fallbackAsset: fallbackAsset,
                  activeBorderColor: activeBorderColor,
                ),
              ),
            Positioned(
              right: other == null ? 0 : overlapPx,
              top: frontTop,
              child: _avatarBox(
                url: active?.avatar,
                size: size,
                isActive: true, // front is active & colored
                grayscale: false,
                fallbackAsset: fallbackAsset,
                activeBorderColor: activeBorderColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  final VoidCallback? onBackPressed;
  final String? pages;
  const HomeTab({super.key, this.onBackPressed, this.pages});

  @override
  State<HomeTab> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin {
  String selectedDay = 'Today';
  DateTime selectedDate = DateTime.now();
  final StudentHomeController controller = Get.put(StudentHomeController());
  final TaskController taskController = Get.put(TaskController());
  final LoginController loginController = Get.put(LoginController());
  final TeacherListController teacherListController = Get.put(
    TeacherListController(),
  );
  int index = 0;

  String selectedSubject = 'All'; // default selected
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.studentHomeData.value == null) {
        controller.getStudentHome();
        controller.getSiblingsData();
        teacherListController.teacherListData();
      }
    });
  }

  final List<String> subjects = [
    'All',
    'Science',
    'English',
    'Social Science',
    'Maths',
  ];

  String formatDate(String date) {
    // Split the original date by '.'
    List<String> parts = date.split('.');
    if (parts.length < 2) return date; // fallback if format is unexpected

    String day = parts[0];
    String month = parts[1];

    return "$month.$day"; // "oct.17"
  }

  String _fmt(DateTime d) =>
      DateFormat('dd MMM yyyy').format(d); // e.g., 23 Sep 2025

  PopupMenuItem<String> _buildMenuItem(String value) {
    final isSelected = value == selectedDay;
    return PopupMenuItem<String>(
      value: value,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.lightBlue : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          value,
          style: GoogleFont.ibmPlexSans(
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return WillPopScope(
      onWillPop: () async {
        return await false;
      },
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: SafeArea(
          child: Obx(() {
            final isLoading = controller.isLoading.value;
            final hasLoadedOnce = controller.hasLoadedOnce.value;
            final data = controller.studentHomeData.value;

            final img = controller.siblingsList;

            // 1) First load or refresh with no cached data → loader
            if (isLoading && data == null) {
              return AppLoader.circularLoader();
            }

            // 2) Only after first load completes, if still null → empty state
            if (!isLoading && !hasLoadedOnce) {
              // defensive, but shouldn't hit because isLoading starts true
              return AppLoader.circularLoader();
            }

            // if (data == null) {
            //   return Center(child: Text("No student data available"));
            // }
            final tasks = data?.tasks ?? [];
            final subjects = <String>{'All'};
            for (var task in tasks) {
              if (task.subject != null && task.subject.isNotEmpty) {
                subjects.add(task.subject);
              }
            }

            final siblings = controller.siblingsList;

            // robust pick: active (front) + one other (back)
            dynamic activeStudent =
                controller.selectedStudent.value; // <-- .value !
            if (activeStudent == null) {
              try {
                activeStudent = siblings.firstWhere((s) => s.isActive == true);
              } catch (_) {
                activeStudent = siblings.isNotEmpty ? siblings.first : null;
              }
            }

            dynamic otherStudent;
            for (final s in siblings) {
              if (activeStudent == null || s.id != activeStudent.id) {
                otherStudent = s;
                break;
              }
            }
            // NOTE: if only one student, otherStudent stays null → only active shown

            // if only one student, otherStudent stays null → only active shown

            // final siblings = controller.siblingsList;
            // final activeStudent = siblings.firstWhere(
            //   (s) => s.isActive == true,
            //   orElse: () => siblings.first,
            // );

            final subjectsList = subjects.toList();

            return RefreshIndicator(
              onRefresh: () async {
                await controller.getStudentHome();
                await teacherListController.teacherListData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        AppImages.schoolLogo,
                        height: 58,
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(height: 20),

                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 0,
                      ),
                      isThreeLine:
                          true, // give more height so title can wrap nicely
                      title: Text.rich(
                        TextSpan(
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 28,
                            color: AppColor.black,
                            height: 1.1,
                          ),
                          text: 'Hi ',
                          children: [
                            TextSpan(
                              text: data?.name ?? "Welcome",
                              style: GoogleFont.ibmPlexSans(
                                fontWeight: FontWeight.w800,
                                fontSize: 28,
                                height: 1.1,
                                color: AppColor.black,
                              ),
                            ),
                            TextSpan(
                              text: '!',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: AppColor.blue,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 2, // ✅ long name wraps to 2 lines
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text.rich(
                            TextSpan(
                              text: data?.className ?? '',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 14,
                                color: AppColor.grey,
                                fontWeight: FontWeight.w800,
                              ),
                              children: [
                                TextSpan(
                                  text: 'th ',
                                  style: GoogleFont.ibmPlexSans(fontSize: 10),
                                ),
                                TextSpan(
                                  text: 'Grade - ',
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 14,
                                    color: AppColor.grey,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: data?.section ?? '',
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 14,
                                    color: AppColor.grey,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: ' Section',
                                  style: GoogleFont.ibmPlexSans(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // ✅ Icons moved to trailing so they don't overlap the title
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Message button
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessageScreen(),
                                ),
                              );
                            },
                            child: Image.asset(
                              AppImages.messageIcon,
                              height: 40,
                              width: 40,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Exactly two avatars: active (front, color) + other (back, grayscale)
                          if (siblings.isNotEmpty)
                            TwoProfileStack(
                              active: activeStudent,
                              other: otherStudent, // null => only active shown
                              size: 49, // front(active)
                              backSize: 38, // <-- customize B/W size here
                              overlapFraction:
                                  0.50, // optional: how much to overlap
                              fallbackAsset: AppImages.moreSimage1,
                              activeBorderColor: Colors.transparent,
                              onTap: () {
                                SwitchProfileSheet.show(
                                  context,
                                  students: controller.siblingsList,
                                  selectedStudent: controller.selectedStudent,
                                  onSwitch: (student) async {
                                    await controller.switchSiblings(
                                      id: student.id,
                                    );
                                    controller.selectStudent(student);
                                  },
                                  onLogout: () async {
                                    await loginController.logout();
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColor.white,
                            AppColor.lightWhite, // cyan
                          ],
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [AppColor.blueG1, AppColor.blueG2],
                                  ),
                                  // border: Border.all(color: Colors.black12),
                                  //  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                    left: 10,
                                    top: 10,
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColor.white.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 15,
                                              ),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Image.asset(
                                                        AppImages.morning,
                                                        height: 39,
                                                        width: 47.5,
                                                      ),
                                                      SizedBox(height: 3),
                                                      Text(
                                                        'Morning',
                                                        style:
                                                            GoogleFont.ibmPlexSans(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  AppColor
                                                                      .white,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 9),
                                                  SizedBox(
                                                    height: 70,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: List.generate(7, (
                                                        index,
                                                      ) {
                                                        return Container(
                                                          width: 2,
                                                          height: 8,
                                                          decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                              colors: [
                                                                AppColor
                                                                    .lightGrey
                                                                    .withOpacity(
                                                                      0.05,
                                                                    ),
                                                                AppColor.white
                                                                    .withOpacity(
                                                                      0.05,
                                                                    ),
                                                              ], // gradient top to bottom
                                                              begin:
                                                                  Alignment
                                                                      .topCenter,
                                                              end:
                                                                  Alignment
                                                                      .bottomCenter,
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  ),
                                                  SizedBox(width: 9),
                                                  Column(
                                                    children: [
                                                      Image.asset(
                                                        AppImages.afternoon,
                                                        height: 39,
                                                        width: 47.5,
                                                      ),
                                                      SizedBox(height: 3),
                                                      Text(
                                                        'Afternoon',
                                                        style:
                                                            GoogleFont.ibmPlexSans(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  AppColor
                                                                      .white,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 15,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Today',
                                                  style: GoogleFont.ibmPlexSans(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColor.white,
                                                  ),
                                                ),
                                                Text(
                                                  'Attendance',
                                                  style: GoogleFont.ibmPlexSans(
                                                    fontSize: 18,
                                                    color: AppColor.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Row(
                                            children: [
                                              Container(
                                                width: 150,
                                                height: 1,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      AppColor.lightGrey
                                                          .withOpacity(0.3),
                                                      AppColor.lightGrey
                                                          .withOpacity(0.2),

                                                      AppColor.white
                                                          .withOpacity(0.1),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          CommonBottomNavigation(
                                                            initialIndex: 3,
                                                          ),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  'View All',
                                                  style: GoogleFont.ibmPlexSans(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColor.lightGrey,
                                                  ),
                                                ),
                                                SizedBox(width: 2),
                                                Image.asset(
                                                  AppImages.rightArrow,
                                                  height: 9,
                                                  color: AppColor.lightGrey,
                                                ),
                                              ],
                                            ),
                                          ),

                                          if (controller
                                                  .studentHomeData
                                                  .value
                                                  ?.announcements[0]
                                                  .new_testing_addmission_status ==
                                              true) ...[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) => Admission1(
                                                          pages: 'homeScreen',
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Start Admission',
                                                    style:
                                                        GoogleFont.ibmPlexSans(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              AppColor
                                                                  .lightGrey,
                                                        ),
                                                  ),
                                                  SizedBox(width: 2),
                                                  Image.asset(
                                                    AppImages.rightArrow,
                                                    height: 9,
                                                    color: AppColor.lightGrey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],

                                          if (controller
                                                  .studentHomeData
                                                  .value
                                                  ?.announcements[1]
                                                  .addmissionStatusTesting ==
                                              true) ...[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            CheckAdmissionStatus(
                                                              page:
                                                                  'homeScreen',
                                                            ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Check Admission Status',
                                                    style:
                                                        GoogleFont.ibmPlexSans(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              AppColor
                                                                  .lightGrey,
                                                        ),
                                                  ),
                                                  SizedBox(width: 2),
                                                  Image.asset(
                                                    AppImages.rightArrow,
                                                    height: 9,
                                                    color: AppColor.lightGrey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      Positioned(
                                        top: 90,
                                        left: 35,
                                        child: Image.asset(
                                          data?.attendance.morning == true
                                              ? AppImages.greenTick
                                              : AppImages.failedImage,
                                          height: 18,
                                        ),
                                      ),
                                      Positioned(
                                        top: 90,
                                        right: 32,
                                        child: Image.asset(
                                          data?.attendance.afternoon == true
                                              ? AppImages.greenTick
                                              : AppImages.failedImage,
                                          height: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              if (controller
                                      .studentHomeData
                                      .value
                                      ?.announcements[0]
                                      .newAdmissionStatus ==
                                  true) ...[
                                SizedBox(width: 15),
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: 175,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.centerRight,
                                            colors: [
                                              AppColor.lightBlueG1,
                                              AppColor.lightBlueG1.withOpacity(
                                                0.5,
                                              ),
                                              AppColor.lightBlueG2,
                                            ],
                                          ),
                                          // border: Border.all(color: Colors.black12),
                                          // color: AppColor.white,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 47,
                                            right: 8,
                                            left: 8,
                                            bottom: 8,
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColor.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 26,
                                                    right: 20,
                                                    left: 15,
                                                    bottom: 10,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        maxLines: 3,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        data
                                                                ?.announcements[0]
                                                                .message
                                                                .toString() ??
                                                            '',
                                                        style:
                                                            GoogleFont.ibmPlexSans(
                                                              fontSize: 16,
                                                              color:
                                                                  AppColor
                                                                      .lightBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),

                                                      Text(
                                                        data
                                                                ?.announcements[0]
                                                                .submessage
                                                                .toString() ??
                                                            '',
                                                        style:
                                                            GoogleFont.ibmPlexSans(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  AppColor
                                                                      .black,
                                                            ),
                                                      ),

                                                      Divider(
                                                        color:
                                                            AppColor.lightGrey,
                                                      ),

                                                      InkWell(
                                                        onTap: () {
                                                          final ann =
                                                              controller
                                                                  .studentHomeData
                                                                  .value
                                                                  ?.announcements[0];
                                                          print(ann?.toJson());
                                                          if (ann == null)
                                                            return;

                                                          loginController
                                                              .handleHomeAdmissionTapFromAnnouncement(
                                                                ann,
                                                                page:
                                                                    'homeScreen',
                                                              );
                                                          // Navigator.push(
                                                          //   context,
                                                          //   MaterialPageRoute(
                                                          //     builder:
                                                          //         (
                                                          //           context,
                                                          //         ) => Admission1(
                                                          //           pages:
                                                          //               'homeScreen',
                                                          //         ),
                                                          //   ),
                                                          // );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'Open Now',
                                                              style: GoogleFont.ibmPlexSans(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColor
                                                                        .blueG2,
                                                              ),
                                                            ),
                                                            SizedBox(width: 7),
                                                            Image.asset(
                                                              AppImages
                                                                  .rightArrow,
                                                              height: 10,
                                                              color:
                                                                  AppColor
                                                                      .blueG2,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      child: Image.asset(
                                        AppImages.homeScreenCont2,
                                        height: 67,
                                        width: 77.31,
                                      ),
                                      left: 20,
                                      top: 12,
                                    ),
                                  ],
                                ),
                              ],
                              if (data?.announcements[1].admissionStatus ==
                                  true) ...[
                                SizedBox(width: 15),
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: 175,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.centerRight,
                                            colors: [
                                              AppColor.lightBlueG1,
                                              AppColor.lightBlueG1.withOpacity(
                                                0.5,
                                              ),
                                              AppColor.lightBlueG2,
                                            ],
                                          ),
                                          // border: Border.all(color: Colors.black12),
                                          // color: AppColor.white,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 60,
                                            right: 8,
                                            left: 8,
                                            bottom: 8,
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColor.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 32,
                                                    right: 20,
                                                    left: 15,
                                                    bottom: 15,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data
                                                                ?.announcements[1]
                                                                .message
                                                                .toString() ??
                                                            '',
                                                        style:
                                                            GoogleFont.ibmPlexSans(
                                                              fontSize: 16,
                                                              color:
                                                                  AppColor
                                                                      .lightBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),

                                                      Text(
                                                        data
                                                                ?.announcements[1]
                                                                .submessage
                                                                .toString() ??
                                                            '',
                                                        style:
                                                            GoogleFont.ibmPlexSans(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  AppColor
                                                                      .black,
                                                            ),
                                                      ),

                                                      Divider(
                                                        color:
                                                            AppColor.lightGrey,
                                                      ),

                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (
                                                                    context,
                                                                  ) => CheckAdmissionStatus(
                                                                    page:
                                                                        'homeScreen',
                                                                  ),
                                                            ),
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'Check Now',
                                                              style: GoogleFont.ibmPlexSans(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColor
                                                                        .blueG2,
                                                              ),
                                                            ),
                                                            SizedBox(width: 7),
                                                            Image.asset(
                                                              AppImages
                                                                  .rightArrow,
                                                              height: 10,
                                                              color:
                                                                  AppColor
                                                                      .blueG2,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      top: 19,
                                      child: Image.asset(
                                        AppImages.homeScreenCont3,
                                        height: 75,
                                        width: 73.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (data?.announcements[2].examStatus ==
                                  true) ...[
                                SizedBox(width: 15),
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: 160,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.centerRight,
                                            colors: [
                                              AppColor.orangeG1, // light blue
                                              AppColor.orangeG2, // cyan
                                              AppColor.orangeG3, // cyan
                                            ],
                                          ),
                                          // border: Border.all(color: Colors.black12),
                                          // color: AppColor.white,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 60,
                                            right: 8,
                                            left: 8,
                                            bottom: 15,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColor.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 40,
                                                        right: 20,
                                                        left: 20,
                                                        bottom: 56,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        data
                                                                ?.announcements[2]
                                                                .message
                                                                .toString() ??
                                                            '',
                                                        style:
                                                            GoogleFont.ibmPlexSans(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  AppColor
                                                                      .lightBlack,
                                                            ),
                                                      ),

                                                      SizedBox(height: 7),
                                                      Text(
                                                        data
                                                                ?.announcements[2]
                                                                .submessage
                                                                .toString() ??
                                                            '',
                                                        style:
                                                            GoogleFont.ibmPlexSans(
                                                              color:
                                                                  AppColor.grey,
                                                              fontSize: 12,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      child: Image.asset(
                                        AppImages.clock,
                                        height: 72,
                                        width: 60.3,
                                      ),
                                      left: 12,
                                      top: 15,
                                    ),
                                    Positioned(
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColor.brown,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                            vertical: 3,
                                          ),
                                          child: Text(
                                            formatDate(
                                              data?.announcements[2].submessage
                                                      .toString() ??
                                                  '',
                                            ),
                                            style: GoogleFont.ibmPlexSans(
                                              fontSize: 12,
                                              color: AppColor.yellow,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      right: 25,
                                      top: 48,
                                    ),
                                    // Positioned(
                                    //   child: TextButton(
                                    //     style: ButtonStyle(
                                    //       backgroundColor: WidgetStatePropertyAll(
                                    //         AppColor.brown,
                                    //       ),
                                    //     ),
                                    //     onPressed: () {},
                                    //     child: Text(
                                    //       'Jun 11',
                                    //       style: TextStyle(
                                    //         fontSize: 12,
                                    //         color: AppColor.yellow,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   right: 25,
                                    //   top: 70,
                                    // ),
                                  ],
                                ),
                              ],
                              if (data?.announcements[3].noticeBoardStatus ==
                                  true) ...[
                                SizedBox(width: 15),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColor.greenG4.withOpacity(0.2),
                                        AppColor.greenG2.withOpacity(0.4),
                                        AppColor.greenG1.withOpacity(0.9),
                                        // AppColor.greenG1.withOpacity(0.9),
                                      ],
                                    ),
                                    // border: Border.all(color: Colors.black12),
                                    //  color: AppColor.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 0,
                                      left: 8,
                                      right: 8,
                                      bottom: 15,
                                    ),
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 20.0,
                                                  ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      AppColor.white,
                                                      AppColor.white,
                                                      AppColor.white,
                                                      AppColor.white,
                                                      AppColor.white,
                                                      AppColor.white,
                                                      AppColor.white
                                                          .withOpacity(0.1),
                                                      AppColor.white
                                                          .withOpacity(0.1),
                                                    ],
                                                  ),

                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),

                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 10,
                                                        left: 15,
                                                        right: 62,
                                                        bottom: 52,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data
                                                                ?.announcements[3]
                                                                .message
                                                                .toString() ??
                                                            '',
                                                        style:
                                                            GoogleFont.ibmPlexSans(
                                                              fontSize: 12,
                                                              color:
                                                                  AppColor
                                                                      .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        data
                                                                ?.announcements[3]
                                                                .submessage
                                                                .toString() ??
                                                            '',
                                                        style:
                                                            GoogleFont.ibmPlexSans(
                                                              fontSize: 10,
                                                              color:
                                                                  AppColor.grey,
                                                            ),
                                                      ),
                                                      SizedBox(height: 21),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                              left: 53.0,
                                                            ),
                                                        child: InkWell(
                                                          onTap: () {},
                                                          child: Image.asset(
                                                            AppImages
                                                                .greenButtomArrow,
                                                            height: 24,
                                                            width: 23,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              'Notice Board',
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: AppColor.lightBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Positioned.fill(
                                          child: Image.asset(
                                            AppImages.bag,
                                            height: 20,
                                          ),
                                          top: 120,
                                          left: 45,
                                          right: 45,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              if (data?.announcements[4].termFeesStatus ==
                                  true) ...[
                                SizedBox(width: 15),
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: 180,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.centerRight,
                                            colors: [
                                              AppColor.blueCG1, // light blue
                                              AppColor.blueCG2, // cyan
                                              AppColor.blueCG3, // cyan
                                            ],
                                          ),
                                          // border: Border.all(color: Colors.black12),
                                          // color: AppColor.white,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 67,
                                            right: 10,
                                            left: 10,
                                            bottom: 8,
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColor.white,
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 40,
                                                    right: 20,
                                                    left: 15,
                                                    bottom: 10,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              right: 45.0,
                                                            ),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                            color:
                                                                AppColor
                                                                    .lightBlue,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 3,
                                                                ),
                                                            child: Center(
                                                              child: Text(
                                                                formatDate(
                                                                  data
                                                                          ?.announcements[4]
                                                                          .submessage
                                                                          .toString() ??
                                                                      '',
                                                                ),
                                                                style: GoogleFont.ibmPlexSans(
                                                                  fontSize: 12,
                                                                  color:
                                                                      AppColor
                                                                          .textBlue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 6),
                                                      Text(
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        data
                                                                ?.announcements[4]
                                                                .message
                                                                .toString() ??
                                                            '',
                                                        style:
                                                            GoogleFont.ibmPlexSans(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  AppColor
                                                                      .black,
                                                            ),
                                                      ),
                                                      // SizedBox(height: 4),
                                                      Divider(
                                                        color:
                                                            AppColor.lightGrey,
                                                      ),
                                                      // SizedBox(height: 4),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (
                                                                    context,
                                                                  ) => CommonBottomNavigation(
                                                                    initialIndex:
                                                                        4,
                                                                  ),
                                                            ),
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'Know More',
                                                              style: GoogleFont.ibmPlexSans(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColor
                                                                        .blueG2,
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Image.asset(
                                                              AppImages
                                                                  .rightArrow,
                                                              height: 7,
                                                              color:
                                                                  AppColor
                                                                      .blueG2,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      child: Image.asset(
                                        AppImages.wallet,
                                        height: 107,
                                      ),
                                      left: 18,
                                      top: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.centerRight,
                          colors: [
                            AppColor.lightGrey,
                            AppColor.lightGrey,
                            AppColor.lightGrey,
                            AppColor.white,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ---------- Header ----------
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                children: [
                                  Text(
                                    'Your Tasks',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.black,
                                    ),
                                  ),
                                  const Spacer(),
                                  PopupMenuButton<String>(
                                    color: AppColor.white,
                                    onSelected: (value) async {
                                      if (value == 'Today') {
                                        setState(() {
                                          selectedDay = 'Today';
                                          selectedDate = DateTime.now();
                                        });
                                      } else if (value == 'Yesterday') {
                                        setState(() {
                                          selectedDay = 'Yesterday';
                                          selectedDate = DateTime.now()
                                              .subtract(
                                                const Duration(days: 1),
                                              );
                                        });
                                      } else if (value == 'Custom Date') {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              selectedDate ?? DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                dialogBackgroundColor:
                                                    AppColor.white,
                                                colorScheme: ColorScheme.light(
                                                  primary: AppColor.blueG2,
                                                  onPrimary: Colors.white,
                                                  onSurface: AppColor.black,
                                                ),
                                                textButtonTheme:
                                                    TextButtonThemeData(
                                                      style:
                                                          TextButton.styleFrom(
                                                            foregroundColor:
                                                                AppColor.blueG2,
                                                          ),
                                                    ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );

                                        if (picked != null) {
                                          setState(() {
                                            selectedDate = picked;
                                            selectedDay = _fmt(
                                              picked,
                                            ); // 🔥 show the picked date on the button
                                          });
                                        }
                                      }
                                    },
                                    itemBuilder:
                                        (context) => [
                                          _buildMenuItem('Today'),
                                          _buildMenuItem('Yesterday'),
                                          _buildMenuItem('Custom Date'),
                                        ],
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            selectedDay,

                                            style: GoogleFont.ibmPlexSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            size: 20,
                                            color: AppColor.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  /* PopupMenuButton<String>(
                                    color: AppColor.white,
                                    onSelected: (value) async {
                                      setState(() {
                                        selectedDay = value;
                                      });

                                      if (value == 'Today') {
                                        selectedDate = DateTime.now();
                                      } else if (value == 'Yesterday') {
                                        selectedDate = DateTime.now().subtract(
                                          const Duration(days: 1),
                                        );
                                      } else if (value == 'Custom Date') {
                                        DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              selectedDate ?? DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                dialogBackgroundColor:
                                                    AppColor.white,
                                                colorScheme: ColorScheme.light(
                                                  primary: AppColor.blueG2,
                                                  onPrimary: Colors.white,
                                                  onSurface: AppColor.black,
                                                ),
                                                textButtonTheme:
                                                    TextButtonThemeData(
                                                      style:
                                                          TextButton.styleFrom(
                                                            foregroundColor:
                                                                AppColor.blueG2,
                                                          ),
                                                    ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );

                                        if (picked != null) {
                                          setState(() {
                                            selectedDate = picked;
                                          });
                                        }
                                      }
                                    },
                                    itemBuilder:
                                        (context) => [
                                          _buildMenuItem('Today'),
                                          _buildMenuItem('Yesterday'),
                                          _buildMenuItem('Custom Date'),
                                        ],
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            selectedDay ?? 'Select Date',
                                            style: GoogleFont.ibmPlexSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            size: 20,
                                            color: AppColor.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),*/
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ---------- Task List with Subject Filter ----------
                            Obx(() {
                              if (controller.isLoading.value) {
                                return AppLoader.circularLoader();
                              }

                              final tasks =
                                  controller.studentHomeData.value?.tasks ?? [];

                              // filter tasks by selected date first
                              final dateFilteredTasks =
                                  tasks.where((task) {
                                    final taskDate =
                                        DateTime.parse(
                                          task.date.toString(),
                                        ).toLocal();
                                    return taskDate.year ==
                                            selectedDate!.year &&
                                        taskDate.month == selectedDate!.month &&
                                        taskDate.day == selectedDate!.day;
                                  }).toList();

                              // subjects available only for that date
                              final validSubjects =
                                  dateFilteredTasks
                                      .map((e) => e.subject)
                                      .toSet()
                                      .toList();

                              // apply subject filter
                              final filteredTasks =
                                  dateFilteredTasks.where((task) {
                                    return selectedSubject == null ||
                                        selectedSubject == 'All' ||
                                        task.subject == selectedSubject;
                                  }).toList();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ---------- Subject Filter Row ----------
                                  if (validSubjects.isNotEmpty) ...[
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          // Add "All" button always
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                            ),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                elevation:
                                                    const MaterialStatePropertyAll(
                                                      0,
                                                    ),
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                      selectedSubject == 'All'
                                                          ? AppColor.white
                                                          : AppColor.lightGrey,
                                                    ),
                                                side: MaterialStatePropertyAll(
                                                  BorderSide(
                                                    color:
                                                        selectedSubject == 'All'
                                                            ? AppColor.blue
                                                            : AppColor
                                                                .lightGrey,
                                                    width: 2,
                                                  ),
                                                ),
                                                shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  selectedSubject = 'All';
                                                });
                                              },
                                              child: Text(
                                                'All',
                                                style: GoogleFont.ibmPlexSans(
                                                  color:
                                                      selectedSubject == 'All'
                                                          ? AppColor.blue
                                                          : AppColor.grey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Render only subjects having tasks for selected date
                                          ...validSubjects.map((subject) {
                                            final isSelected =
                                                selectedSubject == subject;
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8.0,
                                              ),
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  elevation:
                                                      const MaterialStatePropertyAll(
                                                        0,
                                                      ),
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                        isSelected
                                                            ? AppColor.white
                                                            : AppColor
                                                                .lightGrey,
                                                      ),
                                                  side: MaterialStatePropertyAll(
                                                    BorderSide(
                                                      color:
                                                          isSelected
                                                              ? AppColor.blue
                                                              : AppColor
                                                                  .lightGrey,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  shape: MaterialStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedSubject = subject;
                                                  });
                                                },
                                                child: Text(
                                                  subject,
                                                  style: GoogleFont.ibmPlexSans(
                                                    color:
                                                        isSelected
                                                            ? AppColor.blue
                                                            : AppColor.grey,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 25),
                                  ],

                                  // ---------- Tasks or Empty State ----------
                                  if (filteredTasks.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        children: [
                                          Center(
                                            child: Text(
                                              'No tasks available',
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 14,
                                                color: AppColor.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Image.asset(AppImages.noDataFound),
                                        ],
                                      ),
                                    )
                                  else
                                    Column(
                                      children:
                                          filteredTasks.map((task) {
                                            final taskDate =
                                                DateTime.parse(
                                                  task.date.toString(),
                                                ).toLocal();
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 16,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColor.white,
                                                  border: Border.all(
                                                    color: AppColor.grey
                                                        .withOpacity(0.1),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 15,
                                                    ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            task.title,
                                                            style:
                                                                GoogleFont.ibmPlexSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 16,
                                                                ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            if (task.type ==
                                                                'Quiz') {
                                                              // Optional: quick loader
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    false,
                                                                builder:
                                                                    (
                                                                      _,
                                                                    ) => Center(
                                                                      child: AppLoader.circularLoader(
                                                                        color:
                                                                            AppColor.black,
                                                                      ),
                                                                    ),
                                                              );

                                                              final result =
                                                                  await Get.find<
                                                                        QuizController
                                                                      >()
                                                                      .tryGetResult(
                                                                        task.id,
                                                                      );

                                                              if (Navigator.canPop(
                                                                context,
                                                              ))
                                                                Navigator.pop(
                                                                  context,
                                                                );

                                                              if (!context
                                                                  .mounted)
                                                                return;

                                                              if (result !=
                                                                  null) {
                                                                // Already submitted => go to result screen
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (
                                                                          _,
                                                                        ) => QuizResultScreen(
                                                                          data:
                                                                              result,
                                                                        ),
                                                                  ),
                                                                );
                                                              } else {
                                                                // Not attempted => go to quiz screen
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (
                                                                          _,
                                                                        ) => QuizScreen(
                                                                          quizId:
                                                                              task.id,
                                                                        ),
                                                                  ),
                                                                );
                                                              }
                                                            } else {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (
                                                                        _,
                                                                      ) => TaskDetail(
                                                                        teacherImage:
                                                                            task.teacherImage,
                                                                        id:
                                                                            task.id,
                                                                      ),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                'View',
                                                                style: GoogleFont.ibmPlexSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      AppColor
                                                                          .blue,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward_ios_outlined,
                                                                color:
                                                                    AppColor
                                                                        .blue,
                                                                size: 11,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      task.description,
                                                      style:
                                                          GoogleFont.ibmPlexSans(
                                                            fontSize: 12,
                                                            color:
                                                                AppColor.grey,
                                                          ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    const Divider(),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Assigned By: ${task.assignedByName}',
                                                            style:
                                                                GoogleFont.ibmPlexSans(
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                        ),
                                                        Text(
                                                          DateAndTimeConvert.formatDateTime(
                                                            task.time
                                                                .toString(),
                                                            showDate: false,
                                                            showTime: true,
                                                          ),
                                                          style:
                                                              GoogleFont.ibmPlexSans(
                                                                color:
                                                                    AppColor
                                                                        .lowGrey,
                                                                fontSize: 12,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

Widget buildAnnouncementCard(Announcement ann, BuildContext context) {
  if (ann.newAdmissionStatus == true) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.centerRight,
              colors: [
                AppColor.lightBlueG1,
                AppColor.lightBlueG1.withOpacity(0.5),
                AppColor.lightBlueG2,
              ],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 70,
              right: 8,
              left: 8,
              bottom: 8,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Expanded Text for long messages
                        Text(
                          softWrap: true, // allow wrapping
                          overflow: TextOverflow.visible,
                          ann.message,
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.lightBlack,
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(color: AppColor.lightGrey),
                        SizedBox(height: 6),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => Admission1()),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Open Now',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.blueG2,
                                ),
                              ),
                              SizedBox(width: 7),
                              Image.asset(
                                AppImages.rightArrow,
                                height: 10,
                                color: AppColor.blueG2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 33,
          child: Image.asset(
            AppImages.homeScreenCont2,
            height: 67,
            width: 77.31,
          ),
        ),
      ],
    );
  } else if (ann.admissionStatus == true) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.centerRight,
              colors: [
                AppColor.lightBlueG1,
                AppColor.lightBlueG1.withOpacity(0.5),
                AppColor.lightBlueG2,
              ],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 60,
              right: 8,
              left: 8,
              bottom: 8,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          softWrap: true, // allow wrapping
                          overflow: TextOverflow.visible,
                          ann.message,
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.lightBlack,
                          ),
                        ),

                        SizedBox(height: 8),
                        Divider(color: AppColor.lightGrey),
                        SizedBox(height: 6),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckAdmissionStatus(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Check Now',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.blueG2,
                                ),
                              ),
                              SizedBox(width: 7),
                              Image.asset(
                                AppImages.rightArrow,
                                height: 10,
                                color: AppColor.blueG2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 19,
          child: Image.asset(
            AppImages.homeScreenCont3,
            height: 75,
            width: 73.5,
          ),
        ),
      ],
    );
  } else if (ann.examStatus == true) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.orangeG1, AppColor.orangeG2, AppColor.orangeG3],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 60,
              right: 10,
              left: 10,
              bottom: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          maxLines: 2,
                          softWrap: true,

                          ann.message,
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.lightBlack,
                          ),
                        ),

                        SizedBox(height: 7),
                        Text(
                          maxLines: 2,
                          softWrap: true,

                          ann.submessage,
                          style: GoogleFont.ibmPlexSans(
                            color: AppColor.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 15,
          child: Image.asset(AppImages.clock, height: 72, width: 60.3),
        ),
        Positioned(
          right: 25,
          top: 48,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColor.brown,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'Jun 11',
              style: GoogleFont.ibmPlexSans(
                fontSize: 12,
                color: AppColor.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Add more for noticeBoardStatus and termFeesStatus if needed
  return SizedBox();
}
