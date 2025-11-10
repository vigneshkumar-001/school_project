import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/model/announcement_response.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/model/exam_result_response.dart';
import 'package:st_school_project/api/data_source/apiDataSource.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';

import '../../../../../Core/Utility/app_color.dart';
import '../../More Screen/profile_screen/model/fees_history_response.dart';
import '../model/announcement_details_response.dart';
import '../model/exam_details_response.dart';

/*class AnnouncementController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  RxString currentLoadingStatus = ''.obs;

  RxBool isLoading = false.obs;
  String accessToken = '';
  Rx<AnnouncementData?> announcementData = Rx<AnnouncementData?>(null);
  Rx<AnnouncementDetails?> announcementDetails = Rx<AnnouncementDetails?>(null);
  Rx<FeePlansData?> feesPlanData = Rx<FeePlansData?>(null);
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



  Future<FeePlansData?> getStudentPaymentPlan({
    bool showLoader = true,
    required int id,
  }) async {

    try {
      if (showLoader) showPopupLoader();

      final results = await apiDataSource.getStudentPaymentPlan(id: id);

      return results.fold(
            (failure) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
          return null;
        },
            (response) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.i('Announcement Details Fetched ✅');
          feesPlanData.value = response.data; // store in observable
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
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnnouncementController extends GetxController {
  final ApiDataSource apiDataSource = ApiDataSource();

  final RxBool isLoading = false.obs;
  final RxString currentLoadingStatus = ''.obs;

  // Use Rxn<T> for nullable observables
  final Rxn<AnnouncementData> announcementData = Rxn<AnnouncementData>();
  final Rxn<AnnouncementDetails> announcementDetails = Rxn<AnnouncementDetails>();
  final Rxn<FeePlansData> feesPlanData = Rxn<FeePlansData>();
  final Rxn<ExamResultData> examResultData = Rxn<ExamResultData>();
  final Rxn<ExamDetailsDatas> examDetails = Rxn<ExamDetailsDatas>();

  int? lastFetchedExamId;

  @override
  void onInit() {
    super.onInit();

  }

  Future<void> getAnnouncement({bool showLoader = true}) async {
    await _withLoader(() async {
      final results = await apiDataSource.getAnnouncement();
      results.fold(
            (failure) {
          AppLogger.log.e(failure.message);
        },
            (response) {
          announcementData.value = response.data;
          AppLogger.log.i('Announcement data loaded: ${response.toString()}');
        },
      );
    }, show: showLoader);
  }

  Future<void> getExamDetailsList({
    required int examId,
    bool showLoader = true,
  }) async {
    await _withLoader(() async {
      final results = await apiDataSource.getExamDetailsList(examId: examId);
      results.fold(
            (failure) {
          AppLogger.log.e(failure.message);
        },
            (response) {
          examDetails.value = response.data;
          AppLogger.log.i('Exam details loaded: ${response.data}');
        },
      );
    }, show: showLoader);
  }

  Future<AnnouncementDetails?> getAnnouncementDetails({
    required int id,
    bool showLoader = true,
  }) async {
    return await _withLoader<AnnouncementDetails?>(() async {
      final results = await apiDataSource.getAnnouncementDetails(id: id);
      return results.fold(
            (failure) {
          AppLogger.log.e(failure.message);
          return null;
        },
            (response) {
          announcementDetails.value = response.data;
          AppLogger.log.i('Announcement details fetched ✅');
          return response.data;
        },
      );
    }, show: showLoader);
  }

  Future<ExamResultData?> getExamResultData({
    required int id,
    bool showLoader = true,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && lastFetchedExamId == id && examResultData.value != null) {
      return examResultData.value;
    }

    return await _withLoader<ExamResultData?>(() async {
      final results = await apiDataSource.getExamResultData(id: id);
      return results.fold(
            (failure) {
          AppLogger.log.e(failure.message);
          return null;
        },
            (response) {
          examResultData.value = response.data;
          lastFetchedExamId = id;
          AppLogger.log.i('Exam result data fetched ✅');
          return response.data;
        },
      );
    }, show: showLoader);
  }

  Future<FeePlansData?> getStudentPaymentPlan({
    required int id,
    bool showLoader = true,
  }) async {
    return await _withLoader<FeePlansData?>(() async {
      final results = await apiDataSource.getStudentPaymentPlan(id: id);
      return results.fold(
            (failure) {
          AppLogger.log.e(failure.message);
          return null;
        },
            (response) {
          feesPlanData.value = response.data;
          AppLogger.log.i('Student payment plan fetched ✅');
          return response.data;
        },
      );
    }, show: showLoader);
  }

  // Utility method to show/hide loader and run a task
  Future<T?> _withLoader<T>(Future<T?> Function() task, {bool show = true}) async {
    if (show) showPopupLoader();
    try {
      return await task();
    } catch (e) {
      AppLogger.log.e(e);
      return null;
    } finally {
      if (show) hidePopupLoader();
    }
  }

  void showPopupLoader() {
    if (!(Get.isDialogOpen ?? false)) {
      Get.dialog(
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 3,
              ),
            ),
          ),
        ),
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.3),
      );
    }
  }

  void hidePopupLoader() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
