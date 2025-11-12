// import 'dart:convert';
//
// class StudentInfoResponse {
//   final bool status;
//   final int code;
//   final AdmissionData? data;
//
//   StudentInfoResponse({required this.status, required this.code, this.data});
//
//   factory StudentInfoResponse.fromJson(Map<String, dynamic> json) =>
//       StudentInfoResponse(
//         status: json["status"] ?? false,
//         code: json["code"] ?? 0,
//         data:
//             json["data"] != null ? AdmissionData.fromJson(json["data"]) : null,
//       );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "code": code,
//     "data": data?.toJson(),
//   };
// }
//
// class AdmissionData {
//   final int? id;
//   final int? windowId;
//   final int? step;
//   final int? studentId;
//   final String? studentName;
//   final String? studentNameTamil;
//   final String? aadhaar;
//   final String? dob;
//   final String? religion;
//   final String? caste;
//   final String? community;
//   final String? motherTongue;
//   final String? nationality;
//   final String? idProof1;
//   final String? idProof2;
//   final String? email;
//   final String? fatherName;
//   final String? fatherNameTamil;
//   final String? fatherQualification;
//   final String? fatherOccupation;
//   final String? fatherIncome;
//   final String? fatherOfficeAddress;
//   final String? motherName;
//   final String? motherNameTamil;
//   final String? motherQualification;
//   final String? motherOccupation;
//   final String? motherIncome;
//   final String? motherOfficeAddress;
//   final bool? hasGuardian;
//   final String? guardianName;
//   final String? guardianNameTamil;
//   final String? guardianQualification;
//   final String? guardianOccupation;
//   final String? guardianOfficeAddress;
//   final String? guardianIncome;
//   final bool? hasSisterInSchool;
//   final String? sisterDetails;
//   final String? mobilePrimary;
//   final String? mobileSecondary;
//   final String? country;
//   final String? state;
//   final String? city;
//   final String? pinCode;
//   final String? address;
//   final List<DocsChecklist>? docsChecklist;
//   final bool? consentAccepted;
//   final String? status;
//   final String? admissionCode;
//   final String? submittedAt;
//   final String? createdAt;
//   final String? updatedAt;
//
//   AdmissionData({
//     this.id,
//     this.windowId,
//     this.step,
//     this.studentId,
//     this.studentName,
//     this.studentNameTamil,
//     this.aadhaar,
//     this.dob,
//     this.religion,
//     this.caste,
//     this.community,
//     this.motherTongue,
//     this.nationality,
//     this.idProof1,
//     this.idProof2,
//     this.email,
//     this.fatherName,
//     this.fatherNameTamil,
//     this.fatherQualification,
//     this.fatherOccupation,
//     this.fatherIncome,
//     this.fatherOfficeAddress,
//     this.motherName,
//     this.motherNameTamil,
//     this.motherQualification,
//     this.motherOccupation,
//     this.motherIncome,
//     this.motherOfficeAddress,
//     this.hasGuardian,
//     this.guardianName,
//     this.guardianNameTamil,
//     this.guardianQualification,
//     this.guardianOccupation,
//     this.guardianOfficeAddress,
//     this.guardianIncome,
//     this.hasSisterInSchool,
//     this.sisterDetails,
//     this.mobilePrimary,
//     this.mobileSecondary,
//     this.country,
//     this.state,
//     this.city,
//     this.pinCode,
//     this.address,
//     this.docsChecklist,
//     this.consentAccepted,
//     this.status,
//     this.admissionCode,
//     this.submittedAt,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory AdmissionData.fromJson(Map<String, dynamic> json) => AdmissionData(
//     id: json["id"],
//     windowId: json["windowId"],
//     studentId: json["studentId"],
//     studentName: json["studentName"],
//     step: json["step"],
//     studentNameTamil: json["studentNameTamil"],
//     aadhaar: json["aadhaar"],
//     dob: json["dob"],
//     religion: json["religion"],
//     caste: json["caste"],
//     community: json["community"],
//     motherTongue: json["motherTongue"],
//     nationality: json["nationality"],
//     idProof1: json["idProof1"],
//     idProof2: json["idProof2"],
//     email: json["email"],
//     fatherName: json["fatherName"],
//     fatherNameTamil: json["fatherNameTamil"],
//     fatherQualification: json["fatherQualification"],
//     fatherOccupation: json["fatherOccupation"],
//     fatherIncome: json["fatherIncome"],
//     fatherOfficeAddress: json["fatherOfficeAddress"],
//     motherName: json["motherName"],
//     motherNameTamil: json["motherNameTamil"],
//     motherQualification: json["motherQualification"],
//     motherOccupation: json["motherOccupation"],
//     motherIncome: json["motherIncome"],
//     motherOfficeAddress: json["motherOfficeAddress"],
//     hasGuardian: json["hasGuardian"],
//     guardianName: json["guardianName"],
//     guardianNameTamil: json["guardianNameTamil"],
//     guardianQualification: json["guardianQualification"],
//     guardianOccupation: json["guardianOccupation"],
//     guardianOfficeAddress: json["guardianOfficeAddress"],
//     guardianIncome: json["guardianIncome"],
//     hasSisterInSchool: json["hasSisterInSchool"],
//     sisterDetails: json["sisterDetails"],
//     mobilePrimary: json["mobilePrimary"],
//     mobileSecondary: json["mobileSecondary"],
//     country: json["country"],
//     state: json["state"],
//     city: json["city"],
//     pinCode: json["pinCode"],
//     address: json["address"],
//     docsChecklist: (json["docsChecklist"] as List?)
//         ?.map((e) => DocsChecklist.fromJson(e))
//         .toList(),
//     consentAccepted: json["consentAccepted"],
//     status: json["status"],
//     admissionCode: json["admissionCode"],
//     submittedAt: json["submittedAt"],
//     createdAt: json["createdAt"],
//     updatedAt: json["updatedAt"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "windowId": windowId,
//     "studentId": studentId,
//     "step": step,
//     "studentName": studentName,
//     "studentNameTamil": studentNameTamil,
//     "aadhaar": aadhaar,
//     "dob": dob,
//     "religion": religion,
//     "caste": caste,
//     "community": community,
//     "motherTongue": motherTongue,
//     "nationality": nationality,
//     "idProof1": idProof1,
//     "idProof2": idProof2,
//     "email": email,
//     "fatherName": fatherName,
//     "fatherNameTamil": fatherNameTamil,
//     "fatherQualification": fatherQualification,
//     "fatherOccupation": fatherOccupation,
//     "fatherIncome": fatherIncome,
//     "fatherOfficeAddress": fatherOfficeAddress,
//     "motherName": motherName,
//     "motherNameTamil": motherNameTamil,
//     "motherQualification": motherQualification,
//     "motherOccupation": motherOccupation,
//     "motherIncome": motherIncome,
//     "motherOfficeAddress": motherOfficeAddress,
//     "hasGuardian": hasGuardian,
//     "guardianName": guardianName,
//     "guardianNameTamil": guardianNameTamil,
//     "guardianQualification": guardianQualification,
//     "guardianOccupation": guardianOccupation,
//     "guardianOfficeAddress": guardianOfficeAddress,
//     "guardianIncome": guardianIncome,
//     "hasSisterInSchool": hasSisterInSchool,
//     "sisterDetails": sisterDetails,
//     "mobilePrimary": mobilePrimary,
//     "mobileSecondary": mobileSecondary,
//     "country": country,
//     "state": state,
//     "city": city,
//     "pinCode": pinCode,
//     "address": address,
//     "docsChecklist": docsChecklist,
//     "consentAccepted": consentAccepted,
//     "status": status,
//     "admissionCode": admissionCode,
//     "submittedAt": submittedAt,
//     "createdAt": createdAt,
//     "updatedAt": updatedAt,
//   };
// }
// class DocsChecklist {
//   final String? key;
//   final String? title;
//   final bool? provided;
//
//   DocsChecklist({
//     this.key,
//     this.title,
//     this.provided,
//   });
//
//   factory DocsChecklist.fromJson(Map<String, dynamic> json) => DocsChecklist(
//     key: json["key"],
//     title: json["title"],
//     provided: json["provided"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "key": key,
//     "title": title,
//     "provided": provided,
//   };
// }


