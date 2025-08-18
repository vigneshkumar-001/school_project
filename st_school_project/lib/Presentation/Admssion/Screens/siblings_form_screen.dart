import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/communication_screen.dart';

class SiblingsFormScreen extends StatefulWidget {
  const SiblingsFormScreen({super.key});

  @override
  State<SiblingsFormScreen> createState() => _SiblingsFormScreenState();
}

class _SiblingsFormScreenState extends State<SiblingsFormScreen> {
  String selected = 'Yes';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController admissionNoController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  bool isSubmitted = false;
  @override
  void dispose() {
    nameController.dispose();
    admissionNoController.dispose();
    classController.dispose();
    sectionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                SizedBox(height: 25),
                LinearProgressIndicator(
                  minHeight: 6,
                  value: 0.6,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
                  backgroundColor: AppColor.lowGery1,
                  borderRadius: BorderRadius.circular(16),
                ),
                SizedBox(height: 30),
                CustomTextField.textWith600(
                  text:
                      "If Your Sister Studying in St.Joseph's Matriculation School-Madurai.",
                  fontSize: 26,
                ),
                CustomTextField.richText(
                  text: '',
                  text2: 'Only Own Sisters',
                  secondFontSize: 26,
                  fontWeight2: FontWeight.w500,
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = 'Yes';
                        });
                      },
                      child: CustomContainer.parentInfo(
                        text: 'Yes',
                        isSelected: selected == 'Yes',
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = 'No';
                        });
                      },
                      child: CustomContainer.parentInfo(
                        text: 'No',
                        isSelected: selected == 'No',
                      ),
                    ),
                  ],
                ),

                if (selected == 'Yes') ...[
                  for (int i = 0; i < siblings.length; i++) ...[
                    i == 0
                        ? SizedBox.shrink()
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextField.textWith600(
                              text: 'Sibling ${i + 1}',
                              fontSize: 18,
                            ),
                            if (i == 1)
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    siblings.removeAt(i);
                                  });
                                },
                              ),
                          ],
                        ),
                    SizedBox(height: 15),
                    CustomTextField.richText(text: 'Name', text2: ''),
                    SizedBox(height: 10),
                    CustomContainer.studentInfoScreen(
                      isError:
                          isSubmitted &&
                          siblings[i].nameController.text.trim().isEmpty,
                      errorText:
                          isSubmitted &&
                                  siblings[i].nameController.text.trim().isEmpty
                              ? 'Name is required'
                              : null,
                      onChanged: (value) {
                        if (isSubmitted && value.trim().isNotEmpty) {
                          setState(() {});
                        }
                      },
                      controller: siblings[i].nameController,
                      text: '',
                      verticalDivider: false,
                    ),
                    SizedBox(height: 15),
                    CustomTextField.richText(text: 'Admission No', text2: ''),
                    SizedBox(height: 10),
                    CustomContainer.studentInfoScreen(

                      isError:
                          isSubmitted &&
                          siblings[i].admissionNoController.text.trim().isEmpty,
                      errorText:
                          isSubmitted &&
                                  siblings[i].admissionNoController.text
                                      .trim()
                                      .isEmpty
                              ? 'Admission No is required'
                              : null,
                      onChanged: (value) {
                        if (isSubmitted && value.trim().isNotEmpty) {
                          setState(() {});
                        }
                      },
                      controller: siblings[i].admissionNoController,
                      text: '',
                      verticalDivider: false,
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField.richText(
                                text: 'Class',
                                text2: '',
                              ),
                              SizedBox(height: 10),
                              CustomContainer.studentInfoScreen(
                                isError:
                                    isSubmitted &&
                                    siblings[i].classController.text
                                        .trim()
                                        .isEmpty,
                                controller: siblings[i].classController,
                                errorText:
                                    isSubmitted &&
                                            siblings[i].classController.text
                                                .trim()
                                                .isEmpty
                                        ? 'Class is required'
                                        : null,
                                onChanged: (value) {
                                  if (isSubmitted && value.trim().isNotEmpty) {
                                    setState(() {});
                                  }
                                },
                                text: '',
                                verticalDivider: false,
                                imagePath: AppImages.dropDown,
                                imageSize: 11,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField.richText(
                                text: 'Section',
                                text2: '',
                              ),
                              SizedBox(height: 10),
                              CustomContainer.studentInfoScreen(
                                isError:
                                    isSubmitted &&
                                    siblings[i].sectionController.text
                                        .trim()
                                        .isEmpty,
                                controller: siblings[i].sectionController,
                                errorText:
                                    isSubmitted &&
                                            siblings[i].sectionController.text
                                                .trim()
                                                .isEmpty
                                        ? 'Section is required'
                                        : null,
                                onChanged: (value) {
                                  if (isSubmitted && value.trim().isNotEmpty) {
                                    setState(() {});
                                  }
                                },
                                text: '',
                                verticalDivider: false,
                                imagePath: AppImages.dropDown,
                                imageSize: 11,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],

                  SizedBox(height: 25),
                  if (siblings.length < 2)
                    Center(
                      child: GestureDetector(
                        onTap: addMoreSibling,
                        child: CustomTextField.textWith600(
                          text: 'Add More',
                          fontSize: 16,
                        ),
                      ),
                    ),

                  SizedBox(height: 15),

                  AppButton.button(
                    image: AppImages.rightSaitArrow,
                    text: 'Save & Continue',
                    onTap: () {
                      setState(() {
                        isSubmitted = true;
                      });

                      bool allValid = siblings.every(
                        (sibling) =>
                            sibling.nameController.text.trim().isNotEmpty &&
                            sibling.admissionNoController.text
                                .trim()
                                .isNotEmpty &&
                            sibling.classController.text.trim().isNotEmpty &&
                            sibling.sectionController.text.trim().isNotEmpty,
                      );

                      if (allValid) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommunicationScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ] else ...[
                  SizedBox(height: 350),
                  AppButton.button(
                    image: AppImages.rightSaitArrow,
                    text: 'Save & Continue',
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunicationScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addMoreSibling() {
    if (siblings.length < 2) {
      setState(() {
        siblings.add(SiblingInfo());
      });
    }
  }

  List<SiblingInfo> siblings = [SiblingInfo()];
}

class SiblingInfo {
  TextEditingController nameController = TextEditingController();
  TextEditingController admissionNoController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
}
