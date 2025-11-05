import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math' as math;
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/snack_bar.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Core/Widgets/swicth_profile_sheet.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen/controller/fees_history_controller.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen/controller/teacher_list_controller.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen/screen/profile_screen.dart';
import '../../../../Core/Utility/app_color.dart' show AppColor;
import '../../../../Core/Utility/google_font.dart' show GoogleFont;
import '../../../../Core/Widgets/date_and_time_convert.dart';
import '../../../../payment_web_view.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More Screen/profile_screen/model/fees_history_response.dart';

import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:st_school_project/Core/Utility/app_loader.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Presentation/Admssion/Controller/admission_controller.dart';

import '../../../Core/Utility/app_color.dart';
import '../../../Core/Utility/app_images.dart';
import '../../../Core/Utility/google_font.dart';
import '../../../Core/Widgets/bottom_navigationbar.dart';
import '../../../Core/Widgets/custom_textfield.dart';
import '../../Onboarding/Screens/Home Screen/home_tab.dart';

class CheckAdmissionStatus extends StatefulWidget {
  const CheckAdmissionStatus({super.key});

  @override
  State<CheckAdmissionStatus> createState() => _CheckAdmissionStatusState();
}

class _CheckAdmissionStatusState extends State<CheckAdmissionStatus> {
  final AdmissionController controller = Get.put(AdmissionController());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _admissionIdController = TextEditingController();

