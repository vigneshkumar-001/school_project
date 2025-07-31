import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';

import 'check_admission_status.dart';

class AdmissionPaymentSuccess extends StatefulWidget {
  const AdmissionPaymentSuccess({super.key});

  @override
  State<AdmissionPaymentSuccess> createState() =>
      _AdmissionPaymentSuccessState();
}

class _AdmissionPaymentSuccessState extends State<AdmissionPaymentSuccess> {

  bool _isCopied = false;

  void handleCopy() {
    Clipboard.setData(ClipboardData(text: 'SJ54956J6'));
    setState(() {
      _isCopied = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15, top: 80),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 55.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.lowGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                    child: Column(
                      children: [
                        Text(
                          'Your Admission Id',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.black,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Text(
                              'SJ54956J6',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColor.greenMore1,
                              ),
                            ),
                            SizedBox(width: 11),
                            Column(
                              children: [
                                InkWell(
                                  onTap: handleCopy,
                                  child: Image.asset(
                                    AppImages.copyImage,
                                    height: 20,
                                  ),
                                ),
                                if (_isCopied)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      'Copied',
                                      style: GoogleFont.ibmPlexSans(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 34),
              Image.asset(AppImages.paymentSuccessful),
              Text(
                'Payment Successful',
                style: GoogleFont.ibmPlexSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: AppColor.greenMore1,
                ),
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text:
                      'You can check admission status using given admission id in ',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 16,
                    color: AppColor.grey,
                  ),
                  children: [
                    TextSpan(
                      text: 'Admission checking page',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 16,
                        color: AppColor.lightBlack,
                      ),
                    ),
                    TextSpan(
                      text: ' using',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 16,
                        color: AppColor.grey,
                      ),
                    ),
                    TextSpan(
                      text: ' Admission Id',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 16,
                        color: AppColor.lightBlack,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              AppButton.button(
                text: 'Admission Status',
                image: AppImages.rightSaitArrow,
                width: 220,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckAdmissionStatus(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
