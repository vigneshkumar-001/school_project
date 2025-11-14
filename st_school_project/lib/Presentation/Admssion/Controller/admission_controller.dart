import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:st_school_project/Presentation/Admssion/Model/get_admission.dart';
import 'package:st_school_project/Presentation/Admssion/Model/status_response.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/check_admission_status.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/communication_screen.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/required_photo_screens.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/siblings_form_screen.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/student_info_screen.dart';
import '../../../Core/Utility/snack_bar.dart';
import '../../../api/data_source/apiDataSource.dart';
import '../../../payment_web_view.dart';

import '../Model/admission_1_response.dart';
import '../Model/class_section_response.dart';
import '../Model/country_model.dart';
import '../Model/student_drop_down_response.dart';
import '../Screens/admission_1.dart';
import '../Screens/admission_payment_success.dart';
import '../Screens/parents_info_screen.dart';
import '../Screens/submit_the_admission.dart';

class AdmissionController extends GetxController {
  final ApiDataSource apiDataSource = ApiDataSource();
  RxBool isLoading = false.obs;
  RxBool isCountriesLoading = false.obs;
  final RxBool isBottomSheetLoading = false.obs;
  RxBool isStateLoading = false.obs;
  var docsChecklist = <DocsChecklist>[].obs;

  final RxList<Country> countries = <Country>[].obs;
  final RxList<StateModel> states = <StateModel>[].obs;
  final RxList<City> city = <City>[].obs;
  final currentAdmission = Rxn<GetAdmissionData>();

  RxList<AdmissionData> admissionList = <AdmissionData>[].obs;
  RxList<StatusData> statusData = <StatusData>[].obs;

  final religionCasteData = Rxn<ReligionCasteData>();
  final classSectionResponse = Rxn<ClassSectionResponse>();

  final isParentsSaving = false.obs;
  final studentId = 0;

  final TextEditingController nameEnglishController = TextEditingController();
  final TextEditingController nameTamilController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController casteController = TextEditingController();
  final TextEditingController communityController = TextEditingController();
  final TextEditingController tongueController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController personalId1Controller = TextEditingController();
  final TextEditingController personalId2Controller = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();

  final TextEditingController englishController = TextEditingController();
  final TextEditingController tamilController = TextEditingController();
  final TextEditingController fatherOccupation = TextEditingController();
  final TextEditingController fatherQualification = TextEditingController();
  final TextEditingController fatherAnnualIncome = TextEditingController();
  final TextEditingController officeAddress = TextEditingController();

  // Mo TextEditingController her
  final TextEditingController motherQualification = TextEditingController();
  final TextEditingController motherNameTamilController =
      TextEditingController();
  final TextEditingController motherNameEnglishController =
      TextEditingController();
  final TextEditingController motherOccupation = TextEditingController();
  final TextEditingController motherOfficeAddressController =
      TextEditingController();
  final TextEditingController motherAnnualIncome = TextEditingController();

  // Gu  rdian
  final TextEditingController guardianEnglish = TextEditingController();
  final TextEditingController guardianTamil = TextEditingController();
  final TextEditingController guardianQualification = TextEditingController();
  final TextEditingController guardianOccupation = TextEditingController();
  final TextEditingController guardianAnnualIncome = TextEditingController();
  final TextEditingController guardianOfficeAddress = TextEditingController();

  final TextEditingController primaryMobileController = TextEditingController();
  final TextEditingController secondaryMobileController =
      TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<void> fetchCountries() async {
    try {
      isBottomSheetLoading.value = true;
      final results = await apiDataSource.getCountries();
      results.fold(
        (failure) => AppLogger.log.e(failure.message),
        (res) => countries.assignAll(res.data ?? []),
      );
    } catch (e) {
      AppLogger.log.e(e);
    } finally {
      isBottomSheetLoading.value = false;
    }
  }

  Future<void> fetchStates({required String country}) async {
    try {
      isBottomSheetLoading.value = true;
      final results = await apiDataSource.getStates(country: country);
      results.fold(
        (failure) => AppLogger.log.e(failure.message),
        (res) => states.assignAll(res.data ?? []),
      );
    } catch (e) {
      AppLogger.log.e(e);
    } finally {
      isBottomSheetLoading.value = false;
    }
  }

  Future<void> fetchCities({
    required String state,
    required String country,
  }) async {
    try {
      isBottomSheetLoading.value = true;
      final results = await apiDataSource.getCities(
        state: state,
        country: country,
      );
      results.fold(
        (failure) => AppLogger.log.e(failure.message),
        (res) => city.assignAll(res.data ?? []),
      );
    } catch (e) {
      AppLogger.log.e(e);
    } finally {
      isBottomSheetLoading.value = false;
    }
  }

