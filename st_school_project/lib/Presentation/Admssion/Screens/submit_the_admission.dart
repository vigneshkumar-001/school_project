import 'package:flutter/material.dart';

import '../../../Core/Utility/app_color.dart';
import '../../../Core/Utility/app_images.dart';
import '../../../Core/Utility/google_font.dart';

class SubmitTheAdmission extends StatefulWidget {
  const SubmitTheAdmission({super.key});

  @override
  State<SubmitTheAdmission> createState() => _SubmitTheAdmissionState();
}

class _SubmitTheAdmissionState extends State<SubmitTheAdmission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                    border: Border.all(color: AppColor.lowLightBlue, width: 1),
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
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.lightGrey,
                    border: Border.all(color: AppColor.lowLightBlue, width: 1),
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
        ],
      ),
    );
  }
}
