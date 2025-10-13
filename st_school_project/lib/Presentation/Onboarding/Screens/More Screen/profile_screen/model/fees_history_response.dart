class FeesHistoryResponse {
  final bool status;
  final int code;
  final String message;
  final FeePlansData data;

  FeesHistoryResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory FeesHistoryResponse.fromJson(Map<String, dynamic> json) {
    return FeesHistoryResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: FeePlansData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}

class FeePlansData {
  final List<PlanItem> items;

  FeePlansData({required this.items});

  factory FeePlansData.fromJson(Map<String, dynamic> json) {
    return FeePlansData(
      items:
          (json['items'] as List<dynamic>? ?? [])
              .map((e) => PlanItem.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "items": items.map((e) => e.toJson()).toList(),
  };
}

class PlanItem {
  final int planId;
  final int studentId;
  final String name;
  final String announcementDate;
  final String dueDate;
  final String paymentType;
  final Summary summary;
  final String combinedDownloadUrl;

  final List<FeeItem> items;

  PlanItem({
    required this.planId,
    required this.studentId,
    required this.name,
    required this.announcementDate,
    required this.dueDate,
    required this.paymentType,
    required this.summary,
    required this.items,
    required this.combinedDownloadUrl,
  });

  factory PlanItem.fromJson(Map<String, dynamic> json) {
    return PlanItem(
      planId: json['planId'] ?? 0,
      studentId: json['studentId'] ?? 0,
      name: json['name'] ?? '',
      announcementDate: json['announcementDate'] ?? '',
      dueDate: json['dueDate'] ?? '',
      paymentType: json['paymentType'] ?? '',
      combinedDownloadUrl: json['combinedDownloadUrl'] ?? '',
      summary: Summary.fromJson(json['summary'] ?? {}),
      items:
          (json['items'] as List<dynamic>? ?? [])
              .map((e) => FeeItem.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "planId": planId,
    "studentId": studentId,
    "name": name,
    "announcementDate": announcementDate,
    "dueDate": dueDate,
    "paymentType": paymentType,
    "combinedDownloadUrl": combinedDownloadUrl,
    "summary": summary.toJson(),
    "items": items.map((e) => e.toJson()).toList(),
  };
}

class Summary {
  final dynamic totalAmount;
  final dynamic paidAmount;
  final dynamic unpaidCount;

  Summary({
    required this.totalAmount,
    required this.paidAmount,
    required this.unpaidCount,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalAmount: json['totalAmount'] ?? 0,
      paidAmount: json['paidAmount'] ?? 0,
      unpaidCount: json['unpaidCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "totalAmount": totalAmount,
    "paidAmount": paidAmount,
    "unpaidCount": unpaidCount,
  };
}

class FeeItem {
  final int itemId;
  final int studentId;
  final String feeTypeName;
  final dynamic amount;
  final String instructionUrl;
  late final String status;
  final String? paidAt;
  final String? method;
  final String? admissionNo;
  final String? receiptNo;
  final String? receiptLink;
  final ActionModel? action;

  FeeItem({
    required this.itemId,
    required this.studentId,
    required this.feeTypeName,
    required this.amount,
    required this.instructionUrl,

    required this.status,
    this.paidAt,
    this.method,
    this.admissionNo,
    this.receiptLink,
    this.receiptNo,
    this.action,
  });

  factory FeeItem.fromJson(Map<String, dynamic> json) {
    return FeeItem(
      itemId: json['itemId'] ?? 0,
      studentId: json['studentId'] ?? 0,
      feeTypeName: json['feeTypeName'] ?? '',
      instructionUrl: json['instructionUrl'] ?? '',
      amount: json['amount'] ?? 0,
      status: json['status'] ?? '',
      paidAt: json['paidAt'],

      receiptNo: json['receiptNo'],
      admissionNo: json['admissionNo'],
      receiptLink: json['receiptLink'],
      method: json['method'],
      action:
          json['action'] != null ? ActionModel.fromJson(json['action']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "itemId": itemId,
    "studentId": studentId,
    "feeTypeName": feeTypeName,
    "instructionUrl": instructionUrl,
    "amount": amount,
    "status": status,
    "paidAt": paidAt,
    "method": method,
    "receiptNo": receiptNo,
    "admissionNo": admissionNo,
    "receiptLink": receiptLink,
    "action": action?.toJson(),
  };
}

class ActionModel {
  final String type;
  final String? href;

  ActionModel({required this.type, this.href});

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(type: json['type'] ?? '', href: json['href']);
  }

  Map<String, dynamic> toJson() => {"type": type, "href": href};
}
