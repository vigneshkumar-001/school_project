import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import '../../../../Core/Utility/app_color.dart' show AppColor;
import 'otp_screen.dart' show OtpScreen;

class ChangeMobileNumber extends StatefulWidget {
  final String? page;
  const ChangeMobileNumber({super.key, this.page});

  @override
  State<ChangeMobileNumber> createState() => _ChangeMobileNumberState();
}

class _ChangeMobileNumberState extends State<ChangeMobileNumber> {
  final TextEditingController mobileNumberController = TextEditingController();
  bool _isFormatting = false;

  final List<String> images1 = [
    AppImages.advertisement3,
    AppImages.advertisement4,
  ];
  final List<String> images = [
    AppImages.advertisement1,
    AppImages.advertisement2,
  ];

  @override
  void initState() {
    super.initState();
    mobileNumberController.clear();
  }

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
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    if (widget.page == 'splash') ...[
                      Image.asset(AppImages.schoolLogo),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Enter Mobile Number',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColor.lightBlack,
                          ),
                        ),
                      ),
                    ] else ...[
                      CustomContainer.leftSaitArrow(
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Change to New Mobile Number',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColor.lightBlack,
                          ),
                        ),
                      ),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 11,
                      ),
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
                          const SizedBox(width: 10),
                          const SizedBox(height: 35, child: VerticalDivider()),
                          const SizedBox(width: 10),
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
                    const SizedBox(height: 25),
                    AppButton.button(
                      text: 'Get OTP',
                      width: double.infinity,
                      onTap: () {
                        final String mbl = mobileNumberController.text;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(mobileNumber: mbl),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            widget.page == 'splash'
                ? Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColor.splash, Colors.white],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      padding: EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          if (!isKeyboardOpen) ...[
                            CarouselSlider(
                              items:
                                  images.map((imagePath) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        imagePath,
                                        fit: BoxFit.cover,
                                        width: 265,
                                      ),
                                    );
                                  }).toList(),
                              options: CarouselOptions(
                                height: 120,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlay: true,
                                viewportFraction: 0.7,
                                enlargeCenterPage: false,
                              ),
                            ),
                            SizedBox(height: 20),
                            CarouselSlider(
                              items:
                                  images1.map((imagePath) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        imagePath,
                                        fit: BoxFit.cover,
                                        width: 265,
                                      ),
                                    );
                                  }).toList(),
                              options: CarouselOptions(
                                height: 120,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                                viewportFraction: 0.7,
                                enlargeCenterPage: false,
                                reverse: true,
                              ),
                            ),
                            SizedBox(height: 25),
                          ],
                        ],
                      ),
                    ),

                    Positioned(
                      top: 0,
                      right: 15,
                      child: CustomTextField.textWithSmall(
                        text: 'We Are',
                        color: AppColor.weAreColor,
                        fontSize: 47,
                      ),
                    ),
                  ],
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}
