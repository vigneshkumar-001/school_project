import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';

import '../../../Core/Utility/app_color.dart';
import '../../../Core/Utility/app_images.dart';
import '../../../Core/Utility/google_font.dart';

class CheckAdmissionStatus extends StatefulWidget {
  const CheckAdmissionStatus({super.key});

  @override
  State<CheckAdmissionStatus> createState() => _CheckAdmissionStatusState();
}

class _CheckAdmissionStatusState extends State<CheckAdmissionStatus> {
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
                      child: CustomContainer.studentInfoScreen(
                        text: 'Admission Id',
                        verticalDivider: true,
                        flex: 2,
                      ),
                    ),

                    SizedBox(width: 5),
                    Expanded(child: CustomContainer.checkMark(onTap: () {})),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
