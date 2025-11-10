import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/app_loader.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Admssion/Controller/admission_controller.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/communication_screen.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/parents_info_screen.dart';

class SiblingsFormScreen extends StatefulWidget {
  final int id;
  const SiblingsFormScreen({super.key, required this.id});

  @override
  State<SiblingsFormScreen> createState() => _SiblingsFormScreenState();
}

class _SiblingsFormScreenState extends State<SiblingsFormScreen> {
  String selected = 'Yes';
  bool isSubmitted = false;
  // final AdmissionController admissionController = Get.put(
  //   AdmissionController(),
  // );
  final admissionController = Get.put(AdmissionController());

  List<SiblingInfo> siblings = [SiblingInfo()];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (var s in siblings) {
      s.dispose();
    }
    super.dispose();
  }

  void addMoreSibling() {
    if (siblings.length < 2) {
      setState(() => siblings.add(SiblingInfo()));
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      admissionController.levelClassSection();
      admissionController.fetchAndSetUserData();
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomContainer.leftSaitArrow(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final admissionId = prefs.getInt('admissionId') ?? 0;

                        Get.off(ParentsInfoScreen(id: admissionId));
                      },
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
                const SizedBox(height: 25),
                LinearProgressIndicator(
                  minHeight: 6,
                  value: 0.6,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
                  backgroundColor: AppColor.lowGery1,
                  borderRadius: BorderRadius.circular(16),
                ),
                const SizedBox(height: 30),
                CustomTextField.textWith600(
                  text:
                      "If Your Sister Studying in St.Joseph's Matriculation School - Madurai.",
                  fontSize: 26,
                ),
                CustomTextField.richText(
                  text: '',
                  text2: 'Only Own Sisters',
                  secondFontSize: 26,
                  fontWeight2: FontWeight.w500,
                ),
                const SizedBox(height: 25),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => selected = 'Yes'),
                      child: CustomContainer.parentInfo(
                        text: 'Yes',
                        isSelected: selected == 'Yes',
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => setState(() => selected = 'No'),
                      child: CustomContainer.parentInfo(
                        text: 'No',
                        isSelected: selected == 'No',
                      ),
                    ),
                  ],
                ),

                if (selected == 'Yes') ...[
                  for (int i = 0; i < siblings.length; i++) ...[
                    if (i > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextField.textWith600(
                            text: 'Sibling ${i + 1}',
                            fontSize: 18,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed:
                                () => setState(() => siblings.removeAt(i)),
                          ),
                        ],
                      ),
                    SizedBox(height: 32),

                    _buildInputField(
                      label: "Name",
                      controller: siblings[i].nameController,
                      errorText: 'Name is required',
                    ),
                    SizedBox(height: 25),
                    _buildInputField(
                      label: "Admission No",
                      controller: siblings[i].admissionNoController,
                      errorText: 'Admission No is required',
                    ),
                    SizedBox(height: 25),

                    Obx(() {
                      final response =
                          admissionController.classSectionResponse.value;
                      final data = response?.data ?? {};

                      // if (isLoading) {
                      //   return Center(child: CircularProgressIndicator());
                      // }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  label: "Class",
                                  controller: siblings[i].classController,
                                  errorText: 'Class is required',
                                  suffixIcon: AppImages.dropDown,
                                  isDropDown: true,
                                  options: data.keys.toList(),
                                  onSelected: (selected) {
                                    siblings[i].classController.text = selected;
                                    siblings[i].sectionController.clear();
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                child: _buildInputField(
                                  label: "Section",
                                  controller: siblings[i].sectionController,
                                  errorText: 'Section is required',
                                  suffixIcon: AppImages.dropDown,
                                  isDropDown: true,
                                  options:
                                      siblings[i]
                                              .classController
                                              .text
                                              .isNotEmpty
                                          ? (data[siblings[i]
                                                  .classController
                                                  .text] ??
                                              [])
                                          : [],
                                  onSelected: (selected) {
                                    siblings[i].sectionController.text =
                                        selected;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          if (data.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text("No class/section data available"),
                            ),
                        ],
                      );
                    }),
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

                  Obx(() {
                    final isLoading = admissionController.isLoading.value;

                    return AppButton.button(
                      image: AppImages.rightSaitArrow,
                      text: 'Save & Continue',
                      loader:
                          isLoading
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
                          isLoading
                              ? null
                              : () async {
                                FocusScope.of(context).unfocus();
                                await validateAndContinue(
                                  hasSiblings:
                                      selected == 'Yes' ? 'Yes' : 'NoSiblings',
                                );
                              },

                      // onTap:
                      //     isLoading
                      //         ? null
                      //         : () {
                      //           validateAndContinue(hasSiblings: '');
                      //         }, // Disable tap while loading
                    );
                  }),
                ] else ...[
                  SizedBox(height: 350),
                  Obx(() {
                    final isLoading = admissionController.isLoading.value;

                    return AppButton.button(
                      image: AppImages.rightSaitArrow,
                      text: 'Save & Continue',
                      loader:
                          isLoading
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
                          isLoading
                              ? null
                              : () async {
                                FocusScope.of(context).unfocus();
                                await validateAndContinue(
                                  hasSiblings: 'NoSiblings',
                                );
                              }, // Disable tap while loading
                    );
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildInputField({
  //   required String label,
  //   required TextEditingController controller,
  //   required String errorText,
  //   String? suffixIcon,
  // }) {
  //   final hasError = isSubmitted && controller.text.trim().isEmpty;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       CustomTextField.richText(text: label, text2: ''),
  //       const SizedBox(height: 10),
  //       CustomContainer.studentInfoScreen(
  //         isError: hasError,
  //         errorText: hasError ? errorText : null,
  //         controller: controller,
  //         onChanged: (value) {
  //           if (isSubmitted && value.trim().isNotEmpty) setState(() {});
  //         },
  //         text: '',
  //         verticalDivider: false,
  //         imagePath: suffixIcon,
  //         imageSize: 11,
  //       ),
  //     ],
  //   );
  // }

  // void validateAndContinue() async {
  //
  //   HapticFeedback.mediumImpact();
  //   setState(() => isSubmitted = true);
  //
  //   final allValid = siblings.every(
  //     (s) =>
  //         s.nameController.text.trim().isNotEmpty &&
  //         s.admissionNoController.text.trim().isNotEmpty &&
  //         s.classController.text.trim().isNotEmpty &&
  //         s.sectionController.text.trim().isNotEmpty,
  //   );
  //
  //   if (!allValid) {
  //     _showSnack('Please fill all sibling details properly', isError: true);
  //     return;
  //   }
  //
  //   final List<Map<String, String>> siblingList =
  //       siblings.map((s) => s.toJson()).toList();
  //
  //   final error = await admissionController.sistersInfo(
  //     id: widget.id,
  //     siblings: siblingList,
  //   );
  //
  //   if (error == null) {
  //     _showSnack('Saved successfully');
  //     Get.to(() => CommunicationScreen());
  //   } else {
  //     _showSnack(error, isError: true);
  //   }
  // }
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String errorText,
    String? suffixIcon,
    bool isDropDown = false,
    List<String>? options,
    Function(String)? onSelected,
  }) {
    final hasError = isSubmitted && controller.text.trim().isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField.richText(text: label, text2: ''),
        const SizedBox(height: 10),
        GestureDetector(
          onTap:
              isDropDown && options != null
                  ? () async {
                    final picked = await showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (_) {
                        return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (ctx, i) {
                            final item = options[i];
                            return ListTile(
                              title: Text(item),
                              onTap: () => Navigator.pop(ctx, item),
                            );
                          },
                          separatorBuilder: (_, __) => const Divider(),
                          itemCount: options.length,
                        );
                      },
                    );
                    if (picked != null && picked.isNotEmpty) {
                      controller.text = picked;
                      onSelected?.call(picked);
                      setState(() {});
                    }
                  }
                  : null,
          child: AbsorbPointer(
            absorbing: isDropDown,
            child: CustomContainer.studentInfoScreen(
              isError: hasError,
              errorText: hasError ? errorText : null,
              controller: controller,
              onChanged: (value) {
                if (isSubmitted && value.trim().isNotEmpty) setState(() {});
              },
              text: '',
              verticalDivider: false,
              imagePath: suffixIcon,
              imageSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> validateAndContinue({required String hasSiblings}) async {
    HapticFeedback.mediumImpact();
    setState(() => isSubmitted = true);

    if (selected == 'Yes') {
      final allValid = siblings.every(
        (s) =>
            s.nameController.text.trim().isNotEmpty &&
            s.admissionNoController.text.trim().isNotEmpty &&
            s.classController.text.trim().isNotEmpty &&
            s.sectionController.text.trim().isNotEmpty,
      );

      if (!allValid) {
        _showSnack('Please fill all sibling details properly', isError: true);
        return;
      }
    }

    try {
      final siblingList = siblings.map((s) => s.toJson()).toList();

      admissionController.isLoading.value = true;
      final error = await admissionController.sistersInfo(
        id: widget.id,
        siblings: siblingList,
        hasSisterInSchool: hasSiblings,
      );

      admissionController.isLoading.value = false;
    } catch (e) {
      admissionController.isLoading.value = false;
      _showSnack('Unexpected error: $e', isError: true);
    }
  }

  // void validateAndContinue({required String hasSiblings}) async {
  //   HapticFeedback.mediumImpact();
  //
  //   setState(() => isSubmitted = true);
  //
  //   final allValid = siblings.every(
  //     (s) =>
  //         s.nameController.text.trim().isNotEmpty &&
  //         s.admissionNoController.text.trim().isNotEmpty &&
  //         s.classController.text.trim().isNotEmpty &&
  //         s.sectionController.text.trim().isNotEmpty,
  //   );
  //
  //   if (!allValid) {
  //     _showSnack('Please fill all sibling details properly', isError: true);
  //     return;
  //   }
  //
  //   try {
  //     final List<Map<String, String>> siblingList =
  //         siblings.map((s) => s.toJson()).toList();
  //
  //     admissionController.sistersInfo(
  //       id: widget.id,
  //       siblings: siblingList,
  //       hasSisterInSchool: hasSiblings,
  //     );
  //   } catch (e) {
  //     _showSnack('Unexpected error: $e', isError: true);
  //   }
  // }
}

class SiblingInfo {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController admissionNoController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();

  void dispose() {
    nameController.dispose();
    admissionNoController.dispose();
    classController.dispose();
    sectionController.dispose();
  }

  Map<String, String> toJson() {
    return {
      "name": nameController.text.trim(),
      "admNo": admissionNoController.text.trim(),
      "class": classController.text.trim(),
      "section": sectionController.text.trim(),
    };
  }
}
