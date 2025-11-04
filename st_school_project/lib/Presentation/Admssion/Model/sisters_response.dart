import 'dart:convert';

class SistersResponse {
  final bool status;
  final int code;
  final AdmissionData data;

  SistersResponse({
    required this.status,
    required this.code,
    required this.data,
  });

  factory SistersResponse.fromJson(Map<String, dynamic> json) =>
      SistersResponse(
        status: json["status"] ?? false,
        code: json["code"] ?? 0,
        data: AdmissionData.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "data": data.toJson(),
  };
}

class AdmissionData {
  final int? id;
  final int? windowId;
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
  final int? fatherIncome;
  final String? fatherOfficeAddress;
  final String? motherName;
  final String? motherNameTamil;
  final String? motherQualification;
  final String? motherOccupation;
  final int? motherIncome;
  final String? motherOfficeAddress;
  final bool hasGuardian;
  final String? guardianName;
  final String? guardianNameTamil;
  final String? guardianQualification;
  final String? guardianOccupation;
  final String? guardianOfficeAddress;
  final int? guardianIncome;
  final bool hasSisterInSchool;
  final String? sisterDetails;
  final String? mobilePrimary;
  final String? mobileSecondary;
  final String? country;
  final String? state;
  final String? city;
  final String? pinCode;
  final String? address;
  final String? docsChecklist;
  final bool consentAccepted;
  final String? status;
  final String? admissionCode;
  final String? submittedAt;
  final String? createdAt;
  final String? updatedAt;

  AdmissionData({
    this.id,
    this.windowId,
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
    required this.hasGuardian,
    this.guardianName,
    this.guardianNameTamil,
    this.guardianQualification,
    this.guardianOccupation,
    this.guardianOfficeAddress,
    this.guardianIncome,
    required this.hasSisterInSchool,
    this.sisterDetails,
    this.mobilePrimary,
    this.mobileSecondary,
    this.country,
    this.state,
    this.city,
    this.pinCode,
    this.address,
    this.docsChecklist,
    required this.consentAccepted,
    this.status,
    this.admissionCode,
    this.submittedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory AdmissionData.fromJson(Map<String, dynamic> json) => AdmissionData(
    id: json["id"],
    windowId: json["windowId"],
    studentId: json["studentId"],
    studentName: json["studentName"],
    studentNameTamil: json["studentNameTamil"],
    aadhaar: json["aadhaar"],
    dob: json["dob"],
    religion: json["religion"],
    caste: json["caste"],
    community: json["community"],
    motherTongue: json["motherTongue"],
    nationality: json["nationality"],
    idProof1: json["idProof1"],
    idProof2: json["idProof2"],
    email: json["email"],
    fatherName: json["fatherName"],
    fatherNameTamil: json["fatherNameTamil"],
    fatherQualification: json["fatherQualification"],
    fatherOccupation: json["fatherOccupation"],
    fatherIncome: json["fatherIncome"],
    fatherOfficeAddress: json["fatherOfficeAddress"],
    motherName: json["motherName"],
    motherNameTamil: json["motherNameTamil"],
    motherQualification: json["motherQualification"],
    motherOccupation: json["motherOccupation"],
    motherIncome: json["motherIncome"],
    motherOfficeAddress: json["motherOfficeAddress"],
    hasGuardian: json["hasGuardian"] ?? false,
    guardianName: json["guardianName"],
    guardianNameTamil: json["guardianNameTamil"],
    guardianQualification: json["guardianQualification"],
    guardianOccupation: json["guardianOccupation"],
    guardianOfficeAddress: json["guardianOfficeAddress"],
    guardianIncome: json["guardianIncome"],
    hasSisterInSchool: json["hasSisterInSchool"] ?? false,
    sisterDetails: json["sisterDetails"],
    mobilePrimary: json["mobilePrimary"],
    mobileSecondary: json["mobileSecondary"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    pinCode: json["pinCode"],
    address: json["address"],
    docsChecklist: json["docsChecklist"],
    consentAccepted: json["consentAccepted"] ?? false,
    status: json["status"],
    admissionCode: json["admissionCode"],
    submittedAt: json["submittedAt"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "windowId": windowId,
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
    "docsChecklist": docsChecklist,
    "consentAccepted": consentAccepted,
    "status": status,
    "admissionCode": admissionCode,
    "submittedAt": submittedAt,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}

// Helper functions for quick conversion
SistersResponse admissionResponseFromJson(String str) =>
    SistersResponse.fromJson(json.decode(str));

String admissionResponseToJson(SistersResponse data) =>
    json.encode(data.toJson());
