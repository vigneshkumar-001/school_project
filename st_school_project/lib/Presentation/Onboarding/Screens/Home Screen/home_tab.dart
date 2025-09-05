import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/app_loader.dart';
import 'package:st_school_project/Core/Widgets/bottom_navigationbar.dart';

import '../../../../Core/Utility/google_font.dart' show GoogleFont;

import '../../../../Core/Widgets/custom_container.dart';
import '../../../Admssion/Screens/admission_1.dart';
import '../../../Admssion/Screens/check_admission_status.dart';
import '../Attendence Screen/attendence_screen.dart';
import 'package:get/get.dart';

import '../More Screen/change_mobile_number.dart';
import '../More Screen/quiz_result.dart';
import '../More Screen/quiz_screen.dart';
import 'controller/student_home_controller.dart';
import 'model/student_home_response.dart';

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

  void Switchprofileorlogout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.30,
          minChildSize: 0.20,
          maxChildSize: 0.50,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 30,
                      decoration: BoxDecoration(color: AppColor.grayop),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Switch Profile',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColor.black,
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: AppColor.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      title: Text(
                                        'Log out',
                                        style: GoogleFont.ibmPlexSans(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        'Are you sure you want to log out?',
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 14,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: GoogleFont.ibmPlexSans(
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.grey,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // close the dialog
                                            Get.back();

                                            // TODO: clear session/cache here

                                            // remove all previous routes and go to splash/login
                                            Get.offAll(
                                              () => ChangeMobileNumber(
                                                page: 'splash',
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Log out',
                                            style: GoogleFont.ibmPlexSans(
                                              color: AppColor.lightRed,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Logout',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AppColor.lightRed,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Image.asset(AppImages.logOut, height: 28),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        Row(
                          children: [
                            Image.asset(AppImages.moreSimage1, height: 58),
                            SizedBox(width: 5),
                            Text(
                              'Anushka',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 18,
                                color: AppColor.black,
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {},
                              child: Image.asset(
                                AppImages.rightArrow,
                                height: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Image.asset(AppImages.moreSimage1, height: 58),
                            SizedBox(width: 5),
                            Text(
                              'Swathi',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 18,
                                color: AppColor.black,
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColor.blue,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 6,
                                  ),
                                  child: Text(
                                    'Active',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 7),
                            InkWell(
                              onTap: () {},
                              child: Image.asset(
                                AppImages.rightArrow,
                                height: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final std = controller.studentHomeData.value;
    final announcement = std?.announcements[index];
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return AppLoader.circularLoader(AppColor.black);
          }
          return SingleChildScrollView(
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
                Stack(
                  children: [
                    ListTile(
                      title: RichText(
                        text: TextSpan(
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 28,
                            color: AppColor.black,
                          ),
                          text: 'Hi ',
                          children: [
                            TextSpan(
                              text:
                                  controller.studentHomeData.value?.name ??
                                  "Welcome",
                              style: GoogleFont.ibmPlexSans(
                                fontWeight: FontWeight.w800,
                                fontSize: 28,
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
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                              text: std?.className ?? '',
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
                                  text: std?.section ?? '',
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
                      trailing: SizedBox(
                        child: Image.asset(
                          AppImages.moreSimage2,
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 34,
                      bottom: 17,
                      child: InkWell(
                        onTap: () => Switchprofileorlogout(context),
                        child: Image.asset(
                          AppImages.moreSimage1,
                          height: 49,
                          width: 49,
                        ),
                      ),
                    ),
                  ],
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
                              borderRadius: BorderRadius.circular(15),
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
                                                              FontWeight.w700,
                                                          color: AppColor.white,
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
                                                            AppColor.lightGrey
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
                                                    'Afternon',
                                                    style:
                                                        GoogleFont.ibmPlexSans(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: AppColor.white,
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
                                              'Attendence',
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

                                                  AppColor.white.withOpacity(
                                                    0.1,
                                                  ),
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
                                    ],
                                  ),
                                  Positioned(
                                    top: 90,
                                    left: 35,
                                    child: Image.asset(
                                      std!.attendance.morning == true
                                          ? AppImages.greenTick
                                          : AppImages.failedImage,
                                      height: 18,
                                    ),
                                  ),
                                  Positioned(
                                    top: 90,
                                    right: 32,
                                    child: Image.asset(
                                      std.attendance.afternoon == true
                                          ? AppImages.greenTick
                                          : AppImages.failedImage,
                                      height: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 15),

                          Stack(
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
                                  // border: Border.all(color: Colors.black12),
                                  // color: AppColor.white,
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: 26,
                                            right: 50,
                                            left: 15,
                                            bottom: 15,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '2025-26 LKG',
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 16,
                                                  color: AppColor.lightBlack,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),

                                              Text(
                                                'Admission \nStarted',
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColor.black,
                                                ),
                                              ),

                                              SizedBox(height: 10),
                                              Divider(
                                                color: AppColor.lightGrey,
                                              ),
                                              SizedBox(height: 6),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              Admission1(),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Open Now',
                                                      style:
                                                          GoogleFont.ibmPlexSans(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                AppColor.blueG2,
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
                                child: Image.asset(
                                  AppImages.homeScreenCont2,
                                  height: 67,
                                  width: 77.31,
                                ),
                                left: 20,
                                top: 33,
                              ),
                            ],
                          ),

                          SizedBox(width: 15),
                          Stack(
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
                                  // border: Border.all(color: Colors.black12),
                                  // color: AppColor.white,
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: 38,
                                            right: 50,
                                            left: 15,
                                            bottom: 15,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '2025-26 LKG',
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 16,
                                                  color: AppColor.lightBlack,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),

                                              Text(
                                                'Admission \nStarted',
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColor.black,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Divider(
                                                color: AppColor.lightGrey,
                                              ),
                                              SizedBox(height: 6),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              CheckAdmissionStatus(),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Check Now',
                                                      style:
                                                          GoogleFont.ibmPlexSans(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                AppColor.blueG2,
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
                          ),
                          SizedBox(width: 15),
                          Stack(
                            children: [
                              Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.white,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 40,
                                            right: 15,
                                            left: 20,
                                            bottom: 20,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Prepare for',
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColor.lightBlack,
                                                ),
                                              ),
                                              Text(
                                                'Examinations',
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColor.black,
                                                ),
                                              ),
                                              SizedBox(height: 7),
                                              Text(
                                                'First Term Exam will \nbe conducted on \n11.Jun.25 ',
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
                                child: Image.asset(
                                  AppImages.clock,
                                  height: 72,
                                  width: 60.3,
                                ),
                                left: 20,
                                top: 15,
                              ),
                              Positioned(
                                child: SizedBox(
                                  height: 22,
                                  width: 58,
                                  child: Container(
                                    alignment: Alignment.center,
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
                                  AppColor.greenG1.withOpacity(0.9),
                                ],
                              ),
                              // border: Border.all(color: Colors.black12),
                              //  color: AppColor.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                left: 8,
                                right: 8,
                                bottom: 20,
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
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
                                              AppColor.white.withOpacity(0.1),
                                            ],
                                          ),

                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),

                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 18,
                                            left: 15,
                                            right: 20,
                                            bottom: 50,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Upcoming Saturday\nHalf day School',
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 12,
                                                  color: AppColor.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                '16-Jun-25',
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 10,
                                                  color: AppColor.grey,
                                                ),
                                              ),
                                              SizedBox(height: 21),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 45.0,
                                                ),
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Image.asset(
                                                    AppImages.greenButtomArrow,
                                                    height: 24,
                                                    width: 23,
                                                  ),
                                                ),
                                              ),
                                            ],
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
                                  Positioned(
                                    child: Image.asset(
                                      AppImages.bag,
                                      height: 45,
                                      width: 43.75,
                                    ),
                                    top: 140,
                                    left: 50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Stack(
                            children: [
                              Container(
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
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 60,
                                    right: 10,
                                    left: 10,
                                    bottom: 8,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.white,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: 30,
                                            right: 20,
                                            left: 15,
                                            bottom: 15,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 22,
                                                width: 58,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: AppColor.lightBlue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    'Jun 11',
                                                    style:
                                                        GoogleFont.ibmPlexSans(
                                                          fontSize: 12,
                                                          color:
                                                              AppColor.textBlue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 6),
                                              Text(
                                                'Second-Term \nFees',
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColor.black,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Divider(),
                                              SizedBox(height: 6),
                                              InkWell(
                                                onTap: () {},
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Know More',
                                                      style:
                                                          GoogleFont.ibmPlexSans(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                AppColor.blueG2,
                                                          ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Image.asset(
                                                      AppImages.rightArrow,
                                                      height: 7,
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
                                child: Image.asset(
                                  AppImages.wallet,
                                  height: 81,
                                  width: 67.84,
                                ),
                                left: 20,
                                top: 15,
                              ),
                            ],
                          ),
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
                              Spacer(),
                              PopupMenuButton<String>(
                                color: AppColor.white,
                                onSelected: (value) async {
                                  setState(() {
                                    selectedDay = value;
                                  });

                                  if (value == 'Today') {
                                    setState(() {
                                      selectedDate = DateTime.now();
                                    });
                                  } else if (value == 'Yesterday') {
                                    setState(() {
                                      selectedDate = DateTime.now().subtract(
                                        Duration(days: 1),
                                      );
                                    });
                                  } else if (value == 'Custom Date') {
                                    DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
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
                                            textButtonTheme: TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    AppColor
                                                        .blueG2, // buttons like OK/CANCEL
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
                                        selectedDay,
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.black,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        size: 20,
                                        color: AppColor.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                subjects.map((subject) {
                                  final isSelected = selectedSubject == subject;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        elevation: MaterialStatePropertyAll(0),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                              isSelected
                                                  ? AppColor.white
                                                  : AppColor.lightGrey,
                                            ),
                                        side: MaterialStatePropertyAll(
                                          BorderSide(
                                            color:
                                                isSelected
                                                    ? AppColor.blue
                                                    : AppColor.lightGrey,
                                            width: 2,
                                          ),
                                        ),
                                        shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
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
                          ),
                        ),
                        SizedBox(height: 25),
                        Column(
                          children:
                              std.tasks
                                  .where(
                                    (task) =>
                                        selectedSubject == 'All' ||
                                        task.subject == selectedSubject,
                                  )
                                  .map((task) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.white,
                                          border: Border.all(
                                            color: AppColor.grey.withOpacity(
                                              0.1,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 15,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  task.title,
                                                  style: GoogleFont.ibmPlexSans(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Spacer(),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                QuizScreen(quizId: 1,),
                                                      ),
                                                    );
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'View',
                                                        style:
                                                            GoogleFont.ibmPlexSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  AppColor.blue,
                                                            ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Icon(
                                                        Icons
                                                            .arrow_forward_ios_outlined,
                                                        color: AppColor.blue,
                                                        size: 11,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Text(
                                              task.description,
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 12,
                                                color: AppColor.grey,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Divider(),
                                            SizedBox(height: 6),
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
                                                  task.time
                                                      .toString(), // format as needed
                                                  style: GoogleFont.ibmPlexSans(
                                                    color: AppColor.lowGrey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
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
