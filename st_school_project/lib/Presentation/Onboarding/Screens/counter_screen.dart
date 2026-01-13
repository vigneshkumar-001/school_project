import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Core/Utility/app_color.dart';
import '../../../Core/Utility/google_font.dart';
import '../../Admssion/Screens/admission_1.dart';
import 'More Screen/Login_screen/controller/login_controller.dart';

class AdmissionCountdownScreen extends StatefulWidget {
  final String message;
  final String pages;
  const AdmissionCountdownScreen({
    super.key,
    required this.message,
    required this.pages,
  });

  @override
  State<AdmissionCountdownScreen> createState() =>
      _AdmissionCountdownScreenState();
}

class _AdmissionCountdownScreenState extends State<AdmissionCountdownScreen> {
  final LoginController loginController = Get.find<LoginController>();

  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.pages == 'homeScreen';
      },
      child: Scaffold(
        backgroundColor: AppColor.white,

        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading:
              widget.pages == 'homeScreen'
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  )
                  : SizedBox.shrink(),
          title: Text(
            "Please wait",
            style: GoogleFont.ibmPlexSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColor.lightBlack,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Obx(() {
                final sec = loginController.admissionRemainingSeconds.value;

                final total =
                    loginController.admissionTotalSeconds.value == 0
                        ? (sec == 0 ? 1 : sec)
                        : loginController.admissionTotalSeconds.value;

                final progress = (1 - (sec / total)).clamp(0.0, 1.0);

                // ✅ when countdown finished -> go to Admission screen (ONLY ONCE)
                if (!_navigated &&
                    !loginController.isOtpBlocked.value &&
                    sec == 0) {
                  _navigated = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Get.offAll(() => Admission1(pages: widget.pages));
                  });
                }

                final openAtText = loginController.admissionOpenAtText;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColor.lightGrey,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColor.black.withOpacity(0.08)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 72,
                        width: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColor.black.withOpacity(0.08),
                          ),
                        ),
                        child: const Icon(Icons.lock_clock, size: 34),
                      ),
                      const SizedBox(height: 14),

                      Text(
                        'Announcement phase - The admission window will open at: $openAtText',
                        textAlign: TextAlign.center,
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightBlack,
                        ),
                      ),

                      //
                      // if (openAtText.isNotEmpty) ...[
                      //   const SizedBox(height: 8),
                      //   Text(
                      //     "Opens at: $openAtText",
                      //     textAlign: TextAlign.center,
                      //     style: GoogleFont.ibmPlexSans(
                      //       fontSize: 13,
                      //       fontWeight: FontWeight.w600,
                      //       color: AppColor.grayop,
                      //     ),
                      //   ),
                      // ],
                      const SizedBox(height: 18),

                      Text(
                        loginController.admissionCountdownText,
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 44,
                          fontWeight: FontWeight.w800,
                          color: AppColor.lightBlack,
                        ),
                      ),
                      const SizedBox(height: 10),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        "Redirecting automatically when it opens...",
                        textAlign: TextAlign.center,
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColor.grayop,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
