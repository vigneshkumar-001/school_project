import 'dart:convert';
import 'dart:io';

import 'package:st_school_project/Core/Widgets/consents.dart';

import 'package:intl/intl.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/model/announcement_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/model/exam_result_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Home%20Screen/model/student_home_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen/model/fees_details_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen/model/fees_history_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Task%20Screen/model/home_work_id_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Task%20Screen/model/task_response.dart';

import '../../Presentation/Onboarding/Screens/Announcements Screen/model/announcement_details_response.dart';
import '../../Presentation/Onboarding/Screens/Announcements Screen/model/exam_details_response.dart';
import '../../Presentation/Onboarding/Screens/Attendence Screen/model/attendance_response.dart';
import '../../Presentation/Onboarding/Screens/Home Screen/model/message_list_response.dart';
import '../../Presentation/Onboarding/Screens/Home Screen/model/react_response.dart';
import '../../Presentation/Onboarding/Screens/Home Screen/model/sibling_switch_response.dart';
import '../../Presentation/Onboarding/Screens/Home Screen/model/siblings_list_response.dart';
import '../../Presentation/Onboarding/Screens/More Screen/Login_screen/Model/login_response.dart';
import '../../Presentation/Onboarding/Screens/More Screen/Quiz Screen/Model/quiz_attend.dart';
import '../../Presentation/Onboarding/Screens/More Screen/Quiz Screen/Model/quiz_result_response.dart';
import '../../Presentation/Onboarding/Screens/More Screen/Quiz Screen/Model/quiz_submit.dart';
import '../../Presentation/Onboarding/Screens/More Screen/profile_screen/model/student_image_response.dart';
import '../../Presentation/Onboarding/Screens/More Screen/profile_screen/model/teacher_profile_response.dart';
import '../../Presentation/Onboarding/Screens/More Screen/profile_screen/model/user_image_response.dart';
import '../repository/api_url.dart';
import '../repository/failure.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';

import '../repository/request.dart';

abstract class BaseApiDataSource {
  Future<Either<Failure, LoginResponse>> mobileNumberLogin(String mobileNumber);
}

