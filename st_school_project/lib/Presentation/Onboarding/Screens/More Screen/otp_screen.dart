import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Home%20Screen/home_screen.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Home%20Screen/home_tab.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/quiz_screen.dart';

import '../../../../Core/Utility/app_color.dart';
import '../../../../Core/Utility/google_font.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? pages;
  const OtpScreen({super.key, this.mobileNumber, this.pages});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String mobileNumber = widget.mobileNumber.toString() ?? '';
    String maskMobileNumber =
        "******" + mobileNumber.substring(mobileNumber.length - 5);
    return Scaffold(
      backgroundColor: AppColor.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer.leftSaitArrow(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20),
              Text(
                'Enter OTP',
                style: GoogleFont.ibmPlexSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColor.lightBlack,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'OTP sent to $maskMobileNumber, please check and enter below. If you’re not received OTP',
                style: GoogleFont.ibmPlexSans(
                  fontSize: 14,
                  color: AppColor.grey,
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Resend OTP',
                  style: GoogleFont.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColor.blueG2,
                  ),
                ),
              ),
              SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: PinCodeTextField(
                  onCompleted: (value) async {},

                  autoFocus: true,
                  appContext: context,
                  // pastedTextStyle: TextStyle(
                  //   color: Colors.green.shade600,
                  //   fontWeight: FontWeight.bold,
                  // ),
                  length: 4,

                  // obscureText: true,
                  // obscuringCharacter: '*',
                  // obscuringWidget: const FlutterLogo(size: 24,),
                  blinkWhenObscuring: true,
                  mainAxisAlignment: MainAxisAlignment.start,
                  autoDisposeControllers: false,

                  // validator: (v) {
                  //   if (v == null || v.length != 4)
                  //     return 'Enter valid 4-digit OTP';
                  //   return null;
                  // },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(17),
                    fieldHeight: 60,
                    fieldWidth: 60,
                    selectedColor: AppColor.black,
                    activeColor: AppColor.white,
                    activeFillColor: AppColor.white,
                    inactiveColor: AppColor.lowGery1,
                    selectedFillColor: AppColor.white,
                    fieldOuterPadding: EdgeInsets.symmetric(horizontal: 12),
                    inactiveFillColor: AppColor.lowGery1,
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  // errorAnimationController: errorController,
                  controller: otp,
                  keyboardType: TextInputType.number,
                  boxShadows: const [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.black12,
                      blurRadius: 5,
                    ),
                  ],
                  // validator: (value) {
                  //   if (value == null || value.length != 4) {
                  //     return 'Please enter a valid 4-digit OTP';
                  //   }
                  //   return null;
                  // },
                  // onCompleted: (value) async {},
                  onChanged: (value) {
                    debugPrint(value);
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");
                    return true;
                  },
                ),
              ),
              SizedBox(height: 30),
              CustomContainer.checkMark(
                onTap: () {
                  if(widget.pages == 'splash'){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }else{
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizScreen()),
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
