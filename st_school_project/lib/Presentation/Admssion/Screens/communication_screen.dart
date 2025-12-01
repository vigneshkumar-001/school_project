import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Utility/snack_bar.dart';
import 'package:st_school_project/Core/Widgets/bottom_sheets.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Admssion/Controller/admission_controller.dart';

import 'package:st_school_project/Presentation/Admssion/Screens/required_photo_screens.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/siblings_form_screen.dart';

class CommunicationScreen extends StatefulWidget {
  final int id;
  final String page;

  const CommunicationScreen({super.key, required this.id, required this.page});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isSubmitted = false;

  final AdmissionController controller = Get.put(AdmissionController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.fetchAndSetUserData();
      controller.fetchCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    Row(
                      children: [
                        CustomContainer.leftSaitArrow(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final admissionId =
                                prefs.getInt('admissionId') ?? 0;

                            Get.off(
                              SiblingsFormScreen(
                                id: admissionId,
                                page: widget.page,
                              ),
                            );
                          },
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       color: AppColor.lightGrey,
                        //       border: Border.all(
                        //         color: AppColor.lowLightBlue,
                        //         width: 1,
                        //       ),
                        //       borderRadius: BorderRadius.circular(30),
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(10),
                        //       child: Image.asset(
                        //         AppImages.leftArrow,
                        //         height: 12,
                        //         width: 12,
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
                      value: 0.8,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
                      backgroundColor: AppColor.lowGery1,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    SizedBox(height: 40),

                    CustomTextField.textWith600(
                      text: 'Communication Details',
                      fontSize: 26,
                    ),
                    SizedBox(height: 20),

                    CustomTextField.richText(
                      text: 'Mobile Number - Primary',
                      text2: '',
                    ),
                    SizedBox(height: 10),
                    CustomContainer.studentInfoScreen(
                      readOnly: false,
                      keyboardType: TextInputType.number,

                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      isError:
                          isSubmitted &&
                          controller.primaryMobileController.text
                              .trim()
                              .isEmpty,
                      onChanged: (value) {
                        if (isSubmitted && value.trim().isNotEmpty) {
                          setState(() {});
                        }
                      },

                      errorText:
                          isSubmitted &&
                                  controller.primaryMobileController.text
                                      .trim()
                                      .isEmpty
                              ? 'Mobile Number - Primary is required'
                              : null,
                      text: '',
                      controller: controller.primaryMobileController,
                      isMobile: true,
                      verticalDivider: false,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty)
                      //     return 'Enter primary mobile number';
                      //   if (value.length != 10)
                      //     return 'Enter valid 10-digit number';
                      //   return null;
                      // },
                    ),

                    SizedBox(height: 20),
                    CustomTextField.richText(
                      text: 'Mobile Number - Secondary',
                      text2: '',
                    ),
                    SizedBox(height: 10),
                    CustomContainer.studentInfoScreen(
                      keyboardType: TextInputType.number,
                      isError:
                          isSubmitted &&
                          controller.secondaryMobileController.text
                              .trim()
                              .isEmpty,
                      text: '',
                      controller: controller.secondaryMobileController,
                      isMobile: true,
                      verticalDivider: false,
                      //   validator: (value) {
                      //   if (value == null || value.isEmpty)
                      //     return 'Enter Secondary mobile number';
                      //   if (value.length != 10)
                      //     return 'Enter valid 10-digit number';
                      //   return null;
                      // },
                      onChanged: (value) {
                        if (isSubmitted && value.trim().isNotEmpty) {
                          setState(() {});
                        }
                      },

                      errorText:
                          isSubmitted &&
                                  controller.secondaryMobileController.text
                                      .trim()
                                      .isEmpty
                              ? 'Mobile Number - Secondary is required'
                              : null,
                    ),

                    SizedBox(height: 20),
                    CustomTextField.richText(text: 'Country', text2: ''),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        // 🔹 Open the bottom sheet first
                        CommonPickerBottomSheet.show(
                          context: context,
                          title: 'Select Country',
                          rxItems: controller.countries,
                          isLoading: controller.isBottomSheetLoading,
                          displayText: (c) => c.name ?? '',
                          subtitleText: (c) => "+${c.phonecode ?? ''}",
                          onSelect: (selected) async {
                            controller.countryController.text =
                                selected.name ?? '';
                            controller.stateController.clear();
                            controller.cityController.clear();
                            await controller.fetchStates(
                              country: selected.isoCode ?? '',
                            );
                          },
                        );

                        // 🔹 Fetch countries (first load)
                        if (controller.countries.isEmpty) {
                          await controller.fetchCountries();
                        }
                      },
                      child: AbsorbPointer(
                        child: CustomContainer.studentInfoScreen(
                          controller: controller.countryController,
                          text: '',
                          verticalDivider: false,
                          imageSize: 11,
                          imagePath: AppImages.dropDown,
                          isError:
                              isSubmitted &&
                              controller.countryController.text.trim().isEmpty,
                          errorText:
                              isSubmitted &&
                                      controller.countryController.text
                                          .trim()
                                          .isEmpty
                                  ? 'Country is required'
                                  : null,
                        ),
                      ),
                    ),

