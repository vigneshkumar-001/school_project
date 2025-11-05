import 'dart:math';

import 'package:get/get.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:st_school_project/Presentation/Admssion/Model/status_response.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/communication_screen.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/required_photo_screens.dart';
import '../../../Core/Utility/snack_bar.dart';
import '../../../api/data_source/apiDataSource.dart';
import '../../../payment_web_view.dart';
import '../Model/admission1_nextbutton_response.dart' hide AdmissionData;
import '../Model/admission_1_response.dart';
import '../Model/class_section_response.dart';
import '../Model/student_drop_down_response.dart';
import '../Screens/admission_payment_success.dart';
import '../Screens/submit_the_admission.dart';

class AdmissionController extends GetxController {
  final ApiDataSource apiDataSource = ApiDataSource();
  RxBool isLoading = false.obs;

  RxList<AdmissionData> admissionList = <AdmissionData>[].obs;
  RxList<StatusData> statusData = <StatusData>[].obs;

  final religionCasteData = Rxn<ReligionCasteData>();
  final classSectionResponse = Rxn<ClassSectionResponse>();

  final isParentsSaving = false.obs;
  final studentId = 0;

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

  Future<String?> postAdmission1NextButton({required int id}) async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.postAdmission1NextButton(id: id);

      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;
          final data = response;
          AppLogger.log.i("Next button success for ID: $id");

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

  Future<String?> postStudentInfo({
    required int id,
    required String studentName,
    required String studentNameTamil,
    required String aadhaar,
    required String dob,
    required String religion,
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
        idProof1: idProof1,
        idProof2: idProof2,
      );

      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;
          // admissionList.value = response.data;

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

  // Future<String?> ParentsInfo({
  //   required int id,
  //   required String fatherName,
  //   required String fatherNameTamil,
  //   required String fatherQualification,
  //   required String fatherOccupation,
  //   required int fatherIncome,
  //   required String fatherOfficeAddress,
  //   required String motherName,
  //   required String motherNameTamil,
  //   required String motherQualification,
  //   required String motherOccupation,
  //   required int motherIncome,
  //   required String motherOfficeAddress,
  //   required bool hasGuardian,
  //   String? guardianName,
  //   String? guardianNameTamil,
  //   String? guardianQualification,
  //   String? guardianOccupation,
  //   int? guardianIncome,
  //   String? guardianOfficeAddress,
  // }) async {
  //   try {
  //     isLoading.value = true;
  //
  //     final results = await apiDataSource.ParentsInfo(
  //       id: id,
  //       fatherName: fatherName,
  //       fatherNameTamil: fatherNameTamil,
  //       fatherQualification: fatherQualification,
  //       fatherOccupation: fatherOccupation,
  //       fatherIncome: fatherIncome,
  //       fatherOfficeAddress: fatherOfficeAddress,
  //       motherName: motherName,
  //       motherNameTamil: motherNameTamil,
  //       motherQualification: motherQualification,
  //       motherOccupation: motherOccupation,
  //       motherIncome: motherIncome,
  //       motherOfficeAddress: motherOfficeAddress,
  //       hasGuardian: hasGuardian,
  //       guardianName: guardianName,
  //       guardianNameTamil: guardianNameTamil,
  //       guardianQualification: guardianQualification,
  //       guardianOccupation: guardianOccupation,
  //       guardianIncome: guardianIncome,
  //       guardianOfficeAddress: guardianOfficeAddress,
  //     );
  //
  //     results.fold(
  //       (failure) {
  //         isLoading.value = false;
  //         AppLogger.log.e(failure.message);
  //       },
  //       (response) async {
  //         isLoading.value = false;
  //         // admissionList.value = response.data;
  //         AppLogger.log.i("fetched: ${admissionList.length}");
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

  Future<String?> saveParentsInfo({
    required int id,
    required String fatherName,
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
          AppLogger.log.e("ParentsInfo failed: ${failure.message}");
          errorMessage = failure.message;
        },
        (response) async {
          if (response.status) {
            AppLogger.log.i(
              "Parents info saved successfully (code ${response.code})",
            );
          } else {
            errorMessage = "Server error: ${response.code}";
          }
        },
      );

      return errorMessage; // null means success
    } catch (e, st) {
      AppLogger.log.e("ParentsInfo exception: $e\n$st");
      return e.toString();
    } finally {
      isParentsSaving.value = false;
    }
  }

  Future<String?> sistersInfo({
    required int id,
    required String hasSisterInSchool,
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
          isLoading.value = false;
          AppLogger.log.e("SistersInfo failed: ${failure.message}");
          errorMessage = failure.message;
        },
        (response) async {
          AppLogger.log.i("SistersInfo Sucess: ${response.data}");
          isLoading.value = false;
          Get.to(CommunicationScreen(id: id));
        },
      );

      return errorMessage; // null means success
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
          religionCasteData.value = response.data; //  Correct
          AppLogger.log.i("Fetched dropdowns successfully");
        },
      );
    } catch (e) {
      AppLogger.log.e(e);
    }
  }

  Future<void> levelClassSection() async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.levelClassSection();

      results.fold(
        (failure) {
          isLoading.value = false;
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
          Get.to(RequiredPhotoScreens(id: id));
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
          Get.to(SubmitTheAdmission(id: id));
          CustomSnackBar.showError(failure.message);
          isLoading.value = false;
          AppLogger.log.e(failure.message);
          return '';
        },
        (response) async {
          isLoading.value = false;
          Get.to(SubmitTheAdmission(id: id));
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

          Get.to(PaymentWebView(url: response.data?.nextAction?.href.toString()?? ''));
          isLoading.value = false;
          // Get.to(AdmissionPaymentSuccess());


          AppLogger.log.i("Fetched class-section successfully");
          AppLogger.log.i("Parsed data: ${response.data?.nextAction?.href.toString()?? ''}");

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
}
