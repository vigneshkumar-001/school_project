class ClassSectionResponse {
  final bool status;
  final int code;
  final String message;
  final Map<String, List<String>> data;

  ClassSectionResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ClassSectionResponse.fromJson(Map<String, dynamic> json) {
    final parsedData = <String, List<String>>{};

    //  API returns a Map<String, dynamic>
    if (json['data'] is Map<String, dynamic>) {
      (json['data'] as Map<String, dynamic>).forEach((key, value) {
        parsedData[key] = List<String>.from(value.map((e) => e.toString()));
      });
    }

    return ClassSectionResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: parsedData,
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "data": data,
  };
}
