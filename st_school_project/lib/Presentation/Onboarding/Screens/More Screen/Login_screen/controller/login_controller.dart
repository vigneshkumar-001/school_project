import 'package:st_school_project/Core/Utility/snack_bar.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../Core/Widgets/bottom_navigationbar.dart';
import '../../../../../../api/data_source/apiDataSource.dart';
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
  @override
  void onInit() {
    super.onInit();
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
          Get.offAll(CommonBottomNavigation(initialIndex: 0));
          isOtpLoading.value = false;
          AppLogger.log.i(response.message);
          final prefs = await SharedPreferences.getInstance();
          accessToken = response.token;
          prefs.setString('token', accessToken);
          String? token = prefs.getString('token');
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

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      accessToken = token;
      await controller.getStudentHome();
      await controller.getSiblingsData();
      await teacherListController.teacherListData();
      await announcementController.getAnnouncement();
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
