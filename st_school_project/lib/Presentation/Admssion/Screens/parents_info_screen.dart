import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Utility/thanglish_to_tamil.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/siblings_form_screen.dart';
import 'package:http/http.dart' as http;

import '../Controller/admission_controller.dart';

///old ui///

// class ParentsInfoScreen extends StatefulWidget {
//   const ParentsInfoScreen({super.key});
//
//   @override
//   State<ParentsInfoScreen> createState() => _ParentsInfoScreenState();
// }
//
// class _ParentsInfoScreenState extends State<ParentsInfoScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   String selected = 'Father & Mother';
//   bool isSubmitted = false;
//
//   final _formKey1 = GlobalKey<FormState>();
//   bool hasError = false;
//
//   final AdmissionController ctrl = Get.put(AdmissionController());
//
//   final englishController = TextEditingController();
//   final tamilController = TextEditingController();
//   final fatherOccupation = TextEditingController();
//   final fatherQualification = TextEditingController();
//   final fatherAnnualIncome = TextEditingController();
//   final officeAddress = TextEditingController();
//   final motherQualification = TextEditingController();
//   final motherNameTamilController = TextEditingController();
//   final motherNameEnglishController = TextEditingController();
//   final motherOccupation = TextEditingController();
//   final motherOfficeAddressController = TextEditingController();
//   final motherAnnualIncome = TextEditingController();
//
//   final guardianEnglish = TextEditingController();
//   final guardianTamil = TextEditingController();
//   final guardianQualification = TextEditingController();
//   final guardianOccupation = TextEditingController();
//   final guardianAnnualIncome = TextEditingController();
//   final guardianOfficeAddress = TextEditingController();
//
//   List<String> fatherSuggestions = [];
//   bool isFatherLoading = false;
//   List<String> guardianSuggestions = [];
//   bool isGuardianLoading = false;
//
//   List<String> motherSuggestions = [];
//   bool isMotherLoading = false;
//   bool get isBothOfficeAddressEmpty {
//     return officeAddress.text.trim().isEmpty &&
//         motherOfficeAddressController.text.trim().isEmpty;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     CustomContainer.leftSaitArrow(
//                       onTap: () => Navigator.pop(context),
//                     ),
//                     // InkWell(
//                     //   onTap: () {
//                     //     Navigator.pop(context);
//                     //   },
//                     //   child: Container(
//                     //     decoration: BoxDecoration(
//                     //       color: AppColor.lightGrey,
//                     //       border: Border.all(
//                     //         color: AppColor.lowLightBlue,
//                     //         width: 1,
//                     //       ),
//                     //       borderRadius: BorderRadius.circular(30),
//                     //     ),
//                     //     child: Padding(
//                     //       padding: const EdgeInsets.all(10),
//                     //       child: Image.asset(
//                     //         AppImages.leftArrow,
//                     //         height: 12,
//                     //         width: 12,
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                     SizedBox(width: 15),
//                     Text(
//                       '2025 - 2026 LKG Admission',
//                       style: GoogleFont.ibmPlexSans(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppColor.black,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 30),
//                 LinearProgressIndicator(
//                   minHeight: 6,
//                   value: 0.4,
//
//                   valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
//                   stopIndicatorRadius: 16,
//                   backgroundColor: AppColor.lowGery1,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 SizedBox(height: 40),
//                 CustomTextField.textWith600(text: 'Parent Info', fontSize: 26),
//                 SizedBox(height: 20),
//
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selected = 'Father & Mother';
//                         });
//                       },
//                       child: CustomContainer.parentInfo(
//                         text: 'Father & Mother',
//                         isSelected: selected == 'Father & Mother',
//                       ),
//                     ),
//
//                     SizedBox(width: 20),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selected = 'Guardian';
//                         });
//                       },
//                       child: CustomContainer.parentInfo(
//                         text: 'Guardian',
//                         isSelected: selected == 'Guardian',
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: 20),
//                 if (selected == 'Father & Mother') ...[
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomTextField.richText(
//                           text: 'Father Name',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           isError:
//                               isSubmitted &&
//                               englishController.text.trim().isEmpty,
//                           errorText:
//                               isSubmitted &&
//                                       englishController.text.trim().isEmpty
//                                   ? 'Name is required'
//                                   : null,
//
//                           text: 'English',
//                           isTamil: false,
//                           controller: englishController,
//                         ),
//
//                         SizedBox(height: 20),
//
//                         CustomContainer.studentInfoScreen(
//                           errorText:
//                               isSubmitted && tamilController.text.trim().isEmpty
//                                   ? 'Father name (Tamil) is required'
//                                   : null,
//                           isError:
//                               isSubmitted &&
//                               tamilController.text.trim().isEmpty,
//                           onChanged: (value) async {
//                             if (hasError && value.trim().isNotEmpty) {
//                               setState(() {
//                                 hasError = false;
//                               });
//                             }
//                             if (value.trim().isEmpty) {
//                               setState(() => fatherSuggestions = []);
//                               return;
//                             }
//
//                             setState(() => isFatherLoading = true);
//
//                             final result =
//                                 await TanglishTamilHelper.transliterate(value);
//
//                             setState(() {
//                               fatherSuggestions = result;
//                               isFatherLoading = false;
//                             });
//                           },
//
//                           validator: null,
//                           text: 'Tamil',
//                           isTamil: false,
//                           controller: tamilController,
//                         ),
//                         if (isFatherLoading)
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           ),
//                         if (fatherSuggestions.isNotEmpty)
//                           Container(
//                             margin: const EdgeInsets.only(top: 4),
//                             constraints: const BoxConstraints(maxHeight: 150),
//                             decoration: BoxDecoration(
//                               color: AppColor.white,
//                               border: Border.all(color: AppColor.grey),
//                             ),
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: fatherSuggestions.length,
//                               itemBuilder: (context, index) {
//                                 final suggestion = fatherSuggestions[index];
//                                 return ListTile(
//                                   title: Text(suggestion),
//                                   onTap: () {
//                                     TanglishTamilHelper.applySuggestion(
//                                       controller: tamilController,
//                                       suggestion: suggestion,
//                                       onSuggestionApplied: () {
//                                         setState(() => fatherSuggestions = []);
//                                       },
//                                     );
//                                   },
//                                   // onTap:
//                                   //     () => _onSuggestionSelected(suggestion),
//                                 );
//                               },
//                             ),
//                           ),
//
//                         SizedBox(height: 20),
//                         CustomTextField.richText(
//                           text: 'Father Qualification',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               fatherQualification.text.trim().isEmpty,
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           errorText:
//                               isSubmitted &&
//                                       fatherQualification.text.trim().isEmpty
//                                   ? 'Father Qualification is required'
//                                   : null,
//                           validator: null,
//                           controller: fatherQualification,
//                           text: '',
//                           // imagePath: AppImages.dropDown,
//                           imageSize: 11,
//                         ),
//
//                         SizedBox(height: 20),
//                         CustomTextField.richText(
//                           text: 'Father Occupation',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               fatherOccupation.text.trim().isEmpty,
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           errorText:
//                               isSubmitted &&
//                                       fatherOccupation.text.trim().isEmpty
//                                   ? 'Father Occupation is required'
//                                   : null,
//                           validator: null,
//                           controller: fatherOccupation,
//                           text: '',
//                           verticalDivider: false,
//                         ),
//                         SizedBox(height: 20),
//                         CustomTextField.richText(
//                           text: 'Father Annual Income (Rs.)',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           keyboardType: TextInputType.number,
//                           isMobile: true,
//                           isError:
//                               isSubmitted &&
//                               fatherAnnualIncome.text.trim().isEmpty,
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           errorText:
//                               isSubmitted &&
//                                       fatherAnnualIncome.text.trim().isEmpty
//                                   ? 'Father Annual Income is required'
//                                   : null,
//                           validator: null,
//                           controller: fatherAnnualIncome,
//                           text: '',
//                           verticalDivider: false,
//                         ),
//
//                         SizedBox(height: 20),
//                         CustomTextField.richText(
//                           text: 'Office Address',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           // isError: isSubmitted && isBothOfficeAddressEmpty,
//                           // // onChanged: (value) {
//                           // //   if (isSubmitted && value.trim().isNotEmpty) {
//                           // //     setState(() {});
//                           // //   }
//                           // // },
//                           // // errorText:
//                           // //     isSubmitted && isBothOfficeAddressEmpty
//                           // //         ? 'Office Address is required'
//                           // //         : null,
//                           // validator: null,
//                           controller: officeAddress,
//                           maxLine: 3,
//                           text: '',
//                           verticalDivider: false,
//                         ),
//                         SizedBox(height: 20),
//                         Divider(color: AppColor.lightGrey),
//                         SizedBox(height: 20),
//
//                         CustomTextField.richText(
//                           text: 'Mother Name',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               motherNameEnglishController.text.trim().isEmpty,
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           errorText:
//                               isSubmitted &&
//                                       motherNameEnglishController.text
//                                           .trim()
//                                           .isEmpty
//                                   ? 'Mother Name is required'
//                                   : null,
//                           validator: null,
//                           text: 'English',
//                           isTamil: false,
//                           controller: motherNameEnglishController,
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               motherNameTamilController.text.trim().isEmpty,
//                           onChanged: (value) async {
//                             if (hasError && value.trim().isNotEmpty) {
//                               setState(() {
//                                 hasError = false;
//                               });
//                             }
//                             if (value.trim().isEmpty) {
//                               setState(() => motherSuggestions = []);
//                               return;
//                             }
//
//                             setState(() => isMotherLoading = true);
//
//                             final result =
//                                 await TanglishTamilHelper.transliterate(value);
//
//                             setState(() {
//                               motherSuggestions = result;
//                               isMotherLoading = false;
//                             });
//                           },
//                           errorText:
//                               isSubmitted &&
//                                       motherNameTamilController.text
//                                           .trim()
//                                           .isEmpty
//                                   ? 'Mother Name (Tamil) is required'
//                                   : null,
//                           validator: null,
//                           text: 'Tamil',
//                           isTamil: false,
//                           controller: motherNameTamilController,
//                         ),
//                         if (isMotherLoading)
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           ),
//                         if (motherSuggestions.isNotEmpty)
//                           Container(
//                             margin: const EdgeInsets.only(top: 4),
//                             constraints: const BoxConstraints(maxHeight: 150),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(color: Colors.grey),
//                             ),
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: motherSuggestions.length,
//                               itemBuilder: (context, index) {
//                                 final suggestion = motherSuggestions[index];
//                                 return ListTile(
//                                   title: Text(suggestion),
//                                   onTap: () {
//                                     TanglishTamilHelper.applySuggestion(
//                                       controller: motherNameTamilController,
//                                       suggestion: suggestion,
//                                       onSuggestionApplied: () {
//                                         setState(() => motherSuggestions = []);
//                                       },
//                                     );
//                                   },
//                                   // onTap:
//                                   //     () => _onSuggestionSelected(suggestion),
//                                 );
//                               },
//                             ),
//                           ),
//
//                         SizedBox(height: 20),
//                         CustomTextField.richText(
//                           text: 'Mother Qualification',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               motherQualification.text.trim().isEmpty,
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           errorText:
//                               isSubmitted &&
//                                       motherQualification.text.trim().isEmpty
//                                   ? 'Mother Qualification is required'
//                                   : null,
//                           validator: null,
//                           controller: motherQualification,
//                           text: '',
//                           // imagePath: AppImages.dropDown,
//                           imageSize: 11,
//                           verticalDivider: false,
//                         ),
//                         SizedBox(height: 20),
//                         CustomTextField.richText(
//                           text: 'Mother Occupation',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               motherOccupation.text.trim().isEmpty,
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           errorText:
//                               isSubmitted &&
//                                       motherOccupation.text.trim().isEmpty
//                                   ? 'Mother Occupation is required'
//                                   : null,
//                           validator: null,
//                           controller: motherOccupation,
//                           text: '',
//                           verticalDivider: false,
//                         ),
//                         SizedBox(height: 20),
//                         CustomTextField.richText(
//                           text: 'Mother Annual Income (Rs.)',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           keyboardType: TextInputType.number,
//                           isMobile: true,
//                           isError:
//                               isSubmitted &&
//                               motherAnnualIncome.text.trim().isEmpty,
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           errorText:
//                               isSubmitted &&
//                                       motherAnnualIncome.text.trim().isEmpty
//                                   ? 'Mother Annual is required'
//                                   : null,
//                           validator: null,
//                           controller: motherAnnualIncome,
//                           text: '',
//                           verticalDivider: false,
//                         ),
//                         SizedBox(height: 10),
//                         CustomTextField.richText(
//                           text: 'Office Address',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           // isError: isSubmitted && isBothOfficeAddressEmpty,
//                           // onChanged: (value) {
//                           //   if (isSubmitted && value.trim().isNotEmpty) {
//                           //     setState(() {});
//                           //   }
//                           // },
//                           //
//                           // errorText:
//                           //     isSubmitted && isBothOfficeAddressEmpty
//                           //         ? 'Office Address is required'
//                           //         : null,
//                           // validator: null,
//                           controller: motherOfficeAddressController,
//                           maxLine: 3,
//                           text: '',
//                           verticalDivider: false,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ] else if (selected == 'Guardian') ...[
//                   Form(
//                     key: _formKey1,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomTextField.richText(
//                           text: 'Guardian Name',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               guardianEnglish.text.trim().isEmpty,
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           errorText:
//                               isSubmitted && guardianEnglish.text.trim().isEmpty
//                                   ? 'Guardian Name is required'
//                                   : null,
//                           validator: null,
//                           text: 'English',
//                           isTamil: false,
//                           controller: guardianEnglish,
//                         ),
//
//                         SizedBox(height: 20),
//                         CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted && guardianTamil.text.trim().isEmpty,
//                           onChanged: (value) async {
//                             if (hasError && value.trim().isNotEmpty) {
//                               setState(() {
//                                 hasError = false;
//                               });
//                             }
//                             if (value.trim().isEmpty) {
//                               setState(() => guardianSuggestions = []);
//                               return;
//                             }
//
//                             setState(() => isGuardianLoading = true);
//
//                             final result =
//                                 await TanglishTamilHelper.transliterate(value);
//
//                             setState(() {
//                               guardianSuggestions = result;
//                               isGuardianLoading = false;
//                             });
//                           },
//                           text: 'Tamil',
//                           isTamil: false,
//                           controller: guardianTamil,
//                         ),
//                         if (isGuardianLoading)
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           ),
//                         if (guardianSuggestions.isNotEmpty)
//                           Container(
//                             margin: const EdgeInsets.only(top: 4),
//                             constraints: const BoxConstraints(maxHeight: 150),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(color: Colors.grey),
//                             ),
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: guardianSuggestions.length,
//                               itemBuilder: (context, index) {
//                                 final suggestion = guardianSuggestions[index];
//                                 return ListTile(
//                                   title: Text(suggestion),
//                                   onTap: () {
//                                     TanglishTamilHelper.applySuggestion(
//                                       controller: guardianTamil,
//                                       suggestion: suggestion,
//                                       onSuggestionApplied: () {
//                                         setState(
//                                           () => guardianSuggestions = [],
//                                         );
//                                       },
//                                     );
//                                   },
//                                   // onTap:
//                                   //     () => _onSuggestionSelected(suggestion),
//                                 );
//                               },
//                             ),
//                           ),
//
//                         SizedBox(height: 20),
//
//                         CustomTextField.richText(
//                           text: 'Guardian Qualification',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               guardianQualification.text.trim().isEmpty,
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           errorText:
//                               isSubmitted &&
//                                       guardianQualification.text.trim().isEmpty
//                                   ? 'Guardian Qualification is required'
//                                   : null,
//                           validator: null,
//                           controller: guardianQualification,
//                           text: '',
//                           // imagePath: AppImages.dropDown,
//                           imageSize: 11,
//                         ),
//
//                         SizedBox(height: 20),
//                         CustomTextField.richText(
//                           text: 'Guardian Occupation',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               guardianOccupation.text.trim().isEmpty,
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           errorText:
//                               isSubmitted &&
//                                       guardianOccupation.text.trim().isEmpty
//                                   ? 'Guardian Occupation is required'
//                                   : null,
//                           validator: null,
//                           controller: guardianOccupation,
//                           text: '',
//                           verticalDivider: false,
//                         ),
//                         SizedBox(height: 20),
//                         CustomTextField.richText(
//                           text: 'Guardian Annual Income (Rs.)',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               guardianAnnualIncome.text.trim().isEmpty,
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           errorText:
//                               isSubmitted &&
//                                       guardianAnnualIncome.text.trim().isEmpty
//                                   ? 'Guardian Annual Income is required'
//                                   : null,
//                           validator: null,
//                           controller: guardianAnnualIncome,
//                           text: '',
//                           verticalDivider: false,
//                         ),
//                         SizedBox(height: 10),
//                         CustomTextField.richText(
//                           text: 'Office Address',
//                           text2: '',
//                         ),
//                         SizedBox(height: 10),
//                         CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               guardianOfficeAddress.text.trim().isEmpty,
//
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           errorText:
//                               isSubmitted &&
//                                       guardianOfficeAddress.text.trim().isEmpty
//                                   ? 'Guardian Office Address is required'
//                                   : null,
//                           validator: null,
//                           controller: guardianOfficeAddress,
//                           maxLine: 3,
//                           text: '',
//                           verticalDivider: false,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//
//                 SizedBox(height: 30),
//                 AppButton.button(
//                   image: AppImages.rightSaitArrow,
//                   text: 'Save & Continue',
//                   onTap: () {
//                     HapticFeedback.heavyImpact();
//                     setState(() {
//                       isSubmitted = true;
//                     });
//
//                     if (selected == 'Father & Mother') {
//                       bool isFatherFilled =
//                           englishController.text.trim().isNotEmpty &&
//                           tamilController.text.trim().isNotEmpty &&
//                           fatherOccupation.text.trim().isNotEmpty &&
//                           fatherQualification.text.trim().isNotEmpty &&
//                           fatherAnnualIncome.text.trim().isNotEmpty &&
//                           motherNameEnglishController.text.trim().isNotEmpty &&
//                           motherQualification.text.trim().isNotEmpty &&
//                           motherOccupation.text.trim().isNotEmpty &&
//                           motherAnnualIncome.text.trim().isNotEmpty;
//
//                       if (isFatherFilled) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SiblingsFormScreen(),
//                           ),
//                         );
//                       }
//                     }
//
//                     if (selected == 'Guardian') {
//                       bool isGuardianFilled =
//                           guardianEnglish.text.trim().isNotEmpty &&
//                           guardianTamil.text.trim().isNotEmpty &&
//                           guardianOccupation.text.trim().isNotEmpty &&
//                           guardianQualification.text.trim().isNotEmpty &&
//                           guardianAnnualIncome.text.trim().isNotEmpty;
//
//                       if (isGuardianFilled) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SiblingsFormScreen(),
//                           ),
//                         );
//                       }
//                     }
//                   },
//                 ),
//
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

