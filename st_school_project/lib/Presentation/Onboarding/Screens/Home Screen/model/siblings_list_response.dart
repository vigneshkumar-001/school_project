
class  SiblingsListResponse   {
  bool status;
  int code;
  String message;
  List<SiblingsData> data;

  SiblingsListResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory SiblingsListResponse.fromJson(Map<String, dynamic> json) {
    return SiblingsListResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<SiblingsData>.from(
          json['data'].map((x) => SiblingsData.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data.map((x) => x.toJson()).toList(),
  };
}

class SiblingsData {
  int id;
  String name;
  String studentClass;
  String section;
  String avatar;
  bool isActive;

  SiblingsData({
    required this.id,
    required this.name,
    required this.studentClass,
    required this.section,
    required this.avatar,
    required this.isActive,
  });

  factory SiblingsData.fromJson(Map<String, dynamic> json) {
    return SiblingsData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      studentClass: json['class'] ?? '',
      section: json['section'] ?? '',
      avatar: json['avatar'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'class': studentClass,
    'section': section,
    'avatar': avatar,
    'isActive': isActive,
  };
}
