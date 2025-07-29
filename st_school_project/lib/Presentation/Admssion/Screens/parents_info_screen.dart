import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/siblings_form_screen.dart';

class ParentsInfoScreen extends StatefulWidget {
  const ParentsInfoScreen({super.key});

  @override
  State<ParentsInfoScreen> createState() => _ParentsInfoScreenState();
}

class _ParentsInfoScreenState extends State<ParentsInfoScreen> {
  String selected = 'Father & Mother';
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _mobileController = TextEditingController();
  final englishController = TextEditingController();
  final tamilController = TextEditingController();
  final fatherOccupation = TextEditingController();
  final fatherQualification = TextEditingController();
  final fatherAnnualIncome = TextEditingController();
  final officeAddress = TextEditingController();
  final motherQualification = TextEditingController();
  final motherOccupation = TextEditingController();
  final motherAnnualIncome = TextEditingController();
  final guardianQualification = TextEditingController();
  final guardianOccupation = TextEditingController();
  final guardianAnnualIncome = TextEditingController();

  bool _fatherNameError = false;
  bool _motherNameError = false;
  bool _aadhaarError = false;
  bool _mobileError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
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
                            height: 12,
                            width: 12,
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
                  value: 0.4,

                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
                  stopIndicatorRadius: 16,
                  backgroundColor: AppColor.lowGery1,
                  borderRadius: BorderRadius.circular(16),
                ),
                SizedBox(height: 40),
                CustomTextField.textWith600(text: 'Parent Info', fontSize: 26),
                SizedBox(height: 20),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = 'Father & Mother';
                        });
                      },
                      child: CustomContainer.parentInfo(
                        text: 'Father & Mother',
                        isSelected: selected == 'Father & Mother',
                      ),
                    ),

                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = 'Guardian';
                        });
                      },
                      child: CustomContainer.parentInfo(
                        text: 'Guardian',
                        isSelected: selected == 'Guardian',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (selected == 'Father & Mother') ...[
                  CustomTextField.richText(text: 'Father Name', text2: ''),
                  SizedBox(height: 10),
                  CustomContainer.studentInfoScreen(
                    text: 'English',
                    isTamil: false,
                    controller: englishController,
                  ),
                  SizedBox(height: 20),
                  CustomContainer.studentInfoScreen(
                    text: 'Tamil',
                    isTamil: true,
                    controller: tamilController,
                  ),
                  SizedBox(height: 20),
                  CustomTextField.richText(
                    text: 'Father Qualification',
                    text2: '',
                  ),
                  SizedBox(height: 10),
                  CustomContainer.studentInfoScreen(
                    controller: fatherQualification,
                    text: '',
                    imagePath: AppImages.dropDown,
                    imageSize: 11,
                  ),

                  SizedBox(height: 20),
                  CustomTextField.richText(
                    text: 'Father Occupation',
                    text2: '',
                  ),
                  SizedBox(height: 10),
                  CustomContainer.studentInfoScreen(
                    controller: fatherOccupation,
                    text: '',
                    verticalDivider: false,
                  ),
                  SizedBox(height: 20),
                  CustomTextField.richText(
                    text: 'Father Annual Income (Rs.)',
                    text2: '',
                  ),
                  SizedBox(height: 10),
                  CustomContainer.studentInfoScreen(
                    controller: fatherAnnualIncome,
                    text: '',
                    verticalDivider: false,
                  ),

                  SizedBox(height: 20),
                  CustomTextField.richText(text: 'Office Address', text2: ''),
                  SizedBox(height: 10),
                  CustomContainer.studentInfoScreen(
                    controller: officeAddress,
                    maxLine: 3,
                    text: '',
                    verticalDivider: false,
                  ),
                  SizedBox(height: 20),
                  Divider(color: AppColor.lightGrey),
                  SizedBox(height: 20),

                  CustomTextField.richText(text: 'Mother Name', text2: ''),
                  SizedBox(height: 10),
                  CustomContainer.studentInfoScreen(
                    text: 'English',
                    isTamil: false,
                    controller: englishController,
                  ),
                  SizedBox(height: 10),
                  CustomContainer.studentInfoScreen(
                    text: 'Tamil',
                    isTamil: true,
                    controller: tamilController,
                  ),

                  SizedBox(height: 20),
                  CustomTextField.richText(
                    text: 'Mother Qualification',
                    text2: '',
                  ),
                  SizedBox(height: 10),
                  CustomContainer.studentInfoScreen(
                    controller: motherQualification,
                    text: '',
                    imagePath: AppImages.dropDown,
                    imageSize: 11,
                    verticalDivider: false,
                  ),
                  SizedBox(height: 20),
                  CustomTextField.richText(
                    text: 'Mother Occupation',
                    text2: '',
                  ),
                  SizedBox(height: 10),
                  CustomContainer.studentInfoScreen(
                    controller: motherOccupation,
                    text: '',
                    verticalDivider: false,
                  ),
                  SizedBox(height: 20),
                  CustomTextField.richText(
                    text: 'Mother Annual Income (Rs.)',
                    text2: '',
                  ),
                  SizedBox(height: 10),
                  CustomContainer.studentInfoScreen(
                    controller: motherAnnualIncome,
                    text: '',
                    verticalDivider: false,
                  ),
                ] else if (selected == 'Guardian') ...[
                  CustomTextField.richText(text: 'Guardian Name', text2: ''),
                  SizedBox(height: 10),
                  CustomContainer.studentInfoScreen(
                    text: 'English',
                    isTamil: false,
                    controller: englishController,
                  ),
                  SizedBox(height: 20),
                  CustomContainer.studentInfoScreen(
                    text: 'Tamil',
                    isTamil: true,
                    controller: tamilController,
                  ),
                  SizedBox(height: 20),

                  CustomTextField.richText(
                    text: 'Guardian Qualification',
                    text2: '',
                  ),
                  SizedBox(height: 10),
                  CustomContainer.studentInfoScreen(
                    controller: guardianQualification,
                    text: '',
                    imagePath: AppImages.dropDown,
                    imageSize: 11,
                  ),

                  SizedBox(height: 20),
                  CustomTextField.richText(
                    text: 'Guardian Occupation',
                    text2: '',
                  ),
                  SizedBox(height: 10),
                  CustomContainer.studentInfoScreen(
                    controller: guardianOccupation,
                    text: '',
                    verticalDivider: false,
                  ),
                  SizedBox(height: 20),
                  CustomTextField.richText(
                    text: 'Guardian Annual Income (Rs.)',
                    text2: '',
                  ),
                  SizedBox(height: 10),
                  CustomContainer.studentInfoScreen(
                    controller: guardianAnnualIncome,
                    text: '',
                    verticalDivider: false,
                  ),
                ],
                SizedBox(height: 20),
                CustomTextField.richText(text: 'Office Address', text2: ''),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  controller: officeAddress,
                  maxLine: 3,
                  text: '',
                  verticalDivider: false,
                ),
                SizedBox(height: 40),
                AppButton.button(
                  image: AppImages.rightSaitArrow,
                  text: 'Save & Continue',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SiblingsFormScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