///new//
import 'dart:convert';

class StudentInfoResponse {
  final bool status;
  final int code;
  final AdmissionData? data;

  StudentInfoResponse({
    required this.status,
    required this.code,
    this.data,
  });

  factory StudentInfoResponse.fromJson(Map<String, dynamic> json) =>
      StudentInfoResponse(
        status: json["status"] ?? false,
        code: json["code"] ?? 0,
        data: json["data"] != null ? AdmissionData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "data": data?.toJson(),
  };
}

class AdmissionData {
  final int? id;
  final int? windowId;
  final int? step;
  final int? studentId;
  final String? studentName;
  final String? studentNameTamil;
  final String? aadhaar;
  final String? dob;
  final String? religion;
  final String? caste;
  final String? community;
  final String? motherTongue;
  final String? nationality;
  final String? idProof1;
  final String? idProof2;
  final String? email;
  final String? fatherName;
  final String? fatherNameTamil;
  final String? fatherQualification;
  final String? fatherOccupation;
  final String? fatherIncome;
  final String? fatherOfficeAddress;
  final String? motherName;
  final String? motherNameTamil;
  final String? motherQualification;
  final String? motherOccupation;
  final String? motherIncome;
  final String? motherOfficeAddress;
  final bool? hasGuardian;
  final String? guardianName;
  final String? guardianNameTamil;
  final String? guardianQualification;
  final String? guardianOccupation;
  final String? guardianOfficeAddress;
  final String? guardianIncome;
  final bool? hasSisterInSchool;
  final String? sisterDetails;
  final String? mobilePrimary;
  final String? mobileSecondary;
  final String? country;
  final String? state;
  final String? city;
  final String? pinCode;
  final String? address;
  final List<DocsChecklist>? docsChecklist;
  final bool? consentAccepted;
  final String? status;
  final String? admissionCode;
  final String? submittedAt;
  final String? createdAt;
  final String? updatedAt;

