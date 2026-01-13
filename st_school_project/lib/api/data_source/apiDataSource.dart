import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';

import 'package:intl/intl.dart';
import 'package:st_school_project/Presentation/Admssion/Model/country_model.dart';
import 'package:st_school_project/Presentation/Admssion/Model/status_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/model/announcement_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/model/exam_result_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Home%20Screen/model/app_version_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Home%20Screen/model/student_home_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen/model/email_update_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen/model/fees_details_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen/model/fees_history_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Task%20Screen/model/home_work_id_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Task%20Screen/model/task_response.dart';

import '../../Presentation/Admssion/Model/admission1_nextbutton_response.dart';
import '../../Presentation/Admssion/Model/admission_1_response.dart';
import '../../Presentation/Admssion/Model/class_section_response.dart';
import '../../Presentation/Admssion/Model/get_admission.dart';
import '../../Presentation/Admssion/Model/parents_info_response.dart';
import '../../Presentation/Admssion/Model/student_drop_down_response.dart';
import '../../Presentation/Admssion/Model/student_info_response.dart';
import '../../Presentation/Admssion/Model/submit_response.dart';
import '../../Presentation/Onboarding/Screens/Announcements Screen/model/announcement_details_response.dart';
import '../../Presentation/Onboarding/Screens/Announcements Screen/model/exam_details_response.dart';
import '../../Presentation/Onboarding/Screens/Attendence Screen/model/attendance_response.dart';
import '../../Presentation/Onboarding/Screens/Home Screen/model/message_list_response.dart';
import '../../Presentation/Onboarding/Screens/Home Screen/model/react_response.dart';
import '../../Presentation/Onboarding/Screens/Home Screen/model/sibling_switch_response.dart';
import '../../Presentation/Onboarding/Screens/Home Screen/model/siblings_list_response.dart';
import '../../Presentation/Onboarding/Screens/More Screen/Login_screen/Model/login_response.dart';
import '../../Presentation/Onboarding/Screens/More Screen/Login_screen/Model/resent_otp_response.dart';
import '../../Presentation/Onboarding/Screens/More Screen/Login_screen/Model/token_response.dart';
import '../../Presentation/Onboarding/Screens/More Screen/Quiz Screen/Model/quiz_attend.dart';
import '../../Presentation/Onboarding/Screens/More Screen/Quiz Screen/Model/quiz_result_response.dart';
import '../../Presentation/Onboarding/Screens/More Screen/Quiz Screen/Model/quiz_submit.dart';
import '../../Presentation/Onboarding/Screens/More Screen/Refresh/Model/reconcile_response.dart';
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

  // @override
  // Future<Either<Failure, LoginResponse>> mobileNumberLogin(String phone) async {
  //   try {
  //     String url = ApiUrl.login;
  //
  //     dynamic response = await Request.sendRequest(
  //       url,
  //       {"phone": phone},
  //       'Post',
  //       false,
  //     );
  //
  //     AppLogger.log.i(response);
  //
  //     // HTTP Response
  //     if (response is! DioException) {
  //       // success
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         if (response.data['status'] == true) {
  //           return Right(LoginResponse.fromJson(response.data));
  //         } else {
  //           // ✅ send full JSON so controller can read startDate
  //           return Left(ServerFailure(jsonEncode(response.data)));
  //         }
  //       } else {
  //         // ✅ send full JSON error (code 400 also comes here)
  //         return Left(ServerFailure(jsonEncode(response.data)));
  //       }
  //     }
  //
  //     // DioException
  //     final errorData = response.response?.data;
  //     if (errorData is Map) {
  //       // ✅ send full JSON
  //       return Left(ServerFailure(jsonEncode(errorData)));
  //     }
  //
  //     return Left(ServerFailure(response.message ?? "Unknown Dio error"));
  //   } catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   }
  // }
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

      if (response is! DioException) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.data['status'] == true) {
            return Right(LoginResponse.fromJson(response.data));
          } else {
            return Left(ServerFailure(jsonEncode(response.data)));
          }
        } else {
          return Left(ServerFailure(jsonEncode(response.data)));
        }
      }

      final errorData = response.response?.data;
      if (errorData is Map) {
        return Left(ServerFailure(jsonEncode(errorData)));
      }

      return Left(ServerFailure(response.message ?? "Unknown Dio error"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Future<Either<Failure, LoginResponse>> changeMobileNumber(
  //   String phone,
  // ) async
  // {
  //   try {
  //     String url = ApiUrl.changePhoneNumber;
  //
  //     dynamic response = await Request.sendRequest(
  //       url,
  //       {"newPhone": phone},
  //       'Post',
  //       false,
  //     );
  //
  //     AppLogger.log.i(response);
  //
  //     // Not a DioException -> means it's an HTTP Response
  //     if (response is! DioException) {
  //       // If status code is success
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         if (response.data['status'] == true) {
  //           return Right(LoginResponse.fromJson(response.data));
  //         } else {
  //           return Left(
  //             ServerFailure(response.data['message'] ?? "Login failed"),
  //           );
  //         }
  //       } else {
  //         // ❗ API returned non-success code but has JSON error message
  //         return Left(
  //           ServerFailure(response.data['message'] ?? "Something went wrong"),
  //         );
  //       }
  //     }
  //     // Is DioException
  //     else {
  //       final errorData = response.response?.data;
  //       if (errorData is Map && errorData.containsKey('message')) {
  //         return Left(ServerFailure(errorData['message']));
  //       }
  //       return Left(ServerFailure(response.message ?? "Unknown Dio error"));
  //     }
  //   } catch (e) {
  //     return Left(ServerFailure(e.toString()));
  //   }
  // }

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
        // success HTTP
        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = response.data;

          // ✅ Normal success
          if (data['status'] == true) {
            return Right(LoginResponse.fromJson(data));
          }

          // ✅ Special case: status false BUT token exists (applicant)
          final token = data['token'];
          final role = data['role'];
          if (token != null && token.toString().isNotEmpty && role != null) {
            return Right(LoginResponse.fromJson(data));
          }

          // otherwise error
          return Left(ServerFailure(jsonEncode(data)));
        }

        // non-200 response
        return Left(ServerFailure(jsonEncode(response.data)));
      }

      // DioException
      final errorData = response.response?.data;
      if (errorData is Map) {
        return Left(ServerFailure(jsonEncode(errorData)));
      }
      return Left(ServerFailure(response.message ?? "Unknown Dio error"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  //
  // Future<Either<Failure, LoginResponse>> otpLogin({
  //   required String phone,
  //   required String otp,
  // }) async
  // {
  //   try {
  //     String url = ApiUrl.verifyOtp;
  //
  //     dynamic response = await Request.sendRequest(
  //       url,
  //       {"otp": otp, "phone": phone},
  //       'Post',
  //       false,
  //     );
  //     AppLogger.log.i(response);
  //     if (response is! DioException) {
  //       // If status code is success
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         if (response.data['status'] == true) {
  //           return Right(LoginResponse.fromJson(response.data));
  //         } else {
  //           return Left(
  //             ServerFailure(response.data['message'] ?? "Login failed"),
  //           );
  //         }
  //       } else {
  //         // ❗ API returned non-success code but has JSON error message
  //         return Left(
  //           ServerFailure(response.data['message'] ?? "Something went wrong"),
  //         );
  //       }
  //     }
  //     // Is DioException
  //     else {
  //       final errorData = response.response?.data;
  //       if (errorData is Map && errorData.containsKey('message')) {
  //         return Left(ServerFailure(errorData['message']));
  //       }
  //       return Left(ServerFailure(response.message ?? "Unknown Dio error"));
  //     }
  //   } catch (e) {
  //     return Left(ServerFailure(''));
  //   }
  // }

  Future<Either<Failure, ResentOtpResponse>> resentOtp({
    required String phone,
  }) async {
    try {
      String url = ApiUrl.resendOtp;

      dynamic response = await Request.sendRequest(
        url,
        {"phone": phone},
        'Post',
        false,
      );
      AppLogger.log.i(response);
      if (response is! DioException) {
        // If status code is success
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.data['status'] == true) {
            return Right(ResentOtpResponse.fromJson(response.data));
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
  }) async {
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

  Future<Either<Failure, TokenResponse>> checkTokenExpire() async {
    try {
      String url = ApiUrl.expireTokenCheck;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      dynamic response = await Request.sendRequest(
        url,
        {"token": token},
        'Post',
        false,
      );
      AppLogger.log.i(response);

      if (response is! DioException) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Always return TokenResponse, even if status=false
          return Right(TokenResponse.fromJson(response.data));
        } else {
          return Left(
            ServerFailure(response.data['message'] ?? "Something went wrong"),
          );
        }
      } else {
        final errorData = response.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          return Left(ServerFailure(errorData['message']));
        }
        return Left(ServerFailure(response.message ?? "Unknown Dio error"));
      }
    } catch (e) {
      return Left(ServerFailure('Error checking token'));
    }
  }

  Future<Either<Failure, Admission1Response>> getAdmission() async {
    try {
      String url = ApiUrl.getAdmission;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(Admission1Response.fromJson(response.data));
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

  Future<Either<Failure, Admission1NextButtonResponse>>
  postAdmission1NextButton({required int id}) async {
    try {
      String url = ApiUrl.postAdmissionStart(id: id);

      dynamic response = await Request.sendRequest(url, {}, 'post', true);
      AppLogger.log.i(response);
      AppLogger.log.i(url);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(Admission1NextButtonResponse.fromJson(response.data));
        } else {
          AppLogger.log.e(response.data['message']);
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

  Future<Either<Failure, StudentInfoResponse>> StudentInfo({
    required int id,
    required String studentName,
    required String studentNameTamil,
    required String aadhaar,
    required String emailId,
    required String dob,
    required String religion,
    required String caste,
    required String community,
    required String motherTongue,
    required String nationality,
    required String idProof1,
    required String idProof2,
  }) async {
    try {
      String url = ApiUrl.studentInfo(id: id);

      dynamic response = await Request.sendRequest(
        url,
        {
          "studentName": studentName,
          "studentNameTamil": studentNameTamil,
          "aadhaar": aadhaar,
          "dob": dob,
          "religion": religion,
          "caste": caste,
          "community": community,
          "email": emailId,
          "motherTongue": motherTongue,
          "nationality": nationality,
          "idProof1": idProof1,
          "idProof2": idProof2,
        },
        'post',
        true,
      );

      AppLogger.log.i(response); // Log the full response for debugging

      // Check for DioException (API-related error)
      if (response is DioException) {
        // Log the Dio exception for more details
        AppLogger.log.e("DioException: ${response.message}");
        return Left(ServerFailure(response.message ?? "Dio Error"));
      }

      // If status code is 200 or 201, process the data
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['status'] == true) {
          return Right(StudentInfoResponse.fromJson(response.data));
        } else {
          // Show the API error message, even if status is false
          String errorMessage =
              response.data['message'] ?? "Unknown error from server";
          AppLogger.log.e("API Error: $errorMessage");
          return Left(ServerFailure(errorMessage));
        }
      }

      // Check if response contains an error message in case of unexpected status code
      if (response.data != null && response.data['message'] != null) {
        // Extract the error message and return it
        String apiErrorMessage = response.data['message'];
        AppLogger.log.e("API Error: $apiErrorMessage");
        return Left(ServerFailure(apiErrorMessage));
      } else {
        // If no message is found, return a generic message with the status code
        String fallbackMessage =
            "Unexpected error. Status code: ${response.statusCode}";
        AppLogger.log.e(fallbackMessage);
        return Left(ServerFailure(fallbackMessage));
      }
    } catch (e) {
      // Catch any other exceptions and log the error
      AppLogger.log.e("Exception: $e");
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, ParentsInfoResponse>> ParentsInfo({
    required int id,
    required String fatherName,
    required String fatherNameTamil,
    required String fatherQualification,
    required String fatherOccupation,
    required int fatherIncome,
    required String fatherOfficeAddress,
    required String motherName,
    required String motherNameTamil,
    required String motherQualification,
    required String motherOccupation,
    required int motherIncome,
    required String motherOfficeAddress,
    required bool hasGuardian,
    String? guardianName,
    String? guardianNameTamil,
    String? guardianQualification,
    String? guardianOccupation,
    int? guardianIncome,
    String? guardianOfficeAddress,
  }) async {
    try {
      final url = ApiUrl.parentsInfo(id: id);

      final response = await Request.sendRequest(
        url,
        {
          "id": id,
          "fatherName": fatherName,
          "fatherNameTamil": fatherNameTamil,
          "fatherQualification": fatherQualification,
          "fatherOccupation": fatherOccupation,
          "fatherIncome": fatherIncome,
          "fatherOfficeAddress": fatherOfficeAddress,
          "motherName": motherName,
          "motherNameTamil": motherNameTamil,
          "motherQualification": motherQualification,
          "motherOccupation": motherOccupation,
          "motherIncome": motherIncome,
          "motherOfficeAddress": motherOfficeAddress,
          "hasGuardian": hasGuardian,
          if (hasGuardian) "guardianName": guardianName,
          if (hasGuardian) "guardianNameTamil": guardianNameTamil,
          if (hasGuardian) "guardianQualification": guardianQualification,
          if (hasGuardian) "guardianOccupation": guardianOccupation,
          if (hasGuardian) "guardianIncome": guardianIncome,
          if (hasGuardian) "guardianOfficeAddress": guardianOfficeAddress,
        },
        'post',
        true,
      );

      AppLogger.log.i(response);

      if (response is DioException) {
        final statusCode = response.response?.statusCode;
        final message =
            response.response?.data?['message'] ??
            response.message ??
            'Request failed with status code $statusCode';
        return Left(ServerFailure(message));
      }

      final statusCode = response.statusCode ?? 0;

      if (statusCode == 200 || statusCode == 201) {
        if (response.data['status'] == true) {
          return Right(ParentsInfoResponse.fromJson(response.data));
        } else {
          return Left(
            ServerFailure(response.data['message'] ?? 'Unknown API error'),
          );
        }
      } else {
        // Handle all non-200 cases with actual server message
        final message =
            response.data?['message'] ??
            'Server responded with status $statusCode';
        return Left(ServerFailure(message));
      }
    } catch (e) {
      // Catch anything unexpected (like parsing errors)
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, ParentsInfoResponse>> sistersInfo({
    required int id,
    required String hasSisterInSchool,
    required List<Map<String, String>> siblings,
  }) async {
    try {
      final url = ApiUrl.sistersInfo(id: id);

      final payload =
          hasSisterInSchool != 'NoSiblings'
              ? {"hasSisterInSchool": true, "sisterDetails": siblings}
              : {"hasSisterInSchool": false, "sisterDetails": []};

      final response = await Request.sendRequest(url, payload, 'post', true);
      AppLogger.log.i(response);

      if (response is DioException) {
        final message =
            response.response?.data?['message'] ??
            response.message ??
            'Network error occurred';
        return Left(ServerFailure(message));
      }

      final statusCode = response.statusCode;
      final data = response.data;

      if (statusCode == 200 || statusCode == 201) {
        if (data['status'] == true) {
          return Right(ParentsInfoResponse.fromJson(data));
        } else {
          return Left(ServerFailure(data['message'] ?? 'Unknown API error'));
        }
      } else {
        // ✅ Handle API errors like 400, 404, 500, etc.
        final message =
            data['message'] ?? 'Request failed with status code $statusCode';
        return Left(ServerFailure(message));
      }
    } catch (e) {
      return Left(ServerFailure('Exception: ${e.toString()}'));
    }
  }

  Future<Either<Failure, StudentDropDownResponse>> studentDropDown() async {
    try {
      String url = ApiUrl.studentDropDown;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(StudentDropDownResponse.fromJson(response.data));
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

  Future<Either<Failure, ClassSectionResponse>> levelClassSection() async {
    try {
      String url = ApiUrl.levelClassSection;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(ClassSectionResponse.fromJson(response.data));
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

  Future<Either<Failure, ParentsInfoResponse>> communicationDetails({
    required int id,
    required String mobilePrimary,
    required String mobileSecondary,
    required String country,
    required String state,
    required String city,
    required String pinCode,
    required String address,
  }) async {
    try {
      String url = ApiUrl.communicationDetails(id: id);
      final payLoad = {
        "mobilePrimary": mobilePrimary,
        "mobileSecondary": mobileSecondary,
        "country": country,
        "state": state,
        "city": city,
        "pinCode": pinCode,
        "address": address,
      };

      dynamic response = await Request.sendRequest(url, payLoad, 'Post', true);
      AppLogger.log.i(response);
      AppLogger.log.i(payLoad);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(ParentsInfoResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Dio Error"));
      } else {
        final message =
            response.data['message'] ??
            'Request failed with status code ${response.statusCode}';
        return Left(ServerFailure(message));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, ParentsInfoResponse>> requiredPhotos({
    required int id,
    required List<bool> isChecked,
  }) async {
    try {
      String url = ApiUrl.communicationDetails(id: id);
      final payLoad = {
        "docsChecklist": [
          {
            "key": "birth_cert",
            "title": "New online downloaded birth certificate",
            "provided": isChecked[0],
          },
          {
            "key": "community_cert",
            "title": "Community Certificate",
            "provided": isChecked[1],
          },
          {
            "key": "last_academic",
            "title": "Last academic certificate",
            "provided": isChecked[2],
          },
          {
            "key": "residence_proof",
            "title": "Proof of Residence",
            "provided": isChecked[3],
          },
        ],
      };

      dynamic response = await Request.sendRequest(url, payLoad, 'Post', true);
      AppLogger.log.i(response);
      AppLogger.log.i(payLoad);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(ParentsInfoResponse.fromJson(response.data));
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

  Future<Either<Failure, SubmitResponse>> submit({
    required int id,
    required bool isChecked,
  }) async {
    try {
      final url = ApiUrl.submit(id: id);
      final payload = {"consentAccepted": isChecked};

      final response = await Request.sendRequest(url, payload, 'Post', true);
      AppLogger.log.i(response);
      AppLogger.log.i(payload);

      // Handle DioException separately
      if (response is DioException) {
        final message =
            response.response?.data?['message'] ??
            response.message ??
            'Something went wrong';
        return Left(ServerFailure(message));
      }

      final data = response.data;

      // Always check API-level 'status'
      if (data['status'] == true) {
        final parsed = SubmitResponse.fromJson(data);
        return Right(parsed);
      } else {
        // Show API message even for non-200 status
        final message = data['message'] ?? 'Unknown error';
        return Left(ServerFailure(message));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> getCcavenue({required int id}) async {
    try {
      final url = ApiUrl.getCcavenue(id: id);
      final response = await Request.sendGetRequest(url, {}, 'Post', true);

      if (response is! DioException &&
          (response?.statusCode == 200 || response?.statusCode == 201)) {
        if (response?.data is String && response?.data.contains('<html')) {
          // ✅ Direct HTML
          return Right(response?.data as String);
        } else {
          return Left(ServerFailure("Unexpected response format"));
        }
      } else if (response is DioException) {
        final msg = "Dio Error";
        return Left(ServerFailure(msg));
      } else {
        return Left(ServerFailure("Unknown error"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, StatusResponse>> statusCheck({
    required int admissionId,
  }) async {
    try {
      String url = ApiUrl.statusCheck(admissionId: admissionId);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(url);
      AppLogger.log.i(response);

      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(StatusResponse.fromJson(response.data));
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

  Future<Either<Failure, CountryResponse>> getCountries() async {
    try {
      String url = ApiUrl.countries;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(url);
      AppLogger.log.i(response);

      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(CountryResponse.fromJson(response.data));
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

  Future<Either<Failure, StatesResponse>> getStates({
    required String country,
  }) async {
    try {
      String url = ApiUrl.getStates(country: country);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(url);
      AppLogger.log.i(response);

      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(StatesResponse.fromJson(response.data));
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

  Future<Either<Failure, CityResponse>> getCities({
    required String country,
    required String state,
  }) async {
    try {
      String url = ApiUrl.getCities(country: country, state: state);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(url);
      AppLogger.log.i(response);

      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(CityResponse.fromJson(response.data));
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

  Future<Either<Failure, GetAdmissionResponse>> getAdmissionDetails({
    required int id,
  }) async {
    try {
      String url = ApiUrl.getAdmissionDetails(id: id);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(GetAdmissionResponse.fromJson(response.data));
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

  Future<Either<Failure, AppVersionResponse>> appVersionCheck() async {
    try {
      String url = ApiUrl.appVersionCheck;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(AppVersionResponse.fromJson(response.data));
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

  Future<Either<Failure, EmailUpdateResponse>> checkEmail({
    required String email,
  }) async {
    try {
      String url = ApiUrl.checkEmail;
      final payLoad = {"email": email};
      dynamic response = await Request.sendRequest(url, payLoad, 'get', true);
      AppLogger.log.i(response);
      AppLogger.log.i(payLoad);

      // Accept both 200 and 201 as success
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(EmailUpdateResponse.fromJson(response.data));
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

  Future<Either<Failure, ReconcileResponse>> refresh({required int id}) async {
    try {
      final url = ApiUrl.refreshURL(id: id);

      final response = await Request.sendRequest(url, {}, 'Post', true);

      if (response is DioException) {
        final dioError = response as DioException;
        final msg = 'Dio Error: ${dioError.message ?? 'Unknown error'}';
        return Left(ServerFailure(msg));
      }

      if (response == null) {
        return Left(ServerFailure('No response from server'));
      }

      final int statusCode = response.statusCode ?? 0;
      final dynamic data = response.data;

      if (statusCode == 200 || statusCode == 201) {
        if (data is Map<String, dynamic>) {
          final parsed = ReconcileResponse.fromJson(data);
          return Right(parsed);
        }

        if (data is String) {
          if (data.contains('<html')) {
            return Left(ServerFailure('Server returned HTML instead of JSON'));
          }

          try {
            final decoded = jsonDecode(data);
            if (decoded is Map<String, dynamic>) {
              final parsed = ReconcileResponse.fromJson(decoded);
              return Right(parsed);
            } else {
              return Left(ServerFailure('Unexpected JSON structure'));
            }
          } catch (e) {
            return Left(ServerFailure('Failed to parse JSON: $e'));
          }
        }

        return Left(ServerFailure('Unexpected response format'));
      }

      return Left(ServerFailure('HTTP error: $statusCode'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
