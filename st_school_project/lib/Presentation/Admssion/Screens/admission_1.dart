import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/student_info_screen.dart';

import '../Controller/admission_controller.dart';
import 'check_admission_status.dart';

class Admission1 extends StatefulWidget {
  final String? pages;
  const Admission1({super.key, this.pages});

  @override
  State<Admission1> createState() => _Admission1State();
}

class _Admission1State extends State<Admission1> {
  // final List<String> points = [
  //   "I hereby certify that the following information provided by me is correct and I understand that if the information is incorrect or false the ward shall be automatically debarred from the admission without any further notice.",
  //   "I assure that I will never give any donation / contribution to anybody in the getting admission of the school.",
  //   "I accept the process of admission undertaken by the school and I will abide by the decision taken by the school authorities.",
  //   "I assure that I will allow my daughter to attend the Sports / Programmes / Classes given by Male teachers (If needed) appointed by the School Management.",
  // ];
  final AdmissionController admissionController = Get.put(
    AdmissionController(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    admissionController.getAdmissions();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final isLoading = admissionController.isLoading.value;
          final admissionList = admissionController.admissionList;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (admissionList.isEmpty) {
            return Center(
              child: Text(
                'No admission data available',
                style: GoogleFont.ibmPlexSans(fontSize: 16),
              ),
            );
          }

          final admission = admissionList.first; // Use first or show list later

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomContainer.leftSaitArrow(
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    // Remove fixed height and use constraints
                    constraints: BoxConstraints(minHeight: screenHeight * 0.70),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            admission.bannerUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: screenHeight * 0.22,
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.25,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.blackG1.withOpacity(0.7),
                                AppColor.black.withOpacity(0.0),
                                Colors.transparent,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.white,
                                ),
                              ),
                              Text(
                                admission.title,
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.white,
                                ),
                              ),
                              Text(
                                admission.academicYear,
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w900,
                                  color: AppColor.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          top: screenHeight * 0.19,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColor.lowLightBlueG1,
                                  AppColor.white,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // 'Instructions',
                                  admission.introText,
                                  style: GoogleFont.ibmPlexSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: AppColor.lightBlack,
                                  ),
                                ),
                                //   SizedBox(height: 10),
                                // if (admission.introText.isNotEmpty)
                                //   Text(
                                //     admission.introText,
                                //     style: GoogleFont.ibmPlexSans(
                                //       fontSize: 13,
                                //       height: 1.5,
                                //       color: AppColor.lightBlack,
                                //     ),
                                //   ),
                                SizedBox(height: 15),
                                ListView.builder(
                                  itemCount: admission.instructions.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.0,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              admission.instructions[index],
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),

                  // AppButton.button(
                  //   onTap: () {
                  //     final id = admissionController.admissionList[0].id;
                  //     AppLogger.log.i(id);
                  //     HapticFeedback.heavyImpact();
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder:
                  //             (context) => StudentInfoScreen(admissionId: id),
                  //       ),
                  //     );
                  //   },
                  //   text:
                  //       widget.pages == "otpScreen"
                  //           ? 'Create New Admission'
                  //           : 'Next Step',
                  //   width: 250,
                  //   image: AppImages.rightSaitArrow,
                  // ),
                  AppButton.button(
                    onTap: () async {
                      if (admissionController.admissionList.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No admission record available'),
                          ),
                        );
                        return;
                      }

                      final id = admissionController.admissionList.first.id;
                      if (id == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid admission ID')),
                        );
                        return;
                      }
                      HapticFeedback.heavyImpact();
                      AppLogger.log.i(' Proceeding to next step for ID: $id');

                      await admissionController.postAdmission1NextButton(
                        id: id,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StudentInfoScreen(admissionId: id),
                        ),
                      );
                    },
                    text:
                        widget.pages == "otpScreen"
                            ? 'Create New Admission'
                            : 'Next Step',
                    width: 250,
                    image: AppImages.rightSaitArrow,
                  ),

                  if (widget.pages == "otpScreen")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckAdmissionStatus(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              children: [
                                Text(
                                  'Check Admission Status',
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.blueG2,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Image.asset(AppImages.rightArrow, height: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
