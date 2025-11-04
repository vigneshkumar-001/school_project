class LoginResponse {
  final bool status;
  final int code;
  final String message;
  final String token;
  final String role;

  LoginResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.token,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] as bool,
      code: json['code'] as int,
      message: json['message'] as String,
      token: json['token'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'token': token,
      'role': role,
    };
  }
}
