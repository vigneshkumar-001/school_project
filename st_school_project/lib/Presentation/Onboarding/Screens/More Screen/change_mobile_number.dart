import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';

import '../../../../Core/Utility/app_color.dart' show AppColor;
import 'otp_screen.dart' show OtpScreen;

class ChangeMobileNumber extends StatefulWidget {
  final String? page;
  const ChangeMobileNumber({super.key, this.page});

  @override
  State<ChangeMobileNumber> createState() => _ChangeMobileNumberState();
}

class _ChangeMobileNumberState extends State<ChangeMobileNumber> {
  String _rawDigits = '';

  @override
  void initState() {
    super.initState();
    mobileNumberController.clear();
  }

  final TextEditingController mobileNumberController = TextEditingController();
  bool _isFormatting = false;

  void _formatPhoneNumber(String value) {
    if (_isFormatting) return;

    _isFormatting = true;

    String digitsOnly = value.replaceAll(' ', '');

    if (digitsOnly.length > 10) {
      digitsOnly = digitsOnly.substring(0, 10);
    }

    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 4 || i == 7) {
        formatted += ' ';
      }
      formatted += digitsOnly[i];
    }

    mobileNumberController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    _isFormatting = false;
  }

  @override
  void dispose() {
    mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer.leftSaitArrow(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Change to New Mobile Number',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColor.lightBlack,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                decoration: BoxDecoration(
                  color: AppColor.lowGery1,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColor.lowGery1),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '+91',
                          style: GoogleFont.inter(
                            fontSize: 14,
                            color: AppColor.grey,
                          ),
                        ),
                        Text(
                          'India',
                          style: GoogleFont.inter(
                            fontSize: 10,
                            color: AppColor.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    SizedBox(height: 35, child: VerticalDivider()),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 9,
                      child: TextField(
                        controller: mobileNumberController,

                        keyboardType: TextInputType.phone,
                        style: GoogleFont.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                        maxLength: 12,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: _formatPhoneNumber,
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '9000 000 000',
                          hintStyle: GoogleFont.inter(
                            color: AppColor.grayop,
                            fontSize: 20,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

              // ElevatedButton(
              //   onPressed: () {
              //     final String phn = mobileNumberController.text.trim();
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => OtpScreen(mobileNumber: phn),
              //       ),
              //     );
              //   },
              //   style: ButtonStyle(
              //     padding: MaterialStateProperty.all(EdgeInsets.zero),
              //     shape: MaterialStateProperty.all(
              //       RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //     elevation: MaterialStateProperty.all(0),
              //     backgroundColor: MaterialStateProperty.all(
              //       Colors.transparent,
              //     ),
              //   ),
              //   child: Ink(
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //         colors: [AppColor.blueG1, AppColor.blueG2],
              //         begin: Alignment.topRight,
              //         end: Alignment.bottomRight,
              //       ),
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     child: Container(
              //       alignment: Alignment.center,
              //       height: 50,
              //       width: double.infinity,
              //       child: Text(
              //         'Get OTP',
              //         style: GoogleFont.ibmPlexSans(
              //           fontSize: 16,
              //           fontWeight: FontWeight.w800,
              //           color: AppColor.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              AppButton.button(text: 'Get OTP', width: double.infinity),
            ],
          ),
        ),
      ),
    );
  }
}
