import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/snack_bar.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen/model/fees_history_response.dart';

import '../../../../../../Core/Utility/app_color.dart';
import '../../../../../../Core/Widgets/bottom_navigationbar.dart';
import '../../../../../../api/data_source/apiDataSource.dart';
import '../../../Announcements Screen/controller/announcement_controller.dart';
import '../../../Home Screen/controller/student_home_controller.dart';
import '../../../Home Screen/home_tab.dart';
import '../../change_mobile_number.dart';
import '../../otp_screen.dart';
import '../../profile_screen/controller/teacher_list_controller.dart';

class FeesHistoryController extends GetxController {
  RxBool isLoading = false.obs;
  String accessToken = '';
  RxBool isOtpLoading = false.obs;
  ApiDataSource apiDataSource = ApiDataSource();

  var feesData = Rxn<FeePlansData>(); // holds the full object

  @override
  void onInit() {
    super.onInit();
  }

  Future<String?> feesHistoryList({bool showLoader = false}) async {
    try {
      if (showLoader) showPopupLoader();
      final results = await apiDataSource.feesHistoryList();
      return results.fold(
        (failure) {
          AppLogger.log.e(failure.message);
        },
        (response) async {
          if (showLoader) hidePopupLoader();

          AppLogger.log.i(response.data.toString());
          feesData.value = response.data;
          return response.data.toString();
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
