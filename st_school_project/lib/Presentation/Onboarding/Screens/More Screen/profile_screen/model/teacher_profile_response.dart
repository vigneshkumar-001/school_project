class TeacherListResponse {
  final bool status;
  final int code;
  final String message;
  final TeachersStudentData? data;

  TeacherListResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory TeacherListResponse.fromJson(Map<String, dynamic> json) {
    return TeacherListResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data:
          json['data'] != null
              ? TeachersStudentData.fromJson(json['data'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "code": code,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class TeachersStudentData {
  final String studentName;
  final String studentClass;
  final String student_phone;
  final String school_contact;
  final String student_image;
  final String? student_email;
  final String section;
  final List<Teacher> teachers;

  TeachersStudentData({
    required this.studentName,
    required this.student_image,
    this.student_email,
    required this.studentClass,
    required this.section,
    required this.teachers,
    required this.school_contact,
    required this.student_phone,
  });

  factory TeachersStudentData.fromJson(Map<String, dynamic> json) {
    return TeachersStudentData(
      studentName: json['student_name'] ?? '',
      studentClass: json['class'] ?? '',
      student_image: json['student_image'] ?? '',
      student_email: json['student_email'] ?? '',
      student_phone: json['student_phone'] ?? '',
      school_contact: json['school_contact'] ?? '',
      section: json['section'] ?? '',
      teachers:
          (json['teachers'] as List<dynamic>? ?? [])
              .map((e) => Teacher.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "student_name": studentName,
      "class": studentClass,
      "student_email": student_email,
      "section": section,
      "student_image": student_image,
      "teachers": teachers.map((e) => e.toJson()).toList(),
    };
  }
}

class Teacher {
  final String subject;
  final String teacherName;
  final String teacherImage;
  final bool classTeacher;

  Teacher({
    required this.subject,
    required this.teacherName,
    required this.teacherImage,
    required this.classTeacher,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      subject: json['subject'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      teacherImage: json['teacher_image'] ?? '',
      classTeacher: json['class_teacher'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "subject": subject,
      "teacher_name": teacherName,
      "teacher_image": teacherImage,
      "class_teacher": classTeacher,
    };
  }
}
