class CountryResponse {
  final bool status;
  final int code;
  final String message;
  final List<Country> data;

  CountryResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    return CountryResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Country.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Country {
  final String name;
  final String isoCode;
  final String phonecode;

  Country({
    required this.name,
    required this.isoCode,
    required this.phonecode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] ?? '',
      isoCode: json['isoCode'] ?? '',
      phonecode: json['phonecode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isoCode': isoCode,
      'phonecode': phonecode,
    };
  }
}

class StatesResponse {
  final bool? status;
  final int? code;
  final String? message;
  final List<StateModel>? data;

  StatesResponse({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory StatesResponse.fromJson(Map<String, dynamic> json) {
    return StatesResponse(
      status: json['status'] as bool?,
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => StateModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}
class StateModel {
  final String? name;
  final String? isoCode;

  StateModel({
    this.name,
    this.isoCode,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      name: json['name'] as String?,
      isoCode: json['isoCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isoCode': isoCode,
    };
  }
}



class CityResponse {
  final bool status;
  final int code;
  final String message;
  final List<City> data;

  CityResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    return CityResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => City.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class City {
  final String name;

  City({required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(name: json['name'] ?? '');
  }
}

