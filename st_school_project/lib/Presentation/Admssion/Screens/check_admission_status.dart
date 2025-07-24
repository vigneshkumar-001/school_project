import 'package:flutter/material.dart';

import '../../../Core/Utility/app_color.dart';
import '../../../Core/Utility/app_images.dart';

class CheckAdmissionStatus extends StatefulWidget {
  const CheckAdmissionStatus({super.key});

  @override
  State<CheckAdmissionStatus> createState() => _CheckAdmissionStatusState();
}

class _CheckAdmissionStatusState extends State<CheckAdmissionStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                child: Image.asset(AppImages.leftArrow, height: 20, width: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