///new ui///
// typedef ParentsInfoSubmitter =
//     Future<String?> Function({
//       required int id,
//       required String fatherName,
//       required String fatherNameTamil,
//       required String fatherQualification,
//       required String fatherOccupation,
//       required int fatherIncome,
//       required String fatherOfficeAddress,
//       required String motherName,
//       required String motherNameTamil,
//       required String motherQualification,
//       required String motherOccupation,
//       required int motherIncome,
//       required String motherOfficeAddress,
//       required bool hasGuardian,
//     });
//
// class ParentsInfoScreen extends StatefulWidget {
//   const ParentsInfoScreen({
//     super.key,
//     required this.applicationId,
//     required this.onSubmitParentsInfo,
//   });
//
//   /// Pass your real application/admission id from previous step
//   final int applicationId;
//
//   /// Inject your controller service here (calls API and returns error string or null)
//   final ParentsInfoSubmitter onSubmitParentsInfo;
//
//   @override
//   State<ParentsInfoScreen> createState() => _ParentsInfoScreenState();
// }
//
// class _ParentsInfoScreenState extends State<ParentsInfoScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _formKey1 = GlobalKey<FormState>();
//
//   String selected = 'Father & Mother';
//   bool isSubmitted = false;
//   bool hasError = false;
//
//   // ===== Controllers =====
//   final englishController = TextEditingController();
//   final tamilController = TextEditingController();
//   final fatherOccupation = TextEditingController();
//   final fatherQualification = TextEditingController();
//   final fatherAnnualIncome = TextEditingController();
//   final officeAddress = TextEditingController();
//
//   final motherQualification = TextEditingController();
//   final motherNameTamilController = TextEditingController();
//   final motherNameEnglishController = TextEditingController();
//   final motherOccupation = TextEditingController();
//   final motherOfficeAddressController = TextEditingController();
//   final motherAnnualIncome = TextEditingController();
//
//   final guardianEnglish = TextEditingController();
//   final guardianTamil = TextEditingController();
//   final guardianQualification = TextEditingController();
//   final guardianOccupation = TextEditingController();
//   final guardianAnnualIncome = TextEditingController();
//   final guardianOfficeAddress = TextEditingController();
//
//   // ===== Suggestions for transliteration =====
//   List<String> fatherSuggestions = [];
//   bool isFatherLoading = false;
//   List<String> guardianSuggestions = [];
//   bool isGuardianLoading = false;
//   List<String> motherSuggestions = [];
//   bool isMotherLoading = false;
//
//   // ===== Dropdown lookups (can be swapped for API-driven lists) =====
//   static const List<String> kQualifications = [
//     'Illiterate',
//     'Primary School',
//     'Middle School',
//     'High School',
//     'Diploma',
//     'Undergraduate',
//     'Postgraduate',
//     'PhD',
//     'Professional',
//   ];
//
//   static const List<String> kOccupations = [
//     'Government Service',
//     'Private Service',
//     'Teacher',
//     'Business',
//     'Self Employed',
//     'Driver',
//     'Farmer',
//     'Doctor',
//     'Engineer',
//     'Lawyer',
//     'Home Maker',
//   ];
//
//   bool _submitting = false;
//
//   // ===== Helpers =====
//   bool get isBothOfficeAddressEmpty =>
//       officeAddress.text.trim().isEmpty &&
//       motherOfficeAddressController.text.trim().isEmpty;
//
//   String? _required(TextEditingController c, String name) {
//     if (c.text.trim().isEmpty) return '$name is required';
//     return null;
//   }
//
//   int _parseInt(String s) {
//     final digits = s.replaceAll(RegExp(r'[^0-9]'), '');
//     if (digits.isEmpty) return 0;
//     return int.tryParse(digits) ?? 0;
//   }
//
//   String? _requireAnyOfficeAddress() {
//     if (isBothOfficeAddressEmpty) {
//       return 'Please enter at least one Office Address (Father or Mother).';
//     }
//     return null;
//   }
//
//   Future<void> _openSelectAndFill({
//     required String title,
//     required List<String> options,
//     required TextEditingController controller,
//   }) async {
//     final choice = await showModalBottomSheet<String>(
//       context: context,
//       isScrollControlled: true,
//       builder: (ctx) {
//         final search = TextEditingController();
//         List<String> filtered = List.from(options);
//
//         void doFilter(String q) {
//           filtered =
//               options
//                   .where((o) => o.toLowerCase().contains(q.toLowerCase()))
//                   .toList();
//           (ctx as Element).markNeedsBuild();
//         }
//
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(ctx).viewInsets.bottom,
//             left: 16,
//             right: 16,
//             top: 16,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 title,
//                 style: GoogleFont.ibmPlexSans(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: search,
//                 decoration: const InputDecoration(
//                   hintText: 'Search…',
//                   border: OutlineInputBorder(),
//                 ),
//                 onChanged: doFilter,
//               ),
//               const SizedBox(height: 12),
//               ConstrainedBox(
//                 constraints: const BoxConstraints(maxHeight: 340),
//                 child: ListView.separated(
//                   shrinkWrap: true,
//                   itemCount: filtered.length,
//                   separatorBuilder: (_, __) => const Divider(height: 1),
//                   itemBuilder:
//                       (_, i) => ListTile(
//                         title: Text(filtered[i]),
//                         onTap: () => Navigator.pop(ctx, filtered[i]),
//                       ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children:
//                     {
//                       Expanded(
//                         child: TextField(
//                           controller: search,
//                           decoration: const InputDecoration(
//                             hintText: 'Or type your own…',
//                             border: OutlineInputBorder(),
//                           ),
//                           onSubmitted: (v) {
//                             if (v.trim().isNotEmpty) {
//                               Navigator.pop(ctx, v.trim());
//                             }
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       ElevatedButton(
//                         onPressed: () {
//                           final v = search.text.trim();
//                           if (v.isNotEmpty) Navigator.pop(ctx, v);
//                         },
//                         child: const Text('Use'),
//                       ),
//                     }.toList(),
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         );
//       },
//     );
//
//     if (choice != null && choice.trim().isNotEmpty) {
//       controller.text = choice.trim();
//       setState(() {});
//     }
//   }
//
//   Future<void> _submitParentsInfo() async {
//     setState(() {
//       isSubmitted = true;
//     });
//
//     final addressError = _requireAnyOfficeAddress();
//
//     if (selected == 'Father & Mother') {
//       final errs =
//           [
//             _required(englishController, 'Father Name'),
//             _required(tamilController, 'Father Name (Tamil)'),
//             _required(fatherQualification, 'Father Qualification'),
//             _required(fatherOccupation, 'Father Occupation'),
//             _required(fatherAnnualIncome, 'Father Annual Income'),
//             _required(motherNameEnglishController, 'Mother Name'),
//             _required(motherNameTamilController, 'Mother Name (Tamil)'),
//             _required(motherQualification, 'Mother Qualification'),
//             _required(motherOccupation, 'Mother Occupation'),
//             _required(motherAnnualIncome, 'Mother Annual Income'),
//             addressError,
//           ].whereType<String>().toList();
//
//       if (errs.isNotEmpty) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(errs.first)));
//         return;
//       }
//     } else {
//       final errs =
//           [
//             _required(guardianEnglish, 'Guardian Name'),
//             _required(guardianTamil, 'Guardian Name (Tamil)'),
//             _required(guardianQualification, 'Guardian Qualification'),
//             _required(guardianOccupation, 'Guardian Occupation'),
//             _required(guardianAnnualIncome, 'Guardian Annual Income'),
//             _required(guardianOfficeAddress, 'Guardian Office Address'),
//           ].whereType<String>().toList();
//
//       if (errs.isNotEmpty) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(errs.first)));
//         return;
//       }
//     }
//
//     setState(() {
//       _submitting = true;
//     });
//
//     try {
//       final String? err = await widget.onSubmitParentsInfo(
//         id: widget.applicationId,
//         fatherName: englishController.text.trim(),
//         fatherNameTamil: tamilController.text.trim(),
//         fatherQualification: fatherQualification.text.trim(),
//         fatherOccupation: fatherOccupation.text.trim(),
//         fatherIncome: _parseInt(fatherAnnualIncome.text),
//         fatherOfficeAddress: officeAddress.text.trim(),
//         motherName: motherNameEnglishController.text.trim(),
//         motherNameTamil: motherNameTamilController.text.trim(),
//         motherQualification: motherQualification.text.trim(),
//         motherOccupation: motherOccupation.text.trim(),
//         motherIncome: _parseInt(motherAnnualIncome.text),
//         motherOfficeAddress: motherOfficeAddressController.text.trim(),
//         hasGuardian: selected == 'Guardian',
//       );
//
//       if (err != null) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(err)));
//         return;
//       }
//
//       if (!mounted) return;
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Parent info saved')));
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const SiblingsFormScreen()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed: $e')));
//     } finally {
//       if (mounted) {
//         setState(() {
//           _submitting = false;
//         });
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     englishController.dispose();
//     tamilController.dispose();
//     fatherOccupation.dispose();
//     fatherQualification.dispose();
//     fatherAnnualIncome.dispose();
//     officeAddress.dispose();
//
//     motherQualification.dispose();
//     motherNameTamilController.dispose();
//     motherNameEnglishController.dispose();
//     motherOccupation.dispose();
//     motherOfficeAddressController.dispose();
//     motherAnnualIncome.dispose();
//
//     guardianEnglish.dispose();
//     guardianTamil.dispose();
//     guardianQualification.dispose();
//     guardianOccupation.dispose();
//     guardianAnnualIncome.dispose();
//     guardianOfficeAddress.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final content = Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header row
//             Row(
//               children: [
//                 CustomContainer.leftSaitArrow(
//                   onTap: () => Navigator.pop(context),
//                 ),
//                 const SizedBox(width: 15),
//                 Text(
//                   '2025 - 2026 LKG Admission',
//                   style: GoogleFont.ibmPlexSans(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: AppColor.black,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 30),
//             // Progress
//             LinearProgressIndicator(
//               minHeight: 6,
//               value: 0.4,
//               valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
//               backgroundColor: AppColor.lowGery1,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             SizedBox(height: 40),
//             CustomTextField.textWith600(text: 'Parent Info', fontSize: 26),
//             const SizedBox(height: 20),
//
//             // Tabs
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => setState(() => selected = 'Father & Mother'),
//                   child: CustomContainer.parentInfo(
//                     text: 'Father & Mother',
//                     isSelected: selected == 'Father & Mother',
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 GestureDetector(
//                   onTap: () => setState(() => selected = 'Guardian'),
//                   child: CustomContainer.parentInfo(
//                     text: 'Guardian',
//                     isSelected: selected == 'Guardian',
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             if (selected == 'Father & Mother') ...[
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Father Name
//                     CustomTextField.richText(text: 'Father Name', text2: ''),
//                     const SizedBox(height: 10),
//                     CustomContainer.studentInfoScreen(
//                       onChanged: (value) {
//                         if (isSubmitted && value.trim().isNotEmpty) {
//                           setState(() {});
//                         }
//                       },
//                       isError:
//                           isSubmitted && englishController.text.trim().isEmpty,
//                       errorText:
//                           isSubmitted && englishController.text.trim().isEmpty
//                               ? 'Name is required'
//                               : null,
//                       text: 'English',
//                       isTamil: false,
//                       controller: englishController,
//                     ),
//                     const SizedBox(height: 20),
//
//                     // Father Name (Tamil) + suggestions
//                     CustomContainer.studentInfoScreen(
//                       errorText:
//                           isSubmitted && tamilController.text.trim().isEmpty
//                               ? 'Father name (Tamil) is required'
//                               : null,
//                       isError:
//                           isSubmitted && tamilController.text.trim().isEmpty,
//                       onChanged: (value) async {
//                         if (hasError && value.trim().isNotEmpty) {
//                           setState(() {
//                             hasError = false;
//                           });
//                         }
//                         if (value.trim().isEmpty) {
//                           setState(() => fatherSuggestions = []);
//                           return;
//                         }
//                         setState(() => isFatherLoading = true);
//                         final result = await TanglishTamilHelper.transliterate(
//                           value,
//                         );
//                         setState(() {
//                           fatherSuggestions = result;
//                           isFatherLoading = false;
//                         });
//                       },
//                       validator: null,
//                       text: 'Tamil',
//                       isTamil: false,
//                       controller: tamilController,
//                     ),
//                     if (isFatherLoading)
//                       const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       ),
//                     if (fatherSuggestions.isNotEmpty)
//                       Container(
//                         margin: const EdgeInsets.only(top: 4),
//                         constraints: const BoxConstraints(maxHeight: 150),
//                         decoration: BoxDecoration(
//                           color: AppColor.white,
//                           border: Border.all(color: AppColor.grey),
//                         ),
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: fatherSuggestions.length,
//                           itemBuilder: (context, index) {
//                             final suggestion = fatherSuggestions[index];
//                             return ListTile(
//                               title: Text(suggestion),
//                               onTap: () {
//                                 TanglishTamilHelper.applySuggestion(
//                                   controller: tamilController,
//                                   suggestion: suggestion,
//                                   onSuggestionApplied: () {
//                                     setState(() => fatherSuggestions = []);
//                                   },
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//
//                     const SizedBox(height: 20),
//
//                     // Father Qualification (dropdown + manual)
//                     CustomTextField.richText(
//                       text: 'Father Qualification',
//                       text2: '',
//                     ),
//                     const SizedBox(height: 10),
//                     GestureDetector(
//                       onTap:
//                           () => _openSelectAndFill(
//                             title: 'Father Qualification',
//                             options: kQualifications,
//                             controller: fatherQualification,
//                           ),
//                       child: AbsorbPointer(
//                         child: CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               fatherQualification.text.trim().isEmpty,
//                           errorText:
//                               isSubmitted &&
//                                       fatherQualification.text.trim().isEmpty
//                                   ? 'Father Qualification is required'
//                                   : null,
//                           controller: fatherQualification,
//                           text: '',
//                           imagePath: AppImages.dropDown,
//                           imageSize: 11,
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Father Occupation (dropdown + manual)
//                     CustomTextField.richText(
//                       text: 'Father Occupation',
//                       text2: '',
//                     ),
//                     const SizedBox(height: 10),
//                     GestureDetector(
//                       onTap:
//                           () => _openSelectAndFill(
//                             title: 'Father Occupation',
//                             options: kOccupations,
//                             controller: fatherOccupation,
//                           ),
//                       child: AbsorbPointer(
//                         child: CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               fatherOccupation.text.trim().isNotEmpty == false,
//                           errorText:
//                               isSubmitted &&
//                                       fatherOccupation.text.trim().isEmpty
//                                   ? 'Father Occupation is required'
//                                   : null,
//                           controller: fatherOccupation,
//                           text: '',
//                           verticalDivider: false,
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Father Annual Income (numeric only)
//                     CustomTextField.richText(
//                       text: 'Father Annual Income (Rs.)',
//                       text2: '',
//                     ),
//                     const SizedBox(height: 10),
//                     CustomContainer.studentInfoScreen(
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       isMobile: true,
//                       isError:
//                           isSubmitted && fatherAnnualIncome.text.trim().isEmpty,
//                       onChanged: (value) {
//                         if (isSubmitted && value.trim().isNotEmpty) {
//                           setState(() {});
//                         }
//                       },
//                       errorText:
//                           isSubmitted && fatherAnnualIncome.text.trim().isEmpty
//                               ? 'Father Annual Income is required'
//                               : null,
//                       validator: null,
//                       controller: fatherAnnualIncome,
//                       text: '',
//                       verticalDivider: false,
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Father Office Address
//                     CustomTextField.richText(text: 'Office Address', text2: ''),
//                     const SizedBox(height: 10),
//                     CustomContainer.studentInfoScreen(
//                       controller: officeAddress,
//                       maxLine: 3,
//                       text: '',
//                       verticalDivider: false,
//                     ),
//
//                     const SizedBox(height: 20),
//                     Divider(color: AppColor.lightGrey),
//                     const SizedBox(height: 20),
//
//                     // Mother Name
//                     CustomTextField.richText(text: 'Mother Name', text2: ''),
//                     const SizedBox(height: 10),
//                     CustomContainer.studentInfoScreen(
//                       isError:
//                           isSubmitted &&
//                           motherNameEnglishController.text.trim().isEmpty,
//                       onChanged: (value) {
//                         if (isSubmitted && value.trim().isNotEmpty) {
//                           setState(() {});
//                         }
//                       },
//                       errorText:
//                           isSubmitted &&
//                                   motherNameEnglishController.text
//                                       .trim()
//                                       .isEmpty
//                               ? 'Mother Name is required'
//                               : null,
//                       validator: null,
//                       text: 'English',
//                       isTamil: false,
//                       controller: motherNameEnglishController,
//                     ),
//                     const SizedBox(height: 10),
//                     CustomContainer.studentInfoScreen(
//                       isError:
//                           isSubmitted &&
//                           motherNameTamilController.text.trim().isEmpty,
//                       onChanged: (value) async {
//                         if (hasError && value.trim().isNotEmpty) {
//                           setState(() {
//                             hasError = false;
//                           });
//                         }
//                         if (value.trim().isEmpty) {
//                           setState(() => motherSuggestions = []);
//                           return;
//                         }
//                         setState(() => isMotherLoading = true);
//                         final result = await TanglishTamilHelper.transliterate(
//                           value,
//                         );
//                         setState(() {
//                           motherSuggestions = result;
//                           isMotherLoading = false;
//                         });
//                       },
//                       errorText:
//                           isSubmitted &&
//                                   motherNameTamilController.text.trim().isEmpty
//                               ? 'Mother Name (Tamil) is required'
//                               : null,
//                       validator: null,
//                       text: 'Tamil',
//                       isTamil: false,
//                       controller: motherNameTamilController,
//                     ),
//                     if (isMotherLoading)
//                       const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       ),
//                     if (motherSuggestions.isNotEmpty)
//                       Container(
//                         margin: const EdgeInsets.only(top: 4),
//                         constraints: const BoxConstraints(maxHeight: 150),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(color: Colors.grey),
//                         ),
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: motherSuggestions.length,
//                           itemBuilder: (context, index) {
//                             final suggestion = motherSuggestions[index];
//                             return ListTile(
//                               title: Text(suggestion),
//                               onTap: () {
//                                 TanglishTamilHelper.applySuggestion(
//                                   controller: motherNameTamilController,
//                                   suggestion: suggestion,
//                                   onSuggestionApplied: () {
//                                     setState(() => motherSuggestions = []);
//                                   },
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//
//                     const SizedBox(height: 20),
//
//                     // Mother Qualification (dropdown + manual)
//                     CustomTextField.richText(
//                       text: 'Mother Qualification',
//                       text2: '',
//                     ),
//                     const SizedBox(height: 10),
//                     GestureDetector(
//                       onTap:
//                           () => _openSelectAndFill(
//                             title: 'Mother Qualification',
//                             options: kQualifications,
//                             controller: motherQualification,
//                           ),
//                       child: AbsorbPointer(
//                         child: CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               motherQualification.text.trim().isEmpty,
//                           errorText:
//                               isSubmitted &&
//                                       motherQualification.text.trim().isEmpty
//                                   ? 'Mother Qualification is required'
//                                   : null,
//                           validator: null,
//                           controller: motherQualification,
//                           text: '',
//                           imagePath: AppImages.dropDown,
//                           imageSize: 11,
//                           verticalDivider: false,
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Mother Occupation (dropdown + manual)
//                     CustomTextField.richText(
//                       text: 'Mother Occupation',
//                       text2: '',
//                     ),
//                     const SizedBox(height: 10),
//                     GestureDetector(
//                       onTap:
//                           () => _openSelectAndFill(
//                             title: 'Mother Occupation',
//                             options: kOccupations,
//                             controller: motherOccupation,
//                           ),
//                       child: AbsorbPointer(
//                         child: CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               motherOccupation.text.trim().isEmpty,
//                           errorText:
//                               isSubmitted &&
//                                       motherOccupation.text.trim().isEmpty
//                                   ? 'Mother Occupation is required'
//                                   : null,
//                           validator: null,
//                           controller: motherOccupation,
//                           text: '',
//                           verticalDivider: false,
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Mother Annual Income (numeric only)
//                     CustomTextField.richText(
//                       text: 'Mother Annual Income (Rs.)',
//                       text2: '',
//                     ),
//                     const SizedBox(height: 10),
//                     CustomContainer.studentInfoScreen(
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       isMobile: true,
//                       isError:
//                           isSubmitted && motherAnnualIncome.text.trim().isEmpty,
//                       onChanged: (value) {
//                         if (isSubmitted && value.trim().isNotEmpty) {
//                           setState(() {});
//                         }
//                       },
//                       errorText:
//                           isSubmitted && motherAnnualIncome.text.trim().isEmpty
//                               ? 'Mother Annual is required'
//                               : null,
//                       validator: null,
//                       controller: motherAnnualIncome,
//                       text: '',
//                       verticalDivider: false,
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     // Mother Office Address
//                     CustomTextField.richText(text: 'Office Address', text2: ''),
//                     const SizedBox(height: 10),
//                     CustomContainer.studentInfoScreen(
//                       controller: motherOfficeAddressController,
//                       maxLine: 3,
//                       text: '',
//                       verticalDivider: false,
//                     ),
//                   ],
//                 ),
//               ),
//             ] else ...[
//               // Guardian flow
//               Form(
//                 key: _formKey1,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Guardian Name
//                     CustomTextField.richText(text: 'Guardian Name', text2: ''),
//                     const SizedBox(height: 10),
//                     CustomContainer.studentInfoScreen(
//                       isError:
//                           isSubmitted && guardianEnglish.text.trim().isEmpty,
//                       onChanged: (value) {
//                         if (isSubmitted && value.trim().isNotEmpty) {
//                           setState(() {});
//                         }
//                       },
//                       errorText:
//                           isSubmitted && guardianEnglish.text.trim().isEmpty
//                               ? 'Guardian Name is required'
//                               : null,
//                       validator: null,
//                       text: 'English',
//                       isTamil: false,
//                       controller: guardianEnglish,
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     CustomContainer.studentInfoScreen(
//                       isError: isSubmitted && guardianTamil.text.trim().isEmpty,
//                       onChanged: (value) async {
//                         if (hasError && value.trim().isNotEmpty) {
//                           setState(() {
//                             hasError = false;
//                           });
//                         }
//                         if (value.trim().isEmpty) {
//                           setState(() => guardianSuggestions = []);
//                           return;
//                         }
//                         setState(() => isGuardianLoading = true);
//                         final result = await TanglishTamilHelper.transliterate(
//                           value,
//                         );
//                         setState(() {
//                           guardianSuggestions = result;
//                           isGuardianLoading = false;
//                         });
//                       },
//                       text: 'Tamil',
//                       isTamil: false,
//                       controller: guardianTamil,
//                     ),
//                     if (isGuardianLoading)
//                       const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       ),
//                     if (guardianSuggestions.isNotEmpty)
//                       Container(
//                         margin: const EdgeInsets.only(top: 4),
//                         constraints: const BoxConstraints(maxHeight: 150),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(color: Colors.grey),
//                         ),
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: guardianSuggestions.length,
//                           itemBuilder: (context, index) {
//                             final suggestion = guardianSuggestions[index];
//                             return ListTile(
//                               title: Text(suggestion),
//                               onTap: () {
//                                 TanglishTamilHelper.applySuggestion(
//                                   controller: guardianTamil,
//                                   suggestion: suggestion,
//                                   onSuggestionApplied: () {
//                                     setState(() => guardianSuggestions = []);
//                                   },
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//
//                     const SizedBox(height: 20),
//
//                     // Guardian Qualification (dropdown + manual)
//                     CustomTextField.richText(
//                       text: 'Guardian Qualification',
//                       text2: '',
//                     ),
//                     const SizedBox(height: 10),
//                     GestureDetector(
//                       onTap:
//                           () => _openSelectAndFill(
//                             title: 'Guardian Qualification',
//                             options: kQualifications,
//                             controller: guardianQualification,
//                           ),
//                       child: AbsorbPointer(
//                         child: CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               guardianQualification.text.trim().isEmpty,
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           errorText:
//                               isSubmitted &&
//                                       guardianQualification.text.trim().isEmpty
//                                   ? 'Guardian Qualification is required'
//                                   : null,
//                           validator: null,
//                           controller: guardianQualification,
//                           text: '',
//                           imagePath: AppImages.dropDown,
//                           imageSize: 11,
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Guardian Occupation (dropdown + manual)
//                     CustomTextField.richText(
//                       text: 'Guardian Occupation',
//                       text2: '',
//                     ),
//                     const SizedBox(height: 10),
//                     GestureDetector(
//                       onTap:
//                           () => _openSelectAndFill(
//                             title: 'Guardian Occupation',
//                             options: kOccupations,
//                             controller: guardianOccupation,
//                           ),
//                       child: AbsorbPointer(
//                         child: CustomContainer.studentInfoScreen(
//                           isError:
//                               isSubmitted &&
//                               guardianOccupation.text.trim().isEmpty,
//                           onChanged: (value) {
//                             if (isSubmitted && value.trim().isNotEmpty) {
//                               setState(() {});
//                             }
//                           },
//                           errorText:
//                               isSubmitted &&
//                                       guardianOccupation.text.trim().isEmpty
//                                   ? 'Guardian Occupation is required'
//                                   : null,
//                           validator: null,
//                           controller: guardianOccupation,
//                           text: '',
//                           verticalDivider: false,
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // Guardian Annual Income (numeric only)
//                     CustomTextField.richText(
//                       text: 'Guardian Annual Income (Rs.)',
//                       text2: '',
//                     ),
//                     const SizedBox(height: 10),
//                     CustomContainer.studentInfoScreen(
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       isError:
//                           isSubmitted &&
//                           guardianAnnualIncome.text.trim().isEmpty,
//                       onChanged: (value) {
//                         if (isSubmitted && value.trim().isNotEmpty) {
//                           setState(() {});
//                         }
//                       },
//                       errorText:
//                           isSubmitted &&
//                                   guardianAnnualIncome.text.trim().isEmpty
//                               ? 'Guardian Annual Income is required'
//                               : null,
//                       validator: null,
//                       controller: guardianAnnualIncome,
//                       text: '',
//                       verticalDivider: false,
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     // Guardian Office Address
//                     CustomTextField.richText(text: 'Office Address', text2: ''),
//                     const SizedBox(height: 10),
//                     CustomContainer.studentInfoScreen(
//                       isError:
//                           isSubmitted &&
//                           guardianOfficeAddress.text.trim().isEmpty,
//                       onChanged: (value) {
//                         if (isSubmitted && value.trim().isNotEmpty) {
//                           setState(() {});
//                         }
//                       },
//                       errorText:
//                           isSubmitted &&
//                                   guardianOfficeAddress.text.trim().isEmpty
//                               ? 'Guardian Office Address is required'
//                               : null,
//                       validator: null,
//                       controller: guardianOfficeAddress,
//                       maxLine: 3,
//                       text: '',
//                       verticalDivider: false,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//
//             const SizedBox(height: 30),
//
//             // Save & Continue
//             AppButton.button(
//               image: AppImages.rightSaitArrow,
//               text: 'Save & Continue',
//               onTap: () async {
//                 HapticFeedback.heavyImpact();
//
//                 // Validate "at least one office address" rule for Father & Mother
//                 if (selected == 'Father & Mother' && isBothOfficeAddressEmpty) {
//                   setState(() => isSubmitted = true);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text(
//                         'Please enter at least one Office Address (Father or Mother).',
//                       ),
//                     ),
//                   );
//                   return;
//                 }
//
//                 await _submitParentsInfo();
//               },
//             ),
//
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             content,
//             if (_submitting)
//               Container(
//                 color: Colors.black.withOpacity(0.25),
//                 child: const Center(child: CircularProgressIndicator()),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

///*********///

class ParentsInfoScreen extends StatefulWidget {
  final int id;
  const ParentsInfoScreen({super.key, required this.id});

  @override
  State<ParentsInfoScreen> createState() => _ParentsInfoScreenState();
}

class _ParentsInfoScreenState extends State<ParentsInfoScreen> {
  final _formKeyFatherMother = GlobalKey<FormState>();
  final _formKeyGuardian = GlobalKey<FormState>();

  String selected = 'Father & Mother';
  bool isSubmitted = false;
  bool hasError = false;

  bool _isParentFormInvalid() => !_validateFatherMother();
  bool _isGuardianFormInvalid() => !_validateGuardian();

  final AdmissionController ctrl = Get.put(AdmissionController());

  // Father
  final englishController = TextEditingController();
  final tamilController = TextEditingController();
  final fatherOccupation = TextEditingController();
  final fatherQualification = TextEditingController();
  final fatherAnnualIncome = TextEditingController();
  final officeAddress = TextEditingController();

  // Mother
  final motherQualification = TextEditingController();
  final motherNameTamilController = TextEditingController();
  final motherNameEnglishController = TextEditingController();
  final motherOccupation = TextEditingController();
  final motherOfficeAddressController = TextEditingController();
  final motherAnnualIncome = TextEditingController();

  // Guardian
  final guardianEnglish = TextEditingController();
  final guardianTamil = TextEditingController();
  final guardianQualification = TextEditingController();
  final guardianOccupation = TextEditingController();
  final guardianAnnualIncome = TextEditingController();
  final guardianOfficeAddress = TextEditingController();

  // Suggestions + loading states
  List<String> fatherSuggestions = [];
  bool isFatherLoading = false;

  List<String> motherSuggestions = [];
  bool isMotherLoading = false;

  List<String> guardianSuggestions = [];
  bool isGuardianLoading = false;

  // Debouncers
  Timer? _fatherDebounce;
  Timer? _motherDebounce;
  Timer? _guardianDebounce;

  // “Dropdown or type” options (you can extend these from API later)
  final List<String> qualificationOptions = const [
    'No Formal Education',
    'Primary',
    'Secondary',
    'Diploma',
    'Undergraduate',
    'Postgraduate',
    'Doctorate',
  ];
  final List<String> occupationOptions = const [
    'Govt. Employee',
    'Private Employee',
    'Self Employed',
    'Business',
    'Farmer',
    'Homemaker',
    'Unemployed',
    'Retired',
  ];

  bool get isBothOfficeAddressEmpty {
    return officeAddress.text.trim().isEmpty &&
        motherOfficeAddressController.text.trim().isEmpty;
  }

  @override
  void dispose() {
    _fatherDebounce?.cancel();
    _motherDebounce?.cancel();
    _guardianDebounce?.cancel();

    englishController.dispose();
    tamilController.dispose();
    fatherOccupation.dispose();
    fatherQualification.dispose();
    fatherAnnualIncome.dispose();
    officeAddress.dispose();

    motherQualification.dispose();
    motherNameTamilController.dispose();
    motherNameEnglishController.dispose();
    motherOccupation.dispose();
    motherOfficeAddressController.dispose();
    motherAnnualIncome.dispose();

    guardianEnglish.dispose();
    guardianTamil.dispose();
    guardianQualification.dispose();
    guardianOccupation.dispose();
    guardianAnnualIncome.dispose();
    guardianOfficeAddress.dispose();
    super.dispose();
  }

  // ---------- Helpers ----------
  Future<void> _debouncedTransliterate({
    required String value,
    required void Function(bool) setLoading,
    required void Function(List<String>) setList,
    required Timer? current,
    required void Function(Timer?) setter,
  }) async {
    current?.cancel();
    setter(
      Timer(const Duration(milliseconds: 280), () async {
        if (value.trim().isEmpty) {
          setList([]);
          setLoading(false);
          return;
        }
        setLoading(true);
        try {
          final res = await TanglishTamilHelper.transliterate(value);
          setList(res);
        } catch (_) {
          setList([]);
        } finally {
          setLoading(false);
        }
      }),
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String? _requiredText(String? v, {String msg = 'This field is required'}) {
    if ((v ?? '').trim().isEmpty) return msg;
    return null;
  }

  String? _requiredIncome(String? v, {String msg = 'Income is required'}) {
    if ((v ?? '').trim().isEmpty) return msg;
    final parsed = int.tryParse(v!.trim());
    if (parsed == null || parsed < 0) return 'Enter a valid amount';
    return null;
  }

  Widget _suggestionList({
    required List<String> suggestions,
    required void Function(String) onTap,
    Color bg = Colors.white,
    Color border = Colors.grey,
  }) {
    if (suggestions.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 4),
      constraints: const BoxConstraints(maxHeight: 150),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: suggestions.length,
        itemBuilder:
            (_, i) => ListTile(
              title: Text(suggestions[i]),
              dense: true,
              onTap: () => onTap(suggestions[i]),
            ),
      ),
    );
  }

  // Reusable “dropdown or type” input
  Widget _dropOrTypeField({
    required String label,
    required TextEditingController controller,
    required List<String> options,
    String? errorText,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField.richText(text: label, text2: ''),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CustomContainer.studentInfoScreen(
                controller: controller,
                text: '',
                isError:
                    isSubmitted && isRequired && controller.text.trim().isEmpty,
                errorText:
                    isSubmitted && isRequired && controller.text.trim().isEmpty
                        ? '$label is required'
                        : errorText,
                onChanged: (_) => setState(() {}),
                verticalDivider: false,
              ),
            ),
            // const SizedBox(width: 10),
            // PopupMenuButton<String>(
            //   itemBuilder:
            //       (_) =>
            //           options
            //               .map((e) => PopupMenuItem(value: e, child: Text(e)))
            //               .toList(),
            //   onSelected: (val) {
            //     controller.text = val;
            //     setState(() {});
            //   },
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 12,
            //       vertical: 12,
            //     ),
            //     decoration: BoxDecoration(
            //       color: AppColor.lightGrey,
            //       border: Border.all(color: AppColor.lowLightBlue, width: 1),
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: const Icon(Icons.arrow_drop_down),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  // Tamil input with transliteration & suggestions
  Widget _tamilField({
    required String label,
    required TextEditingController controller,
    required bool isLoading,
    required List<String> suggestions,
    required void Function(bool) setLoading,
    required void Function(List<String>) setList,
    required Timer? debounce,
    required void Function(Timer?) setDebounce,
    bool requiredField = true,
    String requiredMsg = 'This field is required',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField.richText(text: label, text2: ''),
        const SizedBox(height: 10),
        CustomContainer.studentInfoScreen(
          isError:
              isSubmitted && requiredField && controller.text.trim().isEmpty,
          errorText:
              isSubmitted && requiredField && controller.text.trim().isEmpty
                  ? requiredMsg
                  : null,
          onChanged: (value) async {
            if (hasError && value.trim().isNotEmpty) {
              setState(() => hasError = false);
            }
            await _debouncedTransliterate(
              value: value,
              setLoading: setLoading,
              setList: setList,
              current: debounce,
              setter: setDebounce,
            );
          },
          text: 'Tamil',
          isTamil: false,
          controller: controller,
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        _suggestionList(
          suggestions: suggestions,
          onTap: (s) {
            TanglishTamilHelper.applySuggestion(
              controller: controller,
              suggestion: s,
              onSuggestionApplied: () => setState(() => setList([])),
            );
          },
          bg: AppColor.white,
          border: AppColor.grey,
        ),
      ],
    );
  }

  bool _validateFatherMother() {
    final formOk = _formKeyFatherMother.currentState?.validate() ?? false;

    // manual checks for fields not using Form validators
    final basicOk =
        englishController.text.trim().isNotEmpty &&
        tamilController.text.trim().isNotEmpty &&
        fatherOccupation.text.trim().isNotEmpty &&
        fatherQualification.text.trim().isNotEmpty &&
        fatherAnnualIncome.text.trim().isNotEmpty &&
        motherNameEnglishController.text.trim().isNotEmpty &&
        motherNameTamilController.text.trim().isNotEmpty &&
        motherQualification.text.trim().isNotEmpty &&
        motherOccupation.text.trim().isNotEmpty &&
        motherAnnualIncome.text.trim().isNotEmpty;

    final officeOk = !isBothOfficeAddressEmpty; // at least one office address

    return formOk && basicOk && officeOk;
  }

  bool _validateGuardian() {
    final formOk = _formKeyGuardian.currentState?.validate() ?? false;

    final basicOk =
        guardianEnglish.text.trim().isNotEmpty &&
        guardianTamil.text.trim().isNotEmpty &&
        guardianQualification.text.trim().isNotEmpty &&
        guardianOccupation.text.trim().isNotEmpty &&
        guardianAnnualIncome.text.trim().isNotEmpty &&
        guardianOfficeAddress.text.trim().isNotEmpty;

    return formOk && basicOk;
  }

  void _validateAndContinue() {
    HapticFeedback.heavyImpact();
    setState(() => isSubmitted = true);

    if (selected == 'Father & Mother') {
      final ok = _validateFatherMother();
      if (!ok && isBothOfficeAddressEmpty) {
        // show unobtrusive snackbar to explain the special rule
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Enter at least one Office Address (Father or Mother).',
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      }
      if (ok) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SiblingsFormScreen(id: widget.id)),
        );
      }
    } else {
      if (_validateGuardian()) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SiblingsFormScreen(id: widget.id)),
        );
      }
    }
  }

  // ---------- BUILD ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomContainer.leftSaitArrow(
                      onTap: () => Navigator.pop(context),
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
                const SizedBox(height: 30),
                // Uses your custom LinearProgressIndicator variant
                LinearProgressIndicator(
                  minHeight: 6,
                  value: 0.4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
                  // assuming these are supported by your custom widget
                  stopIndicatorRadius: 16,
                  backgroundColor: AppColor.lowGery1,
                  borderRadius: BorderRadius.circular(16),
                ),
                SizedBox(height: 40),
                CustomTextField.textWith600(text: 'Parent Info', fontSize: 26),
                SizedBox(height: 20),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => selected = 'Father & Mother'),
                      child: CustomContainer.parentInfo(
                        text: 'Father & Mother',
                        isSelected: selected == 'Father & Mother',
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => setState(() => selected = 'Guardian'),
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
                    key: _formKeyFatherMother,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Father
                        CustomTextField.richText(
                          text: 'Father Name',
                          text2: '',
                        ),
                        const SizedBox(height: 10),
                        CustomContainer.studentInfoScreen(
                          onChanged: (_) => setState(() {}),
                          isError:
                              isSubmitted &&
                              englishController.text.trim().isEmpty,
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

                        _tamilField(
                          label: 'Father Name (Tamil)',
                          controller: tamilController,
                          isLoading: isFatherLoading,
                          suggestions: fatherSuggestions,
                          setLoading:
                              (v) => setState(() => isFatherLoading = v),
                          setList:
                              (list) =>
                                  setState(() => fatherSuggestions = list),
                          debounce: _fatherDebounce,
                          setDebounce: (d) => _fatherDebounce = d,
                          requiredField: true,
                          requiredMsg: 'Father name (Tamil) is required',
                        ),

                        SizedBox(height: 20),

                        _dropOrTypeField(
                          label: 'Father Qualification',
                          controller: fatherQualification,
                          options: qualificationOptions,
                          isRequired: true,
                        ),
                        SizedBox(height: 20),

                        _dropOrTypeField(
                          label: 'Father Occupation',
                          controller: fatherOccupation,
                          options: occupationOptions,
                          isRequired: true,
                        ),
                        SizedBox(height: 20),

                        CustomTextField.richText(
                          text: 'Father Annual Income (Rs.)',
                          text2: '',
                        ),
                        SizedBox(height: 10),
                        CustomContainer.studentInfoScreen(
                          keyboardType: TextInputType.number,
                          isMobile: true,
                          isError:
                              isSubmitted &&
                              fatherAnnualIncome.text.trim().isEmpty,
                          errorText:
                              isSubmitted &&
                                      fatherAnnualIncome.text.trim().isEmpty
                                  ? 'Father Annual Income is required'
                                  : null,
                          controller: fatherAnnualIncome,
                          text: '',
                          verticalDivider: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          onChanged: (_) => setState(() {}),
                        ),

                        SizedBox(height: 20),
                        CustomTextField.richText(
                          text: 'Office Address (Father)',
                          text2: '',
                        ),
                        SizedBox(height: 10),
                        CustomContainer.studentInfoScreen(
                          controller: officeAddress,
                          maxLine: 3,
                          text: '',
                          verticalDivider: false,
                          onChanged: (_) => setState(() {}),
                        ),

                        SizedBox(height: 25),
                        CustomContainer.horizonalDivider(),
                        SizedBox(height: 20),

                        // Mother
                        CustomTextField.richText(
                          text: 'Mother Name',
                          text2: '',
                        ),
                        SizedBox(height: 10),
                        CustomContainer.studentInfoScreen(
                          isError:
                              isSubmitted &&
                              motherNameEnglishController.text.trim().isEmpty,
                          errorText:
                              isSubmitted &&
                                      motherNameEnglishController.text
                                          .trim()
                                          .isEmpty
                                  ? 'Mother Name is required'
                                  : null,
                          text: 'English',
                          isTamil: false,
                          controller: motherNameEnglishController,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 10),

                        _tamilField(
                          label: 'Mother Name (Tamil)',
                          controller: motherNameTamilController,
                          isLoading: isMotherLoading,
                          suggestions: motherSuggestions,
                          setLoading:
                              (v) => setState(() => isMotherLoading = v),
                          setList:
                              (list) =>
                                  setState(() => motherSuggestions = list),
                          debounce: _motherDebounce,
                          setDebounce: (d) => _motherDebounce = d,
                          requiredField: true,
                          requiredMsg: 'Mother name (Tamil) is required',
                        ),

                        const SizedBox(height: 20),

                        _dropOrTypeField(
                          label: 'Mother Qualification',
                          controller: motherQualification,
                          options: qualificationOptions,
                          isRequired: true,
                        ),
                        const SizedBox(height: 20),

                        _dropOrTypeField(
                          label: 'Mother Occupation',
                          controller: motherOccupation,
                          options: occupationOptions,
                          isRequired: true,
                        ),
                        const SizedBox(height: 20),

                        CustomTextField.richText(
                          text: 'Mother Annual Income (Rs.)',
                          text2: '',
                        ),
                        const SizedBox(height: 10),
                        CustomContainer.studentInfoScreen(
                          keyboardType: TextInputType.number,
                          isMobile: true,
                          isError:
                              isSubmitted &&
                              motherAnnualIncome.text.trim().isEmpty,
                          errorText:
                              isSubmitted &&
                                      motherAnnualIncome.text.trim().isEmpty
                                  ? 'Mother Annual Income is required'
                                  : null,
                          controller: motherAnnualIncome,
                          text: '',
                          verticalDivider: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 10),

                        CustomTextField.richText(
                          text: 'Office Address (Mother)',
                          text2: '',
                        ),
                        const SizedBox(height: 10),
                        CustomContainer.studentInfoScreen(
                          controller: motherOfficeAddressController,
                          maxLine: 3,
                          text: '',
                          verticalDivider: false,
                          onChanged: (_) => setState(() {}),
                        ),

                        if (isSubmitted && isBothOfficeAddressEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Enter at least one Office Address (Father or Mother).',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ] else ...[
                  // Guardian
                  Form(
                    key: _formKeyGuardian,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField.richText(
                          text: 'Guardian Name',
                          text2: '',
                        ),
                        const SizedBox(height: 10),
                        CustomContainer.studentInfoScreen(
                          isError:
                              isSubmitted &&
                              guardianEnglish.text.trim().isEmpty,
                          errorText:
                              isSubmitted && guardianEnglish.text.trim().isEmpty
                                  ? 'Guardian Name is required'
                                  : null,
                          text: 'English',
                          isTamil: false,
                          controller: guardianEnglish,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 20),

                        _tamilField(
                          label: 'Guardian Name (Tamil)',
                          controller: guardianTamil,
                          isLoading: isGuardianLoading,
                          suggestions: guardianSuggestions,
                          setLoading:
                              (v) => setState(() => isGuardianLoading = v),
                          setList:
                              (list) =>
                                  setState(() => guardianSuggestions = list),
                          debounce: _guardianDebounce,
                          setDebounce: (d) => _guardianDebounce = d,
                          requiredField: true,
                          requiredMsg: 'Guardian Name (Tamil) is required',
                        ),

                        const SizedBox(height: 20),

                        _dropOrTypeField(
                          label: 'Guardian Qualification',
                          controller: guardianQualification,
                          options: qualificationOptions,
                          isRequired: true,
                        ),
                        const SizedBox(height: 20),

                        _dropOrTypeField(
                          label: 'Guardian Occupation',
                          controller: guardianOccupation,
                          options: occupationOptions,
                          isRequired: true,
                        ),
                        const SizedBox(height: 20),

                        CustomTextField.richText(
                          text: 'Guardian Annual Income (Rs.)',
                          text2: '',
                        ),
                        const SizedBox(height: 10),
                        CustomContainer.studentInfoScreen(
                          isError:
                              isSubmitted &&
                              guardianAnnualIncome.text.trim().isEmpty,
                          errorText:
                              isSubmitted &&
                                      guardianAnnualIncome.text.trim().isEmpty
                                  ? 'Guardian Annual Income is required'
                                  : null,
                          controller: guardianAnnualIncome,
                          text: '',
                          verticalDivider: false,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 10),

                        CustomTextField.richText(
                          text: 'Office Address',
                          text2: '',
                        ),
                        const SizedBox(height: 10),
                        CustomContainer.studentInfoScreen(
                          isError:
                              isSubmitted &&
                              guardianOfficeAddress.text.trim().isEmpty,
                          errorText:
                              isSubmitted &&
                                      guardianOfficeAddress.text.trim().isEmpty
                                  ? 'Guardian Office Address is required'
                                  : null,
                          controller: guardianOfficeAddress,
                          maxLine: 3,
                          text: '',
                          verticalDivider: false,
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 30),

                // AppButton.button(
                //   image: AppImages.rightSaitArrow,
                //   text: 'Save & Continue',
                //   onTap: _validateAndContinue,
                // ),

                // --- at the bottom of build(), replace the whole Obx(AppButton...) you have ---
                /*           Obx(() {
                  final saving = ctrl.isParentsSaving.value;
                  return AppButton.button(
                    image: saving ? null : AppImages.rightSaitArrow,
                    text: saving ? 'Saving…' : 'Save & Continue',
                    onTap:
                        saving
                            ? null
                            : () async {
                              HapticFeedback.heavyImpact();
                              FocusScope.of(context).unfocus();

                              setState(() => isSubmitted = true);

                              if (selected == 'Father & Mother') {
                                if (_isParentFormInvalid()) {
                                  _showSnack(
                                    'Please fix the highlighted fields.',
                                    isError: true,
                                  );
                                  return;
                                }

                                if (isBothOfficeAddressEmpty) {
                                  _showSnack(
                                    'Enter at least one Office Address (Father or Mother).',
                                    isError: true,
                                  );
                                  return;
                                }

                                final err = await ctrl.saveParentsInfo(
                                  id: ctrl.studentId,
                                  fatherName: englishController.text.trim(),
                                  fatherNameTamil: tamilController.text.trim(),
                                  fatherQualification:
                                      fatherQualification.text.trim(),
                                  fatherOccupation:
                                      fatherOccupation.text.trim(),
                                  fatherIncome:
                                      int.tryParse(
                                        fatherAnnualIncome.text.trim(),
                                      ) ??
                                      0,
                                  fatherOfficeAddress:
                                      officeAddress.text.trim(),
                                  motherName:
                                      motherNameEnglishController.text.trim(),
                                  motherNameTamil:
                                      motherNameTamilController.text.trim(),
                                  motherQualification:
                                      motherQualification.text.trim(),
                                  motherOccupation:
                                      motherOccupation.text.trim(),
                                  motherIncome:
                                      int.tryParse(
                                        motherAnnualIncome.text.trim(),
                                      ) ??
                                      0,
                                  motherOfficeAddress:
                                      motherOfficeAddressController.text.trim(),
                                  hasGuardian: false,
                                );

                                if (err != null) {
                                  _showSnack(
                                    'Failed to save: $err',
                                    isError: true,
                                  );
                                  return;
                                }

                                _showSnack('Saved successfully');
                                // Navigator.pushNamed(context, '/siblingsForm');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SiblingsFormScreen(),
                                  ),
                                );
                              } else {
                                if (_isGuardianFormInvalid()) {
                                  _showSnack(
                                    'Please fix the highlighted fields.',
                                    isError: true,
                                  );
                                  return;
                                }

                                final err = await ctrl.saveParentsInfo(
                                  id: ctrl.studentId,
                                  fatherName: '',
                                  fatherNameTamil: '',
                                  fatherQualification: '',
                                  fatherOccupation: '',
                                  fatherIncome: 0,
                                  fatherOfficeAddress: '',
                                  motherName: '',
                                  motherNameTamil: '',
                                  motherQualification: '',
                                  motherOccupation: '',
                                  motherIncome: 0,
                                  motherOfficeAddress: '',
                                  hasGuardian: true,
                                  guardianName: guardianEnglish.text.trim(),
                                  guardianNameTamil: guardianTamil.text.trim(),
                                  guardianQualification:
                                      guardianQualification.text.trim(),
                                  guardianOccupation:
                                      guardianOccupation.text.trim(),
                                  guardianIncome:
                                      int.tryParse(
                                        guardianAnnualIncome.text.trim(),
                                      ) ??
                                      0,
                                  guardianOfficeAddress:
                                      guardianOfficeAddress.text.trim(),
                                );

                                if (err != null) {
                                  _showSnack(
                                    'Failed to save: $err',
                                    isError: true,
                                  );
                                  return;
                                }

                                _showSnack('Saved successfully');
                                // Navigator.pushNamed(context, '/siblingsForm');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SiblingsFormScreen(),
                                  ),
                                );
                              }
                            },
                  );
                }),*/
                Obx(() {
                  final loading = ctrl.isParentsSaving.value;
                  return AppButton.button(
                    image: loading ? null : AppImages.rightSaitArrow,
                    text: loading ? 'Saving…' : 'Save & Continue',
                    onTap:
                        loading
                            ? null
                            : () async {
                              HapticFeedback.heavyImpact();
                              FocusScope.of(context).unfocus();
                              setState(() => isSubmitted = true);

                              if (selected == 'Father & Mother') {
                                if (_isParentFormInvalid()) {
                                  _showSnack(
                                    'Please fix the highlighted fields.',
                                    isError: true,
                                  );
                                  return;
                                }

                                if (isBothOfficeAddressEmpty) {
                                  _showSnack(
                                    'Enter at least one Office Address (Father or Mother).',
                                    isError: true,
                                  );
                                  return;
                                }

                                final err = await ctrl.saveParentsInfo(
                                  id: widget.id,
                                  fatherName: englishController.text.trim(),
                                  fatherNameTamil: tamilController.text.trim(),
                                  fatherQualification:
                                      fatherQualification.text.trim(),
                                  fatherOccupation:
                                      fatherOccupation.text.trim(),
                                  fatherIncome:
                                      int.tryParse(
                                        fatherAnnualIncome.text.trim(),
                                      ) ??
                                      0,
                                  fatherOfficeAddress:
                                      officeAddress.text.trim(),
                                  motherName:
                                      motherNameEnglishController.text.trim(),
                                  motherNameTamil:
                                      motherNameTamilController.text.trim(),
                                  motherQualification:
                                      motherQualification.text.trim(),
                                  motherOccupation:
                                      motherOccupation.text.trim(),
                                  motherIncome:
                                      int.tryParse(
                                        motherAnnualIncome.text.trim(),
                                      ) ??
                                      0,
                                  motherOfficeAddress:
                                      motherOfficeAddressController.text.trim(),
                                  hasGuardian: false,
                                );

                                if (err != null) {
                                  _showSnack(
                                    'Failed to save: $err',
                                    isError: true,
                                  );
                                  return;
                                }

                                _showSnack('Saved successfully');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            SiblingsFormScreen(id: widget.id),
                                  ),
                                );
                              } else {
                                // Guardian case
                                if (_isGuardianFormInvalid()) {
                                  _showSnack(
                                    'Please fix the highlighted fields.',
                                    isError: true,
                                  );
                                  return;
                                }

                                final err = await ctrl.saveParentsInfo(
                                  id: widget.id,
                                  fatherName: '',
                                  fatherNameTamil: '',
                                  fatherQualification: '',
                                  fatherOccupation: '',
                                  fatherIncome: 0,
                                  fatherOfficeAddress: '',
                                  motherName: '',
                                  motherNameTamil: '',
                                  motherQualification: '',
                                  motherOccupation: '',
                                  motherIncome: 0,
                                  motherOfficeAddress: '',
                                  hasGuardian: true,
                                  guardianName: guardianEnglish.text.trim(),
                                  guardianNameTamil: guardianTamil.text.trim(),
                                  guardianQualification:
                                      guardianQualification.text.trim(),
                                  guardianOccupation:
                                      guardianOccupation.text.trim(),
                                  guardianIncome:
                                      int.tryParse(
                                        guardianAnnualIncome.text.trim(),
                                      ) ??
                                      0,
                                  guardianOfficeAddress:
                                      guardianOfficeAddress.text.trim(),
                                );

                                if (err != null) {
                                  _showSnack(
                                    'Failed to save: $err',
                                    isError: true,
                                  );
                                  return;
                                }

                                _showSnack('Saved successfully');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            SiblingsFormScreen(id: widget.id),
                                  ),
                                );
                              }
                            },
                  );
                }),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
