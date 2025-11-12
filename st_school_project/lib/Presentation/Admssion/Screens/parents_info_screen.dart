import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Utility/thanglish_to_tamil.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/siblings_form_screen.dart';
import 'package:http/http.dart' as http;
import 'package:st_school_project/Presentation/Admssion/Screens/student_info_screen.dart';

import '../Controller/admission_controller.dart';

class ParentsInfoScreen extends StatefulWidget {
  final int id;
  final String pages;
  const ParentsInfoScreen({super.key, required this.id, required this.pages});

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
    return ctrl.officeAddress.text.trim().isEmpty &&
        ctrl.motherOfficeAddressController.text.trim().isEmpty;
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
        ctrl.englishController.text.trim().isNotEmpty &&
        ctrl.tamilController.text.trim().isNotEmpty &&
        ctrl.fatherOccupation.text.trim().isNotEmpty &&
        ctrl.fatherQualification.text.trim().isNotEmpty &&
        ctrl.fatherAnnualIncome.text.trim().isNotEmpty &&
        ctrl.motherNameEnglishController.text.trim().isNotEmpty &&
        ctrl.motherNameTamilController.text.trim().isNotEmpty &&
        ctrl.motherQualification.text.trim().isNotEmpty &&
        ctrl.motherOccupation.text.trim().isNotEmpty &&
        ctrl.motherAnnualIncome.text.trim().isNotEmpty;

    final officeOk = !isBothOfficeAddressEmpty; // at least one office address

