import 'package:get/get.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Home%20Screen/model/student_home_response.dart';
import '../../../../../../api/data_source/apiDataSource.dart';

class StudentHomeController extends GetxController {
  RxBool isLoading = false.obs;
  String accessToken = '';
  RxBool isOtpLoading = false.obs;
  ApiDataSource apiDataSource = ApiDataSource();

  // Observable to store student home data
  Rx<StudentHomeData?> studentHomeData = Rx<StudentHomeData?>(null);

  @override
  void onInit() {
    super.onInit();
    // getStudentHome();
  }

  Future<String?> getStudentHome() async {
    try {

      isLoading.value = true;

      final results = await apiDataSource.getStudentHomeDetails();

      results.fold(
        (failure) {
          isLoading.value = false;
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
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }
}
