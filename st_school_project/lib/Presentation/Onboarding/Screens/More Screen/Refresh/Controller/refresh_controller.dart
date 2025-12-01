import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';

import '../../../../../../Core/Utility/app_color.dart';
import '../../../../../../api/data_source/apiDataSource.dart';
import '../Model/reconcile_response.dart';

class RefreshController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  Future<ReconcileResponse?> refreshData({
    required int id,
    bool showLoader = false,
  }) async {
    try {
      if (showLoader) showPopupLoader();

      final result = await apiDataSource.refresh(id: id);

      return result.fold(
        (failure) {
          AppLogger.log.e(failure.message);
          if (showLoader) hidePopupLoader();
          return null;
        },
        (response) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.i("Reconciled = ${response.data.reconciled}");
          return response;
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