  Future<String?> getAdmissions() async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.getAdmission();

      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;
          admissionList.value = response.data;
          AppLogger.log.i("Fetched admission data successfully");

          // Convert JSON to model
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  // Future<String?> postAdmission1NextButton({required int id}) async {
  //   try {
  //     isLoading.value = true;
  //     final prefs = await SharedPreferences.getInstance();
  //     final results = await apiDataSource.postAdmission1NextButton(id: id);
  //
  //     results.fold(
  //       (failure) {
  //         isLoading.value = false;
  //         AppLogger.log.e(failure.message);
  //       },
  //       (response) async {
  //         final data = response.data.id;
  //         AppLogger.log.i("Next button success for ID: $id");
  //         AppLogger.log.i(data);
  //         await prefs.setInt('admissionId', response.data?.id ?? 0);
  //         final admissionID = prefs.getInt('admissionId') ?? '';
  //         AppLogger.log.i(" Showing SharedPrefs Admission Id = $admissionID");
  //         await getAdmissionDetails(id: response.data.id ?? 0);
  //         isLoading.value = false;
  //         Get.to(StudentInfoScreen(admissionId: id, pages: 'homeScreen'));
  //
  //         // Convert JSON to model
  //       },
  //     );
  //   } catch (e) {
  //     isLoading.value = false;
  //     AppLogger.log.e(e);
  //     return e.toString();
  //   }
  //   return null;
  // }

  Future<String?> postAdmission1NextButton({
    required int id,
    String? sourcePage, // 👈 from Admission1.pages
  }) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final results = await apiDataSource.postAdmission1NextButton(id: id);

      await results.fold(
        (failure) async {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          final int newId = response.data?.id ?? id;

          AppLogger.log.i("Next button success for ID: $newId");

          await prefs.setInt('admissionId', newId);
          await getAdmissionDetails(id: newId);

          isLoading.value = false;

          Get.to(
            () => StudentInfoScreen(
              admissionId: newId,
              pages: sourcePage, // 👈 VERY IMPORTANT
            ),
          );
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e.toString());
    }

