class ApiUrl {
  static String baseUrl = 'https://school-back-end-594f59bea6cb.herokuapp.com';
  static String baseUrl1 = 'https://9kt7pzw3-4000.inc1.devtunnels.ms';

  static String login = '$baseUrl/student-auth/login';
  static String verifyOtp = '$baseUrl/student-auth/verify-otp';
  static String studentHome = '$baseUrl/student-home';
  static String classList = '$baseUrl/teacher-student-attendance/class-list';
  static String task = '$baseUrl/student-home/tasks?';
  static String attendance =
      '$baseUrl/teacher-student-attendance/mark-attendance';
  static String quizSubmit = '$baseUrl/student-quiz/submit';

  static String studentAttendance({required int classId}) {
    return '$baseUrl/teacher-student-attendance/today-status/?class_id=$classId';
  }

  static String attendanceByDate({
    required int classId,
    required String formattedDate,
  }) {
    return '$baseUrl/teacher-student-attendance/attendance-by-date?class_id=$classId&date=$formattedDate';
  }

  static String QuizAttend({required int quizId}) {
    return '$baseUrl/student-quiz/take/$quizId';
  }

  static String QuizResult({required int quizId}) {
    return '$baseUrl/student-quiz/result/$quizId';
  }

  static String getHomeWorkIdDetails({required int id}) {
    return '$baseUrl/student-home/homework/$id';
  }
}
