// quiz_submit.dart
import 'dart:convert';

class QuizSubmit {
  final bool status;
  final int code;
  final String message;
  final SubmitData data;

  QuizSubmit({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  /// Accepts a JSON String or Map<String, dynamic>.
  factory QuizSubmit.fromAny(dynamic any) {
    if (any is String) {
      final map = jsonDecode(any);
      return QuizSubmit.fromJson(Map<String, dynamic>.from(map));
    }
    if (any is Map) {
      return QuizSubmit.fromJson(Map<String, dynamic>.from(any));
    }
    throw ArgumentError('Unsupported type for QuizSubmit.fromAny');
  }

  factory QuizSubmit.fromJson(Map<String, dynamic> json) {
    return QuizSubmit(
      status: _toBool(json['status']),
      code: _toInt(json['code']),
      message: _toStr(json['message']),
      data: SubmitData.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data.toJson(),
  };
}

class SubmitData {
  final int score;
  final int total;

  SubmitData({required this.score, required this.total});

  factory SubmitData.fromJson(Map<String, dynamic> json) {
    return SubmitData(
      score: _toInt(json['score']),
      total: _toInt(json['total']),
    );
  }

  Map<String, dynamic> toJson() => {'score': score, 'total': total};

  /// Convenience getters
  double get percentage => total == 0 ? 0 : (score / total);
  String get percentageString =>
      total == 0 ? '0%' : '${(percentage * 100).toStringAsFixed(0)}%';
}

/// ---------- Safe cast helpers ----------
int _toInt(dynamic v) {
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}

bool _toBool(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final s = v.toLowerCase().trim();
    return s == 'true' || s == '1' || s == 'yes';
  }
  return false;
}

String _toStr(dynamic v) => v?.toString() ?? '';
