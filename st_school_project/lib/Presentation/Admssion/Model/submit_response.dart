class  SubmitResponse  {
  final bool status;
  final int code;
  final String message;
  final  SubmitAdmissionData? data;

  SubmitResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory SubmitResponse.fromJson(Map<String, dynamic> json) {
    return SubmitResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? SubmitAdmissionData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class SubmitAdmissionData {
  final int id;
  final String status;
  final DateTime? submittedAt;
  final NextAction? nextAction;

  SubmitAdmissionData({
    required this.id,
    required this.status,
    this.submittedAt,
    this.nextAction,
  });

  factory SubmitAdmissionData.fromJson(Map<String, dynamic> json) {
    return SubmitAdmissionData(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'])
          : null,
      nextAction: json['nextAction'] != null
          ? NextAction.fromJson(json['nextAction'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'submittedAt': submittedAt?.toIso8601String(),
      'nextAction': nextAction?.toJson(),
    };
  }
}

class NextAction {
  final String type;
  final String href;

  NextAction({
    required this.type,
    required this.href,
  });

  factory NextAction.fromJson(Map<String, dynamic> json) {
    return NextAction(
      type: json['type'] ?? '',
      href: json['href'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'href': href,
    };
  }
}
