class FeesDetailsResponse {
  final int planId;
  final String name;
  final String announcementDate;
  final String dueDate;
  final String paymentType;
  final Summary summary;
  final List<FeeItem> items;

  FeesDetailsResponse({
    required this.planId,
    required this.name,
    required this.announcementDate,
    required this.dueDate,
    required this.paymentType,
    required this.summary,
    required this.items,
  });

  factory FeesDetailsResponse.fromJson(Map<String, dynamic> json) =>
      FeesDetailsResponse(
        planId: json['planId'],
        name: json['name'],
        announcementDate: json['announcementDate'],
        dueDate: json['dueDate'],
        paymentType: json['paymentType'],
        summary: Summary.fromJson(json['summary']),
        items: (json['items'] as List).map((e) => FeeItem.fromJson(e)).toList(),
      );
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

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalAmount: json['totalAmount'],
    paidAmount: json['paidAmount'],
    unpaidCount: json['unpaidCount'],
  );
}

class FeeItem {
  final int itemId;
  final String feeTypeName;
  final int amount;
  final String status;
  final String paidAt;
  final String method;
  final String admissionNo;
  final String receiptNo;
  final Online online;

  FeeItem({
    required this.itemId,
    required this.feeTypeName,
    required this.amount,
    required this.status,
    required this.paidAt,
    required this.method,
    required this.admissionNo,
    required this.receiptNo,
    required this.online,
  });

  factory FeeItem.fromJson(Map<String, dynamic> json) => FeeItem(
    itemId: json['itemId'],
    feeTypeName: json['feeTypeName'],
    amount: json['amount'],
    status: json['status'],
    paidAt: json['paidAt'],
    method: json['method'],
    admissionNo: json['admissionNo'],
    receiptNo: json['receiptNo'],
    online: Online.fromJson(json['online']),
  );
}

class Online {
  final bool hasGateway;
  final String profileName;

  Online({required this.hasGateway, required this.profileName});

  factory Online.fromJson(Map<String, dynamic> json) =>
      Online(hasGateway: json['hasGateway'], profileName: json['profileName']);
}
