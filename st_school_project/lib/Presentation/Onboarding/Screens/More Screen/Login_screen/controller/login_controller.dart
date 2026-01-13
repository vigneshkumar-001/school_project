// =========================== FULL UPDATED LoginController.dart ===========================
// ✅ Home "Open Now" -> compares API `datetime` (UTC ISO) with current time
// ✅ If not opened -> starts countdown + opens AdmissionCountdownScreen
// ✅ If opened -> navigates to Admission1
// ✅ Fix: counter screen stuck because isCounterScreenOpen stayed true
// ✅ Fix: use `page` argument (no hardcoded 'homeScreen')
// ✅ Works for BOTH OTP flow + Home flow

import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Core/Utility/snack_bar.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:st_school_project/Presentation/Admssion/Controller/admission_controller.dart';

import '../../../../../../Core/Widgets/bottom_navigationbar.dart';
import '../../../../../../api/data_source/apiDataSource.dart';
import '../../../../../Admssion/Screens/admission_1.dart';
import '../../../Announcements Screen/controller/announcement_controller.dart';
import '../../../Home Screen/controller/student_home_controller.dart';
import '../../../Home Screen/model/student_home_response.dart';
import '../../../counter_screen.dart';
import '../../change_mobile_number.dart';
import '../../otp_screen.dart';
import '../../profile_screen/controller/teacher_list_controller.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  String accessToken = '';
  RxBool isOtpLoading = false.obs;

  // Keep your existing flag
  final RxBool isOtpBlocked = false.obs;

  // Counter
  final RxBool isCounterScreenOpen = false.obs;

  // Countdown
  final RxInt admissionTotalSeconds = 0.obs;
  final RxInt admissionRemainingSeconds = 0.obs;
  final Rxn<DateTime> admissionStartAtLocal =
      Rxn<DateTime>(); // local time for UI
  Timer? _admissionTimer;

  ApiDataSource apiDataSource = ApiDataSource();

  // Your controllers (kept as in your file)
  final StudentHomeController controller = Get.put(StudentHomeController());
  final AdmissionController admissionController = Get.put(
    AdmissionController(),
  );
  final AnnouncementController announcementController = Get.put(
    AnnouncementController(),
  );
  final TeacherListController teacherListController = Get.put(
    TeacherListController(),
  );

  final RxInt resendCooldown = 0.obs;
  final RxInt otpExpiry = 0.obs;
  Timer? _otpExpiryTimer;

  @override
  void onInit() {
    super.onInit();
  }

  // ======================= UI GETTERS =======================
  String get admissionCountdownText {
    final s = admissionRemainingSeconds.value;

    final hours = (s ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((s % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (s % 60).toString().padLeft(2, '0');

    return (s >= 3600) ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  String get admissionOpenAtText {
    final dt = admissionStartAtLocal.value;
    if (dt == null) return "";
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
  }

  // ======================= ✅ HOME TAP HANDLER (USE THIS) =======================
  void handleHomeAdmissionTapFromAnnouncement(
    Announcement ann, {
    required String page,
  }) {
    try {
      final iso = ann.datetime.trim();

      print("HOME TAP -> ann=${ann.toJson()}");
      print("HOME TAP -> iso=$iso");

      // If datetime missing -> open admission
      if (iso.isEmpty) {
        print("HOME TAP -> datetime empty -> Admission1");
        Get.to(() => Admission1(pages: page));
        return;
      }

      final startUtc = DateTime.parse(iso).toUtc();
      final nowUtc = DateTime.now().toUtc();

      print("HOME TAP -> startUtc=$startUtc nowUtc=$nowUtc");
      print(
        "HOME TAP -> startLocal=${startUtc.toLocal()} nowLocal=${DateTime.now()}",
      );

      // Not opened -> counter
      if (nowUtc.isBefore(startUtc)) {
        print("HOME TAP -> NOT OPEN -> open Counter");

        // Start countdown
        startAdmissionCountdownFromStartDate(iso);

        // Force unlock (important, sometimes stuck true)
        isCounterScreenOpen.value = false;

        _openCounterScreen(
          message: ann.message.isEmpty ? "Please wait" : ann.message,
          page: page,
        );
        return;
      }

      // Opened -> admission
      print("HOME TAP -> OPEN -> Admission1");
      Get.to(() => Admission1(pages: page));
    } catch (e) {
      print("HOME TAP ERROR -> $e");
      Get.to(() => Admission1(pages: page));
    }
  }

  Future<void> resentOtpWithTimer(String phone) async {
    if (resendCooldown.value > 0) return; // prevent spam
    isOtpLoading.value = true;
    final results = await apiDataSource.resentOtp(phone: phone);
    results.fold(
      (failure) {
        isOtpLoading.value = false;
        CustomSnackBar.showError(failure.message);
      },
      (response) {
        isOtpLoading.value = false;
        resendCooldown.value = response.meta.nextAllowedIn;
        otpExpiry.value = response.meta.nextAllowedIn;
        CustomSnackBar.showSuccess(response.message);
        _startResendTimer();
        _startOtpExpiryTimer();
      },
    );
  }

  Future<bool> checkTokenExpire() async {
    try {
      final results = await apiDataSource.checkTokenExpire();
      return await results.fold(
        (failure) {
          AppLogger.log.e(failure.message);
          return false;
        },
        (response) async {
          AppLogger.log.i(response.message);
          final prefs = await SharedPreferences.getInstance();
          if (response.token.isNotEmpty) {
            accessToken = response.token;
            await prefs.setString('token', accessToken);
          } else {
            accessToken = prefs.getString('token') ?? '';
          }
          if (response.role.toLowerCase() == 'applicant') {
            final admissionID = prefs.getInt('admissionId');
            if (admissionID != null) {
              await admissionController.getAdmissionDetails(id: admissionID);
            }
            return true;
          }
          await _loadInitialData();
          return false; // not applicant
        },
      );
    } catch (e) {
      AppLogger.log.e('Error checking token: $e');
      return false;
    }
  }

  // ======================= COUNTDOWN METHODS =======================
  void startAdmissionCountdownFromStartDate(String startDateIsoUtc) {
    final startUtc = DateTime.parse(startDateIsoUtc).toUtc();
    final startLocal = startUtc.toLocal();

    admissionStartAtLocal.value = startLocal;

    final nowUtc = DateTime.now().toUtc();
    final diff = startUtc.difference(nowUtc).inSeconds;

    if (diff <= 0) {
      stopAdmissionCountdown();
      return;
    }

    isOtpBlocked.value = true;
    admissionRemainingSeconds.value = diff;
    admissionTotalSeconds.value = diff;

    _admissionTimer?.cancel();
    _admissionTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      final left = startUtc.difference(DateTime.now().toUtc()).inSeconds;

      if (left <= 0) {
        stopAdmissionCountdown();
        t.cancel();
      } else {
        admissionRemainingSeconds.value = left;
      }
    });
  }

  void startAdmissionCountdownFromMinutes(int remainingMinutes) {
    final diff = remainingMinutes * 60;
    if (diff <= 0) {
      stopAdmissionCountdown();
      return;
    }

    admissionStartAtLocal.value = DateTime.now().add(Duration(seconds: diff));

    isOtpBlocked.value = true;
    admissionRemainingSeconds.value = diff;
    admissionTotalSeconds.value = diff;

    _admissionTimer?.cancel();
    _admissionTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (admissionRemainingSeconds.value <= 1) {
        stopAdmissionCountdown();
        t.cancel();
      } else {
        admissionRemainingSeconds.value--;
      }
    });
  }

  void stopAdmissionCountdown() {
    _admissionTimer?.cancel();
    _admissionTimer = null;

    isOtpBlocked.value = false;
    admissionRemainingSeconds.value = 0;
    admissionTotalSeconds.value = 0;
    admissionStartAtLocal.value = null;
  }

  void _startResendTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldown.value <= 1) {
        resendCooldown.value = 0;
        timer.cancel();
      } else {
        resendCooldown.value--;
      }
    });
  }

  void _startOtpExpiryTimer() {
    _otpExpiryTimer?.cancel();
    _otpExpiryTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (otpExpiry.value <= 1) {
        otpExpiry.value = 0;
        timer.cancel();
        CustomSnackBar.showError("OTP expired. Please resend.");
      } else {
        otpExpiry.value--;
      }
    });
  }

  // ======================= ✅ COUNTER SCREEN OPEN (UPDATED) =======================
  void _openCounterScreen({required String message, required String page}) {
    if (isCounterScreenOpen.value) {
      print("COUNTER -> already open, blocked");
      return;
    }

    isCounterScreenOpen.value = true;

    final nav = Get.to(
      () => AdmissionCountdownScreen(message: message, pages: page),
      preventDuplicates: false, // ✅ important
    );

    // If Get.to fails, unlock immediately
    if (nav == null) {
      print("COUNTER -> Get.to returned null, unlock");
      isCounterScreenOpen.value = false;
      return;
    }

    nav.then((_) {
      print("COUNTER -> closed, unlock");
      isCounterScreenOpen.value = false;
    });
  }

  // ======================= ✅ OTP WINDOW ERROR HANDLER (YOUR PATTERN, UPDATED WITH page) =======================
  void handleAdmissionWindowError(
    String failureMessage, {
    required String page,
  }) {
    try {
      final decoded = jsonDecode(failureMessage);

      final code = decoded["code"];
      final msg = (decoded["message"] ?? "").toString();
      final data = decoded["data"];

      final isAdmissionWindowNotOpened =
          code == 400 &&
          msg.toLowerCase().contains("admission window") &&
          msg.toLowerCase().contains("has not opened");

      if (isAdmissionWindowNotOpened && data != null) {
        final startDate = data["startDate"];
        final remainingMinutes = data["remainingMinutes"];

        if (startDate != null && startDate.toString().isNotEmpty) {
          startAdmissionCountdownFromStartDate(startDate.toString());
        } else if (remainingMinutes != null) {
          startAdmissionCountdownFromMinutes(
            int.parse(remainingMinutes.toString()),
          );
        } else {
          CustomSnackBar.showError(msg.isEmpty ? "Please wait" : msg);
          return;
        }

        // Force unlock then open
        isCounterScreenOpen.value = false;

        _openCounterScreen(
          message: msg.isEmpty ? "Please wait" : msg,
          page: page,
        );
        return;
      }

      CustomSnackBar.showError(msg.isEmpty ? failureMessage : msg);
    } catch (_) {
      CustomSnackBar.showError(failureMessage);
    }
  }

  // ======================= YOUR EXISTING METHODS BELOW (UNCHANGED) =======================
  Future<String?> mobileNumberLogin(String phone) async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.mobileNumberLogin(phone);
      results.fold(
        (failure) {
          isLoading.value = false;
          CustomSnackBar.showError(failure.message);
        },
        (response) async {
          isLoading.value = false;
          Get.to(() => OtpScreen(mobileNumber: phone, pages: 'splash'));
        },
      );
    } catch (e) {
      isLoading.value = false;
      return e.toString();
    }
    return null;
  }

  Future<String?> changeMobileNumber(String phone) async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.changeMobileNumber(phone);
      results.fold(
        (failure) {
          isLoading.value = false;
          CustomSnackBar.showError(failure.message);
        },
        (response) async {
          isLoading.value = false;
          Get.to(() => OtpScreen(mobileNumber: phone, pages: ''));
        },
      );
    } catch (e) {
      isLoading.value = false;
      return e.toString();
    }
    return null;
  }

  Future<String?> otpLogin({required String phone, required String otp}) async {
    try {
      isOtpLoading.value = true;
      final results = await apiDataSource.otpLogin(otp: otp, phone: phone);

      results.fold(
        (failure) {
          isOtpLoading.value = false;
          CustomSnackBar.showError(failure.message);
        },
        (response) async {
          final prefs = await SharedPreferences.getInstance();

          final String token = (response.token ?? '').toString();
          final String role = (response.role ?? '').toString();
          final String msg = (response.message ?? '').toString();
          final lowerMsg = msg.toLowerCase();

          if (token.isNotEmpty) {
            accessToken = token;
            await prefs.setString('token', token);
          }
          await prefs.setString('role', role);

          // if window not opened -> counter only
          final bool shouldOpenCounter =
              lowerMsg.contains('admission window') &&
              lowerMsg.contains('not opened');

          if (shouldOpenCounter) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('forceLoginOnRestart', true);

            final match = RegExp(
              r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z',
            ).firstMatch(msg);

            if (match != null) {
              startAdmissionCountdownFromStartDate(match.group(0)!);
            }

            isCounterScreenOpen.value = false;
            _openCounterScreen(
              message: msg.isEmpty ? "Please wait" : msg,
              page: 'otpScreen',
            );

            isOtpLoading.value = false;
            return;
          }

          await prefs.setBool('isAdmissionCompleted', false);

          await _loadInitialData();

          if (role.toLowerCase() == 'student') {
            await prefs.setBool('isAdmissionCompleted', true);
            Get.offAll(CommonBottomNavigation(initialIndex: 0));
          } else {
            await prefs.setBool('isAdmissionCompleted', false);
            Get.offAll(Admission1(pages: 'otpScreen'));
          }

          isOtpLoading.value = false;
        },
      );
    } catch (e) {
      isOtpLoading.value = false;
      return e.toString();
    }
    return null;
  }

  Future<String?> changeNumberOtpLogin({
    required String phone,
    required String otp,
  }) async {
    try {
      isOtpLoading.value = true;
      final results = await apiDataSource.changeOtpLogin(
        otp: otp,
        phone: phone,
      );
      results.fold(
        (failure) {
          isOtpLoading.value = false;
          CustomSnackBar.showError(failure.message);
          AppLogger.log.e(failure.message);
        },
        (response) async {
          Get.offAll(CommonBottomNavigation(initialIndex: 4));
          isOtpLoading.value = false;
          AppLogger.log.i(response.message);
          // final prefs = await SharedPreferences.getInstance();
          // accessToken = response.token;
          // prefs.setString('token', accessToken);
          // String? token = prefs.getString('token');
          // AppLogger.log.i('token = $token');
        },
      );
    } catch (e) {
      isOtpLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      controller.getStudentHome(),
      controller.getSiblingsData(),
      teacherListController.teacherListData(),
      announcementController.getAnnouncement(),
    ]);
  }

  Future<String?> sendFcmToken(String token) async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.sendFcmToken(token: token);
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
          AppLogger.log.i('I Not sended Fcm Token To Api ');
        },
        (response) async {
          isLoading.value = false;
          AppLogger.log.i('I sended Fcm Token To Api ');
          AppLogger.log.i(response.message);
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.remove('token');
    accessToken = '';
    Get.offAll(() => ChangeMobileNumber(page: 'splash'));
  }

  @override
  void onClose() {
    _otpExpiryTimer?.cancel();
    _admissionTimer?.cancel();
    super.onClose();
  }
}

