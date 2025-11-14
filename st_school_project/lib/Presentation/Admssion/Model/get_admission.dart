
import 'dart:convert';

class GetAdmissionResponse {
  final bool status;
  final int code;
  final GetAdmissionData? data;

  GetAdmissionResponse({
    required this.status,
    required this.code,
    required this.data,
  });

  factory GetAdmissionResponse.fromJson(Map<String, dynamic> json) =>
      GetAdmissionResponse(
        status: json["status"] ?? false,
        code: json["code"] ?? 0,
        data:
        json["data"] != null ? GetAdmissionData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "data": data?.toJson(),
  };
}

class GetAdmissionData {
  final int? id;
  final int? windowId;
  final int step;
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

  final bool hasGuardian;
  final String? guardianName;
  final String? guardianNameTamil;
  final String? guardianQualification;
  final String? guardianOccupation;
  final String? guardianOfficeAddress;
  final String? guardianIncome;

  final bool hasSisterInSchool;
  final String? sisterDetails;

  final String? mobilePrimary;
  final String? mobileSecondary;
  final String? country;
  final String? state;
  final String? city;
  final String? pinCode;
  final String? address;

  final List<DocsChecklist>? docsChecklist;
  final bool consentAccepted;
  final String? status;
  final String? admissionCode;
  final String? submittedAt;
  final String? createdAt;
  final String? updatedAt;

  GetAdmissionData({
    this.id,
    this.windowId,
    required this.step,
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

  ///  Safe parser for weird backend values
  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List && value.isNotEmpty) return value.first.toString();
    return value.toString();
  }

  factory GetAdmissionData.fromJson(Map<String, dynamic> json) {
    return GetAdmissionData(
      id: json["id"],
      windowId: json["windowId"],
      studentId: json["studentId"],
      step: json["step"] ?? 1,
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

      hasGuardian: json["hasGuardian"] == true ||
          json["hasGuardian"] == 1 ||
          json["hasGuardian"] == "true",
      guardianName: _parseString(json["guardianName"]),
      guardianNameTamil: _parseString(json["guardianNameTamil"]),
      guardianQualification: _parseString(json["guardianQualification"]),
      guardianOccupation: _parseString(json["guardianOccupation"]),
      guardianOfficeAddress: _parseString(json["guardianOfficeAddress"]),
      guardianIncome: _parseString(json["guardianIncome"]),

      hasSisterInSchool: json["hasSisterInSchool"] == true ||
          json["hasSisterInSchool"] == 1 ||
          json["hasSisterInSchool"] == "true",
      sisterDetails: _parseString(json["sisterDetails"]),

      mobilePrimary: _parseString(json["mobilePrimary"]),
      mobileSecondary: _parseString(json["mobileSecondary"]),
      country: _parseString(json["country"]),
      state: _parseString(json["state"]),
      city: _parseString(json["city"]),
      pinCode: _parseString(json["pinCode"]),
      address: _parseString(json["address"]),

      docsChecklist: (json["docsChecklist"] as List?)
          ?.map((e) => DocsChecklist.fromJson(e))
          .toList(),

      consentAccepted: json["consentAccepted"] == true ||
          json["consentAccepted"] == 1 ||
          json["consentAccepted"] == "true",
      status: _parseString(json["status"]),
      admissionCode: _parseString(json["admissionCode"]),
      submittedAt: _parseString(json["submittedAt"]),
      createdAt: _parseString(json["createdAt"]),
      updatedAt: _parseString(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "windowId": windowId,
    "studentId": studentId,
    "step": step,
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

  DocsChecklist({this.key, this.title, this.provided});

  factory DocsChecklist.fromJson(Map<String, dynamic> json) => DocsChecklist(
    key: GetAdmissionData._parseString(json["key"]),
    title: GetAdmissionData._parseString(json["title"]),
    provided: json["provided"] == true ||
        json["provided"] == 1 ||
        json["provided"] == "true",
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "title": title,
    "provided": provided,
  };
}
