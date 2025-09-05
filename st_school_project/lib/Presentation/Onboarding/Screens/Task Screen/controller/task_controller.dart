import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Home%20Screen/model/student_home_response.dart';
import '../../../../../../api/data_source/apiDataSource.dart';
import '../../../../../Core/Utility/app_color.dart';
import '../model/home_work_id_response.dart';
import '../model/task_response.dart';

class TaskController extends GetxController {
  RxBool isLoading = false.obs;
  String accessToken = '';
  RxBool isOtpLoading = false.obs;
  ApiDataSource apiDataSource = ApiDataSource();
  RxList<YourTask> tasks = <YourTask>[].obs;
  Rx<HomeworkIdDetail?> homeworkDetail = Rx<HomeworkIdDetail?>(null);

  List<String> get subjectFilters {
    final set = <String>{};
    for (final t in tasks) {
      final s = t.subject?.trim();
      if (s != null && s.isNotEmpty) set.add(s);
    }
    final list = set.toList()..sort();
    return ['All', ...list];
  }

  @override
  void onInit() {
    super.onInit();
    //getTaskDetails();
  }

  Future<String?> getTaskDetails() async {
    if (isLoading.value) return null;
    try {
      isLoading.value = true;

      final results = await apiDataSource.getTaskDetails();

      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;
          tasks.value = response.data;
          AppLogger.log.i("Tasks fetched: ${tasks.length}");
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

  Future<String?> homeWorkIdDetails({int? id, bool showLoader = true}) async {
    try {
      if (showLoader) showPopupLoader(); // show popup loader

      final results = await apiDataSource.getHomeWorkIdDetails(id: id);

      results.fold(
        (failure) {
          if (showLoader) hidePopupLoader(); // hide popup loader
          AppLogger.log.e(failure.message);
        },
        (response) async {
          if (showLoader) hidePopupLoader(); // hide popup loader
          homeworkDetail.value = response.data;
          AppLogger.log.i("Tasks fetched: ${tasks.length}");
          AppLogger.log.i(response.message);

          // Convert JSON to model
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader(); // hide popup loader
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
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
      barrierDismissible: false, // user can't dismiss by tapping outside
      barrierColor: Colors.black.withOpacity(0.3), // transparent background
    );
  }

  void hidePopupLoader() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
