import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../Core/Utility/google_font.dart' show GoogleFont;

class AttendenceScreen extends StatefulWidget {
  const AttendenceScreen({super.key});

  @override
  State<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends State<AttendenceScreen> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  int current = 15;
  int total = 20;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetProgress = current / total;
    final progressWidth = screenWidth * targetProgress;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColor.drakeBlueG1, AppColor.drakeBlueG2],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Column(
                          children: [
                            Opacity(
                              opacity: 0.2,
                              child: Image.asset(AppImages.jbg),
                            ),
                            Opacity(
                              opacity: 0.2,
                              child: Image.asset(AppImages.jbg),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              child: TableCalendar(
                                focusedDay: today,
                                headerStyle: HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                  titleTextStyle: GoogleFont.ibmPlexSans(
                                    color: AppColor.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  leftChevronIcon: Icon(
                                    CupertinoIcons.left_chevron,
                                    size: 24,
                                    color: AppColor.white,
                                  ),
                                  rightChevronIcon: Icon(
                                    CupertinoIcons.right_chevron,
                                    size: 24,
                                    color: AppColor.white,
                                  ),
                                  headerPadding: EdgeInsets.only(bottom: 25),
                                ),
                                availableGestures: AvailableGestures.all,
                                selectedDayPredicate:
                                    (day) => isSameDay(day, today),
                                startingDayOfWeek: StartingDayOfWeek.monday,
                                firstDay: DateTime.utc(2000),
                                lastDay: DateTime.utc(2050),
                                onDaySelected: _onDaySelected,
                                calendarStyle: CalendarStyle(
                                  todayDecoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColor.blueG1,
                                        AppColor.blueG2,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  selectedDecoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  weekendTextStyle: GoogleFont.ibmPlexSans(
                                    color: AppColor.grey,
                                    letterSpacing: 1.2,
                                  ),
                                  weekNumberTextStyle: GoogleFont.ibmPlexSans(
                                    color: AppColor.white,
                                  ),
                                  defaultTextStyle: GoogleFont.ibmPlexSans(
                                    color: AppColor.white,
                                  ),
                                ),
                                daysOfWeekStyle: DaysOfWeekStyle(
                                  weekdayStyle: GoogleFont.ibmPlexSans(
                                    color: AppColor.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 1.2,
                                  ),
                                  weekendStyle: GoogleFont.ibmPlexSans(
                                    color: AppColor.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 15,
                                            color: AppColor.yellow,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'Event',
                                            style: GoogleFont.ibmPlexSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: AppColor.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 15,
                                            color: AppColor.greenG4,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'Holidays',
                                            style: GoogleFont.ibmPlexSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: AppColor.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 15,
                                            color: AppColor.lightRed,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'Absent',
                                            style: GoogleFont.ibmPlexSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: AppColor.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.40,
              minChildSize: 0.40,
              maxChildSize: 0.99,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 30,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Today',
                            style: GoogleFont.ibmPlexSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 26,
                              color: AppColor.lightBlack,
                            ),
                          ),
                          SizedBox(height: 25),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: AppColor.lightGrey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        AppImages.amorning1,
                                        height: 55,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Morning',
                                        style: GoogleFont.ibmPlexSans(
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.lightBlack,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(7, (index) {
                                      return Container(
                                        width: 2,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColor.lightGrey.withOpacity(
                                                0.2,
                                              ),
                                              AppColor.black.withOpacity(0.2),
                                            ], // gradient top to bottom
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        AppImages.aafternoon2,
                                        height: 55,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Afternoon',
                                        style: GoogleFont.ibmPlexSans(
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.lightBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Stack(
                            children: [
                              Image.asset(AppImages.attendence1),
                              Positioned(
                                bottom: 0,

                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColor.black.withOpacity(0.1),
                                        AppColor.black,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(22),
                                      bottomRight: Radius.circular(22),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 34,
                                      vertical: 25,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Sports Day',
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.white,
                                          ),
                                        ),
                                        SizedBox(width: 124),
                                        Icon(
                                          CupertinoIcons.clock_fill,
                                          size: 20,
                                          color: AppColor.white,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '3Pm',
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 12,
                                            color: AppColor.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          'to',
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 12,
                                            color: AppColor.white,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          '5Pm',
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 12,
                                            color: AppColor.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          Row(
                            children: [
                              Text(
                                'July ',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.lightBlack,
                                ),
                              ),
                              Text(
                                'Overall ',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.lightBlack,
                                ),
                              ),
                              Text(
                                'Attendance',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.lightBlack,
                                ),
                              ),
                              SizedBox(width: 85),
                              Text(
                                'Average',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.orange,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),

                          Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                height: 30,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColor.grayop,
                                      AppColor.lightWhite,
                                      AppColor.lightWhite,
                                      AppColor.grayop,
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 9,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                height: 30,
                                width: progressWidth,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColor.red01G1,
                                      AppColor.orange01G2,
                                      AppColor.green01G3,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),

                              Positioned(
                                left: progressWidth - 25,
                                top: 3,
                                child: Container(
                                  width: 15,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: AppColor.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Text(
                            "$current Out of $total",
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor.grayop,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
