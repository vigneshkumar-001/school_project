class AttendanceResponse {
  final bool status;
  final String message;
  final AttendanceData? data;

  AttendanceResponse({required this.status, required this.message, this.data});

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AttendanceData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data?.toJson()};
  }
}

class AttendanceData {
  final int studentId;
  final String studentName;
  final String studentClass;
  final String section;
  final int classId;
  final String month;
  final String year;
  final String monthName;
  final int totalWorkingDays;
  final int fullDayPresentCount;
  final double presentPercentage;
  final Map<String, AttendanceByDate> attendanceByDate;

  AttendanceData({
    required this.studentId,
    required this.studentName,
    required this.studentClass,
    required this.section,
    required this.classId,
    required this.month,
    required this.year,
    required this.monthName,
    required this.totalWorkingDays,
    required this.fullDayPresentCount,
    required this.presentPercentage,
    required this.attendanceByDate,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    final attendanceMap = <String, AttendanceByDate>{};
    if (json['attendance_by_date'] != null) {
      json['attendance_by_date'].forEach((key, value) {
        attendanceMap[key] = AttendanceByDate.fromJson(value);
      });
    }

    return AttendanceData(
      studentId: json['student_id'] ?? 0,
      studentName: json['student_name'] ?? '',
      studentClass: json['class'] ?? '',
      section: json['section'] ?? '',
      classId: json['class_id'] ?? 0,
      month: json['month']?.toString() ?? '',
      year: json['year']?.toString() ?? '',
      monthName: json['monthName'] ?? '',
      totalWorkingDays: json['totalWorkingDays'] ?? 0,
      fullDayPresentCount: json['fullDayPresentCount'] ?? 0,
      presentPercentage: (json['present_percentage'] ?? 0).toDouble(),
      attendanceByDate: attendanceMap,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['student_id'] = studentId;
    map['student_name'] = studentName;
    map['class'] = studentClass;
    map['section'] = section;
    map['class_id'] = classId;
    map['month'] = month;
    map['year'] = year;
    map['monthName'] = monthName;
    map['totalWorkingDays'] = totalWorkingDays;
    map['fullDayPresentCount'] = fullDayPresentCount;
    map['present_percentage'] = presentPercentage;
    map['attendance_by_date'] = attendanceByDate.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    return map;
  }
}

class AttendanceByDate {
  final String morning;
  final String afternoon;
  final bool fullDayAbsent;
  final bool holidayStatus;
  final bool eventsStatus;
  String? eventTitle;
  String? eventImage;

  AttendanceByDate({
    required this.morning,
    required this.afternoon,
    required this.fullDayAbsent,
    required this.holidayStatus,
    required this.eventsStatus,
    this.eventImage,
    this.eventTitle,
  });

  factory AttendanceByDate.fromJson(Map<String, dynamic> json) {
    return AttendanceByDate(
      morning: json['morning'] ?? '',
      afternoon: json['afternoon'] ?? '',
      fullDayAbsent: json['full_day_absent'] ?? false,
      holidayStatus: json['holiday_status'] ?? false,
      eventsStatus: json['events_status'] ?? false,
      eventTitle: json['event_title'] as String?,
      eventImage: json['event_image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'morning': morning,
      'afternoon': afternoon,
      'full_day_absent': fullDayAbsent,
      'holiday_status': holidayStatus,
      'events_status': eventsStatus,
      'event_title': eventTitle,
      'event_image': eventImage,
    };
  }
}
