import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen/controller/teacher_list_controller.dart';
import '../../../../Core/Utility/app_color.dart' show AppColor;
import 'Login_screen/controller/login_controller.dart';
import 'otp_screen.dart' show OtpScreen;

class ChangeMobileNumber extends StatefulWidget {
  final String? page;
  const ChangeMobileNumber({super.key, this.page});

  @override
  State<ChangeMobileNumber> createState() => _ChangeMobileNumberState();
}

class _ChangeMobileNumberState extends State<ChangeMobileNumber> {
  final LoginController loginController = Get.put(LoginController());
  final TeacherListController teacherListController = Get.put(
    TeacherListController(),
  );
  final TextEditingController mobileNumberController = TextEditingController();
  bool _showClear = false;
  bool _isFormatting = false;
  String errorText = '';

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
    setState(() {
      errorText = '';
    });
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
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              if (widget.page == 'splash') ...[
                                Image.asset(AppImages.schoolLogo),
                                const SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  child: Text(
                                    'Enter Mobile Number',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.lightBlack,
                                    ),
                                  ),
                                ),
                              ] else if (widget.page == 'email') ...[
                                CustomContainer.leftSaitArrow(
                                  onTap: () => Navigator.pop(context),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  child: Text(
                                    'Change to New Email Id',
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
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
                              if (widget.page == 'email') ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 11,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.lightGrey,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color:
                                          mobileNumberController.text.isNotEmpty
                                              ? (errorText != null
                                                  ? Colors.red
                                                  : AppColor.black)
                                              : AppColor.lightGrey,
                                      width:
                                          mobileNumberController.text.isNotEmpty
                                              ? 2
                                              : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: TextFormField(
                                          controller:
                                              mobileNumberController, // can rename to emailController
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          style: GoogleFont.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                          maxLength: 50,
                                          onChanged: (value) {
                                            setState(() {
                                              // Validate email on every change
                                              if (value.isEmpty) {
                                                errorText =
                                                    'Please enter your email';
                                              } else {
                                                final emailRegex = RegExp(
                                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                                );
                                                errorText =
                                                    (emailRegex.hasMatch(value)
                                                        ? null
                                                        : 'Please enter a valid email') ??
                                                    '';
                                              }
                                            });
                                          },
                                          decoration: InputDecoration(
                                            counterText: '',
                                            hintText: 'xxx@gmail.com',
                                            hintStyle: GoogleFont.inter(
                                              color: AppColor.grayop,
                                              fontSize: 20,
                                            ),
                                            border: InputBorder.none,
                                            suffixIcon:
                                                mobileNumberController
                                                        .text
                                                        .isNotEmpty
                                                    ? GestureDetector(
                                                      onTap: () {
                                                        mobileNumberController
                                                            .clear();
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 12,
                                                              right: 8,
                                                            ),
                                                        child: Text(
                                                          'Clear',
                                                          style:
                                                              GoogleFont.ibmPlexSans(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    AppColor
                                                                        .grayop,
                                                              ),
                                                        ),
                                                      ),
                                                    )
                                                    : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (errorText != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12.0,
                                      top: 6,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        errorText!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 10),
                              ] else ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 11,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.lightGrey,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color:
                                          mobileNumberController.text.isNotEmpty
                                              ? AppColor.black
                                              : AppColor.lightGrey,
                                      width:
                                          mobileNumberController.text.isNotEmpty
                                              ? 2
                                              : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                      SizedBox(
                                        height: 35,
                                        child: VerticalDivider(),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        flex: 9,
                                        child: TextFormField(
                                          autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction,
                                          controller: mobileNumberController,
                                          keyboardType: TextInputType.phone,
                                          style: GoogleFont.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                          maxLength: 12,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onChanged: (value) {
                                            _formatPhoneNumber(value);
                                            setState(() {});
                                          },
                                          decoration: InputDecoration(
                                            counterText: '',
                                            hintText: '9000 000 000',
                                            hintStyle: GoogleFont.inter(
                                              color: AppColor.grayop,
                                              fontSize: 20,
                                            ),
                                            border: InputBorder.none,
                                            suffixIcon:
                                                mobileNumberController
                                                        .text
                                                        .isNotEmpty
                                                    ? GestureDetector(
                                                      onTap: () {
                                                        mobileNumberController
                                                            .clear();
                                                        setState(() {});
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 12,
                                                              right: 8,
                                                            ),
                                                        child: Text(
                                                          'Clear',
                                                          style:
                                                              GoogleFont.ibmPlexSans(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    AppColor
                                                                        .grayop,
                                                              ),
                                                        ),
                                                      ),
                                                    )
                                                    : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12.0,
                                    top: 4,
                                  ),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      errorText,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              Obx(() {
                                return AppButton.button(
                                  text:
                                      widget.page == 'email'
                                          ? 'Submit'
                                          : 'Get OTP',
                                  loader:
                                      loginController.isLoading.value
                                          ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                          : null,
                                  width: double.infinity,
                                  onTap:loginController.isLoading.value? null : () {
                                    final String input =
                                        mobileNumberController.text
                                            .trim(); // rename to emailController if email
                                    if (widget.page == 'email') {
                                      // Email validation
                                      if (input.isEmpty) {
                                        setState(() {
                                          errorText = 'Email is required';
                                        });
                                      } else {
                                        final emailRegex = RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                        );
                                        if (!emailRegex.hasMatch(input)) {
                                          setState(() {
                                            errorText =
                                                'Please enter a valid email';
                                          });
                                        } else {
                                          setState(() {
                                            errorText = '';
                                          });
                                          // Call your controller method for email submission
                                          teacherListController.emailUpdate(
                                            context: context,
                                            showLoader: true,
                                            email: input,
                                          );
                                        }
                                      }
                                    } else {
                                      // Mobile number validation (existing logic)
                                      final String mbl = input.replaceAll(
                                        ' ',
                                        '',
                                      );
                                      if (mbl.isEmpty) {
                                        setState(() {
                                          errorText =
                                              'Mobile Number is Required';
                                        });
                                      } else if (mbl.length != 10) {
                                        setState(() {
                                          errorText =
                                              'Mobile Number must be exactly 10 digits';
                                        });
                                      } else {
                                        setState(() {
                                          errorText = '';
                                        });
                                        widget.page == 'splash'
                                            ? loginController.mobileNumberLogin(
                                              mbl,
                                            )
                                            : loginController
                                                .changeMobileNumber(mbl);
                                      }
                                    }
                                  },
                                );
                              }),

                              /*       Obx(() {
                                return AppButton.button(
                                  text: widget.page == 'email' ? 'Submit' : 'Get OTP',
                                  loader:
                                      loginController.isLoading.value
                                          ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                          : null,
                                  width: double.infinity,
                                  onTap: () {
                                    final String mbl = mobileNumberController
                                        .text
                                        .replaceAll(' ', '');
                                    if (mbl.isEmpty) {
                                      setState(() {
                                        errorText = 'Mobile Number is Required';
                                      });
                                    } else if (mbl.length != 10) {
                                      setState(() {
                                        errorText =
                                            'Mobile Number must be exactly 10 digits';
                                      });
                                    } else {
                                      setState(() {
                                        errorText = '';
                                      });

                                      widget.page == 'splash'
                                          ? loginController.mobileNumberLogin(
                                            mbl,
                                          )
                                          : loginController.changeMobileNumber(
                                            mbl,
                                          );
                                    }
                                  },
                                );
                              }),*/
                            ],
                          ),
                        ),
                      ),

                      // Bottom carousel / stack
                      /*  if (widget.page == 'splash' && !isKeyboardOpen)
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 43),
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
                                  CarouselSlider(
                                    items: images.map((imagePath) {
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
                                    items: images1.map((imagePath) {
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
                        ),
*/
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
                                      SizedBox(
                                        height: 120,
                                        child: CarouselSlider(
                                          items:
                                              images.map((imagePath) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.asset(
                                                    imagePath,
                                                    fit: BoxFit.cover,
                                                    width:
                                                        280, // 👈 2 images per screen
                                                  ),
                                                );
                                              }).toList(),
                                          options: CarouselOptions(
                                            height: 120,
                                            autoPlay: true,
                                            autoPlayInterval: Duration(
                                              seconds: 3,
                                            ),
                                            viewportFraction:
                                                0.75, // 👈 ensures 2 per screen
                                            enlargeCenterPage: false,
                                            padEnds: false,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 25),
                                      SizedBox(
                                        height: 120,
                                        child: CarouselSlider(
                                          items:
                                              images1.map((imagePath) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.asset(
                                                    imagePath,
                                                    fit: BoxFit.cover,
                                                    width:
                                                        280, // 👈 2 images per screen
                                                  ),
                                                );
                                              }).toList(),
                                          options: CarouselOptions(
                                            height: 120,
                                            autoPlay: true,
                                            autoPlayInterval: Duration(
                                              seconds: 3,
                                            ),
                                            viewportFraction:
                                                0.75, // 👈 ensures 2 per screen
                                            enlargeCenterPage: false,
                                            padEnds: false,
                                            reverse: true,
                                          ),
                                        ),
                                      ),

                                      /*  CarouselSlider(
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
                                viewportFraction: 0.75,   // 👈 two images fit in one view
                                enlargeCenterPage: false, // 👈 no zoom on center image
                                disableCenter: true,      // 👈 removes centering
                                autoPlay: true,
                                // viewportFraction: 0.70,
                                // enlargeCenterPage: false,
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
                                        width: 320,
                                      ),
                                    );
                                  }).toList(),
                              options: CarouselOptions(
                                height: 115,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                                viewportFraction: 0.85,
                                enlargeCenterPage: false,
                                reverse: true,
                              ),
                            ),*/
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
              ),
            );
          },
        ),
      ),
    );
  }

  /*  Widget build(BuildContext context) {
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
                  vertical: 10,
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
                        color: AppColor.lightGrey,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color:
                              mobileNumberController.text.isNotEmpty
                                  ? AppColor.black
                                  : AppColor.lightGrey,
                          width: mobileNumberController.text.isNotEmpty ? 2 : 1,
                        ),
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
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                              onChanged: (value) {
                                _formatPhoneNumber(value);
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: '9000 000 000',
                                hintStyle: GoogleFont.inter(
                                  color: AppColor.grayop,
                                  fontSize: 20,
                                ),
                                border: InputBorder.none,
                                suffixIcon:
                                    mobileNumberController.text.isNotEmpty
                                        ? GestureDetector(
                                          onTap: () {
                                            mobileNumberController.clear();
                                            setState(() {});
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 12,
                                              right: 8,
                                            ),
                                            child: Text(
                                              'Clear',
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.grayop,
                                              ),
                                            ),
                                          ),
                                        )
                                        : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 4),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          errorText,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Obx(() {
                      return AppButton.button(
                        text: 'Get OTP',
                        loader:
                            loginController.isLoading.value
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : null,
                        width: double.infinity,
                        onTap: () {
                          final String mbl = mobileNumberController.text
                              .replaceAll(' ', '');
                          if (mbl.isEmpty) {
                            setState(() {
                              errorText = 'Mobile Number is Required';
                            });
                          } else if (mbl.length != 10) {
                            setState(() {
                              errorText =
                                  'Mobile Number must be exactly 10 digits';
                            });
                          } else {
                            setState(() {
                              errorText = '';
                            });

                            */ /*7904005315*/ /*
                            */ /*9894143252*/ /*
                            widget.page == 'splash'
                                ? loginController.mobileNumberLogin(mbl)
                                : loginController.changeMobileNumber(mbl);
                            // Get.to(
                            //   OtpScreen(mobileNumber: mbl, pages: 'splash'),
                            // );
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),

            widget.page == 'splash'
                ? Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 43),
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
  }*/
}
