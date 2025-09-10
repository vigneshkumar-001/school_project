/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Map<int, String> selectedAnswers = {};
  int questionIndex = 0;
  int selectedAnswerIndexQ1 = -1;
  int selectedAnswerIndexQ2 = -1;
  bool isQuizCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isQuizCompleted ? 0 : 0,
            vertical: isQuizCompleted ? 0 : 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isQuizCompleted
                    ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            AppColor.quizGreen.withOpacity(
                              0.9,
                            ), // Light green bottom
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.lightGrey,
                                    border: Border.all(
                                      color: AppColor.lightGrey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Image.asset(
                                      AppImages.leftArrow,
                                      height: 17,
                                      width: 17,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  'Maths Quiz Result',
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            CustomTextField.textWithSmall(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              text: 'Great!',
                              color: AppColor.greenMore1,
                            ),
                            SizedBox(height: 10),
                            CustomTextField.textWithSmall(
                              text: '2 out of 3',
                              color: AppColor.black,
                              fontSize: 18,
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: LinearProgressIndicator(
                                minHeight: 6,
                                value: 0.9,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColor.greenMore1,
                                ),
                                stopIndicatorRadius: 16,
                                backgroundColor: AppColor.lowGery1,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            SizedBox(height: 50),
                          ],
                        ),
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColor.lightGrey,
                                  border: Border.all(
                                    color: AppColor.lowLightBlue,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    CupertinoIcons.left_chevron,
                                    color: AppColor.grey,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Text(
                                'Maths Quiz',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.black,
                                ),
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColor.grayop,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 7,
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        AppImages.clockIcon,
                                        width: 18,
                                        height: 17,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '2.40',
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.lightBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          LinearProgressIndicator(
                            minHeight: 6,
                            value: 0.2,

                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColor.blue,
                            ),
                            stopIndicatorRadius: 16,
                            backgroundColor: AppColor.lowGery1,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      CustomTextField.quizQuestion(
                        sno: '1.',
                        text: 'What is 7 + 6?',
                      ),
                      SizedBox(height: 15),
                      CustomContainer.quizContainer(
                        isQuizCompleted: isQuizCompleted,
                        leftTextNumber: 'A',
                        leftValue: '11',
                        rightTextNumber: 'B',
                        rightValue: "12",
                        leftSelected: selectedAnswerIndexQ1 == 0,
                        rightSelected: selectedAnswerIndexQ1 == 1,
                        leftOnTap: () {
                          setState(() {
                            selectedAnswerIndexQ1 = 0;
                          });
                        },
                        rightOnTap: () {
                          setState(() {
                            selectedAnswerIndexQ1 = 1;
                          });
                        },
                      ),
                      SizedBox(height: 20),

                      CustomContainer.quizContainer(
                        isQuizCompleted: isQuizCompleted,
                        leftTextNumber: 'C',
                        leftValue: '13',
                        rightTextNumber: 'D',
                        rightValue: "14",
                        leftSelected: selectedAnswerIndexQ1 == 2,
                        rightSelected: selectedAnswerIndexQ1 == 3,
                        leftOnTap: () {
                          setState(() {
                            selectedAnswerIndexQ1 = 2;
                          });
                        },
                        rightOnTap: () {
                          setState(() {
                            selectedAnswerIndexQ1 = 3;
                          });
                        },
                      ),
                      SizedBox(height: 35),
                      CustomTextField.quizQuestion(
                        sno: '2.',
                        text: 'What is the value of 5 × 3?',
                      ),

                      SizedBox(height: 15),
                      CustomContainer.quizContainer(
                        isQuizCompleted: isQuizCompleted,
                        leftTextNumber: 'A',
                        leftValue: '11',
                        rightTextNumber: 'B',
                        rightValue: "12",
                        leftSelected: selectedAnswerIndexQ2 == 0,
                        rightSelected: selectedAnswerIndexQ2 == 1,
                        leftOnTap: () {
                          setState(() {
                            selectedAnswerIndexQ2 = 0;
                          });
                        },
                        rightOnTap: () {
                          setState(() {
                            selectedAnswerIndexQ2 = 1;
                          });
                        },
                      ),
                      SizedBox(height: 20),

                      CustomContainer.quizContainer(
                        isQuizCompleted: isQuizCompleted,
                        leftSelected: selectedAnswerIndexQ2 == 2,
                        rightSelected: selectedAnswerIndexQ2 == 3,
                        leftTextNumber: 'C',
                        leftValue: '13',
                        rightTextNumber: 'D',
                        rightValue: "14",
                        leftOnTap: () {
                          setState(() {
                            selectedAnswerIndexQ2 = 2;
                          });
                        },
                        rightOnTap: () {
                          setState(() {
                            selectedAnswerIndexQ2 = 3;
                          });
                        },
                      ),
                      SizedBox(height: 35),
                      CustomTextField.quizQuestion(
                        sno: '3.',
                        text:
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                      ),
                      SizedBox(height: 20),
                      CustomContainer.quizContainer1(
                        isQuizCompleted: isQuizCompleted,
                        isSelected: selectedAnswers[questionIndex] == 'A',
                        onTap: () {
                          setState(() {
                            selectedAnswers[questionIndex] = 'A';
                          });
                        },
                        leftTextNumber: 'A',
                        leftValue:
                            'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
                      ),
                      SizedBox(height: 20),

                      CustomContainer.quizContainer1(
                        isQuizCompleted: isQuizCompleted,
                        isSelected: selectedAnswers[questionIndex] == 'B',
                        onTap: () {
                          setState(() {
                            selectedAnswers[questionIndex] = 'B';
                          });
                        },
                        leftTextNumber: 'B',
                        leftValue:
                            'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
                      ),
                      SizedBox(height: 20),

                      CustomContainer.quizContainer1(
                        isQuizCompleted: isQuizCompleted,
                        isSelected: selectedAnswers[questionIndex] == 'C',
                        onTap: () {
                          setState(() {
                            selectedAnswers[questionIndex] = 'C';
                          });
                        },
                        leftTextNumber: 'C',
                        leftValue:
                            'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
                      ),
                      SizedBox(height: 20),

                      CustomContainer.quizContainer1(
                        isQuizCompleted: isQuizCompleted,
                        isSelected: selectedAnswers[questionIndex] == 'D',
                        onTap: () {
                          setState(() {
                            selectedAnswers[questionIndex] = 'D';
                          });
                        },
                        leftTextNumber: 'D',
                        leftValue:
                            'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),
                if (!isQuizCompleted)
                  CustomContainer.checkMark(
                    imagePath: AppImages.tick,
                    onTap: () {
                      setState(() {
                        isQuizCompleted = !isQuizCompleted;
                      });
                    },
                  )
                else
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isQuizCompleted = !isQuizCompleted;
                      });
                    },
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 25,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.blue, width: 1),
                        ),
                        child: CustomTextField.textWithSmall(
                          text: 'Go Home',
                          color: AppColor.blue,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/

// quiz_screen.dart
/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'Quiz Screen/Model/quiz_attend.dart';
import 'Quiz Screen/controller/quiz_controller.dart';

class QuizScreen extends StatefulWidget {
  final int quizId;
  const QuizScreen({super.key, required this.quizId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizController c = Get.put(QuizController());

  bool isQuizCompleted = false;

  @override
  void initState() {
    super.initState();
    c.loadQuiz(quizId: 11);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final quiz = c.quizRx.value;
          if (c.isLoading.value && quiz == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (quiz == null) {
            return const Center(child: Text('No quiz data'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isQuizCompleted ? _completedHeader(quiz) : _activeHeader(quiz),
                if (!isQuizCompleted) _progressBar(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(children: _buildQuestionBlocks(quiz)),
                ),
                const SizedBox(height: 30),
                if (!isQuizCompleted)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: CustomContainer.checkMark(
                      imagePath: AppImages.tick,
                      onTap: () {
                        setState(() => isQuizCompleted = true);

                        final payload = c.submissionPayload;
                        print('payload: $payload');
                      },
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      setState(() => isQuizCompleted = false);
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 25,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.blue, width: 1),
                        ),
                        child: CustomTextField.textWithSmall(
                          text: 'Go Home',
                          color: AppColor.blue,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ---------- Headers ----------
  Widget _activeHeader(QuizData quiz) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColor.lightGrey,
                  border: Border.all(color: AppColor.lowLightBlue, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(CupertinoIcons.left_chevron, color: AppColor.grey),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                quiz.heading,
                style: GoogleFont.ibmPlexSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.grayop, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  child: Row(
                    children: [
                      Image.asset(AppImages.clockIcon, width: 18, height: 17),
                      const SizedBox(width: 5),
                      Obx(
                        () => Text(
                          _formatTime(c.remainingSeconds.value),
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.lightBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${quiz.subject} • ${quiz.className}',
              style: GoogleFont.ibmPlexSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColor.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _completedHeader(QuizData quiz) {
    final answered = c.answeredCount;
    final total = c.totalQuestions;
    final pct = total == 0 ? 0.0 : answered / total;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, AppColor.quizGreen.withOpacity(0.9)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.lightGrey,
                    border: Border.all(color: AppColor.lightGrey, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      AppImages.leftArrow,
                      height: 17,
                      width: 17,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  '${quiz.heading} Result',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            CustomTextField.textWithSmall(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              text: 'Great!',
              color: AppColor.greenMore1,
            ),
            const SizedBox(height: 10),
            CustomTextField.textWithSmall(
              text: '$answered out of $total answered',
              color: AppColor.black,
              fontSize: 18,
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: pct.clamp(0.0, 1.0),
                // Keep your project’s custom props if you extended LPI:
                // stopIndicatorRadius: 16,
                backgroundColor: AppColor.lowGery1,
                // borderRadius: BorderRadius.circular(16),
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.greenMore1),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _progressBar() {
    final total = c.totalQuestions;
    final answered = c.answeredCount;
    final value = total == 0 ? 0.0 : answered / total;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: LinearProgressIndicator(
        minHeight: 6,
        value: value.clamp(0.0, 1.0),
        backgroundColor: AppColor.lowGery1,
        // borderRadius: BorderRadius.circular(16),
        valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
      ),
    );
  }

  // ---------- Questions & Options ----------
  List<Widget> _buildQuestionBlocks(QuizData quiz) {
    final widgets = <Widget>[];
    for (int i = 0; i < quiz.questions.length; i++) {
      final q = quiz.questions[i];
      widgets.addAll([
        CustomTextField.quizQuestion(sno: '${i + 1}.', text: q.text),
        const SizedBox(height: 15),
        ..._buildOptionsForQuestion(q),
        const SizedBox(height: 35),
      ]);
    }
    return widgets;
  }

  List<Widget> _buildOptionsForQuestion(Question q) {
    final opts = q.options;

    // If any option text is long, switch to stacked long cards
    final hasLong = opts.any((o) => !_isShort(o.text));
    if (hasLong) {
      return [
        for (int i = 0; i < opts.length; i++) ...[
          CustomContainer.quizContainer1(
            isQuizCompleted: isQuizCompleted,
            isSelected: c.isSelected(q.id, opts[i].id),
            onTap: () => c.selectOption(questionId: q.id, optionId: opts[i].id),
            leftTextNumber: _letter(i),
            leftValue: opts[i].text,
          ),
          const SizedBox(height: 16),
        ],
      ];
    }

    // Short answers → two-column rows
    final rows = <Widget>[];
    for (int i = 0; i < opts.length; i += 2) {
      final left = opts[i];
      final right = i + 1 < opts.length ? opts[i + 1] : null;

      rows.add(
        CustomContainer.quizContainer(
          isQuizCompleted: isQuizCompleted,
          leftTextNumber: _letter(i),
          leftValue: left.text,
          rightTextNumber: right != null ? _letter(i + 1) : '',
          rightValue: right?.text ?? '',
          leftSelected: c.isSelected(q.id, left.id),
          rightSelected: right != null && c.isSelected(q.id, right.id),
          leftOnTap: () => c.selectOption(questionId: q.id, optionId: left.id),
          rightOnTap:
              right == null
                  ? null
                  : () => c.selectOption(questionId: q.id, optionId: right.id),
        ),
      );
      rows.add(const SizedBox(height: 20));
    }
    // remove the last gap
    if (rows.isNotEmpty) rows.removeLast();
    return rows;
  }

  // ---------- Utils ----------
  Widget _errorState(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40),
            const SizedBox(height: 12),
            Text(msg, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => c.loadQuiz(quizId: widget.quizId),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  bool _isShort(String s) {
    final t = s.trim();
    return t.length <= 30 && !t.contains('\n');
  }

  String _letter(int index) {
    // A, B, C, D... (covers up to 26)
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (index >= 0 && index < letters.length) return letters[index];
    return '?';
  }
}*/

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:st_school_project/Core/Utility/app_color.dart';
// import 'package:st_school_project/Core/Utility/app_images.dart';
// import 'package:st_school_project/Core/Utility/app_loader.dart';
// import 'package:st_school_project/Core/Utility/google_font.dart';
// import 'package:st_school_project/Core/Widgets/consents.dart';
// import 'package:st_school_project/Core/Widgets/custom_container.dart';
// import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
// import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/quiz_result.dart';
//
// import 'Quiz Screen/Model/quiz_attend.dart';
// import 'Quiz Screen/Model/quiz_result_response.dart';
// import 'Quiz Screen/Model/quiz_submit.dart';
// import 'Quiz Screen/controller/quiz_controller.dart';
//
// class QuizScreen extends StatefulWidget {
//   final int quizId;
//   const QuizScreen({super.key, required this.quizId});
//
//   @override
//   State<QuizScreen> createState() => _QuizScreenState();
// }
//
// class _QuizScreenState extends State<QuizScreen> {
//   final QuizController c = Get.put(QuizController());
//   bool isQuizCompleted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     c.loadQuiz(quizId: widget.quizId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Obx(() {
//               final quiz = c.quizRx.value;
//               if (c.loadQuizLoading.value) {
//                 return Center(child: AppLoader.circularLoader( ));
//               }
//
//               if (quiz == null) {
//                 return const Center(child: Text('No quiz data'));
//               }
//
//               return SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     isQuizCompleted
//                         ? _completedHeader(quiz)
//                         : _activeHeader(quiz),
//                     if (!isQuizCompleted) _progressBar(),
//                     const SizedBox(height: 24),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Column(children: _buildQuestionBlocks(quiz)),
//                     ),
//                     const SizedBox(height: 30),
//
//                     // if (!isQuizCompleted)
//                     Obx(() {
//                       final submitting = c.isSubmitting.value;
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 20),
//                         child: IgnorePointer(
//                           ignoring: submitting,
//                           child: AnimatedOpacity(
//                             duration: const Duration(milliseconds: 200),
//                             opacity: submitting ? 0.5 : 1.0,
//                             child: CustomContainer.checkMark(
//                               imagePath: AppImages.tick,
//                               onTap: () async {
//                                 if (c.isSubmitting.isTrue) return;
//
//                                 await c.submitCurrent(
//                                   quizId: widget.quizId,
//                                 );
//
//
//                               },
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//
//                     // else
//                     //   GestureDetector(
//                     //     onTap: () {
//                     //       setState(() => isQuizCompleted = false);
//                     //     },
//                     //     child: Center(
//                     //       child: Container(
//                     //         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//                     //         decoration: BoxDecoration(
//                     //           borderRadius: BorderRadius.circular(16),
//                     //           border: Border.all(color: AppColor.blue, width: 1),
//                     //         ),
//                     //         child: CustomTextField.textWithSmall(
//                     //           text: 'Go Home',
//                     //           color: AppColor.blue,
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ),
//                     // const SizedBox(height: 20),
//                   ],
//                 ),
//               );
//             }),
//
//             // Submitting overlay (reads Rx inside Obx → valid)
//             Obx(
//               () =>
//                   c.isSubmitting.value
//                       ? Container(
//                         color: Colors.black.withOpacity(0.15),
//                         child: Center(
//                           child: AppLoader.circularLoader( ),
//                         ),
//                       )
//                       : const SizedBox.shrink(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ---------- Headers ----------
//   Widget _activeHeader(QuizData quiz) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: AppColor.lightGrey,
//                   border: Border.all(color: AppColor.lowLightBlue, width: 1),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: IconButton(
//                   onPressed: () => Navigator.pop(context),
//                   icon: Icon(CupertinoIcons.left_chevron, color: AppColor.grey),
//                 ),
//               ),
//               const SizedBox(width: 15),
//               Text(
//                 quiz.heading,
//                 style: GoogleFont.ibmPlexSans(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: AppColor.black,
//                 ),
//               ),
//               const Spacer(),
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: AppColor.grayop, width: 1),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 9,
//                     vertical: 7,
//                   ),
//                   child: Row(
//                     children: [
//                       Image.asset(AppImages.clockIcon, width: 18, height: 17),
//                       const SizedBox(width: 5),
//                       Obx(() => Text(
//                         _formatTime(c.remainingSeconds.value),
//                         style: GoogleFont.ibmPlexSans(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: c.remainingSeconds.value <= 10 ? Colors.red : AppColor.lightBlack,
//                         ),
//                       ))
//
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               '${quiz.subject} • ${quiz.className}',
//               style: GoogleFont.ibmPlexSans(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 color: AppColor.grey,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _completedHeader(QuizData quiz) {
//     final SubmitData? r = c.submitRx.value; // API result (score/total)
//     final int shownScore = r?.score ?? c.answeredCount;
//     final int shownTotal = r?.total ?? c.totalQuestions;
//     final double pct = shownTotal == 0 ? 0.0 : shownScore / shownTotal;
//
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.white, AppColor.quizGreen.withOpacity(0.9)],
//         ),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(25),
//           bottomRight: Radius.circular(25),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: AppColor.lightGrey,
//                     border: Border.all(color: AppColor.lightGrey, width: 1),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8),
//                     child: Image.asset(
//                       AppImages.leftArrow,
//                       height: 17,
//                       width: 17,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 Text(
//                   '${quiz.heading}',
//                   style: GoogleFont.ibmPlexSans(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: AppColor.black,
//                   ),
//                 ),
//               ],
//             ),
//             /*       const SizedBox(height: 15),
//             CustomTextField.textWithSmall(
//               fontSize: 40,
//               fontWeight: FontWeight.w800,
//               text: r != null ? 'Well done!' : 'Great!',
//               color: AppColor.greenMore1,
//             ),*/
//             /*  const SizedBox(height: 10),
//             CustomTextField.textWithSmall(
//               text: '$shownScore out of $shownTotal',
//               color: AppColor.black,
//               fontSize: 18,
//             ),*/
//             const SizedBox(height: 22),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: LinearProgressIndicator(
//                 minHeight: 6,
//                 value: pct.clamp(0.0, 1.0),
//                 backgroundColor: AppColor.lowGery1,
//                 valueColor: AlwaysStoppedAnimation<Color>(AppColor.greenMore1),
//               ),
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _progressBar() {
//     final total = c.totalQuestions;
//     final answered = c.answeredCount;
//     final value = total == 0 ? 0.0 : answered / total;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: LinearProgressIndicator(
//         minHeight: 6,
//         value: value.clamp(0.0, 1.0),
//         backgroundColor: AppColor.lowGery1,
//         valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
//       ),
//     );
//   }
//
//   // ---------- Questions & Options ----------
//   List<Widget> _buildQuestionBlocks(QuizData quiz) {
//     final widgets = <Widget>[];
//     for (int i = 0; i < quiz.questions.length; i++) {
//       final q = quiz.questions[i];
//       widgets.addAll([
//         CustomTextField.quizQuestion(sno: '${i + 1}.', text: q.text),
//         const SizedBox(height: 15),
//         ..._buildOptionsForQuestion(q),
//         const SizedBox(height: 35),
//       ]);
//     }
//     return widgets;
//   }
//
//   // Always render 4 slots (pad missing with placeholders)
//   List<Widget> _buildOptionsForQuestion(Question q) {
//     final base = q.options.length > 4 ? q.options.take(4).toList() : q.options;
//     final List<OptionItem?> filled = List<OptionItem?>.from(base);
//     while (filled.length < 4) filled.add(null);
//
//     // If any real option is long → stacked cards
//     final hasLong = base.any((o) => !_isShort(o.text));
//     if (hasLong) {
//       return [
//         for (int i = 0; i < 4; i++) ...[
//           CustomContainer.quizContainer1(
//             isQuizCompleted: false,
//             isSelected: filled[i] != null && c.isSelected(q.id, filled[i]!.id),
//             onTap:
//                 filled[i] == null
//                     ? null
//                     : () => c.selectOption(
//                       questionId: q.id,
//                       optionId: filled[i]!.id,
//                     ),
//             leftTextNumber: filled[i] == null ? '' : _letter(i),
//             leftValue: filled[i]?.text ?? '',
//           ),
//           const SizedBox(height: 16),
//         ],
//       ];
//     }
//
//     // Short text → two rows of two (placeholders stay transparent)
//     return [
//       CustomContainer.quizContainer(
//         isQuizCompleted: false,
//         leftTextNumber: filled[0] == null ? '' : _letter(0),
//         leftValue: filled[0]?.text ?? '',
//         rightTextNumber: filled[1] == null ? '' : _letter(1),
//         rightValue: filled[1]?.text ?? '',
//         leftSelected: filled[0] != null && c.isSelected(q.id, filled[0]!.id),
//         rightSelected: filled[1] != null && c.isSelected(q.id, filled[1]!.id),
//         leftOnTap:
//             filled[0] == null
//                 ? null
//                 : () =>
//                     c.selectOption(questionId: q.id, optionId: filled[0]!.id),
//         rightOnTap:
//             filled[1] == null
//                 ? null
//                 : () =>
//                     c.selectOption(questionId: q.id, optionId: filled[1]!.id),
//       ),
//       const SizedBox(height: 20),
//       CustomContainer.quizContainer(
//         isQuizCompleted: false,
//         leftTextNumber: filled[2] == null ? '' : _letter(2),
//         leftValue: filled[2]?.text ?? '',
//         rightTextNumber: filled[3] == null ? '' : _letter(3),
//         rightValue: filled[3]?.text ?? '',
//         leftSelected: filled[2] != null && c.isSelected(q.id, filled[2]!.id),
//         rightSelected: filled[3] != null && c.isSelected(q.id, filled[3]!.id),
//         leftOnTap:
//             filled[2] == null
//                 ? null
//                 : () =>
//                     c.selectOption(questionId: q.id, optionId: filled[2]!.id),
//         rightOnTap:
//             filled[3] == null
//                 ? null
//                 : () =>
//                     c.selectOption(questionId: q.id, optionId: filled[3]!.id),
//       ),
//     ];
//   }
//
//   // ---------- Utils ----------
//   Widget _errorState(String msg) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.error_outline, size: 40),
//             const SizedBox(height: 12),
//             Text(msg, textAlign: TextAlign.center),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: () => c.loadQuiz(quizId: widget.quizId),
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /*String _formatTime(int seconds) {
//     final m = (seconds ~/ 60).toString().padLeft(2, '0');
//     final s = (seconds % 60).toString().padLeft(2, '0');
//     return '$m:$s';
//   }*/
//
//
//   String _formatTime(int seconds) {
//     final m = (seconds ~/ 60).toString().padLeft(2, '0');
//     final s = (seconds % 60).toString().padLeft(2, '0');
//     return '$m:$s';
//   }
//
//   /// Red when very low (<= 10s) OR within last 10% of total time.
//   /// Pass `totalSeconds` if you want the 10% rule; otherwise it only uses <= 10s.
//   bool _isCritical(int remainingSeconds, {int? totalSeconds}) {
//     final lowAbsolute = remainingSeconds <= 10; // last 10 seconds
//     final lowRelative = totalSeconds != null
//         ? remainingSeconds <= (totalSeconds * 0.10).ceil()
//         : false;
//     return lowAbsolute || lowRelative;
//   }
//
//   /// Helper to get the color for the timer text
//   Color _timeColor(int remainingSeconds, {int? totalSeconds}) {
//     return _isCritical(remainingSeconds, totalSeconds: totalSeconds)
//         ? Colors.red
//         : AppColor.black; // use whatever your normal color is
//   }
//
//
//   bool _isShort(String s) {
//     final t = s.trim();
//     return t.length <= 30 && !t.contains('\n');
//   }
//
//   String _letter(int index) {
//     const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
//     if (index >= 0 && index < letters.length) return letters[index];
//     return '?';
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Core/Utility/app_color.dart';
import '../../../../Core/Utility/app_images.dart';
import '../../../../Core/Utility/app_loader.dart';
import '../../../../Core/Utility/google_font.dart' as gf;
import '../../../../Core/Widgets/bottom_navigationbar.dart';
import '../../../../Core/Widgets/custom_container.dart';
import '../../../../Core/Widgets/custom_textfield.dart';
import '../Task Screen/task_screen.dart';
import 'Quiz Screen/Model/quiz_attend.dart';
import 'Quiz Screen/Model/quiz_submit.dart';
import 'Quiz Screen/controller/quiz_controller.dart';

class QuizScreen extends StatefulWidget {
  final int quizId;
  const QuizScreen({super.key, required this.quizId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizController c = Get.put(QuizController());
  bool isQuizCompleted = false;

  // Ensure time-up triggers ONCE
  bool _handledTimeUp = false;
  Worker? _timeWorker;

  @override
  void initState() {
    super.initState();
    c.loadQuiz(quizId: widget.quizId);

    // Robust: fire when remainingSeconds changes to <= 0
    _timeWorker = ever<int>(c.remainingSeconds, (sec) async {
      if (sec <= 0 && !_handledTimeUp) {
        _handledTimeUp = true;
        await _onTimeUp();
      }
    });
  }

  @override
  void dispose() {
    _timeWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              final quiz = c.quizRx.value;
              if (c.loadQuizLoading.value) {
                return Center(child: AppLoader.circularLoader());
              }

              if (quiz == null) {
                return const Center(child: Text('No quiz data'));
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isQuizCompleted
                        ? _completedHeader(quiz)
                        : _activeHeader(quiz),
                    if (!isQuizCompleted) _progressBar(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(children: _buildQuestionBlocks(quiz)),
                    ),
                    const SizedBox(height: 30),

                    // Submit button
                    Obx(() {
                      final submitting = c.isSubmitting.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: IgnorePointer(
                          ignoring: submitting,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: submitting ? 0.5 : 1.0,
                            child: CustomContainer.checkMark(
                              imagePath: AppImages.tick,
                              onTap: () async {
                                if (c.isSubmitting.isTrue) return;

                                final ok = await c.submitCurrent(
                                  quizId: widget.quizId,
                                );
                                final success =
                                    (ok == true) || (c.submitRx.value != null);

                                if (success) {
                                  _showSnack('Submit success', isError: false);
                                  // setState(() => isQuizCompleted = true); // optional
                                } else {
                                  _showSnack(
                                    'Submit failed. Try again.',
                                    isError: true,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),

            // Submitting overlay
            Obx(
              () =>
                  c.isSubmitting.value
                      ? Container(
                        color: Colors.black.withOpacity(0.15),
                        child: Center(child: AppLoader.circularLoader()),
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────── Headers ─────────────────────────

  Widget _activeHeader(QuizData quiz) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColor.lightGrey,
                  border: Border.all(color: AppColor.lowLightBlue, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(CupertinoIcons.left_chevron, color: AppColor.grey),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                quiz.heading,
                style: gf.GoogleFont.ibmPlexSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.grayop, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 7,
                  ),
                  child: Row(
                    children: [
                      Image.asset(AppImages.clockIcon, width: 18, height: 17),
                      const SizedBox(width: 5),
                      // Fallback trigger: if worker misses, run here too
                      Obx(() {
                        final secs = c.remainingSeconds.value;

                        if (secs <= 0 && !_handledTimeUp) {
                          _handledTimeUp = true;
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _onTimeUp(),
                          );
                        }

                        return Text(
                          _formatTime(secs),
                          style: gf.GoogleFont.ibmPlexSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                secs <= 10 ? Colors.red : AppColor.lightBlack,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${quiz.subject} • ${quiz.className}',
              style: gf.GoogleFont.ibmPlexSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColor.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _completedHeader(QuizData quiz) {
    final SubmitData? r = c.submitRx.value; // API result (score/total)
    final int shownScore = r?.score ?? c.answeredCount;
    final int shownTotal = r?.total ?? c.totalQuestions;
    final double pct = shownTotal == 0 ? 0.0 : shownScore / shownTotal;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, AppColor.quizGreen.withOpacity(0.9)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.lightGrey,
                    border: Border.all(color: AppColor.lightGrey, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      AppImages.leftArrow,
                      height: 17,
                      width: 17,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  quiz.heading,
                  style: gf.GoogleFont.ibmPlexSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: pct.clamp(0.0, 1.0),
                backgroundColor: AppColor.lowGery1,
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.greenMore1),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _progressBar() {
    final total = c.totalQuestions;
    final answered = c.answeredCount;
    final value = total == 0 ? 0.0 : answered / total;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: LinearProgressIndicator(
        minHeight: 6,
        value: value.clamp(0.0, 1.0),
        backgroundColor: AppColor.lowGery1,
        valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
      ),
    );
  }

  // ───────────────────── Questions & Options ─────────────────────

  List<Widget> _buildQuestionBlocks(QuizData quiz) {
    final widgets = <Widget>[];
    for (int i = 0; i < quiz.questions.length; i++) {
      final q = quiz.questions[i];
      widgets.addAll([
        CustomTextField.quizQuestion(sno: '${i + 1}.', text: q.text),
        const SizedBox(height: 15),
        ..._buildOptionsForQuestion(q),
        const SizedBox(height: 35),
      ]);
    }
    return widgets;
  }

  // Always render 4 slots (pad missing with placeholders)
  List<Widget> _buildOptionsForQuestion(Question q) {
    final base = q.options.length > 4 ? q.options.take(4).toList() : q.options;
    final List<OptionItem?> filled = List<OptionItem?>.from(base);
    while (filled.length < 4) filled.add(null);

    // If any real option is long → stacked cards
    final hasLong = base.any((o) => !_isShort(o.text));
    if (hasLong) {
      return [
        for (int i = 0; i < 4; i++) ...[
          CustomContainer.quizContainer1(
            isQuizCompleted: false,
            isSelected: filled[i] != null && c.isSelected(q.id, filled[i]!.id),
            onTap:
                filled[i] == null
                    ? null
                    : () => c.selectOption(
                      questionId: q.id,
                      optionId: filled[i]!.id,
                    ),
            leftTextNumber: filled[i] == null ? '' : _letter(i),
            leftValue: filled[i]?.text ?? '',
          ),
          const SizedBox(height: 16),
        ],
      ];
    }

    // Short text → two rows of two (placeholders stay transparent)
    return [
      CustomContainer.quizContainer(
        isQuizCompleted: false,
        leftTextNumber: filled[0] == null ? '' : _letter(0),
        leftValue: filled[0]?.text ?? '',
        rightTextNumber: filled[1] == null ? '' : _letter(1),
        rightValue: filled[1]?.text ?? '',
        leftSelected: filled[0] != null && c.isSelected(q.id, filled[0]!.id),
        rightSelected: filled[1] != null && c.isSelected(q.id, filled[1]!.id),
        leftOnTap:
            filled[0] == null
                ? null
                : () =>
                    c.selectOption(questionId: q.id, optionId: filled[0]!.id),
        rightOnTap:
            filled[1] == null
                ? null
                : () =>
                    c.selectOption(questionId: q.id, optionId: filled[1]!.id),
      ),
      const SizedBox(height: 20),
      CustomContainer.quizContainer(
        isQuizCompleted: false,
        leftTextNumber: filled[2] == null ? '' : _letter(2),
        leftValue: filled[2]?.text ?? '',
        rightTextNumber: filled[3] == null ? '' : _letter(3),
        rightValue: filled[3]?.text ?? '',
        leftSelected: filled[2] != null && c.isSelected(q.id, filled[2]!.id),
        rightSelected: filled[3] != null && c.isSelected(q.id, filled[3]!.id),
        leftOnTap:
            filled[2] == null
                ? null
                : () =>
                    c.selectOption(questionId: q.id, optionId: filled[2]!.id),
        rightOnTap:
            filled[3] == null
                ? null
                : () =>
                    c.selectOption(questionId: q.id, optionId: filled[3]!.id),
      ),
    ];
  }

  // ─────────────────────────── Utils ───────────────────────────

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  bool _isShort(String s) {
    final t = s.trim();
    return t.length <= 30 && !t.contains('\n');
  }

  String _letter(int index) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (index >= 0 && index < letters.length) return letters[index];
    return '?';
  }

  // Red alert + navigate to TaskScreen on time up
  Future<void> _onTimeUp() async {
    if (!mounted) return;

    _showSnack('Time up!', isError: true);

    // (Optional) auto-submit here if required by your product:
    // await c.submitCurrent(quizId: widget.quizId);

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    // Use GetX navigation (or Navigator version below)
    Get.offAll(() => CommonBottomNavigation(initialIndex: 2));

    // Navigator alternative:
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (_) => const TaskScreen()),
    //   (_) => false,
    // );
  }

  void _showSnack(String msg, {bool isError = false}) {
    final bg = isError ? Colors.red.shade600 : Colors.green.shade600;
    final icon = isError ? Icons.error_outline : Icons.check_circle_outline;

    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Text(
        msg,
        style: gf.GoogleFont.ibmPlexSans(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: bg,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      icon: Icon(icon, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }
}
