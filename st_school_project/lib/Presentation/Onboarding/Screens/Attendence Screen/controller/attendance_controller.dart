// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:st_school_project/api/data_source/apiDataSource.dart';
// import 'package:st_school_project/Core/Widgets/consents.dart';
//
// import '../../../../../Core/Utility/app_color.dart';
// import '../model/attendance_response.dart';
//
// class AttendanceController extends GetxController {
//   ApiDataSource apiDataSource = ApiDataSource();
//   RxString currentLoadingStatus = ''.obs;
//   RxBool isLoading = false.obs;
//   RxBool isPresentLoading = false.obs;
//   String accessToken = '';
//   Rx<AttendanceData?> attendanceData = Rx<AttendanceData?>(null);
//
//   @override
//   void onInit() {
//     super.onInit();
//   }
//
//   Future<bool> presentOrAbsent({
//     required int month,
//     required int year,
//     bool showLoader = true,
//   }) async {
//     try {
//       if (showLoader) showPopupLoader();
//       final results = await apiDataSource.getAttendanceMonthly(
//         month: month,
//         year: year,
//       );
//       return results.fold(
//         (failure) {
//           if (showLoader) hidePopupLoader(); // hide popup loader
//           AppLogger.log.e(failure.message);
//           return false;
//         },
//         (response) async {
//           if (showLoader) hidePopupLoader(); // hide popup loader
//           attendanceData.value = response.data;
//           AppLogger.log.i(response.toString());
//           return true;
//         },
//       );
//     } catch (e) {
//       if (showLoader) hidePopupLoader(); // hide popup loader
//       AppLogger.log.e(e);
//       return false;
//     }
//   }
//
//   void showPopupLoader() {
//     Get.dialog(
//       Center(
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: CircularProgressIndicator(
//               color: AppColor.black,
//               strokeAlign: 1,
//             ),
//           ),
//         ),
//       ),
//       barrierDismissible: false, // user can't dismiss by tapping outside
//       barrierColor: Colors.black.withOpacity(0.3), // transparent background
//     );
//   }
//
//   void hidePopupLoader() {
//     if (Get.isDialogOpen ?? false) {
//       Get.back();
//     }
//   }
// }