                    // CustomContainer.studentInfoScreen(
                    //
                    //   controller: countryController,
                    //   text: '',
                    //   verticalDivider: false,
                    //   imageSize: 11,
                    //   imagePath: AppImages.dropDown,
                    //   onChanged: (value) {
                    //     if (isSubmitted && value.trim().isNotEmpty) {
                    //       setState(() {});
                    //     }
                    //   },
                    //   isError:
                    //       isSubmitted && countryController.text.trim().isEmpty,
                    //   errorText:
                    //       isSubmitted && countryController.text.trim().isEmpty
                    //           ? 'Country is required'
                    //           : null,
                    //   // validator: (value) {
                    //   //   if (value == null || value.isEmpty)
                    //   //     return 'Enter country';
                    //   //   return null;
                    //   // },
                    // ),
                    SizedBox(height: 20),
                    CustomTextField.richText(text: 'State', text2: ''),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final selectedCountry =
                            controller.countryController.text.trim();
                        if (selectedCountry.isEmpty) {
                          CustomSnackBar.showInfo(
                            "Please choose a country first",
                          );
                          return;
                        }

                        // Open sheet immediately
                        CommonPickerBottomSheet.show(
                          context: context,
                          title: 'Select State',
                          rxItems: controller.states,
                          isLoading: controller.isBottomSheetLoading,
                          displayText: (s) => s.name ?? '',
                          subtitleText: (s) => s.isoCode ?? '',
                          onSelect: (selected) async {
                            controller.stateController.text =
                                selected.name ?? '';
                            await controller.fetchCities(
                              country:
                                  controller.countries
                                      .firstWhereOrNull(
                                        (e) => e.name == selectedCountry,
                                      )
                                      ?.isoCode ??
                                  '',
                              state: selected.isoCode ?? '',
                            );
                            controller.cityController.clear();
                          },
                        );

