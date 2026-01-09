class ApiUrl {
  static String baseUrl = 'https://school-back-end-594f59bea6cb.herokuapp.com';

  // static String baseUrl = 'https://backend.stjosephmatricschool.com';
  // static String baseUrl = 'http://192.168.29.18:3000';

  // static String baseUrl2 =
  //     'https://school-backend-v2-19bebceab98e.herokuapp.com';

  static String teacherInfo = '$baseUrl/student-teacher-info';
  static String paymentHistory = '$baseUrl/student-payments/history';
  static String login = '$baseUrl/student-auth/login';
  static String logout = '$baseUrl/notifications/students/unregister';
  static String changePhoneNumber = '$baseUrl/student/change-phone/request';
  static String verifyOtp = '$baseUrl/student-auth/verify-otp';
  static String resendOtp = '$baseUrl/student-auth/resend-otp';
  static String expireTokenCheck = '$baseUrl/auth-token/refresh-if-expired';
  static String changePhoneVerify = '$baseUrl/student/change-phone/verify';
  static String studentHome = '$baseUrl/student-home';
  static String appVersionCheck = '$baseUrl/versions/student';
  static String checkEmail = '$baseUrl/student-home/profiles/email';
  static String classList = '$baseUrl/teacher-student-attendance/class-list';
  static String task = '$baseUrl/student-home/tasks?';
  static String announcementList = '$baseUrl/student-announcement/list';
  static String studentMessageList = '$baseUrl/student-messages/history';
  static String reactMessage = '$baseUrl/student-messages/create';
  static String notifications = '$baseUrl/notifications/students/register';
  static String profileImage =
      '$baseUrl/student-home/profiles/profile-image-url';
  static String getAdmission = '$baseUrl/admissions/visible';
  static String studentDropDown = '$baseUrl/admissions/meta';
  static String levelClassSection =
      '$baseUrl/admin/class/map/levels-to-sections';
  static String countries = '$baseUrl/geo/countries';

  static String examDetails({required int examId}) {
    return '$baseUrl/student-exams/$examId/details';
  }

  static String statusCheck({required int admissionId}) {
    return '$baseUrl/admissions/my-apps?search=$admissionId';
  }

  static String imageUrl =
      "https://next.fenizotechnologies.com/Adrox/api/image-save";
  static String attendance =
      '$baseUrl/teacher-student-attendance/mark-attendance';
  static String quizSubmit = '$baseUrl/student-quiz/submit';

  static String studentAttendance({required int classId}) {
    return '$baseUrl/teacher-student-attendance/today-status/?class_id=$classId';
  }

  static String profiles = '$baseUrl/student-home/profiles';

  static String switchSiblings({required int id}) {
    return '$baseUrl/student-home/profiles/switch/$id';
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

  static String announcementDetails({required int id}) {
    return '$baseUrl/student-announcement/details/$id';
  }

  static String QuizResult({required int quizId}) {
    return '$baseUrl/student-quiz/result/$quizId';
  }

  static String getHomeWorkIdDetails({required int id}) {
    return '$baseUrl/student-home/homework/$id';
  }

  static String getExamResultData({required int id}) {
    return '$baseUrl/student-exams/$id/result';
  }

  static String getAttendanceMonth({required int month, required int year}) {
    return '$baseUrl/student-home/monthly-attendance-by-student?year=$year&month=$month';
  }

  static String getStudentPaymentPlan({required int id}) {
    return '$baseUrl/student-payments/plan/$id';
  }

  static String admission1NextButton({required int id}) {
    return '$baseUrl/admissions/$id/start';
  }

  static String studentInfo({required int id}) {
    return '$baseUrl/admissions/apps/$id/step1';
  }

  static String parentsInfo({required int id}) {
    return '$baseUrl/admissions/apps/$id/step2';
  }

  static String postAdmissionStart({required int id}) {
    return '$baseUrl/admissions/$id/start';
  }

  static String sistersInfo({required int id}) {
    return '$baseUrl/admissions/apps/$id/step3';
  }

  static String communicationDetails({required int id}) {
    return '$baseUrl/admissions/apps/$id/step4';
  }

  static String submit({required int id}) {
    return '$baseUrl/admissions/apps/$id/submit';
  }

  static String getCcavenue({required int id}) {
    return '$baseUrl/admissions/apps/$id/pay/launch';
  }

  static String getStates({required String country}) {
    return '$baseUrl/geo/states?country=$country';
  }

  static String getCities({required String state, required String country}) {
    return '$baseUrl/geo/cities?country=$country&state=$state';
  }

  static String getAdmissionDetails({required int id}) {
    return '$baseUrl/admissions/apps/$id';
  }

  static String refreshURL({required int id}) {
    return '$baseUrl/student-payments/reconcile-item/$id';
  }
}
