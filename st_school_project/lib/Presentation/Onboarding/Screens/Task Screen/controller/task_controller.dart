import 'package:get/get.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Home%20Screen/model/student_home_response.dart';
import '../../../../../../api/data_source/apiDataSource.dart';
import '../model/home_work_id_response.dart';
import '../model/task_response.dart';

class TaskController extends GetxController {
  RxBool isLoading = false.obs;
  String accessToken = '';
  RxBool isOtpLoading = false.obs;
  ApiDataSource apiDataSource = ApiDataSource();
  RxList<YourTask> tasks = <YourTask>[].obs;
  Rx<HomeworkIdDetail?> homeworkDetail = Rx<HomeworkIdDetail?>(null);

  @override
  void onInit() {
    super.onInit();
    getTaskDetails();
  }

  Future<String?> getTaskDetails() async {
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

          // Convert JSON to model
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<String?> homeWorkIdDetails({int? id}) async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.getHomeWorkIdDetails(id: id);

      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;
          homeworkDetail.value = response.data;
          AppLogger.log.i("Tasks fetched: ${tasks.length}");
          AppLogger.log.i(response.message);

          // Convert JSON to model
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
