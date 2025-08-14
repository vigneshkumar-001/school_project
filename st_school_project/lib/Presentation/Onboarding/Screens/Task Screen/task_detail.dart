import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';

import 'package:get/get.dart';

import '../../../../Core/Utility/app_color.dart';
import '../../../../Core/Utility/google_font.dart';
import 'controller/task_controller.dart';

class TaskDetail extends StatefulWidget {
  final int id;
  const TaskDetail({super.key, required this.id});

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  final TaskController taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskController.homeWorkIdDetails(id: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Obx(() {
          final homework = taskController.homeworkDetail.value;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomContainer.leftSaitArrow(
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Homework Details',
                        style: GoogleFont.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightBlack,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColor.lowLightYellow,
                          AppColor.lowLightYellow.withOpacity(0.2),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 55),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Replace static images with dynamic if available
                                Image.asset(AppImages.tdhs1),

                                SizedBox(height: 20),
                                Image.asset(AppImages.tdhs2),

                                SizedBox(height: 20),
                                Text(
                                  homework?.title ?? '',
                                  style: GoogleFont.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    color: AppColor.lightBlack,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  homework?.description ?? '',
                                  style: GoogleFont.inter(
                                    fontSize: 12,
                                    color: AppColor.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 25,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.black.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            child: Image.asset(
                                              AppImages.avatar1,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            homework?.subject.name ?? '',
                                            style: GoogleFont.inter(
                                              fontSize: 12,
                                              color: AppColor.lightBlack,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.black.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.clock_fill,
                                            size: 35,
                                            color: AppColor.lightBlack
                                                .withOpacity(0.3),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            homework?.time ?? '',
                                            style: GoogleFont.inter(
                                              fontSize: 12,
                                              color: AppColor.lightBlack,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            homework?.date ?? '',
                                            style: GoogleFont.inter(
                                              fontSize: 12,
                                              color: AppColor.grey,
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Optional: class and section dynamically
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.lightGrey,
                          border: Border.all(
                            color: AppColor.lowLightBlue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 7,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.left_chevron,
                                    color: AppColor.grey,
                                    size: 20,
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    '${homework?.classInfo.name ?? ''} - ${homework?.classInfo.section}',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 30),
                      OutlinedButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Text(
                                homework?.subject.name ?? '',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.black,
                                ),
                              ),
                              SizedBox(width: 30),
                              Icon(
                                CupertinoIcons.right_chevron,
                                color: AppColor.grey,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomContainer.leftSaitArrow(
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Homework Details',
                        style: GoogleFont.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightBlack,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      // color: AppColor.lowLightYellow,
                      gradient: LinearGradient(
                        colors: [
                          AppColor.lowLightYellow,
                          AppColor.lowLightYellow,
                          AppColor.lowLightYellow,
                          AppColor.lowLightYellow,
                          AppColor.lowLightYellow,
                          AppColor.lowLightYellow,
                          AppColor.lowLightYellow.withOpacity(0.2),
                        ], // gradient top to bottom
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 55),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(AppImages.tdhs1),
                                SizedBox(height: 20),
                                Image.asset(AppImages.tdhs2),
                                SizedBox(height: 20),
                                Text(
                                  'Draw Single cell',
                                  style: GoogleFont.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    color: AppColor.lightBlack,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Vestibulum non ipsum risus. Quisque et sem eu \nvelit varius pellentesque et sit amet diam. Phasellus \neros libero, finibus eu magna vel, viverra pharetra \nvelit. Nullam congue sapien neque, dapibus \ndignissim magna elementum at. Class aptent taciti \nsociosqu ad litora torquent per conubia nostra, per \ninceptos himenaeos.',
                                  style: GoogleFont.inter(
                                    fontSize: 12,
                                    color: AppColor.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 25,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.black.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            child: Image.asset(
                                              AppImages.avatar1,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Science Homework',
                                            style: GoogleFont.inter(
                                              fontSize: 12,
                                              color: AppColor.lightBlack,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.black.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.clock_fill,
                                            size: 35,
                                            color: AppColor.lightBlack
                                                .withOpacity(0.3),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            '4.30Pm',
                                            style: GoogleFont.inter(
                                              fontSize: 12,
                                              color: AppColor.lightBlack,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            '18.Jul.25',
                                            style: GoogleFont.inter(
                                              fontSize: 12,
                                              color: AppColor.grey,
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.lightGrey,
                          border: Border.all(
                            color: AppColor.lowLightBlue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 7,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      color: AppColor.grey,
                                      CupertinoIcons.left_chevron,
                                      size: 20,
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      'English',
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 30),
                      OutlinedButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Text(
                                'Mathematics',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.black,
                                ),
                              ),
                              SizedBox(width: 30),
                              Icon(
                                color: AppColor.grey,
                                CupertinoIcons.right_chevron,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
