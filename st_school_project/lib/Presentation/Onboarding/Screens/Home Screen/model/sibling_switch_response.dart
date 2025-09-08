class  SiblingsSwitchResponse  {
  final bool status;
  final int code;
  final String message;
  final SwitchProfileData data;

  SiblingsSwitchResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory SiblingsSwitchResponse.fromJson(Map<String, dynamic> json) {
    return SiblingsSwitchResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: SwitchProfileData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class SwitchProfileData {
  final String token;
  final int studentId;

  SwitchProfileData({
    required this.token,
    required this.studentId,
  });

  factory SwitchProfileData.fromJson(Map<String, dynamic> json) {
    return SwitchProfileData(
      token: json['token'] ?? '',
      studentId: json['studentId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'studentId': studentId,
    };
  }
}
