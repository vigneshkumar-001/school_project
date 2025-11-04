import 'dart:async';

import 'package:st_school_project/Core/Utility/snack_bar.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../Core/Widgets/bottom_navigationbar.dart';
import '../../../../../../api/data_source/apiDataSource.dart';
import '../../../../../Admssion/Screens/admission_1.dart';
import '../../../Announcements Screen/controller/announcement_controller.dart';
import '../../../Home Screen/controller/student_home_controller.dart';
import '../../../Home Screen/home_tab.dart';
import '../../change_mobile_number.dart';
import '../../otp_screen.dart';
import '../../profile_screen/controller/teacher_list_controller.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  String accessToken = '';
  RxBool isOtpLoading = false.obs;
  ApiDataSource apiDataSource = ApiDataSource();
  final StudentHomeController controller = Get.put(StudentHomeController());
  final AnnouncementController announcementController = Get.put(
    AnnouncementController(),
  );
  final TeacherListController teacherListController = Get.put(
    TeacherListController(),
  );


  final RxInt resendCooldown = 0.obs;
  final RxInt otpExpiry = 0.obs;
  Timer? _otpExpiryTimer;

  @override
  void onInit() {
    super.onInit();
  }

  Future<String?> sendFcmToken(String token) async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.sendFcmToken(token: token);
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
          AppLogger.log.i('I Not sended Fcm Token To Api ');
        },
        (response) async {
          isLoading.value = false;
          AppLogger.log.i('I sended Fcm Token To Api ');

          AppLogger.log.i(response.message);
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<String?> mobileNumberLogin(String phone) async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.mobileNumberLogin(phone);
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
          CustomSnackBar.showError(failure.message);
        },
        (response) async {
          isLoading.value = false;

          AppLogger.log.i(response.message);

          Get.to(() => OtpScreen(mobileNumber: phone, pages: 'splash'));
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<String?> changeMobileNumber(String phone) async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.changeMobileNumber(phone);
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
          CustomSnackBar.showError(failure.message);
        },
        (response) async {
          isLoading.value = false;

          AppLogger.log.i(response.message);

          Get.to(() => OtpScreen(mobileNumber: phone, pages: ''));
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<String?> otpLogin({required String phone, required String otp}) async {
    try {
      isOtpLoading.value = true;
      final results = await apiDataSource.otpLogin(otp: otp, phone: phone);
      results.fold(
        (failure) {
          isOtpLoading.value = false;
          CustomSnackBar.showError(failure.message);
          AppLogger.log.e(failure.message);
        },
        (response) async {
          AppLogger.log.i(response.message);
          final prefs = await SharedPreferences.getInstance();
          accessToken = response.token;

          prefs.setString('token', accessToken);
          prefs.setString('role', response.role);
          prefs.setBool('isAdmissionCompleted', false);

          String? token = prefs.getString('token');
          final fcmToken = prefs.getString('fcmToken');
          sendFcmToken(fcmToken!);
          await _loadInitialData();
          if (response.role == 'student') {
            prefs.setBool('isAdmissionCompleted', true);
            Get.offAll(CommonBottomNavigation(initialIndex: 0));
          } else {
            prefs.setBool('isAdmissionCompleted', false);
            Get.offAll(Admission1());
          }

          isOtpLoading.value = false;
          AppLogger.log.i('token = $token');
        },
      );
    } catch (e) {
      isOtpLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<String?> resentOtp({required String phone}) async {
    try {
      isOtpLoading.value = true;
      final results = await apiDataSource.resentOtp(phone: phone);
      results.fold(
        (failure) {
          isOtpLoading.value = false;
          CustomSnackBar.showError(failure.message);
          AppLogger.log.e(failure.message);
        },
        (response) async {
          AppLogger.log.i(response.message);
          final prefs = await SharedPreferences.getInstance();
          // accessToken = response.token;

          prefs.setString('token', accessToken);
          prefs.setBool('isAdmissionCompleted', false);

          String? token = prefs.getString('token');
          final fcmToken = prefs.getString('fcmToken');
          sendFcmToken(fcmToken!);
          await _loadInitialData();
          // if (response == 'student') {
          //   prefs.setBool('isAdmissionCompleted', true);
          //   Get.offAll(CommonBottomNavigation(initialIndex: 0));
          // } else {
          //   prefs.setBool('isAdmissionCompleted', false);
          //   Get.offAll(Admission1());
          // }

          isOtpLoading.value = false;
          AppLogger.log.i('token = $token');
        },
      );
    } catch (e) {
      isOtpLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<void> resentOtpWithTimer(String phone) async {
    if (resendCooldown.value > 0) return; // prevent spam

    isOtpLoading.value = true;
    final results = await apiDataSource.resentOtp(phone: phone);

    results.fold(
          (failure) {
        isOtpLoading.value = false;
        CustomSnackBar.showError(failure.message);
      },
          (response) {
        isOtpLoading.value = false;
        resendCooldown.value = response.meta.nextAllowedIn;
        otpExpiry.value = response.meta.nextAllowedIn; // same duration for OTP expiry
        CustomSnackBar.showSuccess(response.message);
        _startResendTimer();
        _startOtpExpiryTimer();
      },
    );
  }

  void _startResendTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldown.value <= 1) {
        resendCooldown.value = 0;
        timer.cancel();
      } else {
        resendCooldown.value--;
      }
    });
  }

  void _startOtpExpiryTimer() {
    _otpExpiryTimer?.cancel();
    _otpExpiryTimer = Timer.periodic( Duration(seconds: 1), (timer) {
      if (otpExpiry.value <= 1) {
        otpExpiry.value = 0;
        timer.cancel();
        CustomSnackBar.showError("OTP expired. Please resend.");
      } else {
        otpExpiry.value--;
      }
    });
  }



  Future<String?> changeNumberOtpLogin({
    required String phone,
    required String otp,
  }) async {
    try {
      isOtpLoading.value = true;
      final results = await apiDataSource.changeOtpLogin(
        otp: otp,
        phone: phone,
      );
      results.fold(
        (failure) {
          isOtpLoading.value = false;
          CustomSnackBar.showError(failure.message);
          AppLogger.log.e(failure.message);
        },
        (response) async {
          Get.offAll(CommonBottomNavigation(initialIndex: 4));
          isOtpLoading.value = false;
          AppLogger.log.i(response.message);
          // final prefs = await SharedPreferences.getInstance();
          // accessToken = response.token;
          // prefs.setString('token', accessToken);
          // String? token = prefs.getString('token');
          // AppLogger.log.i('token = $token');
        },
      );
    } catch (e) {
      isOtpLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<void> checkTokenExpire() async {
    try {
      final results = await apiDataSource.checkTokenExpire();
      results.fold(
        (failure) {
          AppLogger.log.e(failure.message);
        },
        (response) async {
          AppLogger.log.i(response.message);

          final prefs = await SharedPreferences.getInstance();

          // Only replace token if the API returned a new one
          if (response.token.isNotEmpty) {
            accessToken = response.token;
            await prefs.setString('token', accessToken);
            AppLogger.log.i('Token refreshed: $accessToken');
          } else {
            // Keep the existing token
            accessToken = prefs.getString('token') ?? '';
            AppLogger.log.i(
              'Token still valid, using existing token: $accessToken',
            );
          }

          await _loadInitialData();
        },
      );
    } catch (e) {
      AppLogger.log.e('Error checking token: $e');
    } finally {}
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      controller.getStudentHome(),
      controller.getSiblingsData(),
      teacherListController.teacherListData(),
      announcementController.getAnnouncement(),
    ]);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      accessToken = token;
      await _loadInitialData();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    accessToken = '';
    Get.offAll(() => ChangeMobileNumber(page: 'splash'));
  }
}
