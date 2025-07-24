import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';

import '../../../Core/Utility/app_color.dart';
import '../../../Core/Utility/app_images.dart';
import '../../../Core/Utility/google_font.dart';

class SubmitTheAdmission extends StatefulWidget {
  const SubmitTheAdmission({super.key});

  @override
  State<SubmitTheAdmission> createState() => _SubmitTheAdmissionState();
}

class _SubmitTheAdmissionState extends State<SubmitTheAdmission> {
  bool isChecked = false;
  final List<String> points = [
    "I hereby certify that the following information provided by me is correct and I understand that if the information is incorrect or false the ward shall be automatically debarred from the admission without any further notice.",
    "I assure that I will never give any donation / contribution to anybody in the getting admission of the school.",
    "I accept the process of admission undertaken by the school and I will abide by the decision taken by the school authorities.",
    "I assure that I will allow my daughter to attend the Sports / Programmes / Classes given by Male teachers (If needed) appointed by the School Management.",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
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
                    SizedBox(width: 15),
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
                SizedBox(height: 30),
                LinearProgressIndicator(
                  minHeight: 6,
                  value: 1,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
                  stopIndicatorRadius: 16,
                  backgroundColor: AppColor.lowGery1,
                  borderRadius: BorderRadius.circular(16),
                ),
                SizedBox(height: 34),
                Text(
                  'Submit the Admission',
                  style: GoogleFont.ibmPlexSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                  ),
                ),
                SizedBox(height: 22),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 35),
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
                      SizedBox(height: 15),
                      ListView.builder(
                        itemCount: points.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
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
                SizedBox(height: 30),

                CustomContainer.tickContainer(
                  isChecked: isChecked,
                  onTap: () {
                    setState(() {
                      isChecked = !isChecked;
                    });
                  },
                  text:
                      'I have read and understood the instructions furnished above',
                ),
                SizedBox(height: 38),
                AppButton.button(
                  text: 'Pay for Admission',
                  image: AppImages.rightSaitArrow,
                  width: 220,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
