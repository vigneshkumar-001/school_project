import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';

import '../../../Core/Utility/app_color.dart';
import '../../../Core/Utility/app_images.dart';
import '../../../Core/Utility/google_font.dart';
import '../../../Core/Widgets/custom_textfield.dart';

class CheckAdmissionStatus extends StatefulWidget {
  const CheckAdmissionStatus({super.key});

  @override
  State<CheckAdmissionStatus> createState() => _CheckAdmissionStatusState();
}

class _CheckAdmissionStatusState extends State<CheckAdmissionStatus> {
  void _paymentReceipt(BuildContext context) {
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
                                        'SJIG9M4JK',
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
                        onTap: () {
                          setState(() {});
                        },
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.lightGrey,
                      border: Border.all(
                        color: AppColor.lowLightBlue,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        AppImages.leftArrow,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
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
                        text: 'Admission Id',
                        verticalDivider: true,
                        flex: 2,
                      ),
                    ),
                    Expanded(
                      child: CustomContainer.checkMark(
                        onTap: () {},
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
                CustomContainer.myadmissions(
                  imagepath: AppImages.clockIcon,
                  iconColor: AppColor.blue,
                  backRoundColors: AppColor.checkAdmissCont1,
                  iconTextColor: AppColor.blue,
                  maintext: 'Suganya M',
                  subtext1: 'Submitted On ',
                  subtext2: '25 Jul 2025',
                  iconText: 'Pending',
                  onTap: () => _paymentReceipt(context),
                ),
                SizedBox(height: 20),
                CustomContainer.myadmissions(
                  imagepath: AppImages.approvedImage,
                  iconColor: AppColor.greenMore1,
                  backRoundColors: AppColor.checkAdmissCont2,
                  iconTextColor: AppColor.greenMore1,
                  maintext: 'Suganya M',
                  subtext1: 'Submitted On ',
                  subtext2: '25 Jul 2025',
                  iconText: 'Approved',
                ),
                SizedBox(height: 20),
                CustomContainer.myadmissions(
                  imagepath: AppImages.rejectedImage,
                  iconColor: AppColor.lightRed,
                  backRoundColors: AppColor.checkAdmissCont3,
                  iconTextColor: AppColor.lightRed,
                  maintext: 'Suganya M',
                  subtext1: 'Submitted On ',
                  subtext2: '25 Jul 2025',
                  iconText: 'Rejected',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
