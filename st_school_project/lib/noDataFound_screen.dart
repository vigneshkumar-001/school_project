import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/change_mobile_number.dart';

import 'Core/Utility/app_color.dart';
import 'Core/Widgets/bottom_navigationbar.dart';

class NoDataFoundScreen extends StatelessWidget {
  final String page;
  const NoDataFoundScreen({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField.textWith600(
                      text: 'No Data Found',
                      fontSize: 30,
                    ),
                    SizedBox(height: 15),
                    CustomTextField.textWithSmall(
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                      fontSize: 14,
                      text:
                          'Please check your mobile number or contact school to change your mobile number.',
                      color: AppColor.grey,
                    ),
                    Image.asset(AppImages.noDataFound),
                  ],
                ),
              ),
              AppButton.button(
                text: 'Back',
                isBorder: true,
                onTap: () {
                  if (page == 'homeScreen') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                const CommonBottomNavigation(initialIndex: 0),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeMobileNumber(page: 'splash'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
