import 'package:get/get.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../api/data_source/apiDataSource.dart';
import '../model/siblings_list_response.dart';
import '../model/student_home_response.dart';

class StudentHomeController extends GetxController {
  RxBool isLoading = false.obs;
  String accessToken = '';
  final hasLoadedOnce = false.obs;
  RxBool isOtpLoading = false.obs;
  ApiDataSource apiDataSource = ApiDataSource();

  // Observable to store student home data
  Rx<StudentHomeData?> studentHomeData = Rx<StudentHomeData?>(null);
  RxList<SiblingsData> siblingsList = RxList<SiblingsData>([]);
  Rx<SiblingsData?> selectedStudent = Rx<SiblingsData?>(null);
  @override
  void onInit() {
    super.onInit();
    getStudentHome();
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

  Future<void> switchSiblings({required int id}) async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.switchSiblings(id: id);

      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;

          // Override token in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          if (response.data != null && response.data.token != null) {
            accessToken = response.data.token;
            await prefs.setString('token', accessToken);
            AppLogger.log.i("New token saved: $accessToken");
          }
          getStudentHome();
          getSiblingsData();
          // Optionally clear previous student data
          // studentHomeData.value = null;
          // selectedStudent.value = null;
          // siblingsList.clear();

          // Get.offAll(() => ChangeMobileNumber(page: 'splash'));
        },
      );
    } catch (e) {
      isLoading.value = false;
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
}
