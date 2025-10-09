/*
class AnnouncementResponse {
  final bool status;
  final int code;
  final String message;
  final AnnouncementData data;

  AnnouncementResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: AnnouncementData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data.toJson(),
  };
}

class AnnouncementData {
  final List<AnnouncementItem> items;
  final Meta meta;

  AnnouncementData({required this.items, required this.meta});

  factory AnnouncementData.fromJson(Map<String, dynamic> json) {
    return AnnouncementData(
      items:
          (json['items'] as List<dynamic>? ?? [])
              .map((e) => AnnouncementItem.fromJson(e))
              .toList(),
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'meta': meta.toJson(),
  };
}

class AnnouncementItem {
  final int id;
  final String title;
  final String category;
  final String announcementCategory;
  final DateTime notifyDate;
  final int classId;
  final String image;
  final String type;

  AnnouncementItem({
    required this.id,
    required this.title,
    required this.category,
    required this.announcementCategory,
    required this.notifyDate,
    required this.classId,
    required this.image,
    required this.type,
  });

  factory AnnouncementItem.fromJson(Map<String, dynamic> json) {
    return AnnouncementItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      announcementCategory: json['announcementCategory'] ?? '',
      notifyDate: DateTime.tryParse(json['notifyDate'] ?? '') ?? DateTime.now(),
      classId: json['classId'] ?? 0,
      image: json['image'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'announcementCategory': announcementCategory,
    'notifyDate': notifyDate.toIso8601String(),
    'classId': classId,
    'image': image,
    'type': type,
  };
}

class Meta {
  final int page;
  final int limit;
  final int total;
  final int pages;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'total': total,
    'pages': pages,
  };
}
*/

class AnnouncementResponse {
  final bool status;
  final int code;
  final String message;
  final AnnouncementData data;

  AnnouncementResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: AnnouncementData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data.toJson(),
  };
}

class AnnouncementData {
  final List<AnnouncementItem> items;
  final Meta meta;

  AnnouncementData({required this.items, required this.meta});

  factory AnnouncementData.fromJson(Map<String, dynamic> json) {
    return AnnouncementData(
      items:
          (json['items'] as List<dynamic>? ?? [])
              .map((e) => AnnouncementItem.fromJson(e))
              .toList(),
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'meta': meta.toJson(),
  };
}

class AnnouncementItem {
  final int id;
  final int? refId;
  final String title;
  final String category;
  final String announcementCategory;
  final DateTime notifyDate;
  final int? classId;
  final String image;
  final String type;
  final int? studentId;

  // Optional Fee Payment Fields
  final String? dueDate;
  final String? paymentType;
  final double? perStudentAmount;
  final double? paidAmount;
  final double? remainingAmount;
  final bool? canPayOnline;
  final bool? fullyPaid;

  AnnouncementItem({
    required this.id,
    this.refId,
    required this.title,
    required this.category,
    required this.announcementCategory,
    required this.notifyDate,
    this.classId,
    required this.image,
    required this.type,
    this.studentId,
    this.dueDate,
    this.paymentType,
    this.perStudentAmount,
    this.paidAmount,
    this.remainingAmount,
    this.canPayOnline,
    this.fullyPaid,
  });

  factory AnnouncementItem.fromJson(Map<String, dynamic> json) {
    return AnnouncementItem(
      id: json['id'] ?? 0,
      refId: json['refId'],
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      announcementCategory: json['announcementCategory'] ?? '',
      notifyDate: DateTime.tryParse(json['notifyDate'] ?? '') ?? DateTime.now(),
      classId: json['classId'],
      image: json['image'] ?? '',
      type: json['type'] ?? '',
      studentId: json['studentId'],

      // Optional fee-related fields
      dueDate: json['dueDate'],
      paymentType: json['paymentType'],
      perStudentAmount:
          (json['perStudentAmount'] != null)
              ? double.tryParse(json['perStudentAmount'].toString())
              : null,
      paidAmount:
          (json['paidAmount'] != null)
              ? double.tryParse(json['paidAmount'].toString())
              : null,
      remainingAmount:
          (json['remainingAmount'] != null)
              ? double.tryParse(json['remainingAmount'].toString())
              : null,
      canPayOnline: json['canPayOnline'],
      fullyPaid: json['fullyPaid'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'refId': refId,
    'title': title,
    'category': category,
    'announcementCategory': announcementCategory,
    'notifyDate': notifyDate.toIso8601String(),
    'classId': classId,
    'image': image,
    'type': type,
    'studentId': studentId,
    'dueDate': dueDate,
    'paymentType': paymentType,
    'perStudentAmount': perStudentAmount,
    'paidAmount': paidAmount,
    'remainingAmount': remainingAmount,
    'canPayOnline': canPayOnline,
    'fullyPaid': fullyPaid,
  };
}

class Meta {
  final int page;
  final int limit;
  final int total;
  final int pages;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'total': total,
    'pages': pages,
  };
}
