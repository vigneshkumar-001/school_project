class ReconcileResponse {
  final bool status;
  final int code;
  final String message;
  final ReconcileData data;

  ReconcileResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ReconcileResponse.fromJson(Map<String, dynamic> json) {
    return ReconcileResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: ReconcileData.fromJson(json['data'] ?? {}),
    );
  }
}

class ReconcileData {
  final int reconciled;

  ReconcileData({required this.reconciled});

  factory ReconcileData.fromJson(Map<String, dynamic> json) {
    return ReconcileData(reconciled: json['reconciled'] ?? 0);
  }
}
