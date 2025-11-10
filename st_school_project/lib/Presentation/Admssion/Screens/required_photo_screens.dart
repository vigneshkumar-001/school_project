import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Admssion/Controller/admission_controller.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/communication_screen.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/submit_the_admission.dart';

class RequiredPhotoScreens extends StatefulWidget {
  final int id;
  const RequiredPhotoScreens({super.key, required this.id});

  @override
  State<RequiredPhotoScreens> createState() => _RequiredPhotoScreensState();
}

class _RequiredPhotoScreensState extends State<RequiredPhotoScreens> {
  final AdmissionController controller = Get.put(AdmissionController());
  List<String> text = [
    "Birth Certificate",
    "Community Certificate",
    "Baptism Certificate",
    "Income Certificate",
    "Proof of Residence",
  ];

  List<bool> isChecked = List.filled(5, false);
  // final List<String> text = [
  //   'New online downloaded birth certifcate',
  //   'Community Certificate',
  //   'Baptism certifcate',
  //   'Parents last received academic certificate',
  //   'Proof of Residence',
  // ];

  String? errorText;

  // void validateAndNavigate() async {
  //   HapticFeedback.heavyImpact();
  //
  //   final areAllSelected = isChecked.every((value) => value);
  //
  //   if (!areAllSelected) {
  //     setState(() => errorText = "Please check all required documents");
  //   } else {
  //     setState(() => errorText = null);
  //
  //     await controller.requiredPhotos(id: widget.id, isChecked: isChecked);
  //
  //     // Navigator.push(
  //     //   context,
  //     //   MaterialPageRoute(builder: (context) => SubmitTheAdmission()),
  //     // );
  //   }
  // }
  void validateAndNavigate() async {
    HapticFeedback.heavyImpact();

    final docs = controller.docsChecklist;

    // If API already has provided == true for all docs, just proceed
    if (docs.isNotEmpty && docs.every((d) => d.provided == true)) {
      await controller.requiredPhotos(id: widget.id, isChecked: isChecked);
      return;
    }

    // Normal validation for first-time users
    final areAllSelected = isChecked.every((value) => value);

    if (!areAllSelected) {
      setState(() => errorText = "Please check all required documents");
      return;
    }

    setState(() => errorText = null);
    await controller.requiredPhotos(id: widget.id, isChecked: isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.1, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header
                  Row(
                    children: [
                      CustomContainer.leftSaitArrow(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final admissionId = prefs.getInt('admissionId') ?? 0;

                          Get.off(CommunicationScreen(id: admissionId));
                        },
                      ),
                      // InkWell(
                      //   onTap: () => Navigator.pop(context),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: AppColor.lightGrey,
                      //       border: Border.all(color: AppColor.lowLightBlue),
                      //       borderRadius: BorderRadius.circular(30),
                      //     ),
                      //     padding: const EdgeInsets.all(10),
                      //     child: Image.asset(
                      //       AppImages.leftArrow,
                      //       height: 12,
                      //       width: 12,
                      //     ),
                      //   ),
                      // ),
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
                  // Progress bar
                  LinearProgressIndicator(
                    minHeight: 6,
                    value: 0.9,
                    valueColor: AlwaysStoppedAnimation(AppColor.blue),
                    backgroundColor: AppColor.lowGery1,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  const SizedBox(height: 40),

                  // Title
                  CustomTextField.textWith600(
                    text: 'Required Xerox Copies',
                    fontSize: 26,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField.textWithSmall(
                    text:
                        'Required Xerox copies of the certificates to be attached with the downloaded application form',
                    color: AppColor.grey,
                    fontSize: 14,
                  ),

                  const SizedBox(height: 20),
                  CustomTextField.textWithSmall(
                    text: 'Xerox copy of',
                    color: AppColor.lightBlack,
                    fontSize: 20,
                  ),
                  const SizedBox(height: 20),

                  // Checkboxes
                  // Column(
                  //   children: List.generate(text.length, (index) {
                  //     return Padding(
                  //       padding: const EdgeInsets.only(bottom: 10),
                  //       child: CustomContainer.tickContainer(
                  //         text2:
                  //             index == 2
                  //                 ? 'for Catholics'
                  //                 : index == 4
                  //                 ? 'Ration Card | Aadhar Card | Voter Id'
                  //                 : '',
                  //         text: text[index],
                  //         isChecked: isChecked[index],
                  //         borderColor:
                  //             (errorText != null && !isChecked[index])
                  //                 ? AppColor.lightRed
                  //                 : isChecked[index]
                  //                 ? AppColor.blue
                  //                 : AppColor.lowLightBlue,
                  //         onTap: () {
                  //           setState(() {
                  //             isChecked[index] = !isChecked[index];
                  //             if (isChecked.every((e) => e)) {
                  //               errorText = null;
                  //             }
                  //           });
                  //         },
                  //       ),
                  //     );
                  //   }),
                  // ),
                  Obx(() {
                    final docs = controller.docsChecklist;

                    // ✅ CASE 1: API gave no docs list → user first time, show all to choose
                    if (docs.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(text.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomContainer.tickContainer(
                              text2:
                                  index == 2
                                      ? 'for Catholics'
                                      : index == 4
                                      ? 'Ration Card | Aadhar Card | Voter Id'
                                      : '',
                              text: text[index],
                              isChecked: isChecked[index],
                              borderColor:
                                  (errorText != null && !isChecked[index])
                                      ? AppColor.lightRed
                                      : isChecked[index]
                                      ? AppColor.blue
                                      : AppColor.lowLightBlue,
                              onTap: () {
                                setState(() {
                                  isChecked[index] = !isChecked[index];
                                  if (isChecked.every((e) => e)) {
                                    errorText = null;
                                  }
                                });
                              },
                            ),
                          );
                        }),
                      );
                    }

                    // ✅ CASE 2: API returned docs, show only provided == true (non-editable)
                    final checkedDocs =
                        docs.where((d) => d.provided == true).toList();

                    if (checkedDocs.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(checkedDocs.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CustomContainer.tickContainer(
                            text2:
                                index == 2
                                    ? 'for Catholics'
                                    : index == 4
                                    ? 'Ration Card | Aadhar Card | Voter Id'
                                    : '',
                            text:
                                text[index], // no label since you said don’t show name
                            isChecked: true,
                            borderColor: AppColor.blue,
                            onTap: () {

                            }, // disabled
                          ),
                        );
                      }),
                    );
                  }),

                  if (errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 10),
                      child: Text(
                        errorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),

                  // Note Box
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColor.lightRed.withOpacity(0.1),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: CustomTextField.richText(
                      secondFontSize: 12,
                      firstFontSize: 12,
                      text1Color: AppColor.lightRed,
                      text2Color: AppColor.lightRed,
                      fontWeight1: FontWeight.w600,
                      isBold: true,
                      text: 'Note',
                      text2:
                          '  If any of the above requirements are not provided the application will be rejected without any notice.',
                    ),
                  ),

                  const SizedBox(height: 30),

                  Obx(
                    () => AppButton.button(
                      loader:
                          controller.isLoading.value
                              ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                              : null,
                      onTap:
                          controller.isLoading.value
                              ? null
                              : validateAndNavigate,
                      text: 'Save & Continue',
                      image: AppImages.rightSaitArrow,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
