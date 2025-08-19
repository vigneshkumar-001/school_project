import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:intl/intl.dart' show DateFormat;
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/app_loader.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/swicth_profile_sheet.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Task%20Screen/controller/task_controller.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Task%20Screen/task_detail.dart';

import '../../../../Core/Utility/google_font.dart' show GoogleFont;
import '../../../../Core/Widgets/date_and_time_convert.dart';
import '../Home Screen/controller/student_home_controller.dart';
import '../More Screen/quiz_screen.dart';
import 'package:get/get.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with AutomaticKeepAliveClientMixin {
  final TaskController taskController = Get.put(TaskController());
  DateTime selectedDate = DateTime.now();
  final StudentHomeController controller = Get.put(StudentHomeController());
  DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  late ScrollController _scrollController;

  final List<String> months = List.generate(
    12,
    (index) => DateFormat.MMMM().format(DateTime(0, index + 6)),
  );

  List<Map<String, dynamic>> getFullMonthDates(DateTime currentMonth) {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    late ScrollController _scrollController;

    return List.generate(lastDay.day, (i) {
      final date = firstDay.add(Duration(days: i));
      return {
        "day": DateFormat.E().format(date),
        "date": date.day,
        "fullDate": date,
        "formattedFullDate": DateFormat('EEEE, dd MMM yyyy').format(date),
      };
    });
  }

  @override
  bool get wantKeepAlive => true;
  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController = ScrollController();
  //
  //   // Wait for first frame to render, then scroll
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     taskController.getTaskDetails();
  //     scrollToSelectedDate();
  //   });
  // }
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (taskController.tasks.isEmpty) {
        taskController.getTaskDetails();
      }
      scrollToSelectedDate();
    });
  }

  void scrollToSelectedDate() {
    final dates = getFullMonthDates(currentMonth);
    final index = dates.indexWhere((item) {
      final date = item['fullDate'] as DateTime;
      return selectedDate.day == date.day &&
          selectedDate.month == date.month &&
          selectedDate.year == date.year;
    });

    if (index != -1) {
      final double itemWidth = 57;
      double scrollOffset = (index * itemWidth) - 100;
      if (scrollOffset < 0) scrollOffset = 0;

      _scrollController.jumpTo(scrollOffset);
    }
  }

  void showMonthPicker() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => ListView.builder(
            itemCount: months.length,
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(months[index]),
                onTap: () {
                  setState(() {
                    currentMonth = DateTime(DateTime.now().year, index + 6);
                    selectedDate = DateTime(
                      currentMonth.year,
                      currentMonth.month,
                      1,
                    );
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
    );
  }

  /*  void Switchprofileorlogout(BuildContext context) {
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
                      Text(
                        'Logout',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightRed,
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {},
                        child: Image.asset(AppImages.logOut, height: 26),
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
                        child: Image.asset(AppImages.rightArrow, height: 16),
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
                            border: Border.all(color: AppColor.blue, width: 1),
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
                        child: Image.asset(AppImages.rightArrow, height: 16),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }*/

  int index = 0;
  String selectedSubject = 'All';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: [AppColor.blueG1, AppColor.blueG2],
          ),
        ),
        child: SafeArea(
          child: SizedBox.expand(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(AppImages.jbg, fit: BoxFit.cover),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: showMonthPicker,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat('MMMM dd').format(selectedDate),
                                  style: GoogleFont.ibmPlexSans(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColor.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: getFullMonthDates(currentMonth).length,
                        itemBuilder: (context, index) {
                          final item = getFullMonthDates(currentMonth)[index];
                          final date = item['fullDate'] as DateTime;

                          // Check if this date is selected
                          final isSelected =
                              selectedDate.year == date.year &&
                                  selectedDate.month == date.month &&
                                  selectedDate.day == date.day;

                          // Count tasks for this date
                          final tasksForDate = taskController.tasks.where((task) {
                            final taskDate = task.date; // already DateTime
                            return taskDate.year == date.year &&
                                taskDate.month == date.month &&
                                taskDate.day == date.day;
                          }).toList();


                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDate = date;
                                scrollToSelectedDate();
                              });
                            },
                            child: Container(
                              width: 57,
                              decoration: isSelected
                                  ? BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              )
                                  : null,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item['day'],
                                    style: GoogleFont.ibmPlexSans(
                                      color: isSelected ? Colors.blue : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    item['date'].toString(),
                                    style: GoogleFont.ibmPlexSans(
                                      color: isSelected ? Colors.blue : Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                    Expanded(
                      child: Stack(
                        children: [
                          DraggableScrollableSheet(
                            initialChildSize: 0.99,
                            minChildSize: 0.99,
                            maxChildSize: 0.99,
                            builder: (context, scrollController) {
                              return Container(
                                padding: const EdgeInsets.only(top: 20),

                                decoration: const BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      child: Stack(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Your Tasks',
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 177),
                                              Image.asset(
                                                AppImages.moreSimage2,
                                                height: 20,
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            right: 0,
                                            bottom: 6,
                                            child: InkWell(
                                              onTap: () {
                                                SwitchProfileSheet.show(
                                                  context,
                                                  students:
                                                      controller.siblingsList,
                                                  selectedStudent:
                                                      controller
                                                          .selectedStudent,
                                                  onSwitch: (student) async {
                                                    await controller
                                                        .switchSiblings(
                                                          id: student.id,
                                                        );
                                                    controller.selectStudent(
                                                      student,
                                                    );
                                                  },
                                                  onLogout: () async {
                                                    await controller
                                                        .clearData();
                                                    // Get.offAllNamed('/login');
                                                  },
                                                );
                                              },
                                              child: Image.asset(
                                                AppImages.moreSimage1,
                                                height: 30,
                                                width: 40,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Obx(() {
                                            // Generate dynamic subjects from tasks
                                            final subjects = <String>{'All'};
                                            subjects.addAll(
                                              taskController.tasks.map(
                                                (t) => t.subject,
                                              ),
                                            );
                                            final subjectList =
                                                subjects.toList();

                                            return SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children:
                                                    subjectList.map((subject) {
                                                      final isSelected =
                                                          selectedSubject ==
                                                          subject;
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                            ),
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                            elevation:
                                                                MaterialStateProperty.all(
                                                                  0,
                                                                ),
                                                            backgroundColor:
                                                                MaterialStateProperty.all(
                                                                  isSelected
                                                                      ? AppColor
                                                                          .white
                                                                      : AppColor
                                                                          .lightGrey,
                                                                ),
                                                            side: MaterialStateProperty.all(
                                                              BorderSide(
                                                                color:
                                                                    isSelected
                                                                        ? AppColor
                                                                            .black
                                                                        : AppColor
                                                                            .lightGrey,
                                                                width: 2,
                                                              ),
                                                            ),
                                                            shape: MaterialStateProperty.all(
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
                                                              selectedSubject =
                                                                  subject;
                                                            });
                                                          },
                                                          child: Text(
                                                            subject,
                                                            style: TextStyle(
                                                              color:
                                                                  isSelected
                                                                      ? AppColor
                                                                          .black
                                                                      : AppColor
                                                                          .grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                              ),
                                            );
                                          }),
                                          const SizedBox(height: 20),
                                          Expanded(
                                            child: Obx(() {
                                              if (taskController
                                                  .isLoading
                                                  .value) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }

                                              const List<Color> colors = [
                                                AppColor.lowLightBlue,
                                                AppColor.lowLightYellow,
                                                AppColor.lowLightNavi,
                                                AppColor.white,
                                                AppColor.lowLightPink,
                                              ];

                                              final filteredTasks =
                                                  taskController.tasks.where((
                                                    task,
                                                  ) {
                                                    final taskDate = DateTime.parse(
                                                      task.time.toString(),
                                                    ); // convert ISO string to DateTime
                                                    final isSameDate =
                                                        taskDate.year ==
                                                            selectedDate.year &&
                                                        taskDate.month ==
                                                            selectedDate
                                                                .month &&
                                                        taskDate.day ==
                                                            selectedDate.day;

                                                    final isSameSubject =
                                                        selectedSubject ==
                                                            'All' ||
                                                        task.subject ==
                                                            selectedSubject;

                                                    return isSameDate &&
                                                        isSameSubject;
                                                  }).toList();

                                              if (filteredTasks.isEmpty) {
                                                return const Center(
                                                  child: Text(
                                                    'No tasks available',
                                                  ),
                                                );
                                              }

                                              return SingleChildScrollView(
                                                controller: _scrollController,
                                                child: Column(
                                                  children:
                                                      filteredTasks.asMap().entries.map<
                                                        Widget
                                                      >((entry) {
                                                        final index = entry.key;
                                                        final task =
                                                            entry.value;
                                                        final bgColor =
                                                            colors[index %
                                                                colors.length];

                                                        return CustomContainer.taskScreen(
                                                          mainText: task.title,
                                                          subText:
                                                              task.description,
                                                          homeWorkText:
                                                              task.subject,
                                                          avatarImage:
                                                              AppImages
                                                                  .avatar1, // provide avatar if needed
                                                          smaleText: task.type,
                                                          time:
                                                              DateAndTimeConvert.formatDateTime(
                                                                task.time
                                                                    .toString(),
                                                                showDate: false,
                                                                showTime: true,
                                                              ),
                                                          aText1: 'By ',
                                                          aText2:
                                                              task.assignedByName,
                                                          backRoundColor:
                                                              bgColor,
                                                          gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  Colors.black,
                                                                  Colors.black,
                                                                ],
                                                              ),
                                                          onIconTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (
                                                                      context,
                                                                    ) => TaskDetail(
                                                                      id: task.id,
                                                                    ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }).toList(),
                                                ),
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),

                                    /*  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children:
                                            subjects.map((subject) {
                                              final isSelected =
                                                  selectedSubject == subject;
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                ),
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    elevation:
                                                        MaterialStatePropertyAll(
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
                                                                ? AppColor.black
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
                                                    style:
                                                        GoogleFont.ibmPlexSans(
                                                          color:
                                                              isSelected
                                                                  ? AppColor
                                                                      .black
                                                                  : AppColor
                                                                      .grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                    SizedBox(height: 20),

                                    Expanded(
                                      child: Obx(() {
                                        if (taskController.isLoading.value) {
                                          return Center(
                                            child: AppLoader.circularLoader(
                                              AppColor.black,
                                            ),
                                          );
                                        }

                                        const List<Color> colors = [
                                          AppColor.lowLightBlue,
                                          AppColor.lowLightYellow,
                                          AppColor.lowLightNavi,
                                          AppColor.white,
                                          AppColor.lowLightPink,

                                        ];

                                        final filteredTasks =
                                            taskController.tasks.where((task) {
                                              return selectedSubject == 'All' ||
                                                  task.subject ==
                                                      selectedSubject;
                                            }).toList();

                                        if (filteredTasks.isEmpty) {
                                          return const Center(
                                            child: Text('No tasks available'),
                                          );
                                        }

                                        return SingleChildScrollView(
                                          controller: scrollController,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children:
                                                filteredTasks.asMap().entries.map<
                                                  Widget
                                                >((entry) {
                                                  final index =
                                                      entry.key; // task index
                                                  final task = entry.value;
                                                  final bgColor =
                                                      colors[index %
                                                          colors
                                                              .length]; // pick color by index

                                                  return CustomContainer.taskScreen(
                                                    backRoundColors: bgColor,
                                                    subText: task.description,
                                                    homeWorkText: task.subject,
                                                    homeWorkImage: '',
                                                    avatarImage:
                                                        AppImages.avatar1,
                                                    mainText: task.title,
                                                    smaleText: task.type,
                                                    time:
                                                        DateAndTimeConvert.formatDateTime(
                                                          task.time.toString(),
                                                          showDate: false,
                                                          showTime: true,
                                                        ),
                                                    aText1: 'By ',
                                                    aText2: task.assignedByName,
                                                    backRoundColor: bgColor,
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        AppColor.black,
                                                        AppColor.black,
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                    onIconTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  TaskDetail(
                                                                    id: task.id,
                                                                  ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }).toList(),
                                          ),
                                        );
                                      }),
                                    ),*/
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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
