import 'dart:convert';

class ParentsInfoResponse {
  final bool status;
  final int code;
  final AdmissionStudentData data;

  ParentsInfoResponse({
    required this.status,
    required this.code,
    required this.data,
  });

  factory ParentsInfoResponse.fromJson(Map<String, dynamic> json) =>
      ParentsInfoResponse(
        status: json["status"] ?? false,
        code: _parseInt(json["code"]) ?? 0,
        data: AdmissionStudentData.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "data": data.toJson(),
  };
}

/// Utility parser — safely converts dynamic to int
int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString());
}

/// Utility parser — safely converts dynamic to double
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString());
}

class AdmissionStudentData {
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
  final double? fatherIncome;
  final String? fatherOfficeAddress;
  final String? motherName;
  final String? motherNameTamil;
  final String? motherQualification;
  final String? motherOccupation;
  final double? motherIncome;
  final String? motherOfficeAddress;
  final bool? hasGuardian;
  final String? guardianName;
  final String? guardianNameTamil;
  final String? guardianQualification;
  final String? guardianOccupation;
  final String? guardianOfficeAddress;
  final double? guardianIncome;
  final bool? hasSisterInSchool;
  final List<SisterDetail>? sisterDetails;
  final String? mobilePrimary;
  final String? mobileSecondary;
  final String? country;
  final String? state;
  final String? city;
  final String? pinCode;
  final String? address;
  final String? docsChecklist;
  final bool? consentAccepted;
  final String? status;
  final String? admissionCode;
  final String? submittedAt;
  final String? createdAt;
  final String? updatedAt;

  AdmissionStudentData({
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

  factory AdmissionStudentData.fromJson(Map<String, dynamic> json) =>
      AdmissionStudentData(
        id: _parseInt(json["id"]),
        windowId: _parseInt(json["windowId"]),
        studentId: _parseInt(json["studentId"]),
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
        fatherIncome: _parseDouble(json["fatherIncome"]),
        fatherOfficeAddress: json["fatherOfficeAddress"],
        motherName: json["motherName"],
        motherNameTamil: json["motherNameTamil"],
        motherQualification: json["motherQualification"],
        motherOccupation: json["motherOccupation"],
        motherIncome: _parseDouble(json["motherIncome"]),
        motherOfficeAddress: json["motherOfficeAddress"],
        hasGuardian: json["hasGuardian"],
        guardianName: json["guardianName"],
        guardianNameTamil: json["guardianNameTamil"],
        guardianQualification: json["guardianQualification"],
        guardianOccupation: json["guardianOccupation"],
        guardianOfficeAddress: json["guardianOfficeAddress"],
        guardianIncome: _parseDouble(json["guardianIncome"]),
        hasSisterInSchool: json["hasSisterInSchool"],
        sisterDetails:
            json["sisterDetails"] == null
                ? null
                : List<SisterDetail>.from(
                  (json["sisterDetails"] as List).map(
                    (x) => SisterDetail.fromJson(x),
                  ),
                ),
        mobilePrimary: json["mobilePrimary"],
        mobileSecondary: json["mobileSecondary"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        pinCode: json["pinCode"],
        address: json["address"],
        docsChecklist: json["docsChecklist"],
        consentAccepted: json["consentAccepted"],
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
    "sisterDetails": sisterDetails?.map((x) => x.toJson()).toList(),
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

/// Model for sister details
class SisterDetail {
  final String? name;
  final String? admNo;
  final String? classes;
  final String? section;

  SisterDetail({this.name, this.admNo, this.classes, this.section});

  factory SisterDetail.fromJson(Map<String, dynamic> json) => SisterDetail(
    name: json["name"],
    admNo: json["admNo"],
    classes: json["class"],
    section: json["section"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "admNo": admNo,
    "class": classes,
    "section": section,
  };
}
