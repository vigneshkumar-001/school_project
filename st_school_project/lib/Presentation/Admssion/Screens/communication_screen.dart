import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';

import 'package:st_school_project/Presentation/Admssion/Screens/required_photo_screens.dart';



class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                  value: 0.8,

                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
                  stopIndicatorRadius: 16,
                  backgroundColor: AppColor.lowGery1,
                  borderRadius: BorderRadius.circular(16),
                ),
                SizedBox(height: 40),
                CustomTextField.textWith600(
                  text: 'Communication Details',
                  fontSize: 26,
                ),
                SizedBox(height: 20),

                CustomTextField.richText(
                  text: 'Mobile Number - Primary',
                  text2: '',
                ),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  verticalDivider: false,
                ),

                SizedBox(height: 20),

                CustomTextField.richText(
                  text: 'Mobile Number - Secondary',
                  text2: '',
                ),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  verticalDivider: false,
                ),

                SizedBox(height: 20),
                CustomTextField.richText(text: 'Country', text2: ''),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  verticalDivider: false,
                  imageSize: 11,
                  imagePath: AppImages.dropDown,
                ),
                SizedBox(height: 20),
                CustomTextField.richText(text: 'State', text2: ''),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  verticalDivider: false,
                  imageSize: 11,
                  imagePath: AppImages.dropDown,
                ),
                SizedBox(height: 20),
                CustomTextField.richText(text: 'City', text2: ''),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  verticalDivider: false,
                  imageSize: 11,
                  imagePath: AppImages.dropDown,
                ),
                SizedBox(height: 20),

                CustomTextField.richText(text: 'Pin Code', text2: ''),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  verticalDivider: false,
                ),
                SizedBox(height: 20),

                CustomTextField.richText(text: 'Address', text2: ''),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  text: '',
                  verticalDivider: false,
                  maxLine: 4,
                ),
                SizedBox(height: 30),
                AppButton.button(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
 
                        builder: (context) => RequiredPhotoScreens(),
 
 
 
                      ),
                    );
                  },
                  text: 'Save & Continue',
                  image: AppImages.rightSaitArrow,
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