// import 'dart:async';
// import 'dart:convert';
//
// import 'package:intl/intl.dart';
// import 'package:st_school_project/Core/Utility/snack_bar.dart';
// import 'package:st_school_project/Core/Widgets/consents.dart';
//
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:st_school_project/Presentation/Admssion/Controller/admission_controller.dart';
//
// import '../../../../../../Core/Widgets/bottom_navigationbar.dart';
// import '../../../../../../api/data_source/apiDataSource.dart';
// import '../../../../../Admssion/Screens/admission_1.dart';
// import '../../../Announcements Screen/controller/announcement_controller.dart';
// import '../../../Home Screen/controller/student_home_controller.dart';
// import '../../../Home Screen/home_tab.dart';
// import '../../../Home Screen/model/student_home_response.dart';
// import '../../../counter_screen.dart';
// import '../../change_mobile_number.dart';
// import '../../otp_screen.dart';
// import '../../profile_screen/controller/teacher_list_controller.dart';
//
// class LoginController extends GetxController {
//   RxBool isLoading = false.obs;
//   String accessToken = '';
//   RxBool isOtpLoading = false.obs;
//   final RxBool isOtpBlocked = false.obs;
//   final RxInt admissionTotalSeconds = 0.obs;
//   final RxBool isCounterScreenOpen = false.obs;
//   final Rxn<DateTime> admissionStartAtLocal = Rxn<DateTime>(); // local time
//
//   final RxInt admissionRemainingSeconds = 0.obs;
//   Timer? _admissionTimer;
//   ApiDataSource apiDataSource = ApiDataSource();
//   final StudentHomeController controller = Get.put(StudentHomeController());
//   final AdmissionController admissionController = Get.put(
//     AdmissionController(),
//   );
//   final AnnouncementController announcementController = Get.put(
//     AnnouncementController(),
//   );
//   final TeacherListController teacherListController = Get.put(
//     TeacherListController(),
//   );
//
//   final RxInt resendCooldown = 0.obs;
//   final RxInt otpExpiry = 0.obs;
//   Timer? _otpExpiryTimer;
//
//   @override
//   void onInit() {
//     super.onInit();
//   }
//
//   String get admissionCountdownText {
//     final s = admissionRemainingSeconds.value;
//
//     final hours = (s ~/ 3600).toString().padLeft(2, '0');
//     final minutes = ((s % 3600) ~/ 60).toString().padLeft(2, '0');
//     final seconds = (s % 60).toString().padLeft(2, '0');
//
//     // if more than 1 hour show HH:MM:SS else MM:SS
//     return (s >= 3600) ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
//   }
//
//   String get admissionOpenAtText {
//     final dt = admissionStartAtLocal.value;
//     if (dt == null) return "";
//     return DateFormat(
//       'dd MMM yyyy, hh:mm a',
//     ).format(dt); // 08 Jan 2026, 06:00 PM
//   }
//   void handleHomeAdmissionTapFromAnnouncement(Announcement ann,{required String page}) {
//     final iso = ann.datetime.trim();
//
//     // if datetime missing -> open admission
//     if (iso.isEmpty) {
//       Get.to(() => Admission1(pages: 'homeScreen'));
//       return;
//     }
//
//     DateTime startUtc;
//     try {
//       startUtc = DateTime.parse(iso).toUtc();
//     } catch (_) {
//       // invalid datetime -> open admission
//       Get.to(() => Admission1(pages: 'homeScreen'));
//       return;
//     }
//
//     final nowUtc = DateTime.now().toUtc();
//
//     // ✅ if window not opened yet -> counter
//     if (nowUtc.isBefore(startUtc)) {
//       // start countdown using your existing method (best)
//       startAdmissionCountdownFromStartDate(iso);
//
//       _openCounterScreen(message: ann.message.isEmpty ? "Please wait" : ann.message, page: page);
//       return;
//     }
//
//     // ✅ opened -> go admission
//     Get.to(() => Admission1(pages: 'homeScreen'));
//   }
//
//
//   // Parse "09.Jan.26 – 10.Jan.26"
//   // NOTE: because backend has no time, we assume opening time = 09:00 AM local
//   DateTime? _parseHomeStartDate(String? submessage) {
//     if (submessage == null || submessage.trim().isEmpty) return null;
//
//     final startPart = submessage.split(RegExp(r'–|-')).first.trim();
//     final match = RegExp(r'^(\d{1,2})\.(\w{3})\.(\d{2})$').firstMatch(startPart);
//     if (match == null) return null;
//
//     final day = int.parse(match.group(1)!);
//     final monStr = match.group(2)!.toLowerCase();
//     final yy = int.parse(match.group(3)!);
//
//     const months = {
//       'jan': 1,
//       'feb': 2,
//       'mar': 3,
//       'apr': 4,
//       'may': 5,
//       'jun': 6,
//       'jul': 7,
//       'aug': 8,
//       'sep': 9,
//       'oct': 10,
//       'nov': 11,
//       'dec': 12,
//     };
//
//     final month = months[monStr];
//     if (month == null) return null;
//
//     final year = 2000 + yy;
//
//     // opening time assumption
//     return DateTime(year, month, day, 9, 0, 0);
//   }
//   void startAdmissionCountdownFromSeconds(int seconds, {DateTime? openAtLocal}) {
//     if (seconds <= 0) {
//       stopAdmissionCountdown();
//       return;
//     }
//
//     isOtpBlocked.value = true;
//     admissionRemainingSeconds.value = seconds;
//     admissionTotalSeconds.value = seconds;
//
//     if (openAtLocal != null) {
//       admissionStartAtLocal.value = openAtLocal;
//     } else {
//       admissionStartAtLocal.value = DateTime.now().add(Duration(seconds: seconds));
//     }
//
//     _admissionTimer?.cancel();
//     _admissionTimer = Timer.periodic(const Duration(seconds: 1), (t) {
//       final left = admissionRemainingSeconds.value - 1;
//       if (left <= 0) {
//         stopAdmissionCountdown();
//         t.cancel();
//       } else {
//         admissionRemainingSeconds.value = left;
//       }
//     });
//   }
//
//   void startAdmissionCountdownFromStartDate(String startDateIsoUtc) {
//     final startUtc = DateTime.parse(startDateIsoUtc).toUtc();
//     final startLocal = startUtc.toLocal();
//
//     admissionStartAtLocal.value = startLocal;
//
//     final nowUtc = DateTime.now().toUtc();
//     int diff = startUtc.difference(nowUtc).inSeconds;
//
//     if (diff <= 0) {
//       stopAdmissionCountdown();
//       return;
//     }
//
//     isOtpBlocked.value = true;
//     admissionRemainingSeconds.value = diff;
//     admissionTotalSeconds.value = diff;
//
//     _admissionTimer?.cancel();
//     _admissionTimer = Timer.periodic(const Duration(seconds: 1), (t) {
//       final left = startUtc.difference(DateTime.now().toUtc()).inSeconds;
//
//       if (left <= 0) {
//         stopAdmissionCountdown();
//         t.cancel();
//       } else {
//         admissionRemainingSeconds.value = left;
//       }
//     });
//   }
//
//   void startAdmissionCountdownFromMinutes(int remainingMinutes) {
//     final diff = remainingMinutes * 60;
//     if (diff <= 0) {
//       stopAdmissionCountdown();
//       return;
//     }
//
//     // startAt (approx) -> show expected open time
//     admissionStartAtLocal.value = DateTime.now().add(Duration(seconds: diff));
//
//     isOtpBlocked.value = true;
//     admissionRemainingSeconds.value = diff;
//     admissionTotalSeconds.value = diff;
//
//     _admissionTimer?.cancel();
//     _admissionTimer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (admissionRemainingSeconds.value <= 1) {
//         stopAdmissionCountdown();
//         t.cancel();
//       } else {
//         admissionRemainingSeconds.value--;
//       }
//     });
//   }
//
//   void stopAdmissionCountdown() {
//     _admissionTimer?.cancel();
//     _admissionTimer = null;
//     isOtpBlocked.value = false;
//     admissionRemainingSeconds.value = 0;
//     admissionTotalSeconds.value = 0;
//     admissionStartAtLocal.value = null;
//   }
//
//   Future<String?> sendFcmToken(String token) async {
//     try {
//       isLoading.value = true;
//       final results = await apiDataSource.sendFcmToken(token: token);
//       results.fold(
//         (failure) {
//           isLoading.value = false;
//           AppLogger.log.e(failure.message);
//           AppLogger.log.i('I Not sended Fcm Token To Api ');
//         },
//         (response) async {
//           isLoading.value = false;
//           AppLogger.log.i('I sended Fcm Token To Api ');
//
//           AppLogger.log.i(response.message);
//         },
//       );
//     } catch (e) {
//       isLoading.value = false;
//       AppLogger.log.e(e);
//       return e.toString();
//     }
//     return null;
//   }
//
//   void handleAdmissionWindowError(String failureMessage,{required String page}) {
//     try {
//       final decoded = jsonDecode(failureMessage);
//
//       final code = decoded["code"];
//       final msg = (decoded["message"] ?? "").toString();
//       final data = decoded["data"];
//
//       // ✅ Only open counter for THIS exact case
//       final isAdmissionWindowNotOpened =
//           code == 400 &&
//           msg.toLowerCase().contains("admission window") &&
//           msg.toLowerCase().contains("has not opened");
//
//       if (isAdmissionWindowNotOpened && data != null) {
//         final startDate = data["startDate"];
//         final remainingMinutes = data["remainingMinutes"];
//
//         if (startDate != null && startDate.toString().isNotEmpty) {
//           startAdmissionCountdownFromStartDate(startDate.toString());
//         } else if (remainingMinutes != null) {
//           startAdmissionCountdownFromMinutes(
//             int.parse(remainingMinutes.toString()),
//           );
//         } else {
//           // if no time data, just show msg
//           CustomSnackBar.showError(msg.isEmpty ? "Please wait" : msg);
//           return;
//         }
//
//         _openCounterScreen(message: msg.isEmpty ? "Please wait" : msg, page: page);
//         return;
//       }
//
//       // ✅ other errors like "Application not opened" => normal snackbar only
//       CustomSnackBar.showError(msg.isEmpty ? failureMessage : msg);
//     } catch (_) {
//       // not JSON => normal snackbar
//       CustomSnackBar.showError(failureMessage);
//     }
//   }
//
//   void _openCounterScreen({required String message,required String page}) {
//     // already open -> don't push again
//     if (isCounterScreenOpen.value) return;
//
//     isCounterScreenOpen.value = true;
//
//     Get.to(() => AdmissionCountdownScreen(message: message, pages: page,))?.then((_) {
//       // when user comes back
//       isCounterScreenOpen.value = false;
//     });
//   }
//
//   Future<String?> mobileNumberLogin(String phone) async {
//     try {
//       isLoading.value = true;
//       final results = await apiDataSource.mobileNumberLogin(phone);
//       results.fold(
//         (failure) {
//           isLoading.value = false;
//           AppLogger.log.e(failure.message);
//           CustomSnackBar.showError(failure.message);
//         },
//         (response) async {
//           isLoading.value = false;
//
//           AppLogger.log.i(response.message);
//
//           Get.to(() => OtpScreen(mobileNumber: phone, pages: 'splash'));
//         },
//       );
//     } catch (e) {
//       isLoading.value = false;
//       AppLogger.log.e(e);
//       return e.toString();
//     }
//     return null;
//   }
//
//   Future<String?> changeMobileNumber(String phone) async {
//     try {
//       isLoading.value = true;
//       final results = await apiDataSource.changeMobileNumber(phone);
//       results.fold(
//         (failure) {
//           isLoading.value = false;
//           AppLogger.log.e(failure.message);
//           CustomSnackBar.showError(failure.message);
//           // handleAdmissionWindowError(failure.message);
//         },
//         (response) async {
//           isLoading.value = false;
//
//           AppLogger.log.i(response.message);
//
//           Get.to(() => OtpScreen(mobileNumber: phone, pages: ''));
//         },
//       );
//     } catch (e) {
//       isLoading.value = false;
//       AppLogger.log.e(e);
//       return e.toString();
//     }
//     return null;
//   }
//
//   Future<String?> otpLogin({required String phone, required String otp}) async {
//     try {
//       isOtpLoading.value = true;
//
//       final results = await apiDataSource.otpLogin(otp: otp, phone: phone);
//
//       results.fold(
//         (failure) {
//           isOtpLoading.value = false;
//           CustomSnackBar.showError(failure.message);
//           AppLogger.log.e(failure.message);
//         },
//         (response) async {
//           final prefs = await SharedPreferences.getInstance();
//
//           final String token = (response.token ?? '').toString();
//           final String role = (response.role ?? '').toString();
//           final String msg = (response.message ?? '').toString();
//           final lowerMsg = msg.toLowerCase();
//
//           // ✅ save token/role (optional)
//           if (token.isNotEmpty) {
//             accessToken = token;
//             await prefs.setString('token', token);
//           }
//           await prefs.setString('role', role);
//
//           // ✅ IF message says admission window not opened -> ONLY counter screen
//           final bool shouldOpenCounter =
//               lowerMsg.contains('admission window') &&
//               lowerMsg.contains('not opened');
//
//           if (shouldOpenCounter) {
//             // start timer from ISO date inside message if present
//             final match = RegExp(
//               r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z',
//             ).firstMatch(msg);
//
//             if (match != null) {
//               startAdmissionCountdownFromStartDate(match.group(0)!);
//             }
//
//             _openCounterScreen(message: msg.isEmpty ? "Please wait" : msg, page: 'otpScreen');
//
//             isOtpLoading.value = false;
//             return; // ✅ HARD STOP: DO NOT GO TO ADMISSION SCREEN
//           }
//
//           // ✅ Normal flow ONLY when no message like above
//           await prefs.setBool('isAdmissionCompleted', false);
//
//           final fcmToken = prefs.getString('fcmToken');
//           if (fcmToken != null && fcmToken.isNotEmpty) {
//             await sendFcmToken(fcmToken);
//           }
//
//           await _loadInitialData();
//
//           if (role.toLowerCase() == 'student') {
//             await prefs.setBool('isAdmissionCompleted', true);
//             Get.offAll(CommonBottomNavigation(initialIndex: 0));
//           } else {
//             await prefs.setBool('isAdmissionCompleted', false);
//             Get.offAll(Admission1(pages: 'otpScreen'));
//           }
//
//           isOtpLoading.value = false;
//         },
//       );
//     } catch (e) {
//       isOtpLoading.value = false;
//       AppLogger.log.e(e);
//       return e.toString();
//     }
//     return null;
//   }
//
//   // Future<String?> otpLogin({required String phone, required String otp}) async {
//   //   try {
//   //     isOtpLoading.value = true;
//   //     final results = await apiDataSource.otpLogin(otp: otp, phone: phone);
//   //     results.fold(
//   //       (failure) {
//   //         isOtpLoading.value = false;
//   //         CustomSnackBar.showError(failure.message);
//   //         AppLogger.log.e(failure.message);
//   //
//   //       },
//   //       (response) async {
//   //         AppLogger.log.i(response.message);
//   //         final prefs = await SharedPreferences.getInstance();
//   //         accessToken = response.token;
//   //
//   //         prefs.setString('token', accessToken);
//   //         prefs.setString('role', response.role);
//   //         prefs.setBool('isAdmissionCompleted', false);
//   //
//   //         String? token = prefs.getString('token');
//   //         final fcmToken = prefs.getString('fcmToken');
//   //         sendFcmToken(fcmToken?? '');
//   //         await _loadInitialData();
//   //         if (response.role == 'student') {
//   //           prefs.setBool('isAdmissionCompleted', true);
//   //           Get.offAll(CommonBottomNavigation(initialIndex: 0));
//   //         } else {
//   //           prefs.setBool('isAdmissionCompleted', false);
//   //           Get.offAll(Admission1(pages: 'otpScreen'));
//   //         }
//   //
//   //         isOtpLoading.value = false;
//   //         AppLogger.log.i('token = $token');
//   //       },
//   //     );
//   //   } catch (e) {
//   //     isOtpLoading.value = false;
//   //     AppLogger.log.e(e);
//   //     return e.toString();
//   //   }
//   //   return null;
//   // }
//
//   Future<String?> resentOtp({required String phone}) async {
//     try {
//       isOtpLoading.value = true;
//       final results = await apiDataSource.resentOtp(phone: phone);
//       results.fold(
//         (failure) {
//           isOtpLoading.value = false;
//           CustomSnackBar.showError(failure.message);
//           AppLogger.log.e(failure.message);
//         },
//         (response) async {
//           AppLogger.log.i(response.message);
//           final prefs = await SharedPreferences.getInstance();
//           // accessToken = response.token;
//
//           prefs.setString('token', accessToken);
//           prefs.setBool('isAdmissionCompleted', false);
//
//           String? token = prefs.getString('token');
//           final fcmToken = prefs.getString('fcmToken');
//           sendFcmToken(fcmToken ?? '');
//           await _loadInitialData();
//           // if (response == 'student') {
//           //   prefs.setBool('isAdmissionCompleted', true);
//           //   Get.offAll(CommonBottomNavigation(initialIndex: 0));
//           // } else {
//           //   prefs.setBool('isAdmissionCompleted', false);
//           //   Get.offAll(Admission1());
//           // }
//
//           isOtpLoading.value = false;
//           AppLogger.log.i('token = $token');
//         },
//       );
//     } catch (e) {
//       isOtpLoading.value = false;
//       AppLogger.log.e(e);
//       return e.toString();
//     }
//     return null;
//   }
//
//   Future<void> resentOtpWithTimer(String phone) async {
//     if (resendCooldown.value > 0) return; // prevent spam
//
//     isOtpLoading.value = true;
//     final results = await apiDataSource.resentOtp(phone: phone);
//
//     results.fold(
//       (failure) {
//         isOtpLoading.value = false;
//         CustomSnackBar.showError(failure.message);
//       },
//       (response) {
//         isOtpLoading.value = false;
//         resendCooldown.value = response.meta.nextAllowedIn;
//         otpExpiry.value =
//             response.meta.nextAllowedIn; // same duration for OTP expiry
//         CustomSnackBar.showSuccess(response.message);
//         _startResendTimer();
//         _startOtpExpiryTimer();
//       },
//     );
//   }
//
//   void _startResendTimer() {
//     Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (resendCooldown.value <= 1) {
//         resendCooldown.value = 0;
//         timer.cancel();
//       } else {
//         resendCooldown.value--;
//       }
//     });
//   }
//
//   void _startOtpExpiryTimer() {
//     _otpExpiryTimer?.cancel();
//     _otpExpiryTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (otpExpiry.value <= 1) {
//         otpExpiry.value = 0;
//         timer.cancel();
//         CustomSnackBar.showError("OTP expired. Please resend.");
//       } else {
//         otpExpiry.value--;
//       }
//     });
//   }
//
//   Future<String?> changeNumberOtpLogin({
//     required String phone,
//     required String otp,
//   }) async {
//     try {
//       isOtpLoading.value = true;
//       final results = await apiDataSource.changeOtpLogin(
//         otp: otp,
//         phone: phone,
//       );
//       results.fold(
//         (failure) {
//           isOtpLoading.value = false;
//           CustomSnackBar.showError(failure.message);
//           AppLogger.log.e(failure.message);
//         },
//         (response) async {
//           Get.offAll(CommonBottomNavigation(initialIndex: 4));
//           isOtpLoading.value = false;
//           AppLogger.log.i(response.message);
//           // final prefs = await SharedPreferences.getInstance();
//           // accessToken = response.token;
//           // prefs.setString('token', accessToken);
//           // String? token = prefs.getString('token');
//           // AppLogger.log.i('token = $token');
//         },
//       );
//     } catch (e) {
//       isOtpLoading.value = false;
//       AppLogger.log.e(e);
//       return e.toString();
//     }
//     return null;
//   }
//
//   Future<bool> checkTokenExpire() async {
//     try {
//       final results = await apiDataSource.checkTokenExpire();
//       return await results.fold(
//         (failure) {
//           AppLogger.log.e(failure.message);
//           return false;
//         },
//         (response) async {
//           AppLogger.log.i(response.message);
//
//           final prefs = await SharedPreferences.getInstance();
//
//           if (response.token.isNotEmpty) {
//             accessToken = response.token;
//             await prefs.setString('token', accessToken);
//           } else {
//             accessToken = prefs.getString('token') ?? '';
//           }
//
//           if (response.role.toLowerCase() == 'applicant') {
//             final admissionID = prefs.getInt('admissionId');
//             if (admissionID != null) {
//               await admissionController.getAdmissionDetails(id: admissionID);
//             }
//             return true;
//           }
//
//           await _loadInitialData();
//           return false; // not applicant
//         },
//       );
//     } catch (e) {
//       AppLogger.log.e('Error checking token: $e');
//       return false;
//     }
//   }
//
//   Future<void> _loadInitialData() async {
//     await Future.wait([
//       controller.getStudentHome(),
//       controller.getSiblingsData(),
//       teacherListController.teacherListData(),
//       announcementController.getAnnouncement(),
//     ]);
//   }
//
//   Future<bool> isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     if (token != null && token.isNotEmpty) {
//       accessToken = token;
//       await _loadInitialData();
//       return true;
//     }
//     return false;
//   }
//
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     await prefs.remove('token');
//     accessToken = '';
//     Get.offAll(() => ChangeMobileNumber(page: 'splash'));
//   }
//
//   @override
//   void onClose() {
//     _otpExpiryTimer?.cancel();
//     _admissionTimer?.cancel();
//     super.onClose();
//   }
// }
