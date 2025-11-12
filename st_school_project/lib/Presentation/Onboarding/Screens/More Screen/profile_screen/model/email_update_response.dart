class EmailUpdateResponse {
  final bool status;
  final int code;
  final String message;
  final EmailData data;

  EmailUpdateResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory EmailUpdateResponse.fromJson(Map<String, dynamic> json) {
    return EmailUpdateResponse(
      status: json['status'] as bool,
      code: json['code'] as int,
      message: json['message'] as String,
      data: EmailData.fromJson(json['data'] as Map<String, dynamic>),
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

class EmailData {
  final int studentId;
  final String email;

  EmailData({
    required this.studentId,
    required this.email,
  });

  factory EmailData.fromJson(Map<String, dynamic> json) {
    return EmailData(
      studentId: json['studentId'] as int,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'email': email,
    };
  }
}
