class AppVersionResponse {
  final bool status;
  final int code;
  final String message;
  final AppVersionData data;

  AppVersionResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory AppVersionResponse.fromJson(Map<String, dynamic> json) {
    return AppVersionResponse(
      status: json['status'] as bool,
      code: json['code'] as int,
      message: json['message'] as String,
      data: AppVersionData.fromJson(json['data'] as Map<String, dynamic>),
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

class AppVersionData {
  final PlatformVersion android;
  final PlatformVersion ios;

  AppVersionData({
    required this.android,
    required this.ios,
  });

  factory AppVersionData.fromJson(Map<String, dynamic> json) {
    return AppVersionData(
      android: PlatformVersion.fromJson(json['android'] as Map<String, dynamic>),
      ios: PlatformVersion.fromJson(json['ios'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'android': android.toJson(),
      'ios': ios.toJson(),
    };
  }
}

class PlatformVersion {
  final String latestVersion;
  final String minVersion;
  final bool forceUpdate;
  final String? storeUrl;

  PlatformVersion({
    required this.latestVersion,
    required this.minVersion,
    required this.forceUpdate,
    this.storeUrl,
  });

  factory PlatformVersion.fromJson(Map<String, dynamic> json) {
    return PlatformVersion(
      latestVersion: json['latestVersion'] as String,
      minVersion: json['minVersion'] as String,
      forceUpdate: json['forceUpdate'] as bool,
      storeUrl: json['storeUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latestVersion': latestVersion,
      'minVersion': minVersion,
      'forceUpdate': forceUpdate,
      'storeUrl': storeUrl,
    };
  }
}
