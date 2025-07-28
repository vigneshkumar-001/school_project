import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:intl/intl.dart' show DateFormat;
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Task%20Screen/task_detail.dart';

import '../../../../Core/Utility/google_font.dart' show GoogleFont;
import '../More Screen/quiz_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  final List<String> months = List.generate(
    12,
    (index) => DateFormat.MMMM().format(DateTime(0, index + 6)),
  );

  List<Map<String, dynamic>> getFullMonthDates(DateTime currentMonth) {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);

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

  int index = 0;
  String selectedSubject = 'All';

  final List<String> subjects = [
    'All',
    'Quiz',
    'Science',
    'English',
    'Social Science',
    'Maths',
  ];

  final List<Map<String, dynamic>> allTasks = [
    {
      'subject': 'Quiz',
      'homeWorkText': 'Quiz',
      'homeWorkImage': AppImages.taskScreenCont1,
      'avatar': AppImages.avatar1,
      'mainText': 'Mathematics Quiz',
      'subText': 'Waiting for you',
      'smaleText': 'Lorem ipsum dolor sit amet, co...',
      'time': '4.30Pm',
      'bgColor': AppColor.taskScrnCont1,
      'gradient': LinearGradient(
        colors: [AppColor.black, AppColor.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'screen': QuizScreen(),
    },
    {
      'subject': 'Science',
      'homeWorkText': 'Science Homework',
      'avatar': AppImages.avatar1,
      'mainText': 'Draw Single cell',
      'smaleText': 'Lorem ipsum dolor sit amet, co...',
      'time': '4.30Pm',
      'bgColor': AppColor.lowLightBlue,
      'gradient': LinearGradient(
        colors: [AppColor.black, AppColor.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'screen': TaskDetail(),
    },
    {
      'subject': 'Maths',
      'homeWorkText': 'Maths Homework',
      'avatar': AppImages.avatar2,
      'mainText': 'Draw triangle',
      'smaleText': 'Lorem ipsum dolor sit amet, co...',
      'time': '3.00Pm',
      'bgColor': AppColor.lowLightYellow,
      'gradient': LinearGradient(
        colors: [AppColor.black, AppColor.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'subject': 'English',
      'homeWorkText': 'English Homework',
      'avatar': AppImages.avatar3,
      'mainText': 'Write an essay',
      'smaleText': 'Lorem ipsum dolor sit amet...',
      'time': '1.30Pm',
      'bgColor': AppColor.lowLightNavi,
      'gradient': LinearGradient(
        colors: [AppColor.black, AppColor.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'subject': 'Social Science',
      'homeWorkText': 'Social Science Homework',
      'avatar': AppImages.avatar4,
      'mainText': 'Map work',
      'smaleText': 'Lorem ipsum dolor sit amet...',
      'time': '2.30Pm',
      'bgColor': AppColor.lowLightPink,
      'gradient': LinearGradient(
        colors: [AppColor.black, AppColor.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'subject': 'Science',
      'homeWorkText': 'Science Homework',
      'avatar': AppImages.avatar1,
      'mainText': 'Label Plant Cell',
      'smaleText': 'Lorem ipsum dolor sit amet...',
      'time': '5.30Pm',
      'bgColor': AppColor.white,
      'gradient': LinearGradient(
        colors: [AppColor.blueG1, AppColor.blueG2],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                                  DateFormat.MMMM().format(currentMonth),
                                  style: GoogleFont.ibmPlexSans(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
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
                                      child: Text(
                                        'Your Tasks',
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SingleChildScrollView(
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
}
