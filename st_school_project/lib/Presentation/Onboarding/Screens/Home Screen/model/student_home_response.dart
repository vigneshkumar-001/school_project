class StudentHomeResponse {
  bool status;
  int code;
  String message;
  StudentHomeData data;

  StudentHomeResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory StudentHomeResponse.fromJson(Map<String, dynamic> json) {
    return StudentHomeResponse(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: StudentHomeData.fromJson(json['data']),
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
  String name;
  String className;
  String section;
  Attendance attendance;
  List<Announcement> announcements;
  List<Task> tasks;

  StudentHomeData({
    required this.name,
    required this.className,
    required this.section,
    required this.attendance,
    required this.announcements,
    required this.tasks,
  });

  factory StudentHomeData.fromJson(Map<String, dynamic> json) {
    return StudentHomeData(
      name: json['name'],
      className: json['class'],
      section: json['section'],
      attendance: Attendance.fromJson(json['attendance']),
      announcements:
          (json['announcements'] as List)
              .map((e) => Announcement.fromJson(e))
              .toList(),
      tasks: (json['tasks'] as List).map((e) => Task.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'class': className,
    'section': section,
    'attendance': attendance.toJson(),
    'announcements': announcements.map((e) => e.toJson()).toList(),
    'tasks': tasks.map((e) => e.toJson()).toList(),
  };
}

class Attendance {
  bool morning;
  bool afternoon;

  Attendance({required this.morning, required this.afternoon});

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(morning: json['morning'], afternoon: json['afternoon']);
  }

  Map<String, dynamic> toJson() => {'morning': morning, 'afternoon': afternoon};
}

class Announcement {
  bool? newAdmissionStatus;
  bool? admissionStatus;
  bool? examStatus;
  bool? noticeBoardStatus;
  bool? termFeesStatus;
  String message;
  String submessage;

  Announcement({
    this.newAdmissionStatus,
    this.admissionStatus,
    this.examStatus,
    this.noticeBoardStatus,
    this.termFeesStatus,
    required this.message,
    required this.submessage,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      newAdmissionStatus: json['new_addmission_status'],
      admissionStatus: json['addmission_status'],
      examStatus: json['exam_status'],
      noticeBoardStatus: json['notice_board_status'],
      termFeesStatus: json['term_fees_status'],
      message: json['message'],
      submessage: json['submessage'],
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
  int id;
  String title;
  String description;
  DateTime date;
  DateTime time;
  String assignedByName;
  String subject;
  int subjectId;
  String type;

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
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      time: DateTime.parse(json['time']),
      assignedByName: json['assigned_by_name'],
      subject: json['subject'],
      subjectId: json['subject_id'],
      type: json['type'],
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
  };
}
