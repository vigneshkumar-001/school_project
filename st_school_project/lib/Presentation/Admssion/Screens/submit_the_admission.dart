import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Presentation/Admssion/Controller/admission_controller.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/check_admission_status.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/required_photo_screens.dart';
import 'admission_payment_success.dart';

class SubmitTheAdmission extends StatefulWidget {
  final int id;
  final String pages;
  const SubmitTheAdmission({super.key, required this.id, required this.pages});

  @override
  State<SubmitTheAdmission> createState() => _SubmitTheAdmissionState();
}

class _SubmitTheAdmissionState extends State<SubmitTheAdmission> {
  final AdmissionController controller = Get.put(AdmissionController());
  bool isChecked = false;
  bool showError = false;

  final List<String> points = [
    "I hereby certify that the following information provided by me is correct and I understand that if the information is incorrect or false the ward shall be automatically debarred from the admission without any further notice.",
    "I assure that I will never give any donation / contribution to anybody in the getting admission of the school.",
    "I accept the process of admission undertaken by the school and I will abide by the decision taken by the school authorities.",
    "I assure that I will allow my daughter to attend the Sports / Programmes / Classes given by Male teachers (If needed) appointed by the School Management.",
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> validateAndSubmit() async {
    HapticFeedback.heavyImpact();

    final apiConsent =
        controller.currentAdmission.value?.consentAccepted ?? false;

    // If API already accepted consent, skip validation
    if (apiConsent == true) {
      await controller.submitAdmission(
        id: widget.id,
        isChecked: true,
        page: widget.pages,
      );
      return;
    }

    // If user hasn't checked the box, show error
    if (!isChecked) {
      setState(() => showError = true);
      return;
    }

    setState(() => showError = false);
    await controller.submitAdmission(
      id: widget.id,
      isChecked: isChecked,
      page: widget.pages,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final prefs = await SharedPreferences.getInstance();
        final admissionId = prefs.getInt('admissionId') ?? 0;
        Get.off(RequiredPhotoScreens(id: admissionId, pages: widget.pages));
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  children: [
                    CustomContainer.leftSaitArrow(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final admissionId = prefs.getInt('admissionId') ?? 0;
                        Get.off(
                          RequiredPhotoScreens(
                            id: admissionId,
                            pages: widget.pages,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 15),
                    Text(
                      '2025 - 2026 LKG Admission',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                /// Progress bar
                LinearProgressIndicator(
                  minHeight: 6,
                  value: 1,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
                  backgroundColor: AppColor.lowGery1,
                  borderRadius: BorderRadius.circular(16),
                ),
                const SizedBox(height: 20),

                /// Title
                Text(
                  'Submit the Admission',
                  style: GoogleFont.ibmPlexSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 20),

                /// Instructions box
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.lowGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instructions',
                        style: GoogleFont.ibmPlexSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColor.lightBlack,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ListView.builder(
                        itemCount: points.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${index + 1}. ",
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    points[index],
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 12,
                                      height: 1.5,
                                      color: AppColor.lightBlack,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                /// Consent Checkbox Logic
                Obx(() {
                  final apiConsent =
                      controller.currentAdmission.value?.consentAccepted ??
                      false;

                  // API says consent already given → show prechecked and disabled
                  if (apiConsent) {
                    return CustomContainer.tickContainer(
                      isChecked: true,
                      borderColor: AppColor.blue,
                      onTap: () {}, // disable tapping
                      text:
                          'I have read and understood the instructions furnished above',
                    );
                  }

                  // API no consent yet → user must check
                  return CustomContainer.tickContainer(
                    isChecked: isChecked,
                    borderColor:
                        showError
                            ? AppColor.lightRed
                            : isChecked
                            ? AppColor.blue
                            : AppColor.lowLightBlue,
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                        showError = !isChecked;
                      });
                    },
                    text:
                        'I have read and understood the instructions furnished above',
                  );
                }),

                if (showError)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Please accept before continuing",
                      style: TextStyle(color: AppColor.lightRed, fontSize: 13),
                    ),
                  ),

                const SizedBox(height: 38),

                /// Submit button
                Obx(
                  () => AppButton.button(

                    loader:
                        controller.isLoading.value
                            ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                            : null,
                    text: 'Pay for Admission Form',
                    image: AppImages.rightSaitArrow,
                    width: 250,
                    // onTap: (){
                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckAdmissionStatus()));
                    // }
                     onTap:
                         controller.isLoading.value ? null : validateAndSubmit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

