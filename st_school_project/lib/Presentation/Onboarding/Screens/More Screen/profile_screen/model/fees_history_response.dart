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
  final String name;
  final String announcementDate;
  final String dueDate;
  final String paymentType;
  final Summary summary;
  final List<FeeItem> items;

  PlanItem({
    required this.planId,
    required this.name,
    required this.announcementDate,
    required this.dueDate,
    required this.paymentType,
    required this.summary,
    required this.items,
  });

  factory PlanItem.fromJson(Map<String, dynamic> json) {
    return PlanItem(
      planId: json['planId'] ?? 0,
      name: json['name'] ?? '',
      announcementDate: json['announcementDate'] ?? '',
      dueDate: json['dueDate'] ?? '',
      paymentType: json['paymentType'] ?? '',
      summary: Summary.fromJson(json['summary'] ?? {}),
      items:
          (json['items'] as List<dynamic>? ?? [])
              .map((e) => FeeItem.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "planId": planId,
    "name": name,
    "announcementDate": announcementDate,
    "dueDate": dueDate,
    "paymentType": paymentType,
    "summary": summary.toJson(),
    "items": items.map((e) => e.toJson()).toList(),
  };
}

class Summary {
  final int totalAmount;
  final int paidAmount;
  final int unpaidCount;

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
  final String feeTypeName;
  final int amount;
  final String status;
  final String? paidAt;
  final String? method;
  final ActionModel? action;

  FeeItem({
    required this.itemId,
    required this.feeTypeName,
    required this.amount,
    required this.status,
    this.paidAt,
    this.method,
    this.action,
  });

  factory FeeItem.fromJson(Map<String, dynamic> json) {
    return FeeItem(
      itemId: json['itemId'] ?? 0,
      feeTypeName: json['feeTypeName'] ?? '',
      amount: json['amount'] ?? 0,
      status: json['status'] ?? '',
      paidAt: json['paidAt'],
      method: json['method'],
      action:
          json['action'] != null ? ActionModel.fromJson(json['action']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "itemId": itemId,
    "feeTypeName": feeTypeName,
    "amount": amount,
    "status": status,
    "paidAt": paidAt,
    "method": method,
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
