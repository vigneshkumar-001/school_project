/*
// lib/Presentation/Onboarding/Screens/More Screen/Quiz Screen/controller/quiz_controller.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';

import '../../../../../../api/data_source/apiDataSource.dart';
import '../Model/quiz_attend.dart'; // QuizAttend / QuizData / Question / OptionItem

class QuizController extends GetxController {
  // --- Dependencies ---
  final ApiDataSource apiDataSource = ApiDataSource();

  // --- Reactive state ---
  final RxBool isLoading = false.obs;
  final RxString lastError = ''.obs;

  /// The currently loaded quiz (reactive)
  final Rx<QuizData?> quizRx = Rx<QuizData?>(null);
  QuizData? get quiz => quizRx.value;

  /// Map of questionId -> selected optionId
  final RxMap<int, int> selections = <int, int>{}.obs;

  /// Timer (assumes `timeLimit` is in MINUTES from API)
  final RxInt remainingSeconds = 0.obs;
  Timer? _timer;


  /// --- Payload helpers (DYNAMIC maps) ---
  List<Map<String, dynamic>> get submissionPayload =>
      selections.entries
          .map((e) => <String, dynamic>{
        'questionId': e.key,
        'optionId': e.value,
      })
          .toList();
  // --- Derived state helpers ---
  int get totalQuestions => quiz?.questions.length ?? 0;
  int get answeredCount => selections.length;
  bool get isComplete => totalQuestions > 0 && answeredCount == totalQuestions;

  /// Convert current selections to a typical submission payload
  // List<Map<String, int>> get submissionPayload =>
  //     selections.entries
  //         .map((e) => {'questionId': e.key, 'optionId': e.value})
  //         .toList();

  /// Load quiz by id
  Future<String?> loadQuiz({required int quizId}) async {
    if (isLoading.value) return null;
    try {
      isLoading.value = true;
      lastError.value = '';

      final results = await apiDataSource.QuizControllerAttend(quizId: quizId);

      return results.fold(
        (failure) {
          final msg = failure.message;
          lastError.value = msg;
          quizRx.value = null; // ✅ use quizRx (not _quiz)
          selections.clear();
          _stopTimer();
          _logE(msg);
          return msg; // ✅ return a String in failure branch
        },
        (resp) {
          // resp is QuizAttend
          quizRx.value = resp.data; // ✅ use quizRx (not _quiz)
          selections.clear();
          _startTimerFrom(resp.data);
          AppLogger.log.i(
            'Quiz loaded: id=${resp.data.id}, title=${resp.data.heading}',
          );
          // ✅ return null on success (Future<String?>)
        },
      );
    } catch (e) {
      final msg = e.toString();
      lastError.value = msg;
      quizRx.value = null; // ✅ use quizRx (not _quiz)
      selections.clear();
      _stopTimer();
      _logE(msg);
      return msg;
    } finally {
      isLoading.value = false;
    }
  }

  /// Select single-choice option for a question
  void selectOption({required int questionId, required int optionId}) {
    selections[questionId] = optionId;
  }

  /// Check whether an option is selected for a question
  bool isSelected(int questionId, int optionId) {
    return selections[questionId] == optionId;
  }

  /// Get selected option id for a question (or null)
  int? selectedOptionId(int questionId) => selections[questionId];

  /// Clear selection for a single question
  void clearSelection(int questionId) {
    selections.remove(questionId);
  }

  /// Clear all selections
  void clearAllSelections() {
    selections.clear();
  }

  /// Get a question by id (if needed in UI)
  Question? questionById(int questionId) {
    final qs = quiz?.questions ?? const <Question>[];
    for (final q in qs) {
      if (q.id == questionId) return q;
    }
    return null;
  }

  /// Initialize timer from QuizData.timeLimit (minutes)
  void _startTimerFrom(QuizData data) {
    _stopTimer();
    final secs = (data.timeLimit <= 0 ? 0 : data.timeLimit) * 60;
    remainingSeconds.value = secs;
    if (secs <= 0) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final next = remainingSeconds.value - 1;
      if (next <= 0) {
        remainingSeconds.value = 0;
        _stopTimer();
      } else {
        remainingSeconds.value = next;
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }

  // --- Logging helpers (no AppLogger dependency) ---
  void _logI(String msg) => debugPrint(msg);
  void _logE(String msg) => debugPrint('ERROR: $msg');

  // Optional: quick mock to test UI without API
  void loadMock(QuizData data) {
    quizRx.value = data;
    selections.clear();
    _startTimerFrom(data);
  }

  Future<String?> loadQuizSubmit({
    required int quizId,
    required List<Map<String, dynamic>> answers,
  }) async {
    if (isLoading.value) return null;
    try {
      isLoading.value = true;
      lastError.value = '';

      final result = await apiDataSource.loadQuizControllerSubmit(answers: submissionPayload(quizId),
        quizId: quizId,
      );

      return result.fold(
        (failure) {
          lastError.value = failure.message;
          // 🔐 Prevent stale UI from showing old data on error:
          AppLogger.log.e(failure.message);
          return failure.message;
        },
        (resp) {
          AppLogger.log.i('Details fetched: ${resp.data}');
        },
      );
    } catch (e) {
      lastError.value = e.toString();

      AppLogger.log.e(e);
      return e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
*/

