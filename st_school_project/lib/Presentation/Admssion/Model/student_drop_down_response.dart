class StudentDropDownResponse {
  final bool status;
  final int code;
  final ReligionCasteData data;

  StudentDropDownResponse({
    required this.status,
    required this.code,
    required this.data,
  });

  factory StudentDropDownResponse.fromJson(Map<String, dynamic> json) =>
      StudentDropDownResponse(
        status: json["status"] ?? false,
        code: json["code"] ?? 0,
        data: ReligionCasteData.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "data": data.toJson(),
  };
}

class ReligionCasteData {
  final List<String> religion;
  final List<String> caste;
  final List<String> community;
  final List<String> motherTongue;
  final List<String> nationality;

  ReligionCasteData({
    required this.religion,
    required this.caste,
    required this.community,
    required this.motherTongue,
    required this.nationality,
  });

  factory ReligionCasteData.fromJson(Map<String, dynamic> json) =>
      ReligionCasteData(
        religion: List<String>.from(json["religion"] ?? []),
        caste: List<String>.from(json["caste"] ?? []),
        community: List<String>.from(json["community"] ?? []),
        motherTongue: List<String>.from(json["motherTongue"] ?? []),
        nationality: List<String>.from(json["nationality"] ?? []),
      );

  Map<String, dynamic> toJson() => {
    "religion": religion,
    "caste": caste,
    "community": community,
    "motherTongue": motherTongue,
    "nationality": nationality,
  };
}
