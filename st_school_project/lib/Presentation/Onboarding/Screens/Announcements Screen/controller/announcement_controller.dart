import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/model/announcement_response.dart';
import 'package:st_school_project/api/data_source/apiDataSource.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';

import '../../../../../Core/Utility/app_color.dart';

class AnnouncementController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  RxString currentLoadingStatus = ''.obs;

  RxBool isLoading = false.obs;
  String accessToken = '';
  Rx<AnnouncementData?>  announcementData = Rx<AnnouncementData?>(null);

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