import 'dart:async';
import 'dart:convert';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../../../api/data_source/apiDataSource.dart';
import '../../quiz_result.dart';
import '../Model/quiz_attend.dart'; // QuizAttend / QuizData / Question / OptionItem
import '../Model/quiz_result_response.dart';
import '../Model/quiz_submit.dart'; // QuizSubmit / SubmitData

class QuizController extends GetxController {
  final ApiDataSource apiDataSource = ApiDataSource();
  final quizResult = Rxn<QuizResultData>();
  // Flags
  final RxBool isLoading = false.obs;
  final RxBool loadQuizLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString lastError = ''.obs;

  // Quiz data
  final Rx<QuizData?> quizRx = Rx<QuizData?>(null);
  QuizData? get quiz => quizRx.value;

  // Submit result (score/total)
  final Rx<SubmitData?> submitRx = Rx<SubmitData?>(null);
  SubmitData? get result => submitRx.value;

  // Selections: questionId -> optionId
  final RxMap<int, int> selections = <int, int>{}.obs;

  // Timer
  final RxInt remainingSeconds = 0.obs;
  Timer? _timer;
  final RxMap<int, bool> _submitted = <int, bool>{}.obs;
  // Derived
  int get totalQuestions => quiz?.questions.length ?? 0;
  int get answeredCount => selections.length;
  bool get isComplete => totalQuestions > 0 && answeredCount == totalQuestions;

  // Payload for submit (camelCase; flip to snake_case if your backend needs it)
  List<Map<String, dynamic>> get submissionPayload =>
      selections.entries
          .map(
            (e) => <String, dynamic>{
              'questionId': e.key,
              'selectedOptionId': e.value,
            },
          )
          .toList();

  // Load quiz
  Future<String?> loadQuiz({required int quizId}) async {
    try {
      loadQuizLoading.value = true;
      lastError.value = '';
      submitRx.value = null;

      final results = await apiDataSource.QuizControllerAttend(quizId: quizId);

      final err = results.fold<String?>(
        (failure) {
          loadQuizLoading.value = false;
          final msg = failure.message;
          lastError.value = msg;
          quizRx.value = null;
          selections.clear();
          _stopTimer();
          debugPrint('ERROR loadQuiz: $msg');
          return msg;
        },
        (resp) {
          loadQuizLoading.value = false;
          final data = resp.data; // QuizData
          quizRx.value = data;
          selections.clear();
          lastError.value = '';
          debugPrint('Quiz loaded: ${data.id} - ${data.heading}');
          _startTimerFrom(data);
          return resp.data.toString();
        },
      );
      return err;
    } catch (e) {
      loadQuizLoading.value = false;
      final msg = 'Load error: $e';
      lastError.value = msg;
      quizRx.value = null;
      selections.clear();
      _stopTimer();
      debugPrint('ERROR loadQuiz: $msg');
      return msg;
    } finally {
      isLoading.value = false;
    }
  }

