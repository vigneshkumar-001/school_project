// quiz_response.dart
import 'dart:convert';

class QuizAttend {
  final bool status;
  final int code;
  final String message;
  final QuizData data;

  QuizAttend({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  /// Accepts either a JSON string or a Map<String, dynamic>.
  factory QuizAttend.fromAny(dynamic any) {
    if (any is String) {
      final map = jsonDecode(any);
      return QuizAttend.fromJson(Map<String, dynamic>.from(map));
    }
    if (any is Map) {
      return QuizAttend.fromJson(Map<String, dynamic>.from(any));
    }
    throw ArgumentError('Unsupported type for QuizAttend.fromAny');
  }

  factory QuizAttend.fromJson(Map<String, dynamic> json) {
    return QuizAttend(
      status: _toBool(json['status']),
      code: _toInt(json['code']),
      message: _toStr(json['message']),
      data: QuizData.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
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

class QuizData {
  final int id;
  final String heading;
  final int timeLimit;
  /// "class" is a reserved word in Dart, so we map it to className.
  final String className;
  final String subject;
  final List<Question> questions;

  QuizData({
    required this.id,
    required this.heading,
    required this.timeLimit,
    required this.className,
    required this.subject,
    required this.questions,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) {
    final qList = (json['questions'] as List? ?? [])
        .map((e) => Question.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return QuizData(
      id: _toInt(json['id']),
      heading: _toStr(json['heading']),
      timeLimit: _toInt(json['timeLimit']),
      className: _toStr(json['class']), // map "class" -> className
      subject: _toStr(json['subject']),
      questions: qList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'heading': heading,
      'timeLimit': timeLimit,
      'class': className, // map back to "class"
      'subject': subject,
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }

  int get totalQuestions => questions.length;
}

class Question {
  final int id;
  final String text;
  final List<OptionItem> options;

  Question({
    required this.id,
    required this.text,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final opts = (json['options'] as List? ?? [])
        .map((e) => OptionItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return Question(
      id: _toInt(json['id']),
      text: _toStr(json['text']),
      options: opts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}

class OptionItem {
  final int id;
  final String text;

  OptionItem({
    required this.id,
    required this.text,
  });

  factory OptionItem.fromJson(Map<String, dynamic> json) {
    return OptionItem(
      id: _toInt(json['id']),
      text: _toStr(json['text']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
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
