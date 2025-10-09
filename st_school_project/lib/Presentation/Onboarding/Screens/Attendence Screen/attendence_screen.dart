import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:intl/intl.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';

import 'package:table_calendar/table_calendar.dart';

import '../../../../Core/Utility/google_font.dart' show GoogleFont;
import '../../../../Core/Widgets/attendance_card.dart';
import '../../../../Core/Widgets/progress_bar.dart';

import 'package:get/get.dart';

import 'controller/attendance_controller.dart';
import 'model/attendance_response.dart';

class AttendenceScreen extends StatefulWidget {
  const AttendenceScreen({super.key});

  @override
  State<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends State<AttendenceScreen> {
  DateTime today = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final AttendanceController controller = Get.put(AttendanceController());
  AttendanceData? attendanceData;

  AttendanceByDate? getDayAttendance(DateTime day) {
    final formatted = DateFormat('yyyy-MM-dd').format(day);
    return controller.attendanceData.value?.attendanceByDate[formatted];
  }

  DateTime? _selectedDay;
  Color? getAttendanceColor(
    DateTime day,
    Map<String, AttendanceByDate> attendanceByDate,
  ) {
    String formatted = DateFormat('yyyy-MM-dd').format(day);
    if (!attendanceByDate.containsKey(formatted)) return null;

    final dayData = attendanceByDate[formatted]!;

    if (dayData.fullDayAbsent) {
      return AppColor.red01G1;
    } else if (dayData.holidayStatus) {
      return AppColor.green01G3; // Holiday color
    } else if (dayData.eventsStatus) {
      return AppColor.yellow;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.presentOrAbsent(
        year: today.year,
        month: today.month,
        showLoader: false,
      );
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
      backgroundColor: AppColor.white,
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
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final attendance =
                            controller.attendanceData.value?.attendanceByDate ??
                            {};

                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: TableCalendar(
                                focusedDay: _focusedDay, // ✅ FIXED
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
                                  headerPadding: const EdgeInsets.only(
                                    bottom: 25,
                                  ),
                                ),
                                availableGestures: AvailableGestures.all,
                                selectedDayPredicate:
                                    (day) => isSameDay(day, today),
                                onPageChanged: (focusedDay) {
                                  setState(() {
                                    _focusedDay = focusedDay; // ✅ updated
                                  });

                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    controller.presentOrAbsent(
                                      year: focusedDay.year,
                                      month: focusedDay.month,
                                    );
                                  });
                                },

                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    today = selectedDay;
                                  });
                                  getDayAttendance(selectedDay);
                                },
                                startingDayOfWeek: StartingDayOfWeek.monday,
                                firstDay: DateTime.utc(2000),
                                lastDay: DateTime.utc(2050),
                                // onDaySelected: _onDaySelected,
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
                                  selectedDecoration: const BoxDecoration(
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
                                calendarBuilders: CalendarBuilders(
                                  markerBuilder: (context, day, events) {
                                    final color = getAttendanceColor(
                                      day,
                                      attendance,
                                    );
                                    if (color != null) {
                                      return Positioned(
                                        bottom: 4,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                  defaultBuilder: (context, day, focusedDay) {
                                    return Center(
                                      child: Text(
                                        '${day.day}',
                                        style: GoogleFont.ibmPlexSans(
                                          color: AppColor.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
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
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 60,
                              ),
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
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 15,
                                            color: AppColor.yellow,
                                          ),
                                          const SizedBox(width: 5),
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
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 15,
                                            color: AppColor.greenG4,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            'Holiday',
                                            style: GoogleFont.ibmPlexSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: AppColor.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 15,
                                            color: AppColor.lightRed,
                                          ),
                                          const SizedBox(width: 5),
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
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
                final selected = _selectedDay ?? today;
                final dayAttendance = getDayAttendance(selected);

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
                            DateFormat('dd MMM yyyy').format(selected),
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
                                      CurvedAttendanceCard(
                                        imagePath: AppImages.Morning1,
                                        isAbsent:
                                            dayAttendance?.morning == 'present',
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
                                      CurvedAttendanceCard(
                                        imagePath: AppImages.Afternoon1,
                                        isAbsent:
                                            dayAttendance?.afternoon ==
                                            "present",
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
                          if (dayAttendance?.eventsStatus == true) ...[
                            const SizedBox(height: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 200,
                                    child:
                                        ((dayAttendance!.eventImage ?? '')
                                                .isNotEmpty)
                                            ? Image.network(
                                              dayAttendance.eventImage!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (_, __, ___) => Container(
                                                    color: Colors.grey[300],
                                                    alignment: Alignment.center,
                                                    child: const Icon(
                                                      Icons.broken_image,
                                                    ),
                                                  ),
                                            )
                                            : Container(
                                              color: Colors.grey[300],
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.image_not_supported,
                                              ),
                                            ),
                                  ),

                                  // gradient + title
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 18,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.1),
                                              Colors.black,
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                (dayAttendance.eventTitle
                                                            ?.trim()
                                                            .isNotEmpty ??
                                                        false)
                                                    ? dayAttendance.eventTitle!
                                                    : 'Event',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColor.white,
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
                          SizedBox(height: 25),
                          Row(
                            children: [
                              Obx(
                                () => Expanded(
                                  child: Text(
                                    '${controller.attendanceData.value?.monthName.toString() ?? ''} Overall Attendance',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.lightBlack,
                                    ),
                                  ),
                                ),
                              ),

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
                          Obx(
                            () => GradientProgressBar(
                              progress:
                                  (controller
                                          .attendanceData
                                          .value
                                          ?.presentPercentage ??
                                      0) /
                                  100,
                            ),
                          ),

                          /*        Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                height: 30,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColor.grayop,
                                      AppColor.lightWhite.withOpacity(0.2),
                                      AppColor.lightWhite.withOpacity(0.2),
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
                                  width: 12,
                                  height: 24,
                                  decoration: BoxDecoration(
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
                          ),*/
                          const SizedBox(height: 12),
                          Obx(
                            () => Text(
                              "${controller.attendanceData.value?.fullDayPresentCount ?? 0} Out of ${controller.attendanceData.value?.totalWorkingDays ?? 0}",
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.grayop,
                              ),
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