    return formOk && basicOk && officeOk;
  }

  bool _validateGuardian() {
    final formOk = _formKeyGuardian.currentState?.validate() ?? false;

    final basicOk =
        ctrl.guardianEnglish.text.trim().isNotEmpty &&
        ctrl.guardianTamil.text.trim().isNotEmpty &&
        ctrl.guardianQualification.text.trim().isNotEmpty &&
        ctrl.guardianOccupation.text.trim().isNotEmpty &&
        ctrl.guardianAnnualIncome.text.trim().isNotEmpty &&
        ctrl.guardianOfficeAddress.text.trim().isNotEmpty;

    return formOk && basicOk;
  }

  // void _validateAndContinue() {
  //   HapticFeedback.heavyImpact();
  //   setState(() => isSubmitted = true);
  //
  //   if (selected == 'Father & Mother') {
  //     final ok = _validateFatherMother();
  //     if (!ok && isBothOfficeAddressEmpty) {
  //       // show unobtrusive snackbar to explain the special rule
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text(
  //             'Enter at least one Office Address (Father or Mother).',
  //           ),
  //           behavior: SnackBarBehavior.floating,
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //     }
  //     if (ok) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (_) => SiblingsFormScreen(id: widget.id)),
  //       );
  //     }
  //   } else {
  //     if (_validateGuardian()) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (_) => SiblingsFormScreen(id: widget.id)),
  //       );
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.fetchAndSetUserData();
    });
  }

  // ---------- BUILD ----------
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await false;
      },
      child: Scaffold(
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
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final admissionId = prefs.getInt('admissionId') ?? 0;

                          Get.off(StudentInfoScreen(admissionId: admissionId));
                        },
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
                  CustomTextField.textWith600(
                    text: 'Parent Info',
                    fontSize: 26,
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      GestureDetector(
                        onTap:
                            () => setState(() => selected = 'Father & Mother'),
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
                                ctrl.englishController.text.trim().isEmpty,
                            errorText:
                                isSubmitted &&
                                        ctrl.englishController.text
                                            .trim()
                                            .isEmpty
                                    ? 'Name is required'
                                    : null,
                            text: 'English',
                            isTamil: false,
                            controller: ctrl.englishController,
                          ),
                          SizedBox(height: 20),

                          _tamilField(
                            label: 'Father Name (Tamil)',
                            controller: ctrl.tamilController,
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
                            controller: ctrl.fatherQualification,
                            options: qualificationOptions,
                            isRequired: true,
                          ),
                          SizedBox(height: 20),

                          _dropOrTypeField(
                            label: 'Father Occupation',
                            controller: ctrl.fatherOccupation,
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
                                ctrl.fatherAnnualIncome.text.trim().isEmpty,
                            errorText:
                                isSubmitted &&
                                        ctrl.fatherAnnualIncome.text
                                            .trim()
                                            .isEmpty
                                    ? 'Father Annual Income is required'
                                    : null,
                            controller: ctrl.fatherAnnualIncome,
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
                            controller: ctrl.officeAddress,
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
                                ctrl.motherNameEnglishController.text
                                    .trim()
                                    .isEmpty,
                            errorText:
                                isSubmitted &&
                                        ctrl.motherNameEnglishController.text
                                            .trim()
                                            .isEmpty
                                    ? 'Mother Name is required'
                                    : null,
                            text: 'English',
                            isTamil: false,
                            controller: ctrl.motherNameEnglishController,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 10),

                          _tamilField(
                            label: 'Mother Name (Tamil)',
                            controller: ctrl.motherNameTamilController,
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
                            controller: ctrl.motherQualification,
                            options: qualificationOptions,
                            isRequired: true,
                          ),
                          const SizedBox(height: 20),

                          _dropOrTypeField(
                            label: 'Mother Occupation',
                            controller: ctrl.motherOccupation,
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
                                ctrl.motherAnnualIncome.text.trim().isEmpty,
                            errorText:
                                isSubmitted &&
                                        ctrl.motherAnnualIncome.text
                                            .trim()
                                            .isEmpty
                                    ? 'Mother Annual Income is required'
                                    : null,
                            controller: ctrl.motherAnnualIncome,
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
                            controller: ctrl.motherOfficeAddressController,
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
                                ctrl.guardianEnglish.text.trim().isEmpty,
                            errorText:
                                isSubmitted &&
                                        ctrl.guardianEnglish.text.trim().isEmpty
                                    ? 'Guardian Name is required'
                                    : null,
                            text: 'English',
                            isTamil: false,
                            controller: ctrl.guardianEnglish,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 20),

                          _tamilField(
                            label: 'Guardian Name (Tamil)',
                            controller: ctrl.guardianTamil,
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
                            controller: ctrl.guardianQualification,
                            options: qualificationOptions,
                            isRequired: true,
                          ),
                          const SizedBox(height: 20),

                          _dropOrTypeField(
                            label: 'Guardian Occupation',
                            controller: ctrl.guardianOccupation,
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
                                ctrl.guardianAnnualIncome.text.trim().isEmpty,
                            errorText:
                                isSubmitted &&
                                        ctrl.guardianAnnualIncome.text
                                            .trim()
                                            .isEmpty
                                    ? 'Guardian Annual Income is required'
                                    : null,
                            controller: ctrl.guardianAnnualIncome,
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
                                ctrl.guardianOfficeAddress.text.trim().isEmpty,
                            errorText:
                                isSubmitted &&
                                        ctrl.guardianOfficeAddress.text
                                            .trim()
                                            .isEmpty
                                    ? 'Guardian Office Address is required'
                                    : null,
                            controller: ctrl.guardianOfficeAddress,
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

                  Obx(
                    () => AppButton.button(
                      loader:
                          ctrl.isParentsSaving.value
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
                          ctrl.isParentsSaving.value
                              ? null
                              : AppImages.rightSaitArrow,
                      text: 'Save & Continue',
                      onTap:
                          ctrl.isParentsSaving.value
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
                                    pages: widget.pages,
                                    id: widget.id,
                                    fatherName:
                                        ctrl.englishController.text.trim(),
                                    fatherNameTamil:
                                        ctrl.tamilController.text.trim(),
                                    fatherQualification:
                                        ctrl.fatherQualification.text.trim(),
                                    fatherOccupation:
                                        ctrl.fatherOccupation.text.trim(),
                                    fatherIncome:
                                        int.tryParse(
                                          ctrl.fatherAnnualIncome.text.trim(),
                                        ) ??
                                        0,
                                    fatherOfficeAddress:
                                        ctrl.officeAddress.text.trim(),
                                    motherName:
                                        ctrl.motherNameEnglishController.text
                                            .trim(),
                                    motherNameTamil:
                                        ctrl.motherNameTamilController.text
                                            .trim(),
                                    motherQualification:
                                        ctrl.motherQualification.text.trim(),
                                    motherOccupation:
                                        ctrl.motherOccupation.text.trim(),
                                    motherIncome:
                                        int.tryParse(
                                          ctrl.motherAnnualIncome.text.trim(),
                                        ) ??
                                        0,
                                    motherOfficeAddress:
                                        ctrl.motherOfficeAddressController.text
                                            .trim(),
                                    hasGuardian: false,
                                  );

                                  if (err != null) {
                                    _showSnack(
                                      'Failed to save: $err',
                                      isError: true,
                                    );
                                    return;
                                  }


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
                                    pages: widget.pages,

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
                                    guardianName:
                                        ctrl.guardianEnglish.text.trim(),
                                    guardianNameTamil:
                                        ctrl.guardianTamil.text.trim(),
                                    guardianQualification:
                                        ctrl.guardianQualification.text.trim(),
                                    guardianOccupation:
                                        ctrl.guardianOccupation.text.trim(),
                                    guardianIncome:
                                        int.tryParse(
                                          ctrl.guardianAnnualIncome.text.trim(),
                                        ) ??
                                        0,
                                    guardianOfficeAddress:
                                        ctrl.guardianOfficeAddress.text.trim(),
                                  );
                                }
                              },
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