  // Submit quiz
  /*  Future<QuizResultData?> submitCurrent({required int quizId}) async {
    if (isSubmitting.value) return null; // guard double taps
    isSubmitting.value = true;
    lastError.value = '';

    try {
      final either = await apiDataSource.loadQuizControllerSubmit(
        quizId: quizId,
        answers: submissionPayload,
      );

      QuizResultData? out;

      either.fold(
            (failure) {
          lastError.value = failure.message ?? 'Submission failed';
        },
            (resp) {
          // Try to coerce whatever the client puts in resp/resp.data into QuizResultData
          final raw = resp.data; // many clients put only the "data" here
          out = _asQuizResultData(raw) ??
              _asQuizResultData(resp) ; // fallback: whole response

          if (out != null) {
            submitRx.value = out as SubmitData?;
            AppLogger.log.i('Submitted: ${out!.score}/${out!.total} (${out!.percentageString})');
          } else {
            lastError.value = 'Invalid result format';
          }
        },
      );

      return out; // non-null => success
    } catch (e, st) {
      lastError.value = 'Submit error: $e';
      AppLogger.log.e('Submit error: $e\n$st');
      return null;
    } finally {
      isSubmitting.value = false;
    }
  }*/
  Future<dynamic> submitCurrent({required int quizId}) async {
    if (isSubmitting.value) return null;
    try {
      isSubmitting.value = true;
      lastError.value = '';
      submitRx.value = null;

      final subEither = await apiDataSource.loadQuizControllerSubmit(
        quizId: quizId,
        answers: submissionPayload,
      );

      // 1) Submit
      final submitErr = await subEither.fold<String?>(
        (failure) {
          final msg = failure.message;
          Get.snackbar(
            'Submit failed',
            failure.message,
            snackPosition: SnackPosition.TOP,
          );
          lastError.value = msg;
          debugPrint('ERROR submit: $msg');
          return msg;
        },
        (resp) {
          AppLogger.log.i("Quiz Created");

          submitRx.value = resp.data; // score/total (minimal)
          _stopTimer();
          return null;
        },
      );
      if (submitErr != null) return submitErr; // ❌ failed

      // 2) Load FULL result for UI
      final results = await apiDataSource.loadQuizResult(quizId: quizId);
      return results.fold<dynamic>(
        (failure) {
          // ✅ Directly show only API "message"
          final msg = failure.message;
          lastError.value = msg;

          // Clear any old snackbar before showing new one
          if (Get.isSnackbarOpen) {
            Get.closeCurrentSnackbar();
          }

          Get.snackbar(
            'Error',
            msg,
            snackPosition: SnackPosition.TOP,

            duration: const Duration(seconds: 3),
          );

          debugPrint('❌ API Error: $msg');
          return msg;
        },
        (response) {
          Get.off(() => QuizResultScreen(data: response.data));
          quizResult.value = response.data;
          AppLogger.log.i("Quiz Created");
          AppLogger.log.i("Quiz Created  = ${response.message}");
          return response; // ✅ return full result object
        },
      );
    } catch (e) {
      final msg = 'Submit error: $e';
      lastError.value = msg;
      debugPrint(msg);
      return msg;
    } finally {
      isSubmitting.value = false;
    }
  }

  // Selection helpers
  void selectOption({required int questionId, required int optionId}) {
    selections[questionId] = optionId;
  }

  bool isSelected(int qId, int optId) => selections[qId] == optId;

  // Timer
  void _startTimerFrom(QuizData data) {
    _stopTimer();
    final secs = (data.timeLimit <= 0 ? 0 : data.timeLimit) * 60;
    remainingSeconds.value = secs;
    if (secs <= 0) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = remainingSeconds.value - 1;
      if (next <= 0) {
        remainingSeconds.value = 0;
        _stopTimer();
      } else {
        remainingSeconds.value = next;
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }

  // Mock (optional)
  void loadMock(QuizData data) {
    quizRx.value = data;
    selections.clear();
    _startTimerFrom(data);
  }

  QuizResultData? _asQuizResultData(dynamic raw) {
    if (raw == null) return null;
    if (raw is QuizResultData) return raw;

    if (raw is Map<String, dynamic>) {
      return QuizResultData.fromJson(raw);
    }
    if (raw is Map) {
      return QuizResultData.fromJson(Map<String, dynamic>.from(raw));
    }
    if (raw is String) {
      // Try full response first, then inner data-only JSON
      try {
        final resp = QuizResultResponse.fromAny(raw);
        return resp.data;
      } catch (_) {
        try {
          final map = Map<String, dynamic>.from(jsonDecode(raw) as Map);
          return QuizResultData.fromJson(map);
        } catch (_) {
          return null;
        }
      }
    }
    if (raw is QuizResultResponse) {
      return raw.data;
    }
    return null;
  }
}
