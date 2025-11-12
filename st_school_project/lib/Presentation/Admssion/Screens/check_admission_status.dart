import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';

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
  final String? page;
  final bool showBackArrow;
  const CheckAdmissionStatus({super.key, this.page, this.showBackArrow = true});

  @override
  State<CheckAdmissionStatus> createState() => _CheckAdmissionStatusState();
}

class _CheckAdmissionStatusState extends State<CheckAdmissionStatus> {
  final AdmissionController controller = Get.put(AdmissionController());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _admissionIdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.geStatusCheck(admissionId: 0);
    });
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
    return WillPopScope(
      onWillPop: () async {
        return await false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.page == "homeScreen")
                    CustomContainer.leftSaitArrow(
                      onTap: () {
                        Get.offAll(HomeTab());
                      },
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
                          onChanged: (text) {
                            searchAdmission();
                          },
                          controller: _admissionIdController,
                          text: 'Admission Id',
                          verticalDivider: true,
                          flex: 2,
                        ),
                      ),
                      Expanded(
                        child: CustomContainer.checkMark(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            searchAdmission();
                          },
                          imagePath: AppImages.searchImage,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      text: '2025-26 result will be updated',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 12,
                        color: AppColor.lowGrey,
                      ),
                      children: [
                        TextSpan(
                          text: '',
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
                        itemCount: controller.statusData.length,
                        itemBuilder: (context, index) {
                          final data = controller.statusData[index];
                          final status = (data.status).toLowerCase();

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
                              imagePath = AppImages.pending;
                              iconColor = AppColor.blue;
                              bgColor = AppColor.checkAdmissCont1;
                              break;
                          }

                          return Column(
                            children: [
                              CustomContainer.myadmissions(
                                imagepath: imagePath,
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

                                iconText: data.status.toUpperCase(),
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
        await Permission.manageExternalStorage.request();
        if (!await Permission.manageExternalStorage.isGranted) {
          Get.snackbar('Permission Denied', 'Storage permission not granted');
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

      final filename = 'receipt_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final bytes = response.bodyBytes;

      //  Use MediaStore insert for Android 10+
      if (Platform.isAndroid) {
        const channel = MethodChannel('file_downloader');
        final result = await channel.invokeMethod('saveToDownloads', {
          'name': filename,
          'bytes': bytes,
        });

        Get.back();
        if (result == true) {
          CustomSnackBar.showSuccess('PDF saved in Downloads');
        } else {
          CustomSnackBar.showError('Failed to save to Downloads');
        }
      } else {
        // iOS fallback
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$filename');
        await file.writeAsBytes(bytes);
        Get.back();
        CustomSnackBar.showSuccess('PDF saved to ${file.path}');
        await OpenFilex.open(file.path);
      }
    } catch (e) {
      Get.back();
      CustomSnackBar.showError(e.toString());
    }
  }
}
