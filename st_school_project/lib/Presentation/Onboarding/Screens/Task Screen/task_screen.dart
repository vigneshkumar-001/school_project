/*import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:intl/intl.dart' show DateFormat;
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/app_loader.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Task%20Screen/controller/task_controller.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Task%20Screen/task_detail.dart';

import '../../../../Core/Utility/google_font.dart' show GoogleFont;

import '../More Screen/change_mobile_number.dart';

import '../../../../Core/Widgets/date_and_time_convert.dart';

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

  void scrollToDateIndex(int index) {
    final double itemWidth = 57;
    final double screenWidth = MediaQuery.of(context).size.width;

    double scrollOffset =
        (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    if (scrollOffset < 0) scrollOffset = 0;
    if (scrollOffset > _scrollController.position.maxScrollExtent) {
      scrollOffset = _scrollController.position.maxScrollExtent;
    }

    _scrollController.animateTo(
      scrollOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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

  int index = 0;
  String selectedSubject = 'All';

  */ /*final List<String> subjects = [
    'All',
    'Quiz',
    'Science',
    'English',
    'Social Science',
    'Maths',
  ];*/ /*

  // final List<Map<String, dynamic>> allTasks = [
  //   {
  //     'subject': 'Quiz',
  //     'homeWorkText': 'Quiz',
  //     'homeWorkImage': AppImages.taskScreenCont1,
  //     'avatar': AppImages.avatar1,
  //     'mainText': 'Mathematics Quiz',
  //     'subText': 'Waiting for you',
  //     'smaleText': 'Lorem ipsum dolor sit amet, co...',
  //     'time': '4.30Pm',
  //     'bgColor': AppColor.taskScrnCont1,
  //     'gradient': LinearGradient(
  //       colors: [AppColor.black, AppColor.black],
  //       begin: Alignment.topLeft,
  //       end: Alignment.bottomRight,
  //     ),
  //     // 'screenBuilder': () => QuizScreen(quizId: 11),
  //   },
  //   {
  //     'subject': 'Science',
  //     'homeWorkText': 'Science Homework',
  //     'avatar': AppImages.avatar1,
  //     'mainText': 'Draw Single cell',
  //     'smaleText': 'Lorem ipsum dolor sit amet, co...',
  //     'time': '4.30Pm',
  //     'bgColor': AppColor.lowLightBlue,
  //     'gradient': LinearGradient(
  //       colors: [AppColor.black, AppColor.black],
  //       begin: Alignment.topLeft,
  //       end: Alignment.bottomRight,
  //     ),
  //   },
  //   {
  //     'subject': 'Maths',
  //     'homeWorkText': 'Maths Homework',
  //     'avatar': AppImages.avatar2,
  //     'mainText': 'Draw triangle',
  //     'smaleText': 'Lorem ipsum dolor sit amet, co...',
  //     'time': '3.00Pm',
  //     'bgColor': AppColor.lowLightYellow,
  //     'gradient': LinearGradient(
  //       colors: [AppColor.black, AppColor.black],
  //       begin: Alignment.topLeft,
  //       end: Alignment.bottomRight,
  //     ),
  //   },
  //   {
  //     'subject': 'English',
  //     'homeWorkText': 'English Homework',
  //     'avatar': AppImages.avatar3,
  //     'mainText': 'Write an essay',
  //     'smaleText': 'Lorem ipsum dolor sit amet...',
  //     'time': '1.30Pm',
  //     'bgColor': AppColor.lowLightNavi,
  //     'gradient': LinearGradient(
  //       colors: [AppColor.black, AppColor.black],
  //       begin: Alignment.topLeft,
  //       end: Alignment.bottomRight,
  //     ),
  //   },
  //   {
  //     'subject': 'Social Science',
  //     'homeWorkText': 'Social Science Homework',
  //     'avatar': AppImages.avatar4,
  //     'mainText': 'Map work',
  //     'smaleText': 'Lorem ipsum dolor sit amet...',
  //     'time': '2.30Pm',
  //     'bgColor': AppColor.lowLightPink,
  //     'gradient': LinearGradient(
  //       colors: [AppColor.black, AppColor.black],
  //       begin: Alignment.topLeft,
  //       end: Alignment.bottomRight,
  //     ),
  //   },
  //   {
  //     'subject': 'Science',
  //     'homeWorkText': 'Science Homework',
  //     'avatar': AppImages.avatar1,
  //     'mainText': 'Label Plant Cell',
  //     'smaleText': 'Lorem ipsum dolor sit amet...',
  //     'time': '5.30Pm',
  //     'bgColor': AppColor.white,
  //     'gradient': LinearGradient(
  //       colors: [AppColor.blueG1, AppColor.blueG2],
  //       begin: Alignment.topLeft,
  //       end: Alignment.bottomRight,
  //     ),
  //   },
  // ];

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
                                    color: AppColor.white,
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
                          final isSelected =
                              selectedDate.day == date.day &&
                              selectedDate.month == date.month &&
                              selectedDate.year == date.year;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDate = date;
                              });
                              scrollToDateIndex(index);
                            },

                            child: Container(
                              width: 57,
                              decoration:
                                  isSelected
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
                                      color:
                                          isSelected
                                              ? Colors.blue
                                              : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    item['date'].toString(),
                                    style: GoogleFont.ibmPlexSans(
                                      color:
                                          isSelected
                                              ? Colors.blue
                                              : Colors.white,
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
                                              onTap:
                                                  () => Switchprofileorlogout(
                                                    context,
                                                  ),
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

                                    */ /*  SingleChildScrollView(
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
                                    ),*/ /*
                                    Obx(() {
                                      final subjects =
                                          taskController
                                              .subjectFilters; // ['All', ...unique subjects]
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children:
                                              subjects.map((subject) {
                                                final isSelected =
                                                    selectedSubject == subject;
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 16.0,
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
                                                                  ? AppColor
                                                                      .black
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
                                                    onPressed:
                                                        () => setState(
                                                          () =>
                                                              selectedSubject =
                                                                  subject,
                                                        ),
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
                                      );
                                    }),

                                    SizedBox(height: 20),

                                    */ /*Expanded(
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ...allTasks
                                                .where(
                                                  (task) =>
                                                      selectedSubject ==
                                                          'All' ||
                                                      task['subject'] ==
                                                          selectedSubject,
                                                )
                                                .map((task) {
                                                  return CustomContainer.taskScreen(
                                                    subText:
                                                        task['subText'] ?? '',
                                                    homeWorkText:
                                                        task['homeWorkText'] ??
                                                        '',
                                                    homeWorkImage:
                                                        task['homeWorkImage'] ??
                                                        '',
                                                    avatarImage:
                                                        task['avatar'] ?? '',
                                                    mainText:
                                                        task['mainText'] ?? '',
                                                    smaleText:
                                                        task['smaleText'] ?? '',
                                                    time: task['time'] ?? '',
                                                    aText1: 'By ',
                                                    aText2: 'Floran',
                                                    backRoundColor:
                                                        task['bgColor'] ??
                                                        AppColor.white,
                                                    gradient: task['gradient'],
                                                    onIconTap: () {
                                                      final screen =
                                                          task['screen'];
                                                      if (screen != null) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (_) => screen,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  );
                                                })
                                                .toList(),
                                          ],
                                        ),
                                      ),
                                    ),*/ /*
                                    */ /*Expanded(
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
                                    ),*/ /*
                                    Expanded(
                                      child: Obx(() {
                                        if (taskController.isLoading.value) {
                                          return Center(
                                            child: AppLoader.circularLoader(
                                              AppColor.black,
                                            ),
                                          );
                                        }

                                        const colors = <Color>[
                                          AppColor.lowLightBlue,
                                          AppColor.lowLightYellow,
                                          AppColor.lowLightNavi,
                                          AppColor.white,
                                          AppColor.lowLightPink,
                                        ];

                                        final filteredTasks =
                                            taskController.tasks.where((task) {
                                              final s = task.subject ?? '';
                                              return selectedSubject == 'All' ||
                                                  s == selectedSubject;
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
                                                  final index = entry.key;
                                                  final task = entry.value;
                                                  final bgColor =
                                                      colors[index %
                                                          colors.length];

                                                  return CustomContainer.taskScreen(
                                                    backRoundColors: bgColor,
                                                    subText: task.description,
                                                    homeWorkText:
                                                        task.subject ?? '—',
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
                                                    gradient:
                                                        const LinearGradient(
                                                          colors: [
                                                            AppColor.black,
                                                            AppColor.black,
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end:
                                                              Alignment
                                                                  .bottomRight,
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
                                    ),
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
}*/

