import 'package:get/get.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Home%20Screen/controller/student_home_controller.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/Quiz%20Screen/controller/quiz_controller.dart';

import 'Presentation/Onboarding/Screens/More Screen/Login_screen/controller/login_controller.dart';


Future<void>  initController() async {
  Get.lazyPut(() => LoginController());
  Get.lazyPut(() => StudentHomeController());
  Get.lazyPut(() => QuizController());

}