  void _paymentReceipt(BuildContext context, String url, String admissionNo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.80,
          minChildSize: 0.20,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColor.grayop,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Image.asset(AppImages.paidImage, height: 98),
                      SizedBox(height: 14),
                      Text(
                        'Rs. 3500',
                        style: GoogleFont.ibmPlexSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 34,
                          color: AppColor.greenMore1,
                        ),
                      ),
                      Text(
                        'Paid to Third term fees',
                        style: GoogleFont.ibmPlexSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: AppColor.lightBlack,
                        ),
                      ),
                      SizedBox(height: 34),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.0),
                        child: DottedLine(
                          dashColor: AppColor.grayop,
                          dashGapLength: 6,
                          dashLength: 7,
                        ),
                      ),
                      SizedBox(height: 40),
                      Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              AppImages.examResultBCImage,
                              height: 250,
                              width: 280,
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.lightGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(17.0),
                                      child: Image.asset(
                                        AppImages.receiptNo,
                                        height: 24,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Receipt No',
                                        style: GoogleFont.ibmPlexSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: AppColor.grey,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'GJGFH87GHJG8II',
                                        style: GoogleFont.ibmPlexSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: AppColor.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 25),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.lightGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(17.0),
                                      child: Image.asset(
                                        AppImages.admissionNo,
                                        height: 24,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Admission No',
                                        style: GoogleFont.ibmPlexSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: AppColor.grey,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        admissionNo,
                                        style: GoogleFont.ibmPlexSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: AppColor.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 25),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.lightGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(17.0),
                                      child: Image.asset(
                                        AppImages.timeImage,
                                        height: 24,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Time',
                                        style: GoogleFont.ibmPlexSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: AppColor.grey,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      RichText(
                                        text: TextSpan(
                                          text: '12.00Pm   ',
                                          style: GoogleFont.ibmPlexSans(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: AppColor.black,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '16 Jun 2025',
                                              style: GoogleFont.ibmPlexSans(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                                color: AppColor.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.0),
                        child: DottedLine(
                          dashColor: AppColor.grayop,
                          dashGapLength: 6,
                          dashLength: 7,
                        ),
                      ),
                      SizedBox(height: 40),
                      GestureDetector(
                        onTap: () async => _downloadAndOpenPdf(url),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 27,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColor.blue,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppImages.downloadImage,
                                    height: 20,
                                  ),
                                  SizedBox(width: 10),
                                  CustomTextField.textWithSmall(
                                    text: 'Download Receipt',
                                    color: AppColor.blue,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    controller.geStatusCheck(admissionId: 0);
  }

  void searchAdmission() {
    final text = _admissionIdController.text.trim();

    if (text.isEmpty) {
      controller.geStatusCheck(admissionId: 0);

      return;
    }

    final id = int.tryParse(text) ?? 0;

    controller.geStatusCheck(admissionId: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer.leftSaitArrow(
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(height: 33),
                Text(
                  'Check Admission Status',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: AppColor.black,
                  ),
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: CustomContainer.studentInfoScreen(
                        controller: _admissionIdController,
                        text: 'Admission Id',
                        verticalDivider: true,
                        flex: 2,
                      ),
                    ),
                    Expanded(
                      child: CustomContainer.checkMark(
                        onTap: () {
                          FocusScope.of(context).unfocus(); // ✅ Hide keyboard
                          searchAdmission(); // ✅ Call your search function
                        },
                        imagePath: AppImages.searchImage,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    text: '2025-26 result will be updated on',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 12,
                      color: AppColor.lowGrey,
                    ),
                    children: [
                      TextSpan(
                        text: ' 25th May',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 12,
                          color: AppColor.lightBlack,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35),
                Text(
                  'My Admissions',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColor.lightBlack,
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(child: AppLoader.circularLoader());
                    }
                    if (controller.statusData.isEmpty) {
                      return const Center(child: Text('No Data Found'));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.statusData.length,
                      itemBuilder: (context, index) {
                        final data = controller.statusData[index];
                        final status = (data.status ?? 'pending').toLowerCase();

                        String imagePath;
                        Color iconColor;
                        Color bgColor;

                        switch (status) {
                          case 'approved':
                            imagePath = AppImages.approvedImage;
                            iconColor = AppColor.greenMore1;
                            bgColor = AppColor.checkAdmissCont2;
                            break;

                          case 'rejected':
                            imagePath = AppImages.rejectedImage;
                            iconColor = AppColor.lightRed;
                            bgColor = AppColor.checkAdmissCont3;
                            break;

                          default:
                            imagePath = AppImages.clockIcon;
                            iconColor = AppColor.blue;
                            bgColor = AppColor.checkAdmissCont1;
                            break;
                        }

                        return Column(
                          children: [
                            CustomContainer.myadmissions(
                              imagepath: AppImages.clockIcon,
                              iconColor: iconColor,
                              backRoundColors: bgColor,
                              iconTextColor: iconColor,
                              maintext: data.studentName.toString() ?? '',
                              subtext1: 'Submitted On ',
                              subtext2:
                                  data.submittedAt != null &&
                                          data.submittedAt!.isNotEmpty
                                      ? DateAndTimeConvert.formatDateTime(
                                        showDate: true,
                                        showTime: false,
                                        data.submittedAt!,
                                      )
                                      : '',

                              iconText: 'Pending',
                              onTap: () {
                                AppLogger.log.i(data.downloadUrl);
                                _downloadAndOpenPdf(data.downloadUrl);
                              },
                            ),
                            SizedBox(height: 20),
                          ],
                        );
                      },
                    );
                  }),
                ),
                // CustomContainer.myadmissions(
                //   imagepath: AppImages.clockIcon,
                //   iconColor: AppColor.blue,
                //   backRoundColors: AppColor.checkAdmissCont1,
                //   iconTextColor: AppColor.blue,
                //   maintext: 'Suganya M',
                //   subtext1: 'Submitted On ',
                //   subtext2: '25 Jul 2025',
                //   iconText: 'Pending',
                //   onTap: () => _paymentReceipt(context),
                // ),
                // SizedBox(height: 20),
                // CustomContainer.myadmissions(
                //   imagepath: AppImages.approvedImage,
                //   iconColor: AppColor.greenMore1,
                //   backRoundColors: AppColor.checkAdmissCont2,
                //   iconTextColor: AppColor.greenMore1,
                //   maintext: 'Suganya M',
                //   subtext1: 'Submitted On ',
                //   subtext2: '25 Jul 2025',
                //   iconText: 'Approved',
                // ),
                // SizedBox(height: 20),
                // CustomContainer.myadmissions(
                //   imagepath: AppImages.rejectedImage,
                //   iconColor: AppColor.lightRed,
                //   backRoundColors: AppColor.checkAdmissCont3,
                //   iconTextColor: AppColor.lightRed,
                //   maintext: 'Suganya M',
                //   subtext1: 'Submitted On ',
                //   subtext2: '25 Jul 2025',
                //   iconText: 'Rejected',
                // ),
                // SizedBox(height: 30),
                // AppButton.button(
                //   text: 'Home Page',
                //   onTap: () {
                //     HapticFeedback.heavyImpact();
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => CommonBottomNavigation(),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _downloadAndOpenPdf(String url) async {
    if (url.isEmpty) {
      Get.snackbar('Error', 'Download URL not available');
      return;
    }

    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        bool openSettings = await Get.dialog(
          AlertDialog(
            title: Text('Permission Required'),
            content: Text(
              'Storage permission is required to download the receipt. Please enable it.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text('OK'),
              ),
            ],
          ),
          barrierDismissible: false,
        );

        if (openSettings) {
          bool isOpened = await openAppSettings();
          if (!isOpened) {
            Get.snackbar('Error', 'Cannot open settings');
            return;
          }

          status = await Permission.manageExternalStorage.request();
          if (!status.isGranted) {
            Get.snackbar('Permission Denied', 'Storage permission not granted');
            return;
          }
        } else {
          return;
        }
      }
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        Get.back();

        CustomSnackBar.showError('Failed to download file');
        return;
      }

      Directory dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final file = File(
        '${dir.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(response.bodyBytes);

      Get.back();
      CustomSnackBar.showSuccess('PDF saved to ${file.path}');
      // Get.snackbar(
      //   'Success',
      //   'PDF saved to ${file.path}',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green.shade600,
      //   colorText: Colors.white,
      //   borderRadius: 12,
      //   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      //   icon: Icon(Icons.check_circle_outline, color: Colors.white),
      //   shouldIconPulse: false,
      //   duration: Duration(seconds: 3),
      //   snackStyle: SnackStyle.FLOATING,
      //   padding: EdgeInsets.all(16),
      // );

      // Share PDF
    } catch (e) {
      Get.back();
      CustomSnackBar.showError(e.toString());
    }
  }
}