/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/app_loader.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/date_and_time_convert.dart';

// Navigate targets
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/quiz_screen.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Task%20Screen/task_detail.dart';

import '../More Screen/change_mobile_number.dart';
import 'controller/task_controller.dart';
import 'model/task_response.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with AutomaticKeepAliveClientMixin {
  final TaskController taskController = Get.put(TaskController());

  DateTime selectedDate = DateTime.now();
  final ScrollController _dateScroll = ScrollController();
  String selectedSubject = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (taskController.tasks.isEmpty) {
        await taskController.getTaskDetails();
      }
      _scrollDateRowToToday();
    });
  }

  @override
  void dispose() {
    _dateScroll.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  // ---------- Date Row Helpers ----------
  List<Map<String, dynamic>> _monthDates(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    return List.generate(last.day, (i) {
      final d = first.add(Duration(days: i));
      return {
        "dayStr": _weekdayShort(d.weekday),
        "dayNum": d.day,
        "fullDate": d,
      };
    });
  }

  String _weekdayShort(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
    }
    return '';
  }

  void _scrollDateRowToToday() {
    final dates = _monthDates(DateTime(selectedDate.year, selectedDate.month));
    final idx = dates.indexWhere((m) {
      final d = m['fullDate'] as DateTime;
      return _isSameDay(d, selectedDate);
    });
    if (idx == -1 || !_dateScroll.hasClients) return; // guard if not attached

    const itemW = 57.0;
    final offset = (idx * itemW) - 100;
    _dateScroll.jumpTo(offset < 0 ? 0 : offset);
  }

  // ---------- Navigation Helpers ----------
  bool _isQuiz(YourTask t) {
    final tType = t.type.trim().toLowerCase();
    return tType == 'quiz';
  }

  bool _isHomework(YourTask t) {
    final tType = t.type.trim().toLowerCase();
    return tType == 'homework';
  }

  void _openTask(BuildContext context, YourTask t) {
    if (_isQuiz(t)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => QuizScreen(quizId: t.id)),
      );
    } else if (_isHomework(t)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TaskDetail(id: t.id)),
      );
    } else {
      // fallback if API introduces a new type
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unknown task type: ${t.type}')));
    }
  }

  // ---------- Utils ----------
  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _monthName(int m) {
    const names = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[m];
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

    final month = DateTime(selectedDate.year, selectedDate.month);
    final monthItems = _monthDates(month);

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
                    // Top: selected date
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 16, 4),
                      child: Row(
                        children: [
                          Text(
                            '${_monthName(selectedDate.month)} '
                            '${selectedDate.day.toString().padLeft(2, '0')} ',
                            style: GoogleFont.ibmPlexSans(
                              color: AppColor.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Image.asset(
                            AppImages.bottomArrow,
                            color: AppColor.white,
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Date row
                    SizedBox(
                      height: 90,
                      child: ListView.separated(
                        controller: _dateScroll,
                        scrollDirection: Axis.horizontal,
                        itemCount: monthItems.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 0),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemBuilder: (_, index) {
                          final item = monthItems[index];
                          final d = item['fullDate'] as DateTime;
                          final isSel = _isSameDay(d, selectedDate);
                          return GestureDetector(
                            onTap: () => setState(() => selectedDate = d),
                            child: Container(
                              width: 57,
                              decoration:
                                  isSel
                                      ? BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: AppColor.blue,
                                          width: 1,
                                        ),
                                      )
                                      : null,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item['dayStr'],
                                    style: GoogleFont.ibmPlexSans(
                                      color:
                                          isSel
                                              ? AppColor.blue
                                              : AppColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    item['dayNum'].toString(),
                                    style: GoogleFont.ibmPlexSans(
                                      color:
                                          isSel
                                              ? AppColor.blue
                                              : AppColor.white,
                                      fontSize: 20,
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
                    SizedBox(height: 20),
                    // Body
                    Expanded(
                      child: DraggableScrollableSheet(
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
                                BoxShadow(color: Colors.black26, blurRadius: 8),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    16,
                                    16,
                                    16,
                                  ),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Your Tasks',
                                            style: GoogleFont.ibmPlexSans(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          SizedBox(width: 195),
                                          Image.asset(
                                            AppImages.moreSimage2,
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 4,
                                        child: InkWell(
                                          onTap:
                                              () => Switchprofileorlogout(
                                                context,
                                              ),
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

                                // Subject chips (from controller)
                                Obx(() {
                                  // Reactive read — this makes Obx rebuild correctly
                                  final tasks = taskController.tasks;

                                  // Build unique subjects safely
                                  final set = <String>{};
                                  for (final t in tasks) {
                                    final s = t.subject.trim();
                                    if (s.isNotEmpty) set.add(s);
                                  }
                                  final subjects = [
                                    'All',
                                    ...set.toList()..sort(),
                                  ];

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      children:
                                          subjects.map((subject) {
                                            final isSelected =
                                                selectedSubject
                                                    .toLowerCase()
                                                    .trim() ==
                                                subject.toLowerCase().trim();
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
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
                                                onPressed:
                                                    () => setState(
                                                      () =>
                                                          selectedSubject =
                                                              subject,
                                                    ),
                                                child: Text(
                                                  subject,
                                                  style: GoogleFont.ibmPlexSans(
                                                    color:
                                                        isSelected
                                                            ? AppColor.black
                                                            : AppColor.grey,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  );
                                }),

                                const SizedBox(height: 8),

                                // Task list
                                Expanded(
                                  child: Obx(() {
                                    if (taskController.isLoading.value) {
                                      return Center(
                                        child: AppLoader.circularLoader(
                                          AppColor.black,
                                        ),
                                      );
                                    }

                                    const colors = <Color>[
                                      AppColor.lowLightBlue,
                                      AppColor.lowLightYellow,
                                      AppColor.lowLightNavi,
                                      AppColor.white,
                                      AppColor.lowLightPink,
                                    ];

                                    final filtered =
                                        taskController.tasks.where((t) {
                                          final subjectOk =
                                              selectedSubject == 'All' ||
                                              t.subject.trim().toLowerCase() ==
                                                  selectedSubject
                                                      .trim()
                                                      .toLowerCase();
                                          final dateOk = _isSameDay(
                                            t.date,
                                            selectedDate,
                                          );
                                          return subjectOk && dateOk;
                                        }).toList();

                                    if (filtered.isEmpty) {
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
                                            filtered.asMap().entries.map((
                                              entry,
                                            ) {
                                              final index = entry.key;
                                              final task = entry.value;
                                              final bgColor =
                                                  colors[index % colors.length];

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                      12,
                                                      10,
                                                      12,
                                                      0,
                                                    ),
                                                child: GestureDetector(
                                                  onTap:
                                                      () => _openTask(
                                                        context,
                                                        task,
                                                      ),
                                                  child: CustomContainer.taskScreen(
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
                                                          task.time
                                                              .toIso8601String(),
                                                          showDate: false,
                                                          showTime: true,
                                                        ),
                                                    aText1: 'By ',
                                                    aText2: task.assignedByName,
                                                    backRoundColor: bgColor,
                                                    gradient:
                                                        const LinearGradient(
                                                          colors: [
                                                            AppColor.black,
                                                            AppColor.black,
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end:
                                                              Alignment
                                                                  .bottomRight,
                                                        ),
                                                    onIconTap:
                                                        () => _openTask(
                                                          context,
                                                          task,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          );
                        },
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
}*/

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:intl/intl.dart' show DateFormat;
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/app_loader.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
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
                          final tasksForDate =
                              taskController.tasks.where((task) {
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
                              decoration:
                                  isSelected
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
                                      color:
                                          isSelected
                                              ? Colors.blue
                                              : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    item['date'].toString(),
                                    style: GoogleFont.ibmPlexSans(
                                      color:
                                          isSelected
                                              ? Colors.blue
                                              : Colors.white,
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

                                              return RefreshIndicator(
                                                onRefresh: () async {
                                                  await taskController
                                                      .getTaskDetails(); // call your reload API
                                                },
                                                child: SingleChildScrollView(
                                                  controller: _scrollController,
                                                  physics:
                                                      const AlwaysScrollableScrollPhysics(),
                                                  child: Column(
                                                    children:
                                                        filteredTasks.asMap().entries.map<
                                                          Widget
                                                        >((entry) {
                                                          final index =
                                                              entry.key;
                                                          final task =
                                                              entry.value;
                                                          final bgColor =
                                                              colors[index %
                                                                  colors
                                                                      .length];

                                                          return CustomContainer.taskScreen(
                                                            homeWorkImage:
                                                                task.type ==
                                                                        'Quiz'
                                                                    ? AppImages
                                                                        .taskScreenCont1
                                                                    : null,
                                                            mainText:
                                                                task.title,
                                                            subText:
                                                                task.description,
                                                            homeWorkText:
                                                                task.subject,
                                                            avatarImage:
                                                                AppImages
                                                                    .avatar1, // provide avatar if needed
                                                            smaleText:
                                                                task.type,
                                                            time: DateAndTimeConvert.formatDateTime(
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
                                                                    Colors
                                                                        .black,
                                                                    Colors
                                                                        .black,
                                                                  ],
                                                                ),
                                                            onIconTap: () {
                                                              AppLogger.log.i(
                                                                task.id,
                                                              );
                                                              AppLogger.log.i(
                                                                task.type,
                                                              );
                                                              if (task.type ==
                                                                  'Quiz') {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (
                                                                          context,
                                                                        ) => QuizScreen(
                                                                          quizId:
                                                                              task.id,
                                                                        ),
                                                                  ),
                                                                );
                                                              } else {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (
                                                                          context,
                                                                        ) => TaskDetail(
                                                                          id:
                                                                              task.id,
                                                                        ),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          );
                                                        }).toList(),
                                                  ),
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
