import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Utility/thanglish_to_tamil.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/siblings_form_screen.dart';
import 'package:http/http.dart' as http;

class ParentsInfoScreen extends StatefulWidget {
  const ParentsInfoScreen({super.key});

  @override
  State<ParentsInfoScreen> createState() => _ParentsInfoScreenState();
}

class _ParentsInfoScreenState extends State<ParentsInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  String selected = 'Father & Mother';
  bool isSubmitted = false;


  final _formKey1 = GlobalKey<FormState>();
  bool hasError = false;
  final englishController = TextEditingController();
  final tamilController = TextEditingController();
  final fatherOccupation = TextEditingController();
  final fatherQualification = TextEditingController();
  final fatherAnnualIncome = TextEditingController();
  final officeAddress = TextEditingController();
  final motherQualification = TextEditingController();
  final motherNameTamilController = TextEditingController();
  final motherNameEnglishController = TextEditingController();
  final motherOccupation = TextEditingController();
  final motherOfficeAddressController = TextEditingController();
  final motherAnnualIncome = TextEditingController();

  final guardianEnglish = TextEditingController();
  final guardianTamil = TextEditingController();
  final guardianQualification = TextEditingController();
  final guardianOccupation = TextEditingController();
  final guardianAnnualIncome = TextEditingController();
  final guardianOfficeAddress = TextEditingController();

  List<String> fatherSuggestions = [];
  List<String> guardianSuggestions = [];
  bool isGuardianLoading = false;
  bool isFatherLoading = false;

  List<String> motherSuggestions = [];
  bool isMotherLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            height: 12,
                            width: 12,
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
                SizedBox(height: 30),
                LinearProgressIndicator(
                  minHeight: 6,
                  value: 0.4,

                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
                  stopIndicatorRadius: 16,
                  backgroundColor: AppColor.lowGery1,
                  borderRadius: BorderRadius.circular(16),
                ),
                SizedBox(height: 40),
                CustomTextField.textWith600(
                  text: 'Parent Info',
                  fontSize: 26,
                ),
                SizedBox(height: 20),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = 'Father & Mother';
                        });
                      },
                      child: CustomContainer.parentInfo(
                        text: 'Father & Mother',
                        isSelected: selected == 'Father & Mother',
                      ),
                    ),

                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = 'Guardian';
                        });
                      },
                      child: CustomContainer.parentInfo(
                        text: 'Guardian',
                        isSelected: selected == 'Guardian',
                      ),
                    ),

                  ],
                ),

              SizedBox(height: 20),
              if (selected == 'Father & Mother') ...[
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField.richText(
                        text: 'Father Name',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },

                        errorText:
                            isSubmitted &&
                                    englishController.text.trim().isEmpty
                                ? 'Name is required'
                                : null,
                        text: 'English',
                        isTamil: false,
                        controller: englishController,
                      ),

                      SizedBox(height: 20),

                      CustomContainer.studentInfoScreen(
                        errorText:
                            isSubmitted && tamilController.text.trim().isEmpty
                                ? 'Father name (Tamil) is required'
                                : null,
                        // onChanged: (value) async {
                        //   if (hasError && value.trim().isNotEmpty) {
                        //     setState(() {
                        //       hasError = false;
                        //     });
                        //   }
                        // },
                        onChanged: (value) async {
                          if (hasError && value.trim().isNotEmpty) {
                            setState(() {
                              hasError = false;
                            });
                          }
                          if (value.trim().isEmpty) {
                            setState(() => fatherSuggestions = []);
                            return;
                          }

                          setState(() => isFatherLoading = true);

                          final result =
                              await TanglishTamilHelper.transliterate(value);

                          setState(() {
                            fatherSuggestions = result;
                            isFatherLoading = false;
                          });
                        },

                        validator: null,
                        text: 'Tamil',
                        isTamil: false,
                        controller: tamilController,
                      ),
                      if (isFatherLoading)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      if (fatherSuggestions.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          constraints: const BoxConstraints(maxHeight: 150),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: fatherSuggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion = fatherSuggestions[index];
                              return ListTile(
                                title: Text(suggestion),
                                onTap: () {
                                  TanglishTamilHelper.applySuggestion(
                                    controller: tamilController,
                                    suggestion: suggestion,
                                    onSuggestionApplied: () {
                                      setState(() => fatherSuggestions = []);
                                    },
                                  );
                                },
                                // onTap:
                                //     () => _onSuggestionSelected(suggestion),
                              );
                            },
                          ),
                        ),

                      SizedBox(height: 20),
                      CustomTextField.richText(
                        text: 'Father Qualification',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },
                        errorText:
                            isSubmitted &&
                                    fatherQualification.text.trim().isEmpty
                                ? 'Father Qualification is required'
                                : null,
                        validator: null,
                        controller: fatherQualification,
                        text: '',
                        imagePath: AppImages.dropDown,
                        imageSize: 11,
                      ),

                      SizedBox(height: 20),
                      CustomTextField.richText(
                        text: 'Father Occupation',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },
                        errorText:
                            isSubmitted &&
                                    fatherOccupation.text.trim().isEmpty
                                ? 'Father Occupation is required'
                                : null,
                        validator: null,
                        controller: fatherOccupation,
                        text: '',
                        verticalDivider: false,
                      ),
                      SizedBox(height: 20),
                      CustomTextField.richText(
                        text: 'Father Annual Income (Rs.)',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },
                        errorText:
                            isSubmitted &&
                                    fatherAnnualIncome.text.trim().isEmpty
                                ? 'Father Annual Income is required'
                                : null,
                        validator: null,
                        controller: fatherAnnualIncome,
                        text: '',
                        verticalDivider: false,
                      ),

                      SizedBox(height: 20),
                      CustomTextField.richText(
                        text: 'Office Address',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },
                        errorText:
                            isSubmitted && officeAddress.text.trim().isEmpty
                                ? 'Office Address is required'
                                : null,
                        validator: null,
                        controller: officeAddress,
                        maxLine: 3,
                        text: '',
                        verticalDivider: false,
                      ),
                      SizedBox(height: 20),
                      Divider(color: AppColor.lightGrey),
                      SizedBox(height: 20),

                      CustomTextField.richText(
                        text: 'Mother Name',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },
                        errorText:
                            isSubmitted &&
                                    motherNameEnglishController.text
                                        .trim()
                                        .isEmpty
                                ? 'Mother Name is required'
                                : null,
                        validator: null,
                        text: 'English',
                        isTamil: false,
                        controller: motherNameEnglishController,
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        // onChanged: (value) {
                        //   if (isSubmitted && value.trim().isNotEmpty) {
                        //     setState(() {});
                        //   }
                        // },
                        onChanged: (value) async {
                          if (hasError && value.trim().isNotEmpty) {
                            setState(() {
                              hasError = false;
                            });
                          }
                          if (value.trim().isEmpty) {
                            setState(() => motherSuggestions = []);
                            return;
                          }

                          setState(() => isMotherLoading = true);

                          final result =
                              await TanglishTamilHelper.transliterate(value);

                          setState(() {
                            motherSuggestions = result;
                            isMotherLoading = false;
                          });
                        },
                        errorText:
                            isSubmitted &&
                                    motherNameTamilController.text
                                        .trim()
                                        .isEmpty
                                ? 'Mother Name (Tamil) is required'
                                : null,
                        validator: null,
                        text: 'Tamil',
                        isTamil: false,
                        controller: motherNameTamilController,
                      ),
                      if (isMotherLoading)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      if (motherSuggestions.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          constraints: const BoxConstraints(maxHeight: 150),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: motherSuggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion = motherSuggestions[index];
                              return ListTile(
                                title: Text(suggestion),
                                onTap: () {
                                  TanglishTamilHelper.applySuggestion(
                                    controller: motherNameTamilController,
                                    suggestion: suggestion,
                                    onSuggestionApplied: () {
                                      setState(() => motherSuggestions = []);
                                    },
                                  );
                                },
                                // onTap:
                                //     () => _onSuggestionSelected(suggestion),
                              );
                            },
                          ),
                        ),

                      SizedBox(height: 20),
                      CustomTextField.richText(
                        text: 'Mother Qualification',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },
                        errorText:
                            isSubmitted &&
                                    motherQualification.text.trim().isEmpty
                                ? 'Mother Qualification is required'
                                : null,
                        validator: null,
                        controller: motherQualification,
                        text: '',
                        imagePath: AppImages.dropDown,
                        imageSize: 11,
                        verticalDivider: false,
                      ),
                      SizedBox(height: 20),
                      CustomTextField.richText(
                        text: 'Mother Occupation',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },
                        errorText:
                            isSubmitted &&
                                    motherOccupation.text.trim().isEmpty
                                ? 'Mother Occupation is required'
                                : null,
                        validator: null,
                        controller: motherOccupation,
                        text: '',
                        verticalDivider: false,
                      ),
                      SizedBox(height: 20),
                      CustomTextField.richText(
                        text: 'Mother Annual Income (Rs.)',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },
                        errorText:
                            isSubmitted &&
                                    motherAnnualIncome.text.trim().isEmpty
                                ? 'Mother Annual is required'
                                : null,
                        validator: null,
                        controller: motherAnnualIncome,
                        text: '',
                        verticalDivider: false,
                      ),
                      SizedBox(height: 10),
                      CustomTextField.richText(
                        text: 'Office Address',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },
                        errorText:
                            isSubmitted &&
                                    motherOfficeAddressController.text
                                        .trim()
                                        .isEmpty
                                ? 'Office Address is required'
                                : null,
                        validator: null,
                        controller: motherOfficeAddressController,
                        maxLine: 3,
                        text: '',
                        verticalDivider: false,
                      ),
                    ],
                  ),
                ),
              ] else if (selected == 'Guardian') ...[
                Form(
                  key: _formKey1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField.richText(
                        text: 'Guardian Name',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },
                        errorText:
                            isSubmitted && guardianEnglish.text.trim().isEmpty
                                ? 'Guardian Name is required'
                                : null,
                        validator: null,
                        text: 'English',
                        isTamil: false,
                        controller: guardianEnglish,
                      ),

                      SizedBox(height: 20),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) async {
                          if (hasError && value.trim().isNotEmpty) {
                            setState(() {
                              hasError = false;
                            });
                          }
                          if (value.trim().isEmpty) {
                            setState(() => guardianSuggestions = []);
                            return;
                          }

                          setState(() => isGuardianLoading = true);

                          final result =
                              await TanglishTamilHelper.transliterate(value);

                          setState(() {
                            guardianSuggestions = result;
                            isGuardianLoading = false;
                          });
                        },
                        text: 'Tamil',
                        isTamil: false,
                        controller: guardianTamil,
                      ),
                      if (isGuardianLoading)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      if (guardianSuggestions.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          constraints: const BoxConstraints(maxHeight: 150),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: guardianSuggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion = guardianSuggestions[index];
                              return ListTile(
                                title: Text(suggestion),
                                onTap: () {
                                  TanglishTamilHelper.applySuggestion(
                                    controller: guardianTamil,
                                    suggestion: suggestion,
                                    onSuggestionApplied: () {
                                      setState(
                                        () => guardianSuggestions = [],
                                      );
                                    },
                                  );
                                },
                                // onTap:
                                //     () => _onSuggestionSelected(suggestion),
                              );
                            },
                          ),
                        ),

                      SizedBox(height: 20),

                      CustomTextField.richText(
                        text: 'Guardian Qualification',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },
                        errorText:
                            isSubmitted &&
                                    guardianQualification.text.trim().isEmpty
                                ? 'Guardian Qualification is required'
                                : null,
                        validator: null,
                        controller: guardianQualification,
                        text: '',
                        imagePath: AppImages.dropDown,
                        imageSize: 11,
                      ),

                      SizedBox(height: 20),
                      CustomTextField.richText(
                        text: 'Guardian Occupation',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },
                        errorText:
                            isSubmitted &&
                                    guardianOccupation.text.trim().isEmpty
                                ? 'Guardian Occupation is required'
                                : null,
                        validator: null,
                        controller: guardianOccupation,
                        text: '',
                        verticalDivider: false,
                      ),
                      SizedBox(height: 20),
                      CustomTextField.richText(
                        text: 'Guardian Annual Income (Rs.)',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },
                        errorText:
                            isSubmitted &&
                                    guardianAnnualIncome.text.trim().isEmpty
                                ? 'Guardian Annual Income is required'
                                : null,
                        validator: null,
                        controller: guardianAnnualIncome,
                        text: '',
                        verticalDivider: false,
                      ),
                      SizedBox(height: 10),
                      CustomTextField.richText(
                        text: 'Office Address',
                        text2: '',
                      ),
                      SizedBox(height: 10),
                      CustomContainer.studentInfoScreen(
                        onChanged: (value) {
                          if (isSubmitted && value.trim().isNotEmpty) {
                            setState(() {});
                          }
                        },
                        errorText:
                            isSubmitted &&
                                    guardianOfficeAddress.text.trim().isEmpty
                                ? 'Guardian Office Address is required'
                                : null,
                        validator: null,
                        controller: guardianOfficeAddress,
                        maxLine: 3,
                        text: '',
                        verticalDivider: false,
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 30),
              AppButton.button(
                image: AppImages.rightSaitArrow,
                text: 'Save & Continue',
                onTap: () {
                  setState(() {
                    isSubmitted = true;
                  });

                  if (selected == 'Father & Mother') {
                    bool isFatherFilled =
                        englishController.text.trim().isNotEmpty &&
                        tamilController.text.trim().isNotEmpty &&
                        fatherOccupation.text.trim().isNotEmpty &&
                        fatherQualification.text.trim().isNotEmpty &&
                        fatherAnnualIncome.text.trim().isNotEmpty &&
                        officeAddress.text.trim().isNotEmpty &&
                        motherNameEnglishController.text.trim().isNotEmpty &&
                        motherQualification.text.trim().isNotEmpty &&
                        motherOccupation.text.trim().isNotEmpty &&
                        motherAnnualIncome.text.trim().isNotEmpty &&
                        motherOfficeAddressController.text.trim().isNotEmpty;

                    if (!isFatherFilled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Please fill all Father & Mother details",
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SiblingsFormScreen(),
                      ),
                    );
                  }

                  if (selected == 'Guardian') {
                    bool isGuardianFilled =
                        guardianEnglish.text.trim().isNotEmpty &&
                        guardianTamil.text.trim().isNotEmpty &&
                        guardianOccupation.text.trim().isNotEmpty &&
                        guardianQualification.text.trim().isNotEmpty &&
                        guardianOfficeAddress.text.trim().isNotEmpty &&
                        guardianAnnualIncome.text.trim().isNotEmpty;

                    if (!isGuardianFilled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please fill all Guardian details"),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SiblingsFormScreen(),
                      ),
                    );
                  }
                },
              ),

              SizedBox(height: 20),
            ],

                        ),
        ),
      ),
      )
    );
  }
}
