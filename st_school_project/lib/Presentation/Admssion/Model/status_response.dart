class  StatusResponse {
  final bool status;
  final int code;
  final String message;
  final List<StatusData> data;

  StatusResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory StatusResponse.fromJson(Map<String, dynamic> json) {
    return StatusResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => StatusData.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class StatusData {
  final int id;
  final String admissionCode;
  final String studentName;
  final String status;
  final String? submittedAt;
  final String createdAt;
  final String phone;
  final WindowData? window;
  final String downloadUrl;
  final String viewUrl;

  StatusData({
    required this.id,
    required this.admissionCode,
    required this.studentName,
    required this.status,
    required this.phone,
    this.submittedAt,
    required this.createdAt,
    this.window,
    required this.downloadUrl,
    required this.viewUrl,
  });

  factory StatusData.fromJson(Map<String, dynamic> json) {
    return StatusData(
      id: json['id'] ?? 0,
      admissionCode: json['admissionCode'] ?? '',
      studentName: json['studentName'] ?? '',
      status: json['status'] ?? '',
      submittedAt: json['submittedAt'],
      phone: json['phone']?? '',
      createdAt: json['createdAt'] ?? '',
      window: json['window'] != null ? WindowData.fromJson(json['window']) : null,
      downloadUrl: json['downloadUrl'] ?? '',
      viewUrl: json['viewUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'admissionCode': admissionCode,
    'studentName': studentName,
    'status': status,
    'submittedAt': submittedAt,
    'phone': phone,
    'createdAt': createdAt,
    'window': window?.toJson(),
    'downloadUrl': downloadUrl,
    'viewUrl': viewUrl,
  };
}

class WindowData {
  final int id;
  final String title;
  final String stream;
  final String academicYear;

  WindowData({
    required this.id,
    required this.title,
    required this.stream,
    required this.academicYear,
  });

  factory WindowData.fromJson(Map<String, dynamic> json) {
    return WindowData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      stream: json['stream'] ?? '',
      academicYear: json['academicYear'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'stream': stream,
    'academicYear': academicYear,
  };
}
