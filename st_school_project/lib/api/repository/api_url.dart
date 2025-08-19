class ApiUrl {
  static String baseUrl = 'https://school-back-end-594f59bea6cb.herokuapp.com';
  static String imageUrl = "https://next.fenizotechnologies.com/Adrox/api/image-save";
  static String login = '$baseUrl/student-auth/login';
  static String verifyOtp = '$baseUrl/student-auth/verify-otp';
  static String studentHome = '$baseUrl/student-home';
  static String profiles = '$baseUrl/student-home/profiles';
  static String classList = '$baseUrl/teacher-student-attendance/class-list';
  static String teacherInfo = '$baseUrl/student-teacher-info';
  static String profileImage = '$baseUrl/student-home/profiles/profile-image-url';
  static String task = '$baseUrl/student-home/tasks?';
  static String attendance =
      '$baseUrl/teacher-student-attendance/mark-attendance';

  static String studentAttendance({required int classId}) {
    return '$baseUrl/teacher-student-attendance/today-status/?class_id=$classId';
  }

  static String attendanceByDate({
    required int classId,
    required String formattedDate,
  }) {
    return '$baseUrl/teacher-student-attendance/attendance-by-date?class_id=$classId&date=$formattedDate';
  }

  static String getHomeWorkIdDetails({required int id}) {
    return '$baseUrl/student-home/homework/$id';
  }

  static String switchSiblings({required int id}) {
    return '$baseUrl/student-home/profiles/switch/$id';
  }

  static String getAttendanceMonth({required int month, required int year}) {
    return '$baseUrl/student-home/monthly-attendance-by-student?year=$year&month=$month';
  }
}