class ApiDataSource extends BaseApiDataSource {
  @override
  Future<Either<Failure, LoginResponse>> mobileNumberLogin(String phone) async {
    try {
      String url = ApiUrl.login;

      dynamic response = await Request.sendRequest(
        url,
        {"phone": phone},
        'Post',
        false,
      );

      AppLogger.log.i(response);

      // Not a DioException -> means it's an HTTP Response
      if (response is! DioException) {
        // If status code is success
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.data['status'] == true) {
            return Right(LoginResponse.fromJson(response.data));
          } else {
            return Left(
              ServerFailure(response.data['message'] ?? "Login failed"),
            );
          }
        } else {
          // ❗ API returned non-success code but has JSON error message
          return Left(
            ServerFailure(response.data['message'] ?? "Something went wrong"),
          );
        }
      }
      // Is DioException
      else {
        final errorData = response.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          return Left(ServerFailure(errorData['message']));
        }
        return Left(ServerFailure(response.message ?? "Unknown Dio error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, LoginResponse>> changeMobileNumber(
    String phone,
  ) async {
    try {
      String url = ApiUrl.changePhoneNumber;

      dynamic response = await Request.sendRequest(
        url,
        {"newPhone": phone},
        'Post',
        false,
      );

      AppLogger.log.i(response);

      // Not a DioException -> means it's an HTTP Response
      if (response is! DioException) {
        // If status code is success
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.data['status'] == true) {
            return Right(LoginResponse.fromJson(response.data));
          } else {
            return Left(
              ServerFailure(response.data['message'] ?? "Login failed"),
            );
          }
        } else {
          // ❗ API returned non-success code but has JSON error message
          return Left(
            ServerFailure(response.data['message'] ?? "Something went wrong"),
          );
        }
      }
      // Is DioException
      else {
        final errorData = response.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          return Left(ServerFailure(errorData['message']));
        }
        return Left(ServerFailure(response.message ?? "Unknown Dio error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, LoginResponse>> otpLogin({
    required String phone,
    required String otp,
  }) async {
    try {
      String url = ApiUrl.verifyOtp;

      dynamic response = await Request.sendRequest(
        url,
        {"otp": otp, "phone": phone},
        'Post',
        false,
      );
      AppLogger.log.i(response);
      if (response is! DioException) {
        // If status code is success
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.data['status'] == true) {
            return Right(LoginResponse.fromJson(response.data));
          } else {
            return Left(
              ServerFailure(response.data['message'] ?? "Login failed"),
            );
          }
        } else {
          // ❗ API returned non-success code but has JSON error message
          return Left(
            ServerFailure(response.data['message'] ?? "Something went wrong"),
          );
        }
      }
      // Is DioException
      else {
        final errorData = response.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          return Left(ServerFailure(errorData['message']));
        }
        return Left(ServerFailure(response.message ?? "Unknown Dio error"));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, LoginResponse>> sendFcmToken({
    required String token,
  }) async
  {
    try {
      String url = ApiUrl.notifications;

      dynamic response = await Request.sendRequest(
        url,
        {
          "token": token,
          "platform": 'android',
          "deviceModel": 'Mobile',
          "appVersion": "2.3.2",
        },
        'Post',
        false,
      );
      AppLogger.log.i(response);
      if (response is! DioException) {
        // If status code is success
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.data['status'] == true) {
            return Right(LoginResponse.fromJson(response.data));
          } else {
            return Left(
              ServerFailure(response.data['message'] ?? "Login failed"),
            );
          }
        } else {
          // ❗ API returned non-success code but has JSON error message
          return Left(
            ServerFailure(response.data['message'] ?? "Something went wrong"),
          );
        }
      }
      // Is DioException
      else {
        final errorData = response.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          return Left(ServerFailure(errorData['message']));
        }
        return Left(ServerFailure(response.message ?? "Unknown Dio error"));
      }
    } catch (e) {
      AppLogger.log.e(e);
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, LoginResponse>> changeOtpLogin({
    required String phone,
    required String otp,
  }) async {
    try {
      String url = ApiUrl.changePhoneVerify;

      dynamic response = await Request.sendRequest(
        url,
        {"newPhone": phone, "otp": otp},
        'Post',
        false,
      );
      AppLogger.log.i(response);
      if (response is! DioException) {
        // If status code is success
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.data['status'] == true) {
            return Right(LoginResponse.fromJson(response.data));
          } else {
            return Left(
              ServerFailure(response.data['message'] ?? "Login failed"),
            );
          }
        } else {
          // ❗ API returned non-success code but has JSON error message
          return Left(
            ServerFailure(response.data['message'] ?? "Something went wrong"),
          );
        }
      }
      // Is DioException
      else {
        final errorData = response.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          return Left(ServerFailure(errorData['message']));
        }
        return Left(ServerFailure(response.message ?? "Unknown Dio error"));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, StudentHomeResponse>> getStudentHomeDetails() async {
    try {
      String url = ApiUrl.studentHome;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(StudentHomeResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, TaskResponse>> getTaskDetails() async {
    try {
      String url = ApiUrl.task;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(TaskResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, HomeWorkIdResponse>> getHomeWorkIdDetails({
    int? id,
  }) async {
    try {
      String url = ApiUrl.getHomeWorkIdDetails(id: id ?? 0);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(HomeWorkIdResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, QuizAttend>> QuizControllerAttend({
    required int quizId,
  }) async {
    try {
      String url = ApiUrl.QuizAttend(quizId: quizId);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(QuizAttend.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, QuizSubmit>> loadQuizControllerSubmit({
    required int quizId,
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      final String url = ApiUrl.quizSubmit;
      final Map<String, dynamic> body = {'quizId': quizId, 'answers': answers};

      final response = await Request.sendRequest(url, body, 'POST', true);
      AppLogger.log.i(response);

      if (response is! DioException &&
          (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 400)) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final quizSubmit = QuizSubmit.fromJson(data);

          if (quizSubmit.status) {
            return Right(quizSubmit);
          } else {
            // ❌ error from backend but still parse message
            return Left(ServerFailure(quizSubmit.message));
          }
        } else {
          return Left(ServerFailure('Invalid response format'));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? 'Dio error'));
      } else {
        return Left(ServerFailure('Unknown error'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, QuizResultResponse>> loadQuizResult({
    required int quizId,
  }) async {
    try {
      String url = ApiUrl.QuizResult(quizId: quizId);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(QuizResultResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, SiblingsSwitchResponse>> switchSiblings({
    int? id,
  }) async {
    try {
      String url = ApiUrl.switchSiblings(id: id ?? 0);

      dynamic response = await Request.sendRequest(url, {}, 'Post', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(SiblingsSwitchResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, SiblingsListResponse>> getSiblingsDetails() async {
    try {
      String url = ApiUrl.profiles;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(SiblingsListResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, AttendanceResponse>> getAttendanceMonthly({
    int? year,
    int? month,
  }) async {
    try {
      String url = ApiUrl.getAttendanceMonth(
        year: year ?? 0,
        month: month ?? 0,
      );

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(AttendanceResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, TeacherListResponse>> teacherProfileData() async {
    try {
      String url = ApiUrl.teacherInfo;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(TeacherListResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, UserImageModels>> userProfileUpload({
    required File imageFile,
  }) async {
    try {
      if (!await imageFile.exists()) {
        return Left(ServerFailure('Image file does not exist.'));
      }

      String url = ApiUrl.imageUrl;
      FormData formData = FormData.fromMap({
        'images': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await Request.formData(url, formData, 'POST', true);
      Map<String, dynamic> responseData =
          jsonDecode(response.data) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          return Right(UserImageModels.fromJson(responseData));
        } else {
          return Left(ServerFailure(responseData['message']));
        }
      } else if (response is Response && response.statusCode == 409) {
        return Left(ServerFailure(responseData['message']));
      } else if (response is Response) {
        return Left(ServerFailure(responseData['message'] ?? "Unknown error"));
      } else {
        return Left(ServerFailure("Unexpected error"));
      }
    } catch (e) {
      // CommonLogger.log.e(e);
      print(e);
      return Left(ServerFailure('Something went wrong'));
    }
  }

  Future<Either<Failure, StudentProfileImageData>> studentProfileInsert({
    String? image,
  }) async {
    try {
      String url = ApiUrl.profileImage;

      dynamic response = await Request.sendRequest(
        url,
        {"url": image},
        'post',
        true,
      );
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(StudentProfileImageData.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, AnnouncementResponse>> getAnnouncement() async {
    try {
      String url = ApiUrl.announcementList;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(AnnouncementResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, AnnouncementDetailsResponse>> getAnnouncementDetails({
    required int id,
  }) async {
    try {
      String url = ApiUrl.announcementDetails(id: id);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(AnnouncementDetailsResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, ExamResultResponse>> getExamResultData({
    required int id,
  }) async {
    try {
      String url = ApiUrl.getExamResultData(id: id);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(ExamResultResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, MessageListResponse>> getMessageList() async {
    try {
      String url = ApiUrl.studentMessageList;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(MessageListResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, ReactResponse>> reactForStudentMessage({
    required String text,
  }) async {
    try {
      String url = ApiUrl.reactMessage;

      final response = await Request.sendRequest(
        url,
        {'text': text},
        'post',
        true,
      );
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response?.statusCode == 200 || response?.statusCode == 201)) {
        if (response?.data['status'] == true) {
          return Right(ReactResponse.fromJson(response?.data));
        } else {
          return Left(ServerFailure(response?.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, ExamDetailsResponse>> getExamDetailsList({
    required int examId,
  }) async {
    try {
      String url = ApiUrl.examDetails(examId: examId);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(ExamDetailsResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, FeesHistoryResponse>> feesHistoryList() async {
    try {
      String url = ApiUrl.paymentHistory;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(FeesHistoryResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, FeesHistoryResponse>> getStudentPaymentPlan({
    required int id,
  }) async {
    try {
      String url = ApiUrl.getStudentPaymentPlan(id: id);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(FeesHistoryResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