    return null;
  }

  Future<String?> postStudentInfo({
    required int id,
    required String studentName,
    required String studentNameTamil,
    required String emailId,
    required String aadhaar,
    required String dob,
    required String religion,
    required String page,
    required String caste,
    required String community,
    required String motherTongue,
    required String nationality,
    required String idProof1,
    required String idProof2,
  }) async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.StudentInfo(
        id: id,
        studentName: studentName,
        studentNameTamil: studentNameTamil,
        aadhaar: aadhaar,
        dob: dob,
        religion: religion,
        caste: caste,
        community: community,
        motherTongue: motherTongue,
        nationality: nationality,
        emailId: emailId,
        idProof1: idProof1,
        idProof2: idProof2,
      );

      results.fold(
        (failure) {
          CustomSnackBar.showError(failure.message);
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;
          Get.to(ParentsInfoScreen(id: response.data?.id ?? 0, pages: page));

          AppLogger.log.i(response.data?.id);

          // Convert JSON to model
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<String?> saveParentsInfo({
    required int id,
    required String fatherName,
    required String pages,
    required String fatherNameTamil,
    required String fatherQualification,
    required String fatherOccupation,
    required int fatherIncome,
    required String fatherOfficeAddress,
    required String motherName,
    required String motherNameTamil,
    required String motherQualification,
    required String motherOccupation,
    required int motherIncome,
    required String motherOfficeAddress,
    required bool hasGuardian,
    String? guardianName,
    String? guardianNameTamil,
    String? guardianQualification,
    String? guardianOccupation,
    int? guardianIncome,
    String? guardianOfficeAddress,
  }) async {
    try {
      isParentsSaving.value = true;

      final results = await apiDataSource.ParentsInfo(
        id: id,
        fatherName: fatherName,
        fatherNameTamil: fatherNameTamil,
        fatherQualification: fatherQualification,
        fatherOccupation: fatherOccupation,
        fatherIncome: fatherIncome,
        fatherOfficeAddress: fatherOfficeAddress,
        motherName: motherName,
        motherNameTamil: motherNameTamil,
        motherQualification: motherQualification,
        motherOccupation: motherOccupation,
        motherIncome: motherIncome,
        motherOfficeAddress: motherOfficeAddress,
        hasGuardian: hasGuardian,
        guardianName: guardianName,
        guardianNameTamil: guardianNameTamil,
        guardianQualification: guardianQualification,
        guardianOccupation: guardianOccupation,
        guardianIncome: guardianIncome,
        guardianOfficeAddress: guardianOfficeAddress,
      );

      String? errorMessage;

      await results.fold(
        (failure) {
          isParentsSaving.value = false;
          AppLogger.log.e("ParentsInfo failed: ${failure.message}");
          errorMessage = failure.message;
          CustomSnackBar.showError(failure.message);
        },
        (response) async {
          isParentsSaving.value = false;
          Get.to(SiblingsFormScreen(id: id, page: pages));
        },
      );

      return errorMessage; // null means success
    } catch (e, st) {
      isParentsSaving.value = false;
      AppLogger.log.e("ParentsInfo exception: $e\n$st");
      return e.toString();
    } finally {
      isParentsSaving.value = false;
    }
  }

  Future<String?> sistersInfo({
    required int id,
    required String hasSisterInSchool,
    required String pages,
    required List<Map<String, String>> siblings,
  }) async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.sistersInfo(
        hasSisterInSchool: hasSisterInSchool,
        id: id,
        siblings: siblings,
      );

      String? errorMessage;

      await results.fold(
        (failure) {
          CustomSnackBar.showError(failure.message);
          isLoading.value = false;
          AppLogger.log.e("SistersInfo failed: ${failure.message}");
          errorMessage = failure.message;
        },
        (response) async {
          await getAdmissionDetails(id: id);
          AppLogger.log.i("SistersInfo Sucess: ${response.data}");
          isLoading.value = false;

          Get.to(CommunicationScreen(id: id, page: pages));
        },
      );

      return errorMessage;
    } catch (e, st) {
      isLoading.value = false;
      AppLogger.log.e("SistersInfo exception: $e\n$st");
      return e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> studentDropDown() async {
    try {
      final results = await apiDataSource.studentDropDown();

      results.fold(
        (failure) {
          AppLogger.log.e(failure.message);
        },
        (response) async {
          religionCasteData.value = response.data;
          AppLogger.log.i("Fetched dropdowns successfully");
        },
      );
    } catch (e) {
      AppLogger.log.e(e);
    }
  }

  Future<void> levelClassSection() async {
    try {
      // isLoading.value = true;

      final results = await apiDataSource.levelClassSection();

      results.fold(
        (failure) {
          //    isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;
          classSectionResponse.value = response;
          AppLogger.log.i("Fetched class-section successfully");
          AppLogger.log.i("Parsed data: ${response.data}");
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
    }
  }

  Future<String?> communicationDetails({
    required int id,
    required String mobilePrimary,
    required String mobileSecondary,
    required String country,
    required String pages,
    required String state,
    required String city,
    required String pinCode,
    required String address,
  }) async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.communicationDetails(
        id: id,
        mobilePrimary: mobilePrimary,
        mobileSecondary: mobileSecondary,
        country: country,
        state: state,
        city: city,
        pinCode: pinCode,
        address: address,
      );

      results.fold(
        (failure) {
          isLoading.value = false;
          CustomSnackBar.showError(failure.message);
          AppLogger.log.e(failure.message);
          return '';
        },
        (response) async {
          isLoading.value = false;

          AppLogger.log.i("Fetched class-section successfully");
          AppLogger.log.i("Parsed data: ${response.data}");
          Get.to(RequiredPhotoScreens(id: id, pages: pages));
          return '';
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return '';
    }
    return null;
  }

  Future<String?> requiredPhotos({
    required int id,
    required String pages,
    required List<bool> isChecked,
  }) async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.requiredPhotos(
        isChecked: isChecked,
        id: id,
      );

      results.fold(
        (failure) {
          CustomSnackBar.showError(failure.message);
          isLoading.value = false;
          AppLogger.log.e(failure.message);
          return '';
        },
        (response) async {
          isLoading.value = false;
          Get.to(SubmitTheAdmission(id: id, pages: pages));
          AppLogger.log.i("Fetched class-section successfully");
          AppLogger.log.i("Parsed data: ${response.data}");

          return '';
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return '';
    }
    return null;
  }

  Future<String?> submitAdmission({
    required int id,
    required bool isChecked,
    required String page,
  }) async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.submit(isChecked: isChecked, id: id);

      results.fold(
        (failure) {
          CustomSnackBar.showError(failure.message);
          isLoading.value = false;
          AppLogger.log.e(failure.message);
          return '';
        },
        (response) async {
          isLoading.value = false;
          // Get.to(PaymentWebView(url: response.data?.nextAction?.href.toString()?? ''));
          // isLoading.value = false;
          // // Get.to(AdmissionPaymentSuccess());
          //
          //
          // AppLogger.log.i("Fetched class-section successfully");
          // AppLogger.log.i("Parsed data: ${response.data?.nextAction?.href.toString()?? ''}");
          final paymentResult = await Get.to<Map<String, dynamic>>(
            () => PaymentWebView(url: response.data?.nextAction?.href ?? ''),
          );

          if (paymentResult != null && paymentResult["status"] == "success") {
            isLoading.value = false;
            // Navigate to your custom success page
            Get.to(
              AdmissionPaymentSuccess(
                pages: page,
                admissionCode: response.data?.admissionCode ?? '',
              ),
            );
          } else {
            isLoading.value = false;
            // Handle failure/cancel
            CustomSnackBar.showError("Payment failed or cancelled!");
          }

          AppLogger.log.i(
            "Payment result: ${paymentResult?.toString() ?? 'No result'}",
          );

          return '';
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return '';
    }
    return null;
  }

  Future<void> getCcavenue({required int id}) async {
    try {
      isLoading.value = true;

      final result = await apiDataSource.getCcavenue(id: id);

      result.fold(
        (failure) {
          CustomSnackBar.showError(failure.message);
          isLoading.value = false;
          AppLogger.log.e("CCAvenue Error: ${failure.message}");
        },
        (htmlContent) async {
          isLoading.value = false;
          AppLogger.log.i("CCAvenue HTML Received");

          Get.to(PaymentWebView(url: htmlContent));
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e("Controller Exception: $e");
    }
  }

  Future<void> geStatusCheck({required int admissionId}) async {
    try {
      isLoading.value = true;

      final result = await apiDataSource.statusCheck(admissionId: admissionId);

      result.fold(
        (failure) {
          isLoading.value = false;
          CustomSnackBar.showError(failure.message);
          AppLogger.log.e("  Error: ${failure.message}");
        },
        (response) async {
          isLoading.value = false;
          statusData.value = response.data;
          AppLogger.log.i(response.toJson());
          AppLogger.log.i(statusData);
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e("Controller Exception: $e");
    }
  }

  Future<void> getAdmissionDetails({required int id}) async {
    try {
      final results = await apiDataSource.getAdmissionDetails(id: id);
      final prefs = await SharedPreferences.getInstance();
      results.fold(
        (failure) {
          AppLogger.log.e(failure.message);
        },
        (response) async {
          AppLogger.log.i("Fetched admission data successfully");
          final admissionID = prefs.getInt('admissionId');
          final currentStep = response.data?.step ?? 1;
          currentAdmission.value = response.data;

          navigateToStep(currentStep, admissionId: admissionID ?? 0);
          response.data;
          AppLogger.log.i("Fetched dropdowns successfully");
        },
      );
    } catch (e) {
      AppLogger.log.e(e);
    }
  }

  void navigateToStep(int step, {required int admissionId}) {
    final screen = admissionScreens(admissionId)[step];
    if (screen != null) {
      Get.offAll(() => screen);
    } else {
      AppLogger.log.e('No screen found for step: $step');
    }
  }

  Map<int, Widget> admissionScreens(int admissionId) => {
    1: StudentInfoScreen(admissionId: admissionId),
    2: ParentsInfoScreen(id: admissionId, pages: ''),
    3: SiblingsFormScreen(id: admissionId, page: ''),
    4: CommunicationScreen(id: admissionId, page: ''),
    5: RequiredPhotoScreens(id: admissionId, pages: ''),
    6: SubmitTheAdmission(id: admissionId, pages: ''),
    7: CheckAdmissionStatus(showBackArrow: false), // or false, as intended
  };

  Future<void> fetchAndSetUserData() async {
    final profile = Get.find<AdmissionController>().currentAdmission.value;

    if (profile != null) {
      docsChecklist.value = profile.docsChecklist ?? [];
      nameEnglishController.text =
          nameEnglishController.text.isEmpty
              ? profile.studentName ?? ''
              : nameEnglishController.text;

      nameTamilController.text =
          nameTamilController.text.isEmpty
              ? profile.studentNameTamil ?? ''
              : nameTamilController.text;

      dobController.text =
          dobController.text.isEmpty ? profile.dob ?? '' : dobController.text;

      aadharController.text =
          aadharController.text.isEmpty
              ? profile.aadhaar ?? ''
              : aadharController.text;

      religionController.text =
          religionController.text.isEmpty
              ? profile.religion ?? ''
              : religionController.text;

      casteController.text =
          casteController.text.isEmpty
              ? profile.caste ?? ''
              : casteController.text;

      communityController.text =
          communityController.text.isEmpty
              ? profile.community ?? ''
              : communityController.text;

      tongueController.text =
          tongueController.text.isEmpty
              ? profile.motherTongue ?? ''
              : tongueController.text;

      nationalityController.text =
          nationalityController.text.isEmpty
              ? profile.nationality ?? ''
              : nationalityController.text;

      personalId1Controller.text =
          personalId1Controller.text.isEmpty
              ? profile.idProof1 ?? ''
              : personalId1Controller.text;

      personalId2Controller.text =
          personalId2Controller.text.isEmpty
              ? profile.idProof2 ?? ''
              : personalId2Controller.text;

      emailIdController.text =
          emailIdController.text.isEmpty
              ? profile.email ?? ''
              : emailIdController.text;
      // Parents Info //
      englishController.text =
          englishController.text.isEmpty
              ? profile.fatherName ?? ''
              : englishController.text;

      tamilController.text =
          tamilController.text.isEmpty
              ? profile.fatherNameTamil ?? ''
              : tamilController.text;

      fatherOccupation.text =
          fatherOccupation.text.isEmpty
              ? profile.fatherOccupation ?? ''
              : fatherOccupation.text;

      fatherQualification.text =
          fatherQualification.text.isEmpty
              ? profile.fatherQualification ?? ''
              : fatherQualification.text;

      fatherAnnualIncome.text =
          fatherAnnualIncome.text.isEmpty
              ? (profile.fatherIncome?.toString() ?? '')
              : fatherAnnualIncome.text;

      officeAddress.text =
          officeAddress.text.isEmpty
              ? profile.fatherOfficeAddress ?? ''
              : officeAddress.text;

      motherQualification.text =
          motherQualification.text.isEmpty
              ? profile.motherOfficeAddress ?? ''
              : motherQualification.text;

      motherNameTamilController.text =
          motherNameTamilController.text.isEmpty
              ? profile.motherNameTamil ?? ''
              : motherNameTamilController.text;

      motherNameEnglishController.text =
          motherNameEnglishController.text.isEmpty
              ? profile.motherName ?? ''
              : motherNameEnglishController.text;

      motherOccupation.text =
          motherOccupation.text.isEmpty
              ? profile.motherOccupation ?? ''
              : motherOccupation.text;

      motherOfficeAddressController.text =
          motherOfficeAddressController.text.isEmpty
              ? profile.motherOfficeAddress ?? ''
              : motherOfficeAddressController.text;

      motherAnnualIncome.text =
          motherAnnualIncome.text.isEmpty
              ? (profile.motherIncome?.toString() ?? '')
              : motherAnnualIncome.text;

      guardianEnglish.text =
          guardianEnglish.text.isEmpty
              ? profile.guardianName ?? ''
              : guardianEnglish.text;

      guardianTamil.text =
          guardianTamil.text.isEmpty
              ? profile.guardianNameTamil ?? ''
              : guardianTamil.text;

      guardianQualification.text =
          guardianQualification.text.isEmpty
              ? profile.guardianQualification ?? ''
              : guardianQualification.text;

      guardianOccupation.text =
          guardianOccupation.text.isEmpty
              ? profile.guardianOccupation ?? ''
              : guardianOccupation.text;

      guardianAnnualIncome.text =
          guardianAnnualIncome.text.isEmpty
              ? (profile.guardianIncome?.toString() ?? '')
              : guardianAnnualIncome.text;

      guardianOfficeAddress.text =
          guardianOfficeAddress.text.isEmpty
              ? profile.guardianOfficeAddress ?? ''
              : guardianOfficeAddress.text;

      primaryMobileController.text =
          primaryMobileController.text.isEmpty
              ? profile.mobilePrimary ?? ''
              : primaryMobileController.text;

      secondaryMobileController.text =
          secondaryMobileController.text.isEmpty
              ? profile.mobileSecondary ?? ''
              : secondaryMobileController.text;

      countryController.text =
          countryController.text.isEmpty
              ? profile.country ?? ''
              : countryController.text;

      stateController.text =
          stateController.text.isEmpty
              ? profile.state ?? ''
              : stateController.text;

      cityController.text =
          cityController.text.isEmpty
              ? profile.city ?? ''
              : cityController.text;

      pincodeController.text =
          pincodeController.text.isEmpty
              ? profile.pinCode ?? ''
              : pincodeController.text;

      addressController.text =
          addressController.text.isEmpty
              ? profile.address ?? ''
              : addressController.text;
    }

    update();
  }
}
