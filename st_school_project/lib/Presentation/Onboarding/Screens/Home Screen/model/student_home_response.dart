class StudentHomeResponse {
  final bool status;
  final int code;
  final String message;
  final StudentHomeData data;

  StudentHomeResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory StudentHomeResponse.fromJson(Map<String, dynamic> json) {
    return StudentHomeResponse(
      status: json['status'] == true,
      code: (json['code'] as int?) ?? 0,
      message: (json['message'] as String?) ?? '',
      data: StudentHomeData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data.toJson(),
  };
}

class StudentHomeData {
  final String name;
  final String className; // API key: "class"
  final String section;
  final Attendance attendance;
  final List<Announcement> announcements;
  final List<Task> tasks;
  final AppVersions? appVersions;

  StudentHomeData({
    required this.name,
    required this.className,
    required this.section,
    required this.attendance,
    required this.announcements,
    required this.tasks,
    required this.appVersions,
  });

  factory StudentHomeData.fromJson(Map<String, dynamic> json) {
    return StudentHomeData(
      name: json['name'] ?? '',
      className: json['class'] ?? '',
      section: json['section'] ?? '',
      attendance: Attendance.fromJson(json['attendance'] ?? {}),
      announcements:
          (json['announcements'] as List? ?? [])
              .map((e) => Announcement.fromJson(e ?? {}))
              .toList(),
      tasks:
          (json['tasks'] as List? ?? [])
              .map((e) => Task.fromJson(e ?? {}))
              .toList(),
      appVersions:
          json['appVersions'] != null
              ? AppVersions.fromJson(json['appVersions'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'class': className,
    'section': section,
    'attendance': attendance.toJson(),
    'announcements': announcements.map((e) => e.toJson()).toList(),
    'tasks': tasks.map((e) => e.toJson()).toList(),
    'appVersions': appVersions?.toJson(),
  };
}

class Attendance {
  final bool morning;
  final bool afternoon;

  Attendance({required this.morning, required this.afternoon});

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      morning: json['morning'] == true,
      afternoon: json['afternoon'] == true,
    );
  }

  Map<String, dynamic> toJson() => {'morning': morning, 'afternoon': afternoon};
}

class Announcement {
  final bool newAdmissionStatus;
  final bool admissionStatus;
  final bool examStatus;
  final bool noticeBoardStatus;
  final bool termFeesStatus;
  final String message;
  final String submessage;

  Announcement({
    this.newAdmissionStatus = false,
    this.admissionStatus = false,
    this.examStatus = false,
    this.noticeBoardStatus = false,
    this.termFeesStatus = false,
    this.message = '',
    this.submessage = '',
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      newAdmissionStatus: json['new_addmission_status'] == true,
      admissionStatus: json['addmission_status'] == true,
      examStatus: json['exam_status'] == true,
      noticeBoardStatus: json['notice_board_status'] == true,
      termFeesStatus: json['term_fees_status'] == true,
      message: json['message'] ?? '',
      submessage: json['submessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'new_addmission_status': newAdmissionStatus,
    'addmission_status': admissionStatus,
    'exam_status': examStatus,
    'notice_board_status': noticeBoardStatus,
    'term_fees_status': termFeesStatus,
    'message': message,
    'submessage': submessage,
  };
}

class Task {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final DateTime time;
  final String assignedByName;
  final String subject;
  final int subjectId;
  final String type;
  final String teacherImage;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.assignedByName,
    required this.subject,
    required this.subjectId,
    required this.type,
    required this.teacherImage,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: _parseDate(json['date']),
      time: _parseDate(json['time']),
      assignedByName: json['assigned_by_name'] ?? '',
      subject: json['subject'] ?? '',
      subjectId: json['subject_id'] ?? 0,
      type: json['type'] ?? '',
      teacherImage: json['teacher_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'date': date.toIso8601String(),
    'time': time.toIso8601String(),
    'assigned_by_name': assignedByName,
    'subject': subject,
    'subject_id': subjectId,
    'type': type,
    'teacher_image': teacherImage,
  };

  static DateTime _parseDate(dynamic v) {
    if (v is String) {
      final dt = DateTime.tryParse(v);
      if (dt != null) return dt;
    }
    return DateTime.now();
  }
}

class AppVersions {
  final AppVersion android;
  final AppVersion ios;

  AppVersions({required this.android, required this.ios});

  factory AppVersions.fromJson(Map<String, dynamic> json) {
    return AppVersions(
      android: AppVersion.fromJson(json['android'] ?? {}),
      ios: AppVersion.fromJson(json['ios'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'android': android.toJson(),
    'ios': ios.toJson(),
  };
}

class AppVersion {
  final String latestVersion;
  final String minVersion;
  final bool forceUpdate;
  final String storeUrl;

  AppVersion({
    required this.latestVersion,
    required this.minVersion,
    required this.forceUpdate,
    required this.storeUrl,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      latestVersion: json['latestVersion'] ?? '',
      minVersion: json['minVersion'] ?? '',
      forceUpdate: json['forceUpdate'] == true,
      storeUrl: json['storeUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'latestVersion': latestVersion,
    'minVersion': minVersion,
    'forceUpdate': forceUpdate,
    'storeUrl': storeUrl,
  };
}

// class StudentHomeResponse {
//   final bool status;
//   final int code;
//   final String message;
//   final StudentHomeData data;
//
//   StudentHomeResponse({
//     required this.status,
//     required this.code,
//     required this.message,
//     required this.data,
//   });
//
//   factory StudentHomeResponse.fromJson(Map<String, dynamic> json) {
//     return StudentHomeResponse(
//       status: json['status'] == true,
//       code: (json['code'] as int?) ?? 0,
//       message: (json['message'] as String?) ?? '',
//       data: StudentHomeData.fromJson((json['data'] as Map<String, dynamic>?) ?? const {}),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'status': status,
//     'code': code,
//     'message': message,
//     'data': data.toJson(),
//   };
// }
//
// class StudentHomeData {
//   final String name;
//   final String className; // API key: "class"
//   final String section;
//   final Attendance attendance;
//   final List<Announcement> announcements;
//   final List<Task> tasks;
//
//   StudentHomeData({
//     required this.name,
//     required this.className,
//     required this.section,
//     required this.attendance,
//     required this.announcements,
//     required this.tasks,
//   });
//
//   factory StudentHomeData.fromJson(Map<String, dynamic> json) {
//     final anns = (json['announcements'] as List?) ?? const [];
//     final tks = (json['tasks'] as List?) ?? const [];
//     return StudentHomeData(
//       name: (json['name'] as String?) ?? '',
//       className: (json['class'] as String?) ?? '',
//       section: (json['section'] as String?) ?? '',
//       attendance: Attendance.fromJson((json['attendance'] as Map<String, dynamic>?) ?? const {}),
//       announcements: anns.map((e) => Announcement.fromJson((e as Map<String, dynamic>?) ?? const {})).toList(),
//       tasks: tks.map((e) => Task.fromJson((e as Map<String, dynamic>?) ?? const {})).toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'name': name,
//     'class': className,
//     'section': section,
//     'attendance': attendance.toJson(),
//     'announcements': announcements.map((e) => e.toJson()).toList(),
//     'tasks': tasks.map((e) => e.toJson()).toList(),
//   };
// }
//
// class Attendance {
//   final bool morning;
//   final bool afternoon;
//
//   Attendance({required this.morning, required this.afternoon});
//
//   factory Attendance.fromJson(Map<String, dynamic> json) {
//     return Attendance(
//       morning: json['morning'] == true,
//       afternoon: json['afternoon'] == true,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {'morning': morning, 'afternoon': afternoon};
// }
//
// class Announcement {
//   // API keys (note the “addmission” spelling)
//   final bool newAdmissionStatus;
//   final bool admissionStatus;
//   final bool examStatus;
//   final bool noticeBoardStatus;
//   final bool termFeesStatus;
//   final String message;
//   final String submessage;
//
//   Announcement({
//     this.newAdmissionStatus = false,
//     this.admissionStatus = false,
//     this.examStatus = false,
//     this.noticeBoardStatus = false,
//     this.termFeesStatus = false,
//     this.message = '',
//     this.submessage = '',
//   });
//
//   factory Announcement.fromJson(Map<String, dynamic> json) {
//     return Announcement(
//       newAdmissionStatus: json['new_addmission_status'] == true,
//       admissionStatus: json['addmission_status'] == true,
//       examStatus: json['exam_status'] == true,
//       noticeBoardStatus: json['notice_board_status'] == true,
//       termFeesStatus: json['term_fees_status'] == true,
//       message: (json['message'] as String?) ?? '',
//       submessage: (json['submessage'] as String?) ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'new_addmission_status': newAdmissionStatus,
//     'addmission_status': admissionStatus,
//     'exam_status': examStatus,
//     'notice_board_status': noticeBoardStatus,
//     'term_fees_status': termFeesStatus,
//     'message': message,
//     'submessage': submessage,
//   };
// }
//
// class Task {
//   final int id;
//   final String title;
//   final String description;     // default ''
//   final DateTime date;          // parsed safely
//   final DateTime time;          // parsed safely
//   final String assignedByName;  // default ''
//   final String subject;         // default ''
//   final int subjectId;          // default 0
//   final String type;            // default ''
//   final String teacher_image;            // default ''
//
//   Task({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.date,
//     required this.time,
//     required this.assignedByName,
//     required this.teacher_image,
//     required this.subject,
//     required this.subjectId,
//     required this.type,
//   });
//
//   factory Task.fromJson(Map<String, dynamic> json) {
//     try {
//       return Task(
//         id: (json['id'] as int?) ?? 0,
//         title: (json['title'] as String?) ?? '',
//         teacher_image: (json['teacher_image'] as String?) ?? '',
//         description: (json['description'] as String?) ?? '',
//         date: _parseDate(json['date']),
//         time: _parseDate(json['time']),
//         assignedByName: (json['assigned_by_name'] as String?) ?? '',
//         subject: (json['subject'] as String?) ?? '',
//         subjectId: (json['subject_id'] as int?) ?? 0,
//         type: (json['type'] as String?) ?? '',
//       );
//     } catch (e, st) {
//       // Helpful debug if a new null/shape appears
//       // ignore: avoid_print
//       print('Task parse error: $e\nJSON: $json\n$st');
//       // Fail soft with a minimal object
//       return Task(
//         id: (json['id'] as int?) ?? 0,
//         title: (json['title'] as String?) ?? '',
//         teacher_image: (json['teacher_image'] as String?) ?? '',
//         description: (json['description'] as String?) ?? '',
//         date: DateTime.now(),
//         time: DateTime.now(),
//         assignedByName: (json['assigned_by_name'] as String?) ?? '',
//         subject: (json['subject'] as String?) ?? '',
//         subjectId: (json['subject_id'] as int?) ?? 0,
//         type: (json['type'] as String?) ?? '',
//       );
//     }
//   }
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'title': title,
//     'description': description,
//     'date': date.toIso8601String(),
//     'time': time.toIso8601String(),
//     'assigned_by_name': assignedByName,
//     'subject': subject,
//     'teacher_image': teacher_image,
//     'subject_id': subjectId,
//     'type': type,
//   };
//
//   static DateTime _parseDate(dynamic v) {
//     if (v is String) {
//       final dt = DateTime.tryParse(v);
//       if (dt != null) return dt;
//     }
//     return DateTime.now();
//   }
// }
