import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/task_screen.dart'
    show TaskScreen;

import '../../../Core/Utility/app_color.dart' show AppColor;

class TaskDetail extends StatefulWidget {
  const TaskDetail({super.key});

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
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
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskScreen(),
                            ),
                          );
                        },
                        icon: Icon(
                          color: AppColor.grey,
                          CupertinoIcons.left_chevron,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      'Homework Details',
                      style: TextStyle(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(AppImages.tdhs1),
                        SizedBox(height: 20),
                        Image.asset(AppImages.tdhs2),
                        SizedBox(height: 20),
                        Text(
                          'Draw Single cell',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: AppColor.lightBlack,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Vestibulum non ipsum risus. Quisque et sem eu \nvelit varius pellentesque et sit amet diam. Phasellus \neros libero, finibus eu magna vel, viverra pharetra \nvelit. Nullam congue sapien neque, dapibus \ndignissim magna elementum at. Class aptent taciti \nsociosqu ad litora torquent per conubia nostra, per \ninceptos himenaeos.',
                          style: TextStyle(fontSize: 12, color: AppColor.grey),
                        ),
                        SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.black.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          child: Image.asset(AppImages.avatar1),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Science Homework',
                                          style: TextStyle(
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
                                    color: AppColor.black.withOpacity(0.1),
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
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.lightBlack,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          '18.Jul.25',
                                          style: TextStyle(
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
                            icon: Row(
                              children: [
                                Icon(
                                  color: AppColor.grey,
                                  CupertinoIcons.left_chevron,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'English',
                                  style: TextStyle(
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
                    SizedBox(width: 15),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
