import 'package:get/get.dart';

import 'Presentation/Onboarding/Screens/More Screen/Login_screen/controller/login_controller.dart';


Future<void>  initController() async {
  Get.lazyPut(() => LoginController());

}
