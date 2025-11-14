// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:st_school_project/Core/Utility/app_color.dart';
// import 'package:st_school_project/Core/Utility/google_font.dart';
// import 'package:st_school_project/Core/Utility/thanglish_to_tamil.dart';
// import 'package:st_school_project/Core/Widgets/consents.dart';
// import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
// import 'package:st_school_project/Core/Widgets/custom_container.dart';
// import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
// import 'package:st_school_project/Presentation/Admssion/Screens/parents_info_screen.dart';
// import '../../../Core/Utility/app_images.dart';
// import '../../../Core/Utility/snack_bar.dart';
// import '../../../api/data_source/apiDataSource.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:st_school_project/Core/Utility/app_color.dart';
// import 'package:st_school_project/Core/Utility/app_images.dart';
// import 'package:st_school_project/Core/Utility/google_font.dart';
// import 'package:st_school_project/Core/Utility/app_loader.dart';
// import 'package:st_school_project/Core/Widgets/custom_container.dart';
//
// class StudentInfoScreen extends StatefulWidget {
//   const StudentInfoScreen({super.key});
//
//   @override
//   State<StudentInfoScreen> createState() => _StudentInfoScreenState();
// }
//
// class AadhaarInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
//     String formatted = '';
//
//     for (int i = 0; i < digitsOnly.length; i++) {
//       formatted += digitsOnly[i];
//       if ((i + 1) % 4 == 0 && i + 1 != digitsOnly.length) {
//         formatted += ' ';
//       }
//     }
//
//     return TextEditingValue(
//       text: formatted,
//       selection: TextSelection.collapsed(offset: formatted.length),
//     );
//   }
// }
//
// class _StudentInfoScreenState extends State<StudentInfoScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   TextEditingController nameEnglishController = TextEditingController();
//   TextEditingController nameTamilController = TextEditingController();
//   TextEditingController aadharController = TextEditingController();
//   TextEditingController dobController = TextEditingController();
//   TextEditingController religionController = TextEditingController();
//   TextEditingController casteController = TextEditingController();
//   TextEditingController communityController = TextEditingController();
//   TextEditingController tongueController = TextEditingController();
//   TextEditingController nationalityController = TextEditingController();
//   TextEditingController personalId1Controller = TextEditingController();
//   TextEditingController personalId2Controller = TextEditingController();
//   List<String> fatherSuggestions = [];
//   bool isFatherLoading = false;
//   final FocusNode tamilFocusNode = FocusNode();
//   @override
//   void dispose() {
//     tamilFocusNode.dispose();
//     nameEnglishController.dispose();
//     nameTamilController.dispose();
//     aadharController.dispose();
//     dobController.dispose();
//     religionController.dispose();
//     casteController.dispose();
//     communityController.dispose();
//     tongueController.dispose();
//     nationalityController.dispose();
//     personalId1Controller.dispose();
//     personalId2Controller.dispose();
//     super.dispose();
//   }
//
//   // 1) Put these lists in your State (top of _StudentInfoScreenState)
//   final List<String> _religions = const [
//     'Hindu',
//     'Christian',
//     'Muslim',
//     'Sikh',
//     'Buddhist',
//     'Jain',
//     'Other',
//   ];
//   final List<String> _castes = const [
//     'BC',
//     'MBC',
//     'SC',
//     'ST',
//     'OC',
//     'DNC',
//     'Other',
//   ];
//   final List<String> _communities = const [
//     'OC',
//     'BC',
//     'MBC',
//     'DNC',
//     'SC',
//     'ST',
//     'Other',
//   ];
//   final List<String> _motherTongues = const [
//     'Tamil',
//     'English',
//     'Telugu',
//     'Malayalam',
//     'Kannada',
//     'Hindi',
//     'Urdu',
//     'Other',
//   ];
//   final List<String> _nationalities = const ['Indian', 'Other'];
//
//   // 2) Add this helper inside _StudentInfoScreenState
//   Future<void> _openSelectSheet({
//     required BuildContext context,
//     required String title,
//     required TextEditingController controller,
//     required List<String> options,
//   }) async {
//     final TextEditingController searchCtrl = TextEditingController(
//       text: controller.text.trim(),
//     );
//     List<String> filtered = List.of(options);
//
//     String? finalize(String raw) {
//       final t = raw.trim();
//       if (t.isNotEmpty) return t;
//       if (filtered.isNotEmpty) return filtered.first;
//       return null;
//     }
//
//     String? picked = await showModalBottomSheet<String>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: AppColor.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (ctx) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(ctx).viewInsets.bottom,
//           ),
//           child: StatefulBuilder(
//             builder: (ctx, setState) {
//               void onSearch(String q) {
//                 setState(() {
//                   filtered =
//                       options
//                           .where(
//                             (o) => o.toLowerCase().contains(q.toLowerCase()),
//                           )
//                           .toList();
//                 });
//               }
//
//               Future<void> onDone() async {
//                 final t = finalize(searchCtrl.text);
//                 if (t != null) Navigator.pop(ctx, t);
//               }
//
//               return SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Handle
//                       Container(
//                         width: 40,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: Colors.black12,
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                       SizedBox(height: 12),
//                       // Title + Done
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               'Select $title',
//                               style: GoogleFont.ibmPlexSans(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColor.black,
//                               ),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () => onDone(),
//                             child: Text(
//                               'Done',
//                               style: GoogleFont.ibmPlexSans(
//                                 color: AppColor.blueG2,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       // Search
//                       TextField(
//                         controller: searchCtrl,
//                         autofocus: true,
//                         textInputAction: TextInputAction.done,
//                         onSubmitted: (_) => onDone(),
//                         onChanged: onSearch,
//                         decoration: InputDecoration(
//                           prefixIcon: const Icon(Icons.search),
//                           hintText: 'Search or type…',
//                           isDense: true,
//                           contentPadding: const EdgeInsets.symmetric(
//                             vertical: 12,
//                             horizontal: 16,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30),
//                             borderSide: const BorderSide(
//                               color: Colors.grey,
//                               width: 1.2,
//                             ),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30),
//                             borderSide: const BorderSide(
//                               color: Colors.grey,
//                               width: 1.2,
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30),
//                             borderSide: const BorderSide(
//                               color: Colors.blue,
//                               width: 1.8,
//                             ),
//                           ),
//                         ),
//                         cursorColor: Colors.blue,
//                       ),
//                       SizedBox(height: 12),
//                       Flexible(
//                         child:
//                             filtered.isEmpty
//                                 ? Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     SizedBox(height: 24),
//                                     Text('No matches'),
//                                     SizedBox(height: 12),
//                                     // ElevatedButton.icon(
//                                     //   icon:   Icon(Icons.check),
//                                     //   label: Text(
//                                     //     'Done – Use "${searchCtrl.text}"',
//                                     //   ),
//                                     //   onPressed:
//                                     //       searchCtrl.text.trim().isEmpty
//                                     //           ? null
//                                     //           : onDone,
//                                     // ),
//                                   ],
//                                 )
//                                 : ListView.separated(
//                                   shrinkWrap: true,
//                                   itemCount: filtered.length,
//                                   separatorBuilder:
//                                       (_, __) => Container(
//                                         width: double.infinity,
//                                         height: 2,
//                                         decoration: BoxDecoration(
//                                           gradient: LinearGradient(
//                                             begin: Alignment.centerRight,
//                                             end: Alignment.centerLeft,
//                                             colors: [
//                                               AppColor.white.withOpacity(0.5),
//                                               AppColor.white3,
//                                               AppColor.white3,
//                                               AppColor.white3,
//                                               AppColor.white3,
//                                               AppColor.white3,
//                                               AppColor.white3,
//                                               AppColor.white.withOpacity(0.5),
//                                             ],
//                                           ),
//                                           borderRadius: BorderRadius.circular(
//                                             1,
//                                           ),
//                                         ),
//                                       ),
//                                   itemBuilder: (ctx, i) {
//                                     final value = filtered[i];
//                                     return ListTile(
//                                       title: Text(value),
//                                       onTap: () => Navigator.pop(ctx, value),
//                                     );
//                                   },
//                                 ),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Icon(Icons.keyboard_alt_outlined, size: 18),
//                           SizedBox(width: 6),
//                           Expanded(
//                             child: Text(
//                               'Tip: Type your value and press Done.',
//                               style: GoogleFont.ibmPlexSans(
//                                 fontSize: 12,
//                                 color: AppColor.grey,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//
//     if (picked != null && picked.trim().isNotEmpty) {
//       controller.text = picked.trim();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       CustomContainer.leftSaitArrow(
//                         onTap: () => Navigator.pop(context),
//                       ),
//                       // InkWell(
//                       //   onTap: () => Navigator.pop(context),
//                       //   child: Container(
//                       //     decoration: BoxDecoration(
//                       //       color: AppColor.lightGrey,
//                       //       border: Border.all(
//                       //         color: AppColor.lowLightBlue,
//                       //         width: 1,
//                       //       ),
//                       //       borderRadius: BorderRadius.circular(30),
//                       //     ),
//                       //     padding: const EdgeInsets.all(10),
//                       //     child: Image.asset(
//                       //       AppImages.leftArrow,
//                       //       height: 12,
//                       //       width: 12,
//                       //     ),
//                       //   ),
//                       // ),
//                       SizedBox(width: 15),
//                       Text(
//                         '2025 - 2026 LKG Admission',
//                         style: GoogleFont.ibmPlexSans(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppColor.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 30),
//                   LinearProgressIndicator(
//                     minHeight: 6,
//                     value: 0.2,
//                     valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
//                     backgroundColor: AppColor.lowGery1,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   SizedBox(height: 40),
//                   CustomTextField.textWith600(
//                     text: 'Student Info',
//                     fontSize: 26,
//                   ),
//                   SizedBox(height: 30),
//
//                   buildField(
//                     label: 'Name of the Student ',
//                     subLabel: 'As per Birth Certificate',
//                     controller: nameEnglishController,
//                     hint: 'English',
//                     validatorMsg: 'Student Name is required',
//                   ),
//
//                   buildField(
//                     context: context,
//                     focusNode: tamilFocusNode,
//                     isTamilField: true,
//                     controller: nameTamilController,
//                     hint: 'Tamil',
//                     validatorMsg: 'Tamil name is required',
//                   ),
//                   if (isFatherLoading)
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                   if (fatherSuggestions.isNotEmpty)
//                     Container(
//                       margin: const EdgeInsets.only(top: 4),
//                       constraints: const BoxConstraints(maxHeight: 150),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.grey),
//                       ),
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: fatherSuggestions.length,
//                         itemBuilder: (context, index) {
//                           final suggestion = fatherSuggestions[index];
//                           return ListTile(
//                             title: Text(suggestion),
//                             onTap: () {
//                               TanglishTamilHelper.applySuggestion(
//                                 controller: nameTamilController,
//                                 suggestion: suggestion,
//                                 onSuggestionApplied: () {
//                                   setState(() => fatherSuggestions = []);
//                                 },
//                               );
//                             },
//                             // onTap:
//                             //     () => _onSuggestionSelected(suggestion),
//                           );
//                         },
//                       ),
//                     ),
//
//                   buildField(
//                     label: 'Student Aadhar Number',
//                     controller: aadharController,
//                     hint: 'Aadhar No',
//                     validatorMsg: ' Aadhar number is required',
//                     isAadhaar: true,
//                     isNumeric: true,
//                   ),
//
//                   buildField(
//                     context: context,
//                     label: 'Date of Birth ',
//                     subLabel: '01-06-2021 to 31-05-2022',
//                     controller: dobController,
//                     hint: '',
//                     validatorMsg: 'Select Date of Birth',
//                     isDOB: true,
//                   ),
//
//                   // buildField(
//                   //   label: 'Religion',
//                   //   controller: religionController,
//                   //   hint: '',
//                   //   validatorMsg: 'Religion is required',
//                   //   isDropDown: true,
//                   //   verticalDivider: false,
//                   // ),
//                   buildField(
//                     label: 'Religion',
//                     controller: religionController,
//                     hint: 'Select or type',
//                     validatorMsg: 'Religion is required',
//                     isDropDown: true,
//                     verticalDivider: false,
//                     context: context,
//                     options: _religions,
//                     pickerTitle: 'Religion',
//                   ),
//
//                   buildField(
//                     label: 'Caste',
//                     controller: casteController,
//                     hint: 'Select or type',
//                     validatorMsg: 'Caste is required',
//                     isDropDown: true,
//                     verticalDivider: false,
//                     context: context,
//                     options: _castes,
//                     pickerTitle: 'Caste',
//                   ),
//
//                   buildField(
//                     label: 'Community',
//                     subLabel: 'As per Community Certificate',
//                     controller: communityController,
//                     hint: 'Select or type',
//                     validatorMsg: 'Community is required',
//                     isDropDown: true,
//                     verticalDivider: false,
//                     context: context,
//                     options: _communities,
//                     pickerTitle: 'Community',
//                   ),
//
//                   buildField(
//                     label: 'Mother Tongue',
//                     controller: tongueController,
//                     hint: 'Select or type',
//                     validatorMsg: 'Mother tongue is required',
//                     isDropDown: true,
//                     verticalDivider: false,
//                     context: context,
//                     options: _motherTongues,
//                     pickerTitle: 'Mother Tongue',
//                   ),
//
//                   buildField(
//                     label: 'Nationality',
//                     controller: nationalityController,
//                     hint: 'Select or type',
//                     validatorMsg: 'Nationality is required',
//                     isDropDown: true,
//                     verticalDivider: false,
//                     context: context,
//                     options: _nationalities,
//                     pickerTitle: 'Nationality',
//                   ),
//
//                   buildField(
//                     label: 'Personal Identification 1',
//                     controller: personalId1Controller,
//                     hint: '',
//                     validatorMsg: 'Personal ID 1 is required',
//                     verticalDivider: false,
//                   ),
//
//                   buildField(
//                     label: 'Personal Identification 2',
//                     controller: personalId2Controller,
//                     hint: '',
//                     validatorMsg: 'Personal ID 2 is required',
//                     verticalDivider: false,
//                   ),
//
//                   SizedBox(height: 30),
//
//                   AppButton.button(
//                     image: AppImages.rightSaitArrow,
//                     text: 'Save & Continue',
//                     onTap: () {
//                       HapticFeedback.heavyImpact();
//                       if (_formKey.currentState!.validate()) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ParentsInfoScreen(),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//
//                   SizedBox(height: 10),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildField({
//     String? label,
//     String? subLabel,
//     required TextEditingController controller,
//     required String hint,
//     required String validatorMsg,
//     bool isDropDown = false,
//     bool isAadhaar = false,
//     bool isDOB = false,
//     bool isNumeric = false,
//     bool isTamilField = false,
//     bool verticalDivider = true,
//     BuildContext? context,
//     FocusNode? focusNode,
//     List<String>? options, // you added this
//     String? pickerTitle, // and this
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (label != null) ...[
//           CustomTextField.richText(text: label, text2: subLabel ?? ''),
//           const SizedBox(height: 10),
//         ],
//         FormField<String>(
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           validator: (value) {
//             final text = controller.text.trim();
//
//             if (text.isEmpty) return validatorMsg;
//
//             if (isAadhaar == true) {
//               final clean = text.replaceAll(' ', '');
//               if (!RegExp(r'^[2-9][0-9]{11}$').hasMatch(clean)) {
//                 return 'Enter a valid Aadhaar number';
//               }
//             }
//
//             // ️ Only enforce min length on plain text fields (not dropdowns/DOB/Aadhaar)
//             if (!isAadhaar && !isDropDown && text.length < 5) {
//               return 'Enter at least 5 characters';
//             }
//             return null;
//           },
//           builder: (field) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () async {
//                     // DOB picker
//                     if (isDOB && context != null) {
//                       final DateTime startDate = DateTime(2021, 6, 1);
//                       final DateTime endDate = DateTime(2022, 5, 31);
//                       final DateTime initial = DateTime(2021, 6, 2);
//
//                       final picked = await showDatePicker(
//                         context: context!,
//                         initialDate: initial,
//                         firstDate: DateTime(2020),
//                         lastDate: DateTime(2025),
//                         builder: (c, child) {
//                           return Theme(
//                             data: Theme.of(c).copyWith(
//                               dialogBackgroundColor: AppColor.white,
//                               colorScheme: ColorScheme.light(
//                                 primary: AppColor.blueG2,
//                                 onPrimary: Colors.white,
//                                 onSurface: AppColor.black,
//                               ),
//                               textButtonTheme: TextButtonThemeData(
//                                 style: TextButton.styleFrom(
//                                   foregroundColor: AppColor.blueG2,
//                                 ),
//                               ),
//                             ),
//                             child: child!,
//                           );
//                         },
//                       );
//
//                       if (picked != null) {
//                         if (picked.isBefore(startDate) ||
//                             picked.isAfter(endDate)) {
//                           ScaffoldMessenger.of(context!).showSnackBar(
//                             const SnackBar(
//                               content: Text(
//                                 'Invalid Date of Birth!\nPlease select a date between 01-06-2021 and 31-05-2022.',
//                               ),
//                               backgroundColor: Colors.red,
//                               duration: Duration(seconds: 3),
//                             ),
//                           );
//                         } else {
//                           controller.text =
//                               "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
//                           field.didChange(controller.text);
//                           FocusScope.of(
//                             context!,
//                           ).requestFocus(nextFieldFocusNode);
//                         }
//                       }
//                       return;
//                     }
//
//                     // NEW: Dropdown picker
//                     if (isDropDown && context != null) {
//                       final picked = await _openSelectSheet(
//                         context: context!,
//                         title: (pickerTitle ?? label ?? 'Select'),
//                         controller: controller,
//                         options: options ?? const [],
//                       );
//                       // _openSelectSheet writes into controller; still notify the field
//                       field.didChange(controller.text);
//                     }
//                   },
//                   child: AbsorbPointer(
//                     absorbing: isDOB, // allow typing for dropdowns
//                     child: CustomContainer.studentInfoScreen(
//                       verticalDivider: verticalDivider,
//                       context: isDOB ? context : null,
//                       keyboardType:
//                           isNumeric ? TextInputType.number : TextInputType.text,
//                       controller: controller,
//                       text: hint,
//                       imagePath:
//                           isDropDown
//                               ? AppImages.dropDown
//                               : (isDOB ? AppImages.calender : null),
//                       isAadhaar: isAadhaar,
//                       isDOB: isDOB,
//                       isError: field.hasError,
//                       focusNode: focusNode,
//                       inputFormatters:
//                           isAadhaar
//                               ? [
//                                 FilteringTextInputFormatter.digitsOnly,
//                                 AadhaarInputFormatter(),
//                               ]
//                               : [],
//                       onChanged:
//                           isTamilField
//                               ? (value) async {
//                                 if (value.trim().isEmpty) {
//                                   setState(() => fatherSuggestions = []);
//                                   return;
//                                 }
//                                 setState(() => isFatherLoading = true);
//                                 final result =
//                                     await TanglishTamilHelper.transliterate(
//                                       value,
//                                     );
//                                 setState(() {
//                                   fatherSuggestions = result;
//                                   isFatherLoading = false;
//                                 });
//                                 field.didChange(value);
//                               }
//                               : field
//                                   .didChange, // keep typing enabled for dropdowns
//                     ),
//                   ),
//                 ),
//                 if (field.hasError)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 5, left: 8),
//                     child: Text(
//                       field.errorText!,
//                       style: GoogleFont.ibmPlexSans(
//                         color: AppColor.lightRed,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 SizedBox(height: 20),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Utility/thanglish_to_tamil.dart';
import 'package:st_school_project/Core/Utility/snack_bar.dart';

import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Utility/snack_bar.dart' as UI;
import 'package:st_school_project/Core/Utility/app_loader.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/admission_1.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/parents_info_screen.dart';

import '../Controller/admission_controller.dart';

class StudentInfoScreen extends StatefulWidget {
  final String? pages;
  final int admissionId; // <-- supply this when navigating

  const StudentInfoScreen({super.key, required this.admissionId, this.pages});

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class AadhaarInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buf = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      buf.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i + 1 != digitsOnly.length) buf.write(' ');
    }
    final formatted = buf.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  late final int admissionId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AdmissionController ctrl = Get.put(AdmissionController());
  final AdmissionController admissionController = Get.put(
    AdmissionController(),
  );

  List<String> fatherSuggestions = [];
  bool isFatherLoading = false;

  final FocusNode tamilFocusNode = FocusNode();
  final FocusNode nextFieldFocusNode = FocusNode(); // used after DOB select

  // @override
  // void dispose() {
  //   tamilFocusNode.dispose();
  //   nextFieldFocusNode.dispose();
  //
  //   nameEnglishController.dispose();
  //   nameTamilController.dispose();
  //   aadharController.dispose();
  //   dobController.dispose();
  //   religionController.dispose();
  //   casteController.dispose();
  //   communityController.dispose();
  //   tongueController.dispose();
  //   nationalityController.dispose();
  //   personalId1Controller.dispose();
  //   personalId2Controller.dispose();
  //   super.dispose();
  // }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDobToIso(String dob) {
    final cleanDob = dob.trim().replaceAll(RegExp(r'[^0-9\-\/]'), '');
    for (final format in ['dd/MM/yyyy', 'dd-MM-yyyy', 'yyyy-MM-dd']) {
      try {
        final date = DateFormat(format).parseStrict(cleanDob);
        // Use strict ISO format for full compatibility
        return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date.toUtc());
      } catch (_) {}
    }
    debugPrint('DOB format not recognized: $dob');
    return dob;
  }

  Future<void> _openSelectSheet({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    required List<String> options,
  }) async {
    final TextEditingController searchCtrl = TextEditingController(
      text: controller.text.trim(),
    );
    List<String> filtered = List.of(options);

    String? finalize(String raw) {
      final t = raw.trim();
      if (t.isNotEmpty) return t;
      if (filtered.isNotEmpty) return filtered.first;
      return null;
    }

    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              void onSearch(String q) {
                setState(() {
                  filtered =
                      options
                          .where(
                            (o) => o.toLowerCase().contains(q.toLowerCase()),
                          )
                          .toList();
                });
              }

              Future<void> onDone() async {
                final t = finalize(searchCtrl.text);
                if (t != null) Navigator.pop(ctx, t);
              }

              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Select $title',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: onDone,
                            child: Text(
                              'Done',
                              style: GoogleFont.ibmPlexSans(
                                color: AppColor.blueG2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: searchCtrl,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => onDone(),
                        onChanged: onSearch,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search or type…',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1.8,
                            ),
                          ),
                        ),
                        cursorColor: Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      Flexible(
                        child:
                            filtered.isEmpty
                                ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 24),
                                    const Text('No matches'),
                                    const SizedBox(height: 12),
                                    // If you want a button, uncomment:
                                    // ElevatedButton.icon(
                                    //   icon: const Icon(Icons.check),
                                    //   label: Text('Done – Use "${searchCtrl.text}"'),
                                    //   onPressed: searchCtrl.text.trim().isEmpty ? null : onDone,
                                    // ),
                                  ],
                                )
                                : ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: filtered.length,
                                  separatorBuilder:
                                      (_, __) => Container(
                                        width: double.infinity,
                                        height: 2,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.centerRight,
                                            end: Alignment.centerLeft,
                                            colors: [
                                              AppColor.white.withOpacity(0.5),
                                              AppColor.white3,
                                              AppColor.white3,
                                              AppColor.white3,
                                              AppColor.white3,
                                              AppColor.white3,
                                              AppColor.white3,
                                              AppColor.white.withOpacity(0.5),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            1,
                                          ),
                                        ),
                                      ),
                                  itemBuilder: (ctx, i) {
                                    final value = filtered[i];
                                    return ListTile(
                                      title: Text(value),
                                      onTap: () => Navigator.pop(ctx, value),
                                    );
                                  },
                                ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.keyboard_alt_outlined, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Tip: Type your value and press Done.',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 12,
                                color: AppColor.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    if (picked != null && picked.trim().isNotEmpty) {
      controller.text = picked.trim();
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      admissionController.studentDropDown();
      admissionController.fetchAndSetUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldGoBack = await showDialog<bool>(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text('Are you sure you want to go back?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return shouldGoBack ?? false;
      },

      // onWillPop: () async {
      //   return await false;
      // },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomContainer.leftSaitArrow(
                          onTap: () async {
                            final shouldGoBack = await showDialog<bool>(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text(
                                    'Are you sure you want to go back?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(ctx, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (shouldGoBack == true) {
                              // If Admission1 doesn’t require parameters:
                              Get.off(() => Admission1());

                              // If Admission1 needs admissionId like before:
                              // final prefs = await SharedPreferences.getInstance();
                              // final admissionId = prefs.getInt('admissionId') ?? 0;
                              // Get.off(() => Admission1(admissionId: admissionId));
                            }
                          },
                        ),

                        // CustomContainer.leftSaitArrow(
                        //   onTap: () async {
                        //     final currentStep =
                        //         ctrl.currentAdmission.value?.step ?? 1;
                        //
                        //     if (currentStep > 1) {
                        //       // handle step logic if needed
                        //     } else if (widget.pages == 'homeScreen') {
                        //       Get.back(); // <-- works even with Get.to()
                        //     } else {
                        //       // Example: navigate to Admission1 screen
                        //       // Get.off(Admission1());
                        //     }
                        //   },
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
                      value: 0.2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
                      backgroundColor: AppColor.lowGery1,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    SizedBox(height: 40),
                    CustomTextField.textWith600(
                      text: 'Student Info',
                      fontSize: 26,
                    ),
                    SizedBox(height: 30),

                    // Name (English)
                    buildField(
                      label: 'Name of the Student ',
                      subLabel: 'As per Birth Certificate',
                      controller: admissionController.nameEnglishController,
                      hint: 'English',
                      validatorMsg: 'Student Name is required',
                    ),

                    // Name (Tamil) + suggestions
                    buildField(
                      context: context,
                      focusNode: tamilFocusNode,
                      isTamilField: true,
                      controller: admissionController.nameTamilController,
                      hint: 'Tamil',
                      validatorMsg: 'Tamil name is required',
                    ),
                    if (isFatherLoading)
                      Padding(
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
                                  controller:
                                      admissionController.nameTamilController,
                                  suggestion: suggestion,
                                  onSuggestionApplied: () {
                                    setState(() => fatherSuggestions = []);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),

                    // Aadhaar
                    buildField(
                      label: 'Student Aadhar Number',
                      controller: admissionController.aadharController,
                      hint: 'Aadhar No',
                      validatorMsg: 'Aadhar number is required',
                      isAadhaar: true,
                      isNumeric: true,
                    ),

                    // DOB (with range)
                    buildField(
                      context: context,
                      label: 'Date of Birth ',
                      subLabel: '01-06-2021 to 31-05-2022',
                      controller: admissionController.dobController,
                      hint: '',
                      validatorMsg: 'Select Date of Birth',
                      isDOB: true,
                    ),
                    buildField(
                      context: context,
                      label: 'Email Id',

                      verticalDivider: false,
                      controller: admissionController.emailIdController,
                      hint: '',
                      validatorMsg: 'Email id is required',
                    ),

                    // Dropdowns with “type or pick”
                    // buildField(
                    //   label: 'Religion',
                    //   controller: religionController,
                    //   hint: 'Select or type',
                    //   validatorMsg: 'Religion is required',
                    //   isDropDown: true,
                    //   verticalDivider: false,
                    //   context: context,
                    //   options: _religions,
                    //   pickerTitle: 'Religion',
                    //   iconSize: 11,
                    // ),
                    // buildField(
                    //   label: 'Caste',
                    //   controller: casteController,
                    //   hint: 'Select or type',
                    //   validatorMsg: 'Caste is required',
                    //   isDropDown: true,
                    //   verticalDivider: false,
                    //   context: context,
                    //   options: _castes,
                    //   pickerTitle: 'Caste',
                    //   iconSize: 11,
                    // ),
                    // buildField(
                    //   label: 'Community',
                    //   subLabel: 'As per Community Certificate',
                    //   controller: communityController,
                    //   hint: 'Select or type',
                    //   validatorMsg: 'Community is required',
                    //   isDropDown: true,
                    //   verticalDivider: false,
                    //   context: context,
                    //   options: _communities,
                    //   pickerTitle: 'Community',
                    //   iconSize: 11,
                    // ),
                    // buildField(
                    //   label: 'Mother Tongue',
                    //   controller: tongueController,
                    //   hint: 'Select or type',
                    //   validatorMsg: 'Mother tongue is required',
                    //   isDropDown: true,
                    //   verticalDivider: false,
                    //   context: context,
                    //   options: _motherTongues,
                    //   pickerTitle: 'Mother Tongue',
                    //   iconSize: 11,
                    // ),
                    // buildField(
                    //   label: 'Nationality',
                    //   controller: nationalityController,
                    //   hint: 'Select or type',
                    //   validatorMsg: 'Nationality is required',
                    //   isDropDown: true,
                    //   verticalDivider: false,
                    //   context: context,
                    //   options: _nationalities,
                    //   pickerTitle: 'Nationality',
                    //   iconSize: 11,
                    // ),

                    // Personal Ids
                    Obx(() {
                      final dropData =
                          admissionController.religionCasteData.value;

                      if (dropData == null) {
                        return Center(
                          child: Text(' ', style: TextStyle(color: Colors.red)),
                        );
                      }

                      return Column(
                        children: [
                          buildField(
                            label: 'Religion',
                            controller: admissionController.religionController,
                            hint: 'Select or type',
                            validatorMsg: 'Religion is required',
                            isDropDown: true,

                            verticalDivider: false,
                            context: context,
                            options: dropData.religion,
                            pickerTitle: 'Religion',
                            iconSize: 11,
                          ),
                          buildField(
                            label: 'Caste',
                            controller: admissionController.casteController,
                            hint: 'Select or type',
                            validatorMsg: 'Caste is required',
                            isDropDown: true,
                            verticalDivider: false,
                            context: context,
                            options: dropData.caste,
                            pickerTitle: 'Caste',
                            iconSize: 11,
                          ),
                          buildField(
                            label: 'Community',
                            subLabel: 'As per Community Certificate',
                            controller: admissionController.communityController,
                            hint: 'Select or type',
                            validatorMsg: 'Community is required',
                            isDropDown: true,
                            verticalDivider: false,
                            context: context,
                            options: dropData.community,
                            pickerTitle: 'Community',
                            iconSize: 11,
                          ),
                          buildField(
                            label: 'Mother Tongue',
                            controller: admissionController.tongueController,
                            hint: 'Select or type',
                            validatorMsg: 'Mother tongue is required',
                            isDropDown: true,
                            verticalDivider: false,
                            context: context,
                            options: dropData.motherTongue,
                            pickerTitle: 'Mother Tongue',
                            iconSize: 11,
                          ),
                          buildField(
                            label: 'Nationality',
                            controller:
                                admissionController.nationalityController,
                            hint: 'Select or type',
                            validatorMsg: 'Nationality is required',
                            isDropDown: true,
                            verticalDivider: false,
                            context: context,
                            options: dropData.nationality,
                            pickerTitle: 'Nationality',
                            iconSize: 11,
                          ),
                        ],
                      );
                    }),

                    buildField(
                      label: 'Personal Identification 1',
                      controller: admissionController.personalId1Controller,
                      hint: '',
                      validatorMsg: 'Personal ID 1 is required',
                      verticalDivider: false,
                    ),
                    buildField(
                      label: 'Personal Identification 2',
                      controller: admissionController.personalId2Controller,
                      hint: '',
                      validatorMsg: 'Personal ID 2 is required',
                      verticalDivider: false,
                    ),

                    SizedBox(height: 30),

                    // Save & Continue (with loader)
                    Obx(
                      () => AppButton.button(
                        loader:
                            ctrl.isLoading.value
                                ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                                : null,
                        image:
                            ctrl.isLoading.value
                                ? null
                                : AppImages.rightSaitArrow,
                        text: 'Save & Continue',
                        onTap:
                            ctrl.isLoading.value
                                ? null
                                : () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final admissionID =
                                      prefs.getInt('admissionId') ?? 0;
                                  HapticFeedback.heavyImpact();
                                  FocusScope.of(context).unfocus();

                                  if (!_formKey.currentState!.validate()) {
                                    _showSnack(
                                      'Please fix the highlighted fields',
                                      isError: true,
                                    );
                                    return;
                                  }

                                  final formattedDob = _formatDobToIso(
                                    admissionController.dobController.text
                                        .trim(),
                                  );

                                  //  Single, correct API call
                                  final err = await ctrl.postStudentInfo(
                                    page: widget.pages ?? '',
                                    emailId:
                                        admissionController
                                            .emailIdController
                                            .text
                                            .trim(),
                                    id: admissionID,
                                    studentName:
                                        admissionController
                                            .nameEnglishController
                                            .text
                                            .trim(),
                                    studentNameTamil:
                                        admissionController
                                            .nameTamilController
                                            .text
                                            .trim(),
                                    aadhaar: admissionController
                                        .aadharController
                                        .text
                                        .replaceAll(' ', ''),
                                    dob: formattedDob,
                                    religion:
                                        admissionController
                                            .religionController
                                            .text
                                            .trim(),
                                    caste:
                                        admissionController.casteController.text
                                            .trim(),
                                    community:
                                        admissionController
                                            .communityController
                                            .text
                                            .trim(),
                                    motherTongue:
                                        admissionController
                                            .tongueController
                                            .text
                                            .trim(),
                                    nationality:
                                        admissionController
                                            .nationalityController
                                            .text
                                            .trim(),
                                    idProof1:
                                        admissionController
                                            .personalId1Controller
                                            .text
                                            .trim(),
                                    idProof2:
                                        admissionController
                                            .personalId2Controller
                                            .text
                                            .trim(),
                                  );

                                  if (err != null) {
                                    _showSnack(
                                      'Failed to save: $err',
                                      isError: true,
                                    );
                                    return;
                                  }
                                },
                      ),
                    ),

                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField({
    String? label,
    String? subLabel,
    required TextEditingController controller,
    required String hint,
    required String validatorMsg,
    bool isDropDown = false,
    bool isAadhaar = false,
    bool isDOB = false,
    bool isNumeric = false,
    bool isTamilField = false,
    bool verticalDivider = true,
    BuildContext? context,
    FocusNode? focusNode,
    List<String>? options,
    String? pickerTitle,
    double iconSize = 20,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          CustomTextField.richText(text: label, text2: subLabel ?? ''),
          const SizedBox(height: 10),
        ],
        FormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            final text = controller.text.trim();
            if (text.isEmpty) return validatorMsg;

            if (isAadhaar == true) {
              final clean = text.replaceAll(' ', '');
              if (!RegExp(r'^[2-9][0-9]{11}$').hasMatch(clean)) {
                return 'Enter a valid Aadhaar number';
              }
            }
            if (label != null && label.toLowerCase().contains('email')) {
              final emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );
              if (!emailRegex.hasMatch(text)) {
                return 'Enter a valid email address';
              }
            }

            // Apply min length only to plain text fields (not dropdowns/DOB/Aadhaar)
            if (!isAadhaar && !isDropDown && text.length < 3) {
              return 'Enter at least 3 characters';
            }
            return null;
          },
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    // DOB picker
                    if (isDOB && context != null) {
                      final DateTime startDate = DateTime(2021, 6, 1);
                      final DateTime endDate = DateTime(2022, 5, 31);
                      final DateTime initial = DateTime(2021, 6, 2);

                      final picked = await showDatePicker(
                        context: context!,
                        initialDate: initial,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2025),
                        builder: (c, child) {
                          return Theme(
                            data: Theme.of(c).copyWith(
                              dialogBackgroundColor: AppColor.white,
                              colorScheme: ColorScheme.light(
                                primary: AppColor.blueG2,
                                onPrimary: Colors.white,
                                onSurface: AppColor.black,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColor.blueG2,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (picked != null) {
                        if (picked.isBefore(startDate) ||
                            picked.isAfter(endDate)) {
                          ScaffoldMessenger.of(context!).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Invalid Date of Birth!\nPlease select a date between 01-06-2021 and 31-05-2022.',
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          controller.text =
                              "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
                          field.didChange(controller.text);
                          FocusScope.of(
                            context!,
                          ).requestFocus(nextFieldFocusNode);
                        }
                      }
                      return;
                    }

                    // Dropdown picker
                    if (isDropDown && context != null) {
                      await _openSelectSheet(
                        context: context!,
                        title: (pickerTitle ?? label ?? 'Select'),
                        controller: controller,
                        options: options ?? const [],
                      );
                      // The sheet writes into controller; still notify the FormField
                      field.didChange(controller.text);
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: isDOB,
                    child: CustomContainer.studentInfoScreen(
                      verticalDivider: verticalDivider,
                      context: isDOB ? context : null,
                      keyboardType:
                          isNumeric
                              ? TextInputType.number
                              : (label != null &&
                                      label.toLowerCase().contains('email')
                                  ? TextInputType.emailAddress
                                  : TextInputType.text),

                      controller: controller,
                      text: hint,
                      imagePath:
                          isDropDown
                              ? AppImages.dropDown
                              : (isDOB ? AppImages.calender : null),
                      imageSize: iconSize,
                      isAadhaar: isAadhaar,
                      isDOB: isDOB,
                      isError: field.hasError,
                      focusNode: focusNode,
                      inputFormatters:
                          isAadhaar
                              ? [
                                FilteringTextInputFormatter.digitsOnly,
                                AadhaarInputFormatter(),
                              ]
                              : [],
                      onChanged:
                          isTamilField
                              ? (value) async {
                                if (value.trim().isEmpty) {
                                  setState(() => fatherSuggestions = []);
                                  return;
                                }
                                setState(() => isFatherLoading = true);
                                final result =
                                    await TanglishTamilHelper.transliterate(
                                      value,
                                    );
                                setState(() {
                                  fatherSuggestions = result;
                                  isFatherLoading = false;
                                });
                                field.didChange(value);
                              }
                              : field.didChange,
                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 8),
                    child: Text(
                      field.errorText!,
                      style: GoogleFont.ibmPlexSans(
                        color: AppColor.lightRed,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ],
    );
  }
}
