import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/app_loader.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/bottom_navigationbar.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';

import '../../../noDataFound_screen.dart';
import '../Controller/admission_controller.dart';
import 'check_admission_status.dart';

class Admission1 extends StatefulWidget {
  final String? pages;
  const Admission1({super.key, this.pages});

  @override
  State<Admission1> createState() => _Admission1State();
}

class _Admission1State extends State<Admission1> {
  final AdmissionController admissionController = Get.put(
    AdmissionController(),
  );
  DateTime? _lastBackPressedAt;

  Future<bool> _handleBackPress() async {
    if (widget.pages == 'otpScreen') {
      final now = DateTime.now();
      if (_lastBackPressedAt != null &&
          now.difference(_lastBackPressedAt!) <= const Duration(seconds: 2)) {
        await SystemNavigator.pop();
        return false;
      }

      _lastBackPressedAt = now;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit the app.'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const CommonBottomNavigation(initialIndex: 0),
      ),
      (route) => false,
    );
    return false;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      admissionController.getAdmissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _handleBackPress,
      child: Scaffold(
        body: SafeArea(
          child: Obx(() {
            final isLoading = admissionController.isLoading.value;
            final admissionList = admissionController.admissionList;

            if (isLoading) {
              return Center(child: AppLoader.circularLoader());
            }

            if (admissionList.isEmpty) {
              return NoDataFoundScreen(page: widget.pages ?? '');
            }

            final admission = admissionList.first;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              children: [
                Row(
                  children: [
                    CustomContainer.leftSaitArrow(
                      onTap: () async {
                        await _handleBackPress();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// Banner Section
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: admission.bannerUrl,
                        width: double.infinity,
                        height: screenHeight * 0.22,
                        fit: BoxFit.cover,

                        placeholder:
                            (context, url) => Container(
                              height: screenHeight * 0.22,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
                            ),

                        errorWidget:
                            (context, url, error) => Container(
                              height: screenHeight * 0.22,
                              color: Colors.grey.shade300,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image, size: 40),
                            ),
                      ),
                    ),

                    Container(
                      height: screenHeight * 0.22,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColor.blackG1.withOpacity(0.7),
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
                  ],
                ),

                const SizedBox(height: 20),

                /// Instructions Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColor.lowLightBlueG1, AppColor.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        admission.introText,
                        style: GoogleFont.ibmPlexSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColor.lightBlack,
                        ),
                      ),

                      const SizedBox(height: 15),

                      ListView.builder(
                        itemCount: admission.instructions.length,
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

                const SizedBox(height: 20),

                /// Button
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

                    HapticFeedback.heavyImpact();

                    await admissionController.postAdmission1NextButton(
                      id: id,
                      sourcePage: widget.pages,
                    );
                  },
                  text:
                      widget.pages == "otpScreen"
                          ? 'Create New Admission'
                          : 'Next Step',
                  width: 250,
                  image: AppImages.rightSaitArrow,
                ),

                /// Check Admission Status
                if (widget.pages == "otpScreen")
                  Center(
                    child: InkWell(
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
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Check Admission Status',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColor.blueG2,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Image.asset(AppImages.rightArrow, height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
