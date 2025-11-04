import 'package:get/get.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/communication_screen.dart';
import '../../../api/data_source/apiDataSource.dart';
import '../Model/admission1_nextbutton_response.dart' hide AdmissionData;
import '../Model/admission_1_response.dart';
import '../Model/class_section_response.dart';
import '../Model/student_drop_down_response.dart';

class AdmissionController extends GetxController {
  final ApiDataSource apiDataSource = ApiDataSource();
  RxBool isLoading = false.obs;
  RxList<AdmissionData> admissionList = <AdmissionData>[].obs;
  final religionCasteData = Rxn<ReligionCasteData>();
  final classSectionResponse = Rxn<ClassSectionResponse>();

  final isParentsSaving = false.obs;
  final studentId = 0; // set dynamically somewhere else

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
          AppLogger.log.i("fetched: ${admissionList.length}");

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
          AppLogger.log.i("fetched: ${admissionList.length}");

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
          isLoading.value = false;
          Get.to(CommunicationScreen());
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
      isLoading.value = true;

      final results = await apiDataSource.studentDropDown();

      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;
          religionCasteData.value = response.data; // ✅ Correct
          AppLogger.log.i("Fetched dropdowns successfully");
        },
      );
    } catch (e) {
      isLoading.value = false;
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
}
