import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/task_detail.dart'
    show TaskDetail;

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  int selectedIndex = 3;

  final List<Map<String, dynamic>> dates = [
    {"day": "Wed", "date": 11},
    {"day": "Thu", "date": 12},
    {"day": "Fri", "date": 13},
    {"day": "Sat", "date": 14},
    {"day": "Sun", "date": 15},
    {"day": "Mon", "date": 16},
    {"day": "Tue", "date": 17},
  ];
  int index = 0;

  String selectedSubject = 'All';

  final List<String> subjects = [
    'All',
    'Science',
    'English',
    'Social Science',
    'Maths',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2880E5),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: [AppColor.blueG1, AppColor.blueG2],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(child: Image.asset(AppImages.jbg)),
              Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text(
                          "July",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(dates.length, (index) {
                        final item = dates[index];
                        final isSelected = index == selectedIndex;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    item['day'],
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.blue
                                              : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: Text(
                                    item['date'].toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isSelected
                                              ? Colors.blue
                                              : Colors.white,
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
                  SizedBox(height: 30),
                  Expanded(
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.99,
                      minChildSize: 0.90,
                      maxChildSize: 0.99,
                      builder: (context, scrollController) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 35),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 8),
                            ],
                          ),
                          child: SingleChildScrollView(
                            controller: scrollController,
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
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
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
                                                    MaterialStatePropertyAll(0),
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
                                                style: TextStyle(
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
                                ),
                                SizedBox(height: 20),
                                CustomContainer.taskScreen(
                                  homeWorkText: 'Science Homework',
                                  avatarImage: AppImages.avatar1,
                                  mainText: 'Draw Single cell',
                                  smaleText:
                                      'Lorem ipsum dolor sit amet, co...',
                                  time: '4.30Pm',
                                  aText1: 'By ',
                                  aText2: 'Floran',
                                  backRoundColor: AppColor.lowLightBlue,
                                  gradient: LinearGradient(
                                    colors: [AppColor.black, AppColor.black],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  onIconTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskDetail(),
                                      ),
                                    );
                                  },
                                ),

                                CustomContainer.taskScreen(
                                  homeWorkText: 'Maths Homework',
                                  avatarImage: AppImages.avatar2,
                                  mainText: 'Draw Single cell',
                                  smaleText:
                                      'Lorem ipsum dolor sit amet, co...',
                                  time: '4.30Pm',
                                  aText1: 'By ',
                                  aText2: 'Floran',
                                  backRoundColor: AppColor.lowLightYellow,
                                  gradient: LinearGradient(
                                    colors: [AppColor.black, AppColor.black],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),

                                CustomContainer.taskScreen(
                                  homeWorkText: 'English Homework',
                                  avatarImage: AppImages.avatar3,
                                  mainText: 'Draw Single cell',
                                  smaleText:
                                      'Lorem ipsum dolor sit amet, co...',
                                  time: '4.30Pm',
                                  aText1: 'By ',
                                  aText2: 'Floran',
                                  backRoundColor: AppColor.lowLightNavi,
                                  gradient: LinearGradient(
                                    colors: [AppColor.black, AppColor.black],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),

                                CustomContainer.taskScreen(
                                  homeWorkText: 'Social Science Homework',
                                  avatarImage: AppImages.avatar4,
                                  mainText: 'Draw Single cell',
                                  smaleText:
                                      'Lorem ipsum dolor sit amet, co...',
                                  time: '4.30Pm',
                                  aText1: 'By ',
                                  aText2: 'Floran',
                                  backRoundColor: AppColor.lowLightPink,
                                  gradient: LinearGradient(
                                    colors: [AppColor.black, AppColor.black],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),

                                CustomContainer.taskScreen(
                                  homeWorkText: 'Science Homework',
                                  avatarImage: AppImages.avatar1,
                                  mainText: 'Draw Single cell',
                                  smaleText:
                                      'Lorem ipsum dolor sit amet, co...',
                                  time: '4.30Pm',
                                  aText1: 'By ',
                                  aText2: 'Floran',
                                  backRoundColor: AppColor.white,
                                  gradient: LinearGradient(
                                    colors: [AppColor.blueG1, AppColor.blueG2],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}
