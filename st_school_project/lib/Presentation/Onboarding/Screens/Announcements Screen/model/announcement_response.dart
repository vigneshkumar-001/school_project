
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
*/



// ---------- helpers ----------
int _asInt(dynamic v, {int fallback = 0}) {
  if (v == null) return fallback;
  if (v is int) return v;
  if (v is double) return v.toInt();
  return int.tryParse(v.toString()) ?? fallback;
}

double? _asDoubleOrNull(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

List<int> _asIntList(dynamic v) {
  if (v == null) return <int>[];
  if (v is List) {
    return v.map((e) => _asInt(e)).toList();
  }
  return <int>[];
}

Map<String, List<int>> _asMapOfIntLists(dynamic v) {
  final Map<String, List<int>> out = {};
  if (v is Map) {
    v.forEach((key, value) {
      out[key.toString()] = _asIntList(value);
    });
  }
  return out;
}

// ---------- root ----------
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
      code: _asInt(json['code']),
      message: json['message']?.toString() ?? '',
      data: AnnouncementData.fromJson(json['data'] ?? const {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data.toJson(),
  };
}

// ---------- data wrapper ----------
class AnnouncementData {
  final List<AnnouncementItem> items;

  /// New: section/type → list of ids
  final Map<String, List<int>> sections;

  /// New: groupKey → list of ids
  final Map<String, List<int>> groups;

  final Meta meta;

  AnnouncementData({
    required this.items,
    required this.sections,
    required this.groups,
    required this.meta,
  });

  factory AnnouncementData.fromJson(Map<String, dynamic> json) {
    return AnnouncementData(
      items: (json['items'] as List<dynamic>? ?? const [])
          .map((e) => AnnouncementItem.fromJson(e))
          .toList(),
      sections: _asMapOfIntLists(json['sections']),
      groups: _asMapOfIntLists(json['groups']),
      meta: Meta.fromJson(json['meta'] ?? const {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'sections': sections.map((k, v) => MapEntry(k, v)),
    'groups': groups.map((k, v) => MapEntry(k, v)),
    'meta': meta.toJson(),
  };
}

// ---------- item ----------
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

  // Optional Fee Payment Fields (kept for backward-compat)
  final String? dueDate;
  final String? paymentType;
  final double? perStudentAmount;
  final double? paidAmount;
  final double? remainingAmount;
  final bool? canPayOnline;
  final bool? fullyPaid;

  // New: per-item section/group helpers
  final List<int> sectionIds;
  final int? sectionIndex;
  final String? groupKey;
  final List<int> groupIds;
  final int? groupIndex;

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
    this.sectionIds = const [],
    this.sectionIndex,
    this.groupKey,
    this.groupIds = const [],
    this.groupIndex,
  });

  factory AnnouncementItem.fromJson(Map<String, dynamic> json) {
    // notifyDate can be missing/invalid: fall back to now
    DateTime parsedDate;
    final nd = json['notifyDate'];
    if (nd is String) {
      parsedDate = DateTime.tryParse(nd) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return AnnouncementItem(
      id: _asInt(json['id']),
      refId: (json['refId'] != null) ? _asInt(json['refId']) : null,
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      announcementCategory: json['announcementCategory']?.toString() ?? '',
      notifyDate: parsedDate,
      classId: (json['classId'] != null) ? _asInt(json['classId']) : null,
      image: json['image']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      studentId: (json['studentId'] != null) ? _asInt(json['studentId']) : null,

      // Optional fee fields
      dueDate: json['dueDate']?.toString(),
      paymentType: json['paymentType']?.toString(),
      perStudentAmount: _asDoubleOrNull(json['perStudentAmount']),
      paidAmount: _asDoubleOrNull(json['paidAmount']),
      remainingAmount: _asDoubleOrNull(json['remainingAmount']),
      canPayOnline: json['canPayOnline'] as bool?,
      fullyPaid: json['fullyPaid'] as bool?,

      // New grouping/section fields
      sectionIds: _asIntList(json['sectionIds']),
      sectionIndex:
      (json['sectionIndex'] != null) ? _asInt(json['sectionIndex']) : null,
      groupKey: json['groupKey']?.toString(),
      groupIds: _asIntList(json['groupIds']),
      groupIndex:
      (json['groupIndex'] != null) ? _asInt(json['groupIndex']) : null,
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
    'sectionIds': sectionIds,
    'sectionIndex': sectionIndex,
    'groupKey': groupKey,
    'groupIds': groupIds,
    'groupIndex': groupIndex,
  };
}

// ---------- meta ----------
class Meta {
  final int page;
  final int limit;
  final int total;
  final int pages; // may be missing in API; we compute if absent

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    final page = _asInt(json['page']);
    final limit = _asInt(json['limit']);
    final total = _asInt(json['total']);
    final pagesFromApi = json['pages'];
    int pages;

    if (pagesFromApi != null) {
      pages = _asInt(pagesFromApi);
    } else {
      // Compute pages if API doesn't send it (ceil(total/limit)), guard limit=0
      pages = (limit > 0) ? ((total + limit - 1) ~/ limit) : 0;
    }

    return Meta(page: page, limit: limit, total: total, pages: pages);
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'total': total,
    'pages': pages,
  };
}
