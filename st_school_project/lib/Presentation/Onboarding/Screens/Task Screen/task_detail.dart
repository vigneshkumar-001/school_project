import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/app_loader.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';

import 'package:get/get.dart';

import '../../../../Core/Utility/app_color.dart';
import '../../../../Core/Utility/google_font.dart';
import '../../../../Core/Widgets/date_and_time_convert.dart';
import 'controller/task_controller.dart';

class TaskDetail extends StatefulWidget {
  final int id;
  final String? teacherImage;
  const TaskDetail({super.key, required this.id, this.teacherImage});

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

  void _openFullScreenNetwork(String url) {
    if (url.isEmpty) return;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder:
          (_) => GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 5,
                child: Image.network(url),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Obx(() {
          final homework = taskController.homeworkDetail.value;
          if (homework == null) {
            return Center(child: AppLoader.circularLoader());
          }

          final tasks = homework.tasks ?? [];

          // Filter all images and paragraphs
          final allImages = tasks.where((t) => t.type == 'image').toList();
          final allParagraphs =
              tasks.where((t) => t.type == 'paragraph').toList();

          final allLists = tasks.where((t) => t.type == 'list').toList();

          // First image for top
          final topImage = allImages.isNotEmpty ? allImages.first : null;

          // Remaining images for horizontal scroll
          final remainingImages =
              allImages.length > 1 ? allImages.sublist(1) : [];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button and title
                Row(
                  children: [
                    CustomContainer.leftSaitArrow(
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 15),
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
                const SizedBox(height: 20),

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (topImage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 30,
                            horizontal: 20,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _openFullScreenNetwork(topImage.content);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                topImage.content ?? '',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => Image.asset(
                                      AppImages.tdhs1,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          homework.title ?? '',
                          style: GoogleFont.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: AppColor.lightBlack,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          homework.description ?? '',
                          style: GoogleFont.inter(
                            fontSize: 12,
                            color: AppColor.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Horizontal scroll of remaining images with counter
                      if (remainingImages.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),

                                itemCount: remainingImages.length,
                                itemBuilder: (context, index) {
                                  final img = remainingImages[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: GestureDetector(
                                      onTap: () {
                                        _openFullScreenNetwork(img.content);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          img.content ?? '',
                                          width: 200,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) => Container(
                                                width: 200,
                                                height: 150,
                                                color: Colors.grey[200],
                                              ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      // Paragraphs
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            allParagraphs.map<Widget>((p) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 20,
                                ),
                                child: Text(
                                  p.content ?? '',
                                  style: GoogleFont.inter(
                                    fontSize: 14,
                                    color: AppColor.lightBlack,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),

                      // Lists
                      if (allLists.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                allLists.asMap().entries.map<Widget>((entry) {
                                  final index =
                                      entry.key + 1; // 1-based numbering
                                  final item = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "$index. ", // numbering
                                          style: GoogleFont.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.lightBlack,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            item.content ?? '',
                                            style: GoogleFont.inter(
                                              fontSize: 14,
                                              color: AppColor.lightBlack,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ],

                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
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
                                          radius: 20, // smaller than 25
                                          backgroundColor: Colors.transparent,
                                          child: ClipOval(
                                            child: Image.network(
                                              widget.teacherImage.toString() ??
                                                  '',
                                              fit: BoxFit.cover,
                                              width: 40,
                                              height: 40,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          homework.subject.name.toString() ??
                                              '',
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
                                          DateAndTimeConvert.formatDateTime(
                                            homework.time.toString() ?? '',

                                            showDate: true,
                                            showTime: true,
                                          ),

                                          style: GoogleFont.inter(
                                            fontSize: 12,
                                            color: AppColor.lightBlack,
                                          ),
                                        ),
                                        // SizedBox(width: 10),
                                        // Text(
                                        //   homework.date.toString() ?? '',
                                        //   style: GoogleFont.inter(
                                        //     fontSize: 12,
                                        //     color: AppColor.grey,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //   child: Row(
      //     children: [
      //       Container(
      //         decoration: BoxDecoration(
      //           color: AppColor.lightGrey,
      //           border: Border.all(color: AppColor.lowLightBlue, width: 1),
      //           borderRadius: BorderRadius.circular(30),
      //         ),
      //         child: Row(
      //           children: [
      //             IconButton(
      //               onPressed: () {},
      //               icon: Padding(
      //                 padding: const EdgeInsets.symmetric(
      //                   horizontal: 15,
      //                   vertical: 7,
      //                 ),
      //                 child: Row(
      //                   children: [
      //                     Icon(
      //                       color: AppColor.grey,
      //                       CupertinoIcons.left_chevron,
      //                       size: 20,
      //                     ),
      //                     SizedBox(width: 20),
      //                     Text(
      //                       'English',
      //                       style: GoogleFont.ibmPlexSans(
      //                         fontSize: 14,
      //                         fontWeight: FontWeight.w600,
      //                         color: AppColor.grey,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       SizedBox(width: 30),
      //       OutlinedButton(
      //         onPressed: () {},
      //         child: Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 14),
      //           child: Row(
      //             children: [
      //               Text(
      //                 'Mathematics',
      //                 style: GoogleFont.ibmPlexSans(
      //                   fontSize: 14,
      //                   fontWeight: FontWeight.w600,
      //                   color: AppColor.black,
      //                 ),
      //               ),
      //               SizedBox(width: 30),
      //               Icon(
      //                 color: AppColor.grey,
      //                 CupertinoIcons.right_chevron,
      //                 size: 20,
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
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
