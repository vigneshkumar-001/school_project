import 'dart:convert';

class Admission1Response {
  final bool status;
  final int code;
  final List<AdmissionData> data;

  Admission1Response({
    required this.status,
    required this.code,
    required this.data,
  });

  factory Admission1Response.fromJson(Map<String, dynamic> json) =>
      Admission1Response(
        status: json["status"] ?? false,
        code: json["code"] ?? 0,
        data:
            json["data"] == null
                ? []
                : List<AdmissionData>.from(
                  json["data"].map((x) => AdmissionData.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AdmissionData {
  final int id;
  final String title;
  final String stream;
  final String academicYear;
  final String startDate;
  final String endDate;
  final String announcementDate;
  final String introText;
  final List<String> instructions;
  final String bannerUrl;
  final bool isPublished;
  final bool isOpen;
  final int feeMasterId;
  final String feeTypeName;
  final String feeAmount;
  final int ccProfileId;
  final String createdAt;
  final String updatedAt;

  AdmissionData({
    required this.id,
    required this.title,
    required this.stream,
    required this.academicYear,
    required this.startDate,
    required this.endDate,
    required this.announcementDate,
    required this.introText,
    required this.instructions,
    required this.bannerUrl,
    required this.isPublished,
    required this.isOpen,
    required this.feeMasterId,
    required this.feeTypeName,
    required this.feeAmount,
    required this.ccProfileId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdmissionData.fromJson(Map<String, dynamic> json) => AdmissionData(
    id: json["id"] ?? 0,
    title: json["title"] ?? "",
    stream: json["stream"] ?? "",
    academicYear: json["academicYear"] ?? "",
    startDate: json["startDate"] ?? "",
    endDate: json["endDate"] ?? "",
    announcementDate: json["announcementDate"] ?? "",
    introText: json["introText"] ?? "",
    instructions:
        json["instructions"] == null
            ? []
            : List<String>.from(json["instructions"].map((x) => x)),
    bannerUrl: json["bannerUrl"] ?? "",
    isPublished: json["isPublished"] ?? false,
    isOpen: json["isOpen"] ?? false,
    feeMasterId: json["feeMasterId"] ?? 0,
    feeTypeName: json["feeTypeName"] ?? "",
    feeAmount: json["feeAmount"] ?? "",
    ccProfileId: json["ccProfileId"] ?? 0,
    createdAt: json["createdAt"] ?? "",
    updatedAt: json["updatedAt"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "stream": stream,
    "academicYear": academicYear,
    "startDate": startDate,
    "endDate": endDate,
    "announcementDate": announcementDate,
    "introText": introText,
    "instructions": List<dynamic>.from(instructions.map((x) => x)),
    "bannerUrl": bannerUrl,
    "isPublished": isPublished,
    "isOpen": isOpen,
    "feeMasterId": feeMasterId,
    "feeTypeName": feeTypeName,
    "feeAmount": feeAmount,
    "ccProfileId": ccProfileId,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
