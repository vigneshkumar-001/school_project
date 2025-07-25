import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/parents_info_screen.dart';

import '../../../Core/Utility/app_images.dart';

class StudentInfoScreen extends StatefulWidget {
  const StudentInfoScreen({super.key});

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                  value: 0.2,

                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
                  stopIndicatorRadius: 16,
                  backgroundColor: AppColor.lowGery1,
                  borderRadius: BorderRadius.circular(16),
                ),
                SizedBox(height: 40),
                CustomTextField.textWith600(text: 'Student Info', fontSize: 26),
                SizedBox(height: 30),
                CustomTextField.richText(
                  text: 'Name of the Student ',
                  text2: 'As per Birth Certificate',
                ),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(text: 'English'),
                SizedBox(height: 20),
                CustomContainer.studentInfoScreen(text: 'Tamil'),
                SizedBox(height: 20),
                CustomTextField.richText(
                  text: 'Student Aadhar Number',
                  text2: '',
                ),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(text: 'Aadhar No'),
                SizedBox(height: 20),
                CustomTextField.richText(
                  text: 'Date of Birth ',
                  text2: '01-06-2021 to 31-05-2022',
                ),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  imagePath: AppImages.calender,
                ),
                SizedBox(height: 20),
                CustomTextField.richText(text: 'Religion', text2: ''),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  verticalDivider: false,
                  imageSize: 11,
                  imagePath: AppImages.dropDown,
                ),
                SizedBox(height: 20),
                CustomTextField.richText(text: 'Caste', text2: ''),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  verticalDivider: false,
                  imageSize: 11,
                  imagePath: AppImages.dropDown,
                ),
                SizedBox(height: 20),
                CustomTextField.richText(
                  text: 'Community  ',
                  text2: 'As per Community Certificate',
                ),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  verticalDivider: false,
                  imageSize: 11,
                  imagePath: AppImages.dropDown,
                ),
                SizedBox(height: 20),
                CustomTextField.richText(text: 'Mother Tongue', text2: ''),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  verticalDivider: false,
                  imageSize: 11,
                  imagePath: AppImages.dropDown,
                ),
                SizedBox(height: 20),
                CustomTextField.richText(text: 'Nationality', text2: ''),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  verticalDivider: false,
                  imageSize: 11,
                  imagePath: AppImages.dropDown,
                ),
                SizedBox(height: 20),
                CustomTextField.richText(
                  text: 'Personal Identification 1',
                  text2: '',
                ),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  verticalDivider: false,
                ),
                SizedBox(height: 20),
                CustomTextField.richText(
                  text: 'Personal Identification 2',
                  text2: '',
                ),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  verticalDivider: false,
                ),
                SizedBox(height: 30),
                AppButton.button(
                  image: AppImages.rightSaitArrow,
                  text: 'Save & Continue',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParentsInfoScreen(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
