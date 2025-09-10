class ExamResultResponse {
  final bool status;
  final int code;
  final String message;
  final ExamResultData data;

  ExamResultResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ExamResultResponse.fromJson(Map<String, dynamic> json) {
    return ExamResultResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: ExamResultData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "code": code,
      "message": message,
      "data": data.toJson(),
    };
  }
}

class ExamResultData {
  final Exam exam;
  final Student student;
  final List<Subject> subjects;
  final Totals? totals; // 👈 nullable

  ExamResultData({
    required this.exam,
    required this.student,
    required this.subjects,
    this.totals,
  });

  factory ExamResultData.fromJson(Map<String, dynamic> json) {
    return ExamResultData(
      exam: Exam.fromJson(json['exam']),
      student: Student.fromJson(json['student']),
      subjects: (json['subjects'] as List)
          .map((e) => Subject.fromJson(e))
          .toList(),
      totals: json['totals'] == null
          ? null
          : Totals.fromJson(json['totals']), // 👈 check for null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "exam": exam.toJson(),
      "student": student.toJson(),
      "subjects": subjects.map((e) => e.toJson()).toList(),
      "totals": totals?.toJson(), // 👈 safe access
    };
  }
}


class Exam {
  final int id;
  final String heading;
  final String className;
  final String section;
  final String startDate;
  final String endDate;
  final String? resultDate;
  final bool isPublished;

  Exam({
    required this.id,
    required this.heading,
    required this.className,
    required this.section,
    required this.startDate,
    required this.endDate,
    this.resultDate,
    required this.isPublished,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] ?? 0,
      heading: json['heading'] ?? '',
      className: json['className'] ?? '',
      section: json['section'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      resultDate: json['resultDate'],
      isPublished: json['isPublished'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "heading": heading,
      "className": className,
      "section": section,
      "startDate": startDate,
      "endDate": endDate,
      "resultDate": resultDate,
      "isPublished": isPublished,
    };
  }
}

class Student {
  final int id;
  final String name;
  final String admissionNo;

  Student({required this.id, required this.name, required this.admissionNo});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      admissionNo: json['admissionNo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "admissionNo": admissionNo};
  }
}

class Subject {
  final int subjectId;
  final String subjectName;
  final int maxMarks;
  final int? obtainedMarks;   // 👈 nullable
  final double? percentage;   // 👈 nullable
  final String? grade;        // 👈 nullable

  Subject({
    required this.subjectId,
    required this.subjectName,
    required this.maxMarks,
    this.obtainedMarks,
    this.percentage,
    this.grade,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subjectId: json['subjectId'] ?? 0,
      subjectName: json['subjectName'] ?? '',
      maxMarks: json['maxMarks'] ?? 0,
      obtainedMarks: json['obtainedMarks'], // can be null
      percentage: json['percentage'] == null
          ? null
          : (json['percentage'] as num).toDouble(),
      grade: json['grade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "subjectId": subjectId,
      "subjectName": subjectName,
      "maxMarks": maxMarks,
      "obtainedMarks": obtainedMarks,
      "percentage": percentage,
      "grade": grade,
    };
  }
}


class Totals {
  final int? totalObtained;
  final int? totalMax;
  final double? percentage;
  final String? grade;
  final bool? complete;
  final int? classRank;
  final int? classStrength;

  Totals({
    this.totalObtained,
    this.totalMax,
    this.percentage,
    this.grade,
    this.complete,
    this.classRank,
    this.classStrength,
  });

  factory Totals.fromJson(Map<String, dynamic> json) {
    return Totals(
      totalObtained: json['totalObtained'],
      totalMax: json['totalMax'],
      percentage: json['percentage'] == null
          ? null
          : (json['percentage'] as num).toDouble(),
      grade: json['grade'],
      complete: json['complete'],
      classRank: json['classRank'],
      classStrength: json['classStrength'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalObtained": totalObtained,
      "totalMax": totalMax,
      "percentage": percentage,
      "grade": grade,
      "complete": complete,
      "classRank": classRank,
      "classStrength": classStrength,
    };
  }
}
