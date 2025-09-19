import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:st_school_project/Core/Utility/snack_bar.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../api/data_source/apiDataSource.dart';
import '../../../../../Core/Utility/app_color.dart';
import '../../More Screen/profile_screen/controller/teacher_list_controller.dart';
import '../model/message_list_response.dart';
import '../model/siblings_list_response.dart';
import '../model/student_home_response.dart';

class StudentHomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isMsgLoading = false.obs;
  String accessToken = '';
  final hasLoadedOnce = false.obs;
  RxBool isOtpLoading = false.obs;
  ApiDataSource apiDataSource = ApiDataSource();

  // Observable to store student home data
  Rx<StudentHomeData?> studentHomeData = Rx<StudentHomeData?>(null);
  RxList<SiblingsData> siblingsList = RxList<SiblingsData>([]);
  Rx<SiblingsData?> selectedStudent = Rx<SiblingsData?>(null);
  RxList<NotificationItem> messageList = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    getStudentHome();
    getMessageList();
  }

  Map<String, List<NotificationItem>> get groupedMessages {
    final Map<String, List<NotificationItem>> grouped = {};

    for (var msg in messageList) {
      final createdDate = DateUtils.dateOnly(msg.createdAt);
      final now = DateUtils.dateOnly(DateTime.now());
      final yesterday = now.subtract(const Duration(days: 1));

      String key;
      if (createdDate == now) {
        key = "Today Messages";
      } else if (createdDate == yesterday) {
        key = "Yesterday Messages";
      } else {
        key = DateFormat("dd MMM yyyy").format(createdDate);
      }

      grouped.putIfAbsent(key, () => []).add(msg);
    }

    return grouped;
  }

  Future<String?> reactForStudentMessage({
    required String text,
    bool like = true,
  }) async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.reactForStudentMessage(text: text);

      results.fold(
        (failure) {
          AppLogger.log.e(failure.message);
        },
        (response) async {
          CustomSnackBar.showSuccess('Message sent to Class Teacher');
          await getMessageList(load: false);

          AppLogger.log.i(messageList.toString());
        },
      );
    } catch (e) {
      AppLogger.log.e(e);
      return e.toString();
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<String?> getMessageList({bool load = true}) async {
    try {
      isMsgLoading.value = load;
      final results = await apiDataSource.getMessageList();
      results.fold(
        (failure) {
          isMsgLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isMsgLoading.value = false;

          // Store in memory
          // classList.assignAll(response.data);
          messageList.value = response.data!. items ;
          AppLogger.log.i(messageList.toString());

          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString('token', response.token);
        },
      );
    } catch (e) {
      isMsgLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<String?> getStudentHome() async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.getStudentHomeDetails();

      results.fold(
        (failure) {
          isLoading.value = false;
          if (!hasLoadedOnce.value) {
            studentHomeData.value = null;
          }
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;

          AppLogger.log.i(response.message);

          studentHomeData.value = response.data; // assign to observable

          AppLogger.log.i(
            "Student Name: ${studentHomeData.value?.name}, Class: ${studentHomeData.value?.className}",
          );
        },
      );
    } catch (e) {
      isLoading.value = false;
      if (!hasLoadedOnce.value) {
        studentHomeData.value = null;
      }
      AppLogger.log.e(e);
      return e.toString();
    } finally {
      hasLoadedOnce.value = true;
      isLoading.value = false;
    }
    return null;
  }

  Future<void> switchSiblings({required int id, bool showLoader = true}) async {
    try {
      if (showLoader) showPopupLoader();

      final results = await apiDataSource.switchSiblings(id: id);

      results.fold(
        (failure) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
        },
        (response) async {
          final prefs = await SharedPreferences.getInstance();
          if (response.data != null && response.data.token != null) {
            accessToken = response.data.token;
            await prefs.setString('token', accessToken);
            AppLogger.log.i("New token saved: $accessToken");
          }
          await getStudentHome();
          await getSiblingsData();
          final teacherListController = Get.find<TeacherListController>();
          await teacherListController.teacherListData();
          if (showLoader) hidePopupLoader();
          // Optionally clear previous student data
          // studentHomeData.value = null;
          // selectedStudent.value = null;
          // siblingsList.clear();

          // Get.offAll(() => ChangeMobileNumber(page: 'splash'));
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
    }
  }

  Future<void> clearData() async {
    studentHomeData.value = null;
    accessToken = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void selectStudent(SiblingsData student) {
    selectedStudent.value = student;
  }

  Future<void> getSiblingsData() async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.getSiblingsDetails();

      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;
          selectedStudent.value = response.data.firstWhere(
            (student) => student.isActive,
            orElse: () => response.data.first,
          );
          siblingsList.value = response.data;
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
    }
  }

  void showPopupLoader() {
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: AppColor.black,
              strokeAlign: 1,
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3), // transparent background
    );
  }

  void hidePopupLoader() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
