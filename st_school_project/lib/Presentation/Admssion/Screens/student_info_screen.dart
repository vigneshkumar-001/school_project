import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
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
              CustomTextField.textWith600(text: 'Student Info',fontSize: 26)
            ],
          ),
        ),
      ),
    );
  }
}
