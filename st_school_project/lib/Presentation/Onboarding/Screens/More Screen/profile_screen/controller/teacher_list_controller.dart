import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen/model/teacher_profile_response.dart';
import 'package:st_school_project/api/data_source/apiDataSource.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';

import '../../../../../../Core/Utility/snack_bar.dart';

class TeacherListController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  RxString currentLoadingStatus = ''.obs;
  RxString frontImageUrl = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isPresentLoading = false.obs;

  Rx<TeacherListResponse?> teacherListResponse = Rx<TeacherListResponse?>(null);
  @override
  void onInit() {
    super.onInit();
    teacherListData();
  }

  Future<String?> teacherListData({bool showLoader = false}) async {
    try {
      if (showLoader) showPopupLoader();
      final results = await apiDataSource.teacherProfileData();
      return results.fold(
        (failure) {
          AppLogger.log.e(failure.message);
        },
        (response) async {
          if (showLoader) hidePopupLoader();

          AppLogger.log.i(response.data.toString());
          teacherListResponse.value = response;
          return response.data.toString();
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
    }
    return null;
  }

  Future<void> imageUpload({
    bool showLoader = true,
    File? frontImageFile,
  }) async {
    try {
      String? frontImageUrl;
      if (showLoader) showPopupLoader();
      if (frontImageFile != null) {
        final frontResult = await apiDataSource.userProfileUpload(
          imageFile: frontImageFile,
        );

        frontImageUrl = frontResult.fold((failure) {
          CustomSnackBar.showError("Front Upload Failed: ${failure.message}");
          return null;
        }, (success) => success.message);

        if (frontImageUrl == null) {
          isLoading.value = false;
          return;
        }
      } else {
        frontImageUrl = this.frontImageUrl.value;
      }
      final results = await apiDataSource.studentProfileInsert(
        image: frontImageUrl,
      );
      return results.fold(
        (failure) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
        },
        (response) async {
          if (showLoader) hidePopupLoader();
          Get.back();
          AppLogger.log.i(response);
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
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
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
    );
  }

  void hidePopupLoader() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
