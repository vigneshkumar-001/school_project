import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/parents_info_screen.dart';
import '../../../Core/Utility/app_images.dart';

class StudentInfoScreen extends StatefulWidget {
  const StudentInfoScreen({super.key});

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameEnglishController = TextEditingController();
  TextEditingController nameTamilController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController religionController = TextEditingController();
  TextEditingController casteController = TextEditingController();
  TextEditingController communityController = TextEditingController();
  TextEditingController tongueController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController personalId1Controller = TextEditingController();
  TextEditingController personalId2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.lightGrey,
                            border: Border.all(
                              color: AppColor.lowLightBlue,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            AppImages.leftArrow,
                            height: 12,
                            width: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
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
                  LinearProgressIndicator(
                    minHeight: 6,
                    value: 0.2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
                    backgroundColor: AppColor.lowGery1,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField.textWith600(
                    text: 'Student Info',
                    fontSize: 26,
                  ),
                  const SizedBox(height: 30),

                  buildField(
                    label: 'Name of the Student ',
                    subLabel: 'As per Birth Certificate',
                    controller: nameEnglishController,
                    hint: 'English',
                    validatorMsg: ' names is required',
                  ),

                  buildField(
                    controller: nameTamilController,
                    hint: 'Tamil',
                    validatorMsg: 'names is required',
                  ),

                  buildField(
                    label: 'Student Aadhar Number',
                    controller: aadharController,
                    hint: 'Aadhar No',
                    validatorMsg: ' Aadhar nomber is required',
                    isAadhaar: true,
                  ),

                  buildField(
                    label: 'Date of Birth ',
                    subLabel: '01-06-2021 to 31-05-2022',
                    controller: dobController,
                    hint: '',
                    validatorMsg: 'Select Date of Birth',
                    isDOB: true,
                  ),

                  buildField(
                    label: 'Religion',
                    controller: religionController,
                    hint: '',
                    validatorMsg: 'Enter religion',
                    isDropDown: true,
                  ),

                  buildField(
                    label: 'Caste',
                    controller: casteController,
                    hint: '',
                    validatorMsg: 'Enter caste',
                    isDropDown: true,
                  ),

                  buildField(
                    label: 'Community',
                    subLabel: 'As per Community Certificate',
                    controller: communityController,
                    hint: '',
                    validatorMsg: 'Enter community',
                    isDropDown: true,
                  ),

                  buildField(
                    label: 'Mother Tongue',
                    controller: tongueController,
                    hint: '',
                    validatorMsg: 'Enter mother tongue',
                    isDropDown: true,
                  ),

                  buildField(
                    label: 'Nationality',
                    controller: nationalityController,
                    hint: '',
                    validatorMsg: 'Enter nationality',
                    isDropDown: true,
                  ),

                  buildField(
                    label: 'Personal Identification 1',
                    controller: personalId1Controller,
                    hint: '',
                    validatorMsg: 'Enter personal ID 1',
                  ),

                  buildField(
                    label: 'Personal Identification 2',
                    controller: personalId2Controller,
                    hint: '',
                    validatorMsg: 'Enter personal ID 2',
                  ),

                  const SizedBox(height: 30),

                  AppButton.button(
                    image: AppImages.rightSaitArrow,
                    text: 'Save & Continue',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  ParentsInfoScreen(),
                          ),
                        );
                      }
                    },
                  ),

                   SizedBox(height: 10),
                ],
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          CustomTextField.richText(text: label, text2: subLabel ?? ''),
          const SizedBox(height: 10),
        ],
        FormField<String>(
          validator: (value) {
            final text = controller.text;
            if (text.isEmpty) return validatorMsg;
            if (isAadhaar && !RegExp(r'^[2-9][0-9]{11}$').hasMatch(text)) {
              return 'required valid Aadhar number';
            }
            return null;
          },
          builder:
              (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomContainer.studentInfoScreen(
                    context: isDOB ? context : null,
                    controller: controller,
                    text: hint,
                    imagePath:
                        isDropDown
                            ? AppImages.dropDown
                            : isDOB
                            ? AppImages.calender
                            : null,
                    isAadhaar: isAadhaar,
                    isDOB: isDOB,
                    isError: field.hasError,
                  ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 8),
                      child: Text(
                        field.errorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
        ),
      ],
    );
  }
}
