import 'package:get/get.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/change_mobile_number.dart';

class AuthRedirect {
  static bool _isRedirecting = false;

  static void toLogin() {
    if (_isRedirecting) return;
    _isRedirecting = true;

    // ✅ Replace with your actual Login screen OR your named route
    // Get.offAllNamed('/login');
    Get.offAll(() => const ChangeMobileNumber(page: 'splash',)); // or LoginScreen()

    Future.delayed(const Duration(milliseconds: 500), () {
      _isRedirecting = false;
    });
  }
}
