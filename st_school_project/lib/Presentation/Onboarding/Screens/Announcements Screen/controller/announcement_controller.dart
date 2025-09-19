import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/model/announcement_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/model/exam_result_response.dart';
import 'package:st_school_project/api/data_source/apiDataSource.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';

import '../../../../../Core/Utility/app_color.dart';
import '../model/announcement_details_response.dart';
import '../model/exam_details_response.dart';

class AnnouncementController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  RxString currentLoadingStatus = ''.obs;

  RxBool isLoading = false.obs;
  String accessToken = '';
  Rx<AnnouncementData?> announcementData = Rx<AnnouncementData?>(null);
  Rx<AnnouncementDetails?> announcementDetails = Rx<AnnouncementDetails?>(null);
  Rx<ExamResultData?> examResultData = Rx<ExamResultData?>(null);
  Rx<ExamDetailsDatas?> examDetails = Rx<ExamDetailsDatas?>(null);
  int? lastFetchedExamId;

  @override
  void onInit() {
    super.onInit();
    getAnnouncement();
  }

  Future<String?> getAnnouncement({bool showLoader = true}) async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.getAnnouncement();
      return results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;
          AppLogger.log.i('announcementData List ');
          announcementData.value = response.data;
          AppLogger.log.i(response.toString());
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
    }
    return null;
  }
  Future<void> getExamDetailsList({required int examId,    bool showLoader = true,}) async {
    try {
      if (showLoader) showPopupLoader();

      final results = await apiDataSource.getExamDetailsList(examId: examId);
      results.fold(
            (failure) {
              if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
        },
            (response) {
              if (showLoader) hidePopupLoader();
          examDetails.value = response.data;

          AppLogger.log.i(response.data);

        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
    }
  }
  Future<AnnouncementDetails?> getAnnouncementDetails({
    bool showLoader = true,
    required int id,
  }) async {

    try {
      if (showLoader) showPopupLoader();

      final results = await apiDataSource.getAnnouncementDetails(id: id);

      return results.fold(
        (failure) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
          return null;
        },
        (response) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.i('Announcement Details Fetched ✅');
          announcementDetails.value = response.data; // store in observable
          return response.data; // return data for UI
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
      return null;
    }
  }

  Future<ExamResultData?> getExamResultData({
    bool showLoader = true,
    required int id,
  }) async {
    if (lastFetchedExamId == id && examResultData.value != null) {
      return examResultData.value;
    }
    try {
      if (showLoader) showPopupLoader();

      final results = await apiDataSource.getExamResultData(id: id);

      return results.fold(
        (failure) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
          return null;
        },
        (response) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.i('examResultData  Fetched ✅');
          examResultData.value = response.data; // store in observable
          lastFetchedExamId = id; // store last fetched id
          return response.data; // return data for UI
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
      return null;
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
