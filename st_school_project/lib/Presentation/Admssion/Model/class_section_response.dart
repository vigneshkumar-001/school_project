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

    final rawData = json['data'];

    if (rawData is Map<String, dynamic>) {
      final content = rawData['classSection'] ?? rawData;

      if (content is Map<String, dynamic>) {
        content.forEach((key, value) {
          if (value is List) {
            parsedData[key] = value.map((e) => e.toString()).toList();
          }
        });
      }
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
