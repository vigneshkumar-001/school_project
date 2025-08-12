import 'package:st_school_project/Core/Widgets/consents.dart';

import 'package:intl/intl.dart';

import '../../Presentation/Onboarding/Screens/More Screen/Login_screen/Model/login_response.dart';
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

      // Check if response is NOT DioException and status code is 200 or 201 (both common success codes)
      if (response is! DioException && (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(LoginResponse.fromJson(response.data));
        } else {
          // If message is a list, convert to string for readability
          final msg = response.data['message'];
          return Left(ServerFailure(msg is String ? msg : msg.toString()));
        }
      } else if (response is DioException) {
        // Dio error occurred, extract error message
        return Left(ServerFailure(response.message ?? "Unknown Dio error"));
      } else {
        // Unexpected error case
        return Left(ServerFailure("Unexpected error"));
      }
    } catch (e) {
      // Catch and return exception message
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
      if (response is! DioException && response.statusCode == 201) {
        if (response.data['status'] == true) {
          return Right(LoginResponse.fromJson(response.data));
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
}
