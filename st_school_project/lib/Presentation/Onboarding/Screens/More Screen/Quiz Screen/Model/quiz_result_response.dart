// lib/Presentation/Onboarding/Screens/More Screen/Quiz Screen/Model/quiz_result_response.dart
// If your folder path has spaces, make sure your imports URL-encode them as %20.

import 'dart:convert';

class QuizResultResponse {
  final bool status;
  final int code;
  final String message;
  final QuizResultData data;

  QuizResultResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  /// Accepts JSON String or Map.
  factory QuizResultResponse.fromAny(dynamic any) {
    if (any is String) {
      final map = jsonDecode(any);
      return QuizResultResponse.fromJson(Map<String, dynamic>.from(map));
    }
    if (any is Map) {
      return QuizResultResponse.fromJson(Map<String, dynamic>.from(any));
    }
    throw ArgumentError('Unsupported type for QuizResultResponse.fromAny');
  }

  factory QuizResultResponse.fromJson(Map<String, dynamic> json) {
    final dataMap = (json['data'] as Map?)?.cast<String, dynamic>() ?? const {};
    return QuizResultResponse(
      status: _toBool(json['status']),
      code: _toInt(json['code']),
      message: _toStr(json['message'] ?? json['msg']),
      data: QuizResultData.fromJson(dataMap),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data.toJson(),
  };
}

class QuizResultData {
  final int quizId;            // optional; UI doesn't require but useful
  final String heading;        // UI uses this for title
  final int score;             // UI shows score/total
  final int total;
  final List<QuestionResult> questions;

  QuizResultData({
    required this.quizId,
    required this.heading,
    required this.score,
    required this.total,
    required this.questions,
  });

  factory QuizResultData.fromJson(Map<String, dynamic> json) {
    final qListRaw = (json['questions'] ?? json['items'] ?? []) as List;
    final qList = qListRaw
        .map((e) => QuestionResult.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return QuizResultData(
      quizId: _toInt(json['quizId'] ?? json['quiz_id'] ?? json['id']),
      heading: _toStr(json['heading'] ?? json['title'] ?? json['name']),
      score: _toInt(json['score'] ?? json['marks'] ?? json['obtained']),
      total: _toInt(json['total'] ?? json['max'] ?? json['full_marks']),
      questions: qList,
    );
  }

  Map<String, dynamic> toJson() => {
    'quizId': quizId,
    'heading': heading,
    'score': score,
    'total': total,
    'questions': questions.map((e) => e.toJson()).toList(),
  };

  double get percentage => total == 0 ? 0.0 : score / total;
  String get percentageString =>
      total == 0 ? '0%' : '${(percentage * 100).toStringAsFixed(0)}%';

  /// Count of correctly answered questions (based on question-level isCorrect)
  int get correctCount => questions.where((q) => q.isCorrect).length;
}

class QuestionResult {
  final int id;
  final String text;
  /// Which option the student selected
  final int selectedOptionId;
  /// Whether the selected option is correct (server may send this)
  final bool isCorrect;
  final List<OptionResult> options;

  QuestionResult({
    required this.id,
    required this.text,
    required this.selectedOptionId,
    required this.isCorrect,
    required this.options,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    final optsRaw = (json['options'] ?? json['choices'] ?? []) as List;
    final opts = optsRaw
        .map((e) => OptionResult.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return QuestionResult(
      id: _toInt(json['id'] ?? json['questionId'] ?? json['question_id']),
      text: _toStr(json['text'] ?? json['question'] ?? json['title']),
      selectedOptionId:
      _toInt(json['selectedOptionId'] ?? json['selected_option_id'] ?? json['selected']),
      isCorrect: _toBool(json['isCorrect'] ?? json['correct'] ?? json['is_correct']),
      options: opts,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'selectedOptionId': selectedOptionId,
    'isCorrect': isCorrect,
    'options': options.map((e) => e.toJson()).toList(),
  };

  OptionResult? get selectedOption {
    for (final o in options) {
      if (o.id == selectedOptionId) return o;
    }
    return null;
  }
}

class OptionResult {
  final int id;
  final String text;
  final bool isCorrect;
  final bool isSelected;

  OptionResult({
    required this.id,
    required this.text,
    required this.isCorrect,
    required this.isSelected,
  });

  factory OptionResult.fromJson(Map<String, dynamic> json) {
    return OptionResult(
      id: _toInt(json['id'] ?? json['optionId'] ?? json['option_id']),
      text: _toStr(json['text'] ?? json['label']),
      isCorrect: _toBool(json['isCorrect'] ?? json['correct'] ?? json['is_correct']),
      isSelected: _toBool(json['isSelected'] ?? json['selected'] ?? json['is_selected']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isCorrect': isCorrect,
    'isSelected': isSelected,
  };
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