  AdmissionData({
    this.id,
    this.windowId,
    this.step,
    this.studentId,
    this.studentName,
    this.studentNameTamil,
    this.aadhaar,
    this.dob,
    this.religion,
    this.caste,
    this.community,
    this.motherTongue,
    this.nationality,
    this.idProof1,
    this.idProof2,
    this.email,
    this.fatherName,
    this.fatherNameTamil,
    this.fatherQualification,
    this.fatherOccupation,
    this.fatherIncome,
    this.fatherOfficeAddress,
    this.motherName,
    this.motherNameTamil,
    this.motherQualification,
    this.motherOccupation,
    this.motherIncome,
    this.motherOfficeAddress,
    this.hasGuardian,
    this.guardianName,
    this.guardianNameTamil,
    this.guardianQualification,
    this.guardianOccupation,
    this.guardianOfficeAddress,
    this.guardianIncome,
    this.hasSisterInSchool,
    this.sisterDetails,
    this.mobilePrimary,
    this.mobileSecondary,
    this.country,
    this.state,
    this.city,
    this.pinCode,
    this.address,
    this.docsChecklist,
    this.consentAccepted,
    this.status,
    this.admissionCode,
    this.submittedAt,
    this.createdAt,
    this.updatedAt,
  });

  /// --- Safe string parser for inconsistent API fields ---
  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List && value.isNotEmpty) return value.first.toString();
    return value.toString();
  }

  /// --- Safe list parser ---
  static List<DocsChecklist>? _parseChecklist(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((e) {
        if (e is Map<String, dynamic>) {
          return DocsChecklist.fromJson(e);
        }
        return DocsChecklist(key: e.toString());
      }).toList();
    }
    return null;
  }

  factory AdmissionData.fromJson(Map<String, dynamic> json) => AdmissionData(
    id: json["id"],
    windowId: json["windowId"],
    step: json["step"],
    studentId: json["studentId"],
    studentName: _parseString(json["studentName"]),
    studentNameTamil: _parseString(json["studentNameTamil"]),
    aadhaar: _parseString(json["aadhaar"]),
    dob: _parseString(json["dob"]),
    religion: _parseString(json["religion"]),
    caste: _parseString(json["caste"]),
    community: _parseString(json["community"]),
    motherTongue: _parseString(json["motherTongue"]),
    nationality: _parseString(json["nationality"]),
    idProof1: _parseString(json["idProof1"]),
    idProof2: _parseString(json["idProof2"]),
    email: _parseString(json["email"]),
    fatherName: _parseString(json["fatherName"]),
    fatherNameTamil: _parseString(json["fatherNameTamil"]),
    fatherQualification: _parseString(json["fatherQualification"]),
    fatherOccupation: _parseString(json["fatherOccupation"]),
    fatherIncome: _parseString(json["fatherIncome"]),
    fatherOfficeAddress: _parseString(json["fatherOfficeAddress"]),
    motherName: _parseString(json["motherName"]),
    motherNameTamil: _parseString(json["motherNameTamil"]),
    motherQualification: _parseString(json["motherQualification"]),
    motherOccupation: _parseString(json["motherOccupation"]),
    motherIncome: _parseString(json["motherIncome"]),
    motherOfficeAddress: _parseString(json["motherOfficeAddress"]),
    hasGuardian: json["hasGuardian"] is bool
        ? json["hasGuardian"]
        : json["hasGuardian"].toString() == "true",
    guardianName: _parseString(json["guardianName"]),
    guardianNameTamil: _parseString(json["guardianNameTamil"]),
    guardianQualification: _parseString(json["guardianQualification"]),
    guardianOccupation: _parseString(json["guardianOccupation"]),
    guardianOfficeAddress: _parseString(json["guardianOfficeAddress"]),
    guardianIncome: _parseString(json["guardianIncome"]),
    hasSisterInSchool: json["hasSisterInSchool"] is bool
        ? json["hasSisterInSchool"]
        : json["hasSisterInSchool"].toString() == "true",
    sisterDetails: _parseString(json["sisterDetails"]),
    mobilePrimary: _parseString(json["mobilePrimary"]),
    mobileSecondary: _parseString(json["mobileSecondary"]),
    country: _parseString(json["country"]),
    state: _parseString(json["state"]),
    city: _parseString(json["city"]),
    pinCode: _parseString(json["pinCode"]),
    address: _parseString(json["address"]),
    docsChecklist: _parseChecklist(json["docsChecklist"]),
    consentAccepted: json["consentAccepted"] is bool
        ? json["consentAccepted"]
        : json["consentAccepted"].toString() == "true",
    status: _parseString(json["status"]),
    admissionCode: _parseString(json["admissionCode"]),
    submittedAt: _parseString(json["submittedAt"]),
    createdAt: _parseString(json["createdAt"]),
    updatedAt: _parseString(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "windowId": windowId,
    "step": step,
    "studentId": studentId,
    "studentName": studentName,
    "studentNameTamil": studentNameTamil,
    "aadhaar": aadhaar,
    "dob": dob,
    "religion": religion,
    "caste": caste,
    "community": community,
    "motherTongue": motherTongue,
    "nationality": nationality,
    "idProof1": idProof1,
    "idProof2": idProof2,
    "email": email,
    "fatherName": fatherName,
    "fatherNameTamil": fatherNameTamil,
    "fatherQualification": fatherQualification,
    "fatherOccupation": fatherOccupation,
    "fatherIncome": fatherIncome,
    "fatherOfficeAddress": fatherOfficeAddress,
    "motherName": motherName,
    "motherNameTamil": motherNameTamil,
    "motherQualification": motherQualification,
    "motherOccupation": motherOccupation,
    "motherIncome": motherIncome,
    "motherOfficeAddress": motherOfficeAddress,
    "hasGuardian": hasGuardian,
    "guardianName": guardianName,
    "guardianNameTamil": guardianNameTamil,
    "guardianQualification": guardianQualification,
    "guardianOccupation": guardianOccupation,
    "guardianOfficeAddress": guardianOfficeAddress,
    "guardianIncome": guardianIncome,
    "hasSisterInSchool": hasSisterInSchool,
    "sisterDetails": sisterDetails,
    "mobilePrimary": mobilePrimary,
    "mobileSecondary": mobileSecondary,
    "country": country,
    "state": state,
    "city": city,
    "pinCode": pinCode,
    "address": address,
    "docsChecklist": docsChecklist?.map((e) => e.toJson()).toList(),
    "consentAccepted": consentAccepted,
    "status": status,
    "admissionCode": admissionCode,
    "submittedAt": submittedAt,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}

class DocsChecklist {
  final String? key;
  final String? title;
  final bool? provided;

  DocsChecklist({
    this.key,
    this.title,
    this.provided,
  });

  factory DocsChecklist.fromJson(Map<String, dynamic> json) => DocsChecklist(
    key: json["key"]?.toString(),
    title: json["title"]?.toString(),
    provided: json["provided"] is bool
        ? json["provided"]
        : json["provided"].toString() == "true",
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "title": title,
    "provided": provided,
  };
}
