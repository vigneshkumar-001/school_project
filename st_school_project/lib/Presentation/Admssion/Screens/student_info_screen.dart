import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Utility/thanglish_to_tamil.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
  List<String> fatherSuggestions = [];
  bool isFatherLoading = false;
  final FocusNode tamilFocusNode = FocusNode();
  @override
  void dispose() {
    // Dispose the focus node along with controllers
    tamilFocusNode.dispose();
    nameEnglishController.dispose();
    nameTamilController.dispose();
    aadharController.dispose();
    dobController.dispose();
    religionController.dispose();
    casteController.dispose();
    communityController.dispose();
    tongueController.dispose();
    nationalityController.dispose();
    personalId1Controller.dispose();
    personalId2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    validatorMsg: 'Student Name is required',
                  ),

                  buildField(
                    context: context,
                    focusNode: tamilFocusNode,
                    isTamilField: true,
                    controller: nameTamilController,
                    hint: 'Tamil',
                    validatorMsg: 'Tamil name is required',
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
                                controller: nameTamilController,
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

                  buildField(
                    label: 'Student Aadhar Number',
                    controller: aadharController,
                    hint: 'Aadhar No',
                    validatorMsg: ' Aadhar number is required',
                    isAadhaar: true,
                    isNumeric: true
                  ),

                  buildField(
                    context: context,
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
                    validatorMsg: 'Religion is required',
                    isDropDown: true,
                  ),

                  buildField(
                    label: 'Caste',
                    controller: casteController,
                    hint: '',
                    validatorMsg: 'Caste is required',
                    isDropDown: true,
                  ),

                  buildField(
                    label: 'Community',
                    subLabel: 'As per Community Certificate',
                    controller: communityController,
                    hint: '',
                    validatorMsg: 'Community is required',
                    isDropDown: true,
                  ),

                  buildField(
                    label: 'Mother Tongue',
                    controller: tongueController,
                    hint: '',
                    validatorMsg: 'Mother tongue is required',
                    isDropDown: true,
                  ),

                  buildField(
                    label: 'Nationality',
                    controller: nationalityController,
                    hint: '',
                    validatorMsg: 'Nationality is required',
                    isDropDown: true,
                  ),

                  buildField(
                    label: 'Personal Identification 1',
                    controller: personalId1Controller,
                    hint: '',
                    validatorMsg: 'Personal ID 1 is required',
                  ),

                  buildField(
                    label: 'Personal Identification 2',
                    controller: personalId2Controller,
                    hint: '',
                    validatorMsg: 'Personal ID 2 is required',
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
                            builder: (context) => ParentsInfoScreen(),
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
    bool isNumeric = false,
    bool isTamilField = false,
    BuildContext? context,
    FocusNode? focusNode,
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
            if (isAadhaar && !RegExp(r'^[2-9][0-9]{11}$').hasMatch(text)) {
              return 'Enter a valid Aadhaar number';
            }
            return null;
          },
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: isDOB && context != null
                      ? () async {
                    final DateTime startDate = DateTime(2021, 6, 1);
                    final DateTime endDate = DateTime(2022, 5, 31);
                    final DateTime initialDate = DateTime(2021, 6, 2);

                    final pickedDate = await showDatePicker(
                      context: context!,
                      initialDate: initialDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2025),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
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

                    if (pickedDate != null) {
                      if (pickedDate.isBefore(startDate) ||
                          pickedDate.isAfter(endDate)) {
                        ScaffoldMessenger.of(context!).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Invalid Date of Birth!\nPlease select a date between 01-06-2021 and 31-05-2022.',
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else {
                        controller.text =
                        "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                        field.didChange(controller.text); // ✅ Trigger validation
                        FocusScope.of(context!).requestFocus(nextFieldFocusNode);
                      }
                    }
                  }
                      : null,
                  child: AbsorbPointer(
                    absorbing: isDOB,
                    child: CustomContainer.studentInfoScreen(
                      context: isDOB ? context : null,
                      keyboardType:
                      isNumeric ? TextInputType.number : TextInputType.text,
                      controller: controller,
                      text: hint,
                      imagePath: isDropDown
                          ? AppImages.dropDown
                          : isDOB
                          ? AppImages.calender
                          : null,
                      isAadhaar: isAadhaar,
                      isDOB: isDOB,
                      isError: field.hasError,
                      focusNode: focusNode,
                      onChanged: isTamilField
                          ? (value) async {
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
                      style: const TextStyle(color: Colors.red, fontSize: 12),
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