                        // Fetch in background
                        if (controller.states.isEmpty) {
                          await controller.fetchStates(
                            country:
                                controller.countries
                                    .firstWhereOrNull(
                                      (e) => e.name == selectedCountry,
                                    )
                                    ?.isoCode ??
                                '',
                          );
                        }
                      },
                      child: AbsorbPointer(
                        child: CustomContainer.studentInfoScreen(
                          isError:
                              isSubmitted &&
                              controller.stateController.text.trim().isEmpty,
                          controller: controller.stateController,
                          errorText:
                              isSubmitted &&
                                      controller.stateController.text
                                          .trim()
                                          .isEmpty
                                  ? 'State is required'
                                  : null,
                          text: '',
                          verticalDivider: false,
                          imageSize: 11,
                          imagePath: AppImages.dropDown,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    CustomTextField.richText(text: 'City', text2: ''),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final selectedState =
                            controller.stateController.text.trim();
                        final selectedCountry =
                            controller.countryController.text.trim();

                        if (selectedState.isEmpty) {
                          CustomSnackBar.showInfo(
                            "Please choose a State first",
                          );
                          return;
                        }

                        CommonPickerBottomSheet.show(
                          context: context,
                          title: 'Select City',
                          rxItems: controller.city,
                          isLoading: controller.isBottomSheetLoading,
                          displayText: (c) => c.name,
                          onSelect: (selected) {
                            controller.cityController.text = selected.name;
                          },
                        );

                        if (controller.city.isEmpty) {
                          final countryIso =
                              controller.countries
                                  .firstWhereOrNull(
                                    (e) => e.name == selectedCountry,
                                  )
                                  ?.isoCode ??
                              '';
                          final stateIso =
                              controller.states
                                  .firstWhereOrNull(
                                    (e) => e.name == selectedState,
                                  )
                                  ?.isoCode ??
                              '';
                          await controller.fetchCities(
                            country: countryIso,
                            state: stateIso,
                          );
                        }
                      },
                      child: AbsorbPointer(
                        child: CustomContainer.studentInfoScreen(
                          controller: controller.cityController,
                          text: '',
                          verticalDivider: false,
                          imageSize: 11,
                          imagePath: AppImages.dropDown,
                          isError:
                              isSubmitted &&
                              controller.cityController.text.trim().isEmpty,
                          errorText:
                              isSubmitted &&
                                      controller.cityController.text
                                          .trim()
                                          .isEmpty
                                  ? 'City is required'
                                  : null,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    CustomTextField.richText(text: 'Pin Code', text2: ''),
                    SizedBox(height: 10),
                    CustomContainer.studentInfoScreen(
                      keyboardType: TextInputType.number,
                      isError:
                          isSubmitted &&
                          controller.pincodeController.text.trim().isEmpty,
                      onChanged: (value) {
                        if (isSubmitted && value.trim().isNotEmpty) {
                          setState(() {});
                        }
                      },

                      errorText:
                          isSubmitted &&
                                  controller.pincodeController.text
                                      .trim()
                                      .isEmpty
                              ? 'Pin Code is required'
                              : null,
                      controller: controller.pincodeController,
                      isPincode: true,
                      text: '',
                      verticalDivider: false,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty)
                      //     return 'Enter pincode';
                      //   if (value.length != 6)
                      //     return 'Enter valid 6-digit pincode';
                      //   return null;
                      // },
                    ),

                    SizedBox(height: 20),
                    CustomTextField.richText(text: 'Address', text2: ''),
                    SizedBox(height: 10),
                    CustomContainer.studentInfoScreen(
                      isError:
                          isSubmitted &&
                          controller.addressController.text.trim().isEmpty,
                      onChanged: (value) {
                        if (isSubmitted && value.trim().isNotEmpty) {
                          setState(() {});
                        }
                      },

                      errorText:
                          isSubmitted &&
                                  controller.addressController.text
                                      .trim()
                                      .isEmpty
                              ? 'Address is required'
                              : null,
                      controller: controller.addressController,
                      text: '',
                      verticalDivider: false,
                      maxLine: 4,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty)
                      //     return 'Enter address';
                      //   return null;
                      // },
                    ),

                    SizedBox(height: 30),
                    Obx(
                      () => AppButton.button(
                        loader:
                            controller.isLoading.value
                                ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                                : null,
                        onTap:
                            controller.isLoading.value
                                ? null
                                : () {
                                  HapticFeedback.heavyImpact();
                                  controller.communicationDetails(
                                    pages: widget.page,
                                    id: widget.id,
                                    mobilePrimary:
                                        controller.primaryMobileController.text
                                            .trim(),
                                    mobileSecondary:
                                        controller
                                            .secondaryMobileController
                                            .text
                                            .trim(),
                                    country:
                                        controller.countryController.text
                                            .trim(),
                                    state:
                                        controller.stateController.text.trim(),
                                    city: controller.cityController.text.trim(),
                                    pinCode:
                                        controller.pincodeController.text
                                            .trim(),
                                    address:
                                        controller.addressController.text
                                            .trim(),
                                  );
                                  // setState(() {
                                  //   isSubmitted = true;
                                  // });
                                  //
                                  // bool isGuardianFilled =
                                  //     primaryMobileController.text
                                  //         .trim()
                                  //         .isNotEmpty &&
                                  //     secondaryMobileController.text
                                  //         .trim()
                                  //         .isNotEmpty &&
                                  //     countryController.text.trim().isNotEmpty &&
                                  //     stateController.text.trim().isNotEmpty &&
                                  //     cityController.text.trim().isNotEmpty &&
                                  //     addressController.text.trim().isNotEmpty &&
                                  //     pincodeController.text.trim().isNotEmpty;
                                  // if (!isGuardianFilled) {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder:
                                  //           (context) => RequiredPhotoScreens(),
                                  //     ),
                                  //   );
                                  // }
                                },
                        text: 'Save & Continue',

                        image: AppImages.rightSaitArrow,
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
