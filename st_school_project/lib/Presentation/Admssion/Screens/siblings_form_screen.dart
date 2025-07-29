import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/communication_screen.dart';

class SiblingsFormScreen extends StatefulWidget {
  const SiblingsFormScreen({super.key});

  @override
  State<SiblingsFormScreen> createState() => _SiblingsFormScreenState();
}

class _SiblingsFormScreenState extends State<SiblingsFormScreen> {
  String selected = 'Yes';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController admissionNoController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    admissionNoController.dispose();
    classController.dispose();
    sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                  value: 0.6,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
                  backgroundColor: AppColor.lowGery1,
                  borderRadius: BorderRadius.circular(16),
                ),
                SizedBox(height: 40),
                CustomTextField.textWith600(
                  text:
                  "If Your Sister Studying in St.Joseph's Matriculation School-Madurai.",
                  fontSize: 26,
                ),
                CustomTextField.richText(
                  text: '',
                  text2: 'Only Own Sisters',
                  secondFontSize: 26,
                  fontWeight2: FontWeight.w500,
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = 'Yes';
                        });
                      },
                      child: CustomContainer.parentInfo(
                        text: 'Yes',
                        isSelected: selected == 'Yes',
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = 'No';
                        });
                      },
                      child: CustomContainer.parentInfo(
                        text: 'No',
                        isSelected: selected == 'No',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                CustomTextField.richText(text: 'Name', text2: ''),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  controller: nameController,
                  text: '',
                  verticalDivider: false,
                ),
                SizedBox(height: 20),
                CustomTextField.richText(text: 'Admission No', text2: ''),
                SizedBox(height: 10),
                CustomContainer.studentInfoScreen(
                  controller: admissionNoController,
                  text: '',
                  verticalDivider: false,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField.richText(text: 'Class', text2: ''),
                          SizedBox(height: 10),
                          CustomContainer.studentInfoScreen(
                            controller: classController,
                            text: '',
                            verticalDivider: false,
                            imagePath: AppImages.dropDown,
                            imageSize: 11,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField.richText(text: 'Section', text2: ''),
                          SizedBox(height: 10),
                          CustomContainer.studentInfoScreen(
                            controller: sectionController,
                            text: '',
                            verticalDivider: false,
                            imagePath: AppImages.dropDown,
                            imageSize: 11,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Center(
                  child: CustomTextField.textWith600(
                    text: 'Add More',
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 25),
                AppButton.button(
                  image: AppImages.rightSaitArrow,
                  text: 'Save & Continue',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunicationScreen(),
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