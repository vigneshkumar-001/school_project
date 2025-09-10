// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:st_school_project/Core/Utility/app_color.dart';
// import 'package:st_school_project/Core/Utility/app_images.dart';
// import 'package:st_school_project/Core/Utility/google_font.dart';
// import 'package:st_school_project/Core/Widgets/custom_container.dart';
// import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
//
// class QuizResult extends StatefulWidget {
//   const QuizResult({super.key});
//
//   @override
//   State<QuizResult> createState() => _QuizResultState();
// }
//
// class _QuizResultState extends State<QuizResult> {
//   Map<int, String> selectedAnswers = {};
//   int questionIndex = 0;
//   int selectedAnswerIndexQ1 = -1;
//   int selectedAnswerIndexQ2 = -1;
//   bool isQuizCompleted = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: isQuizCompleted ? 0 : 0,
//             vertical: isQuizCompleted ? 0 : 20,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.white,
//                         AppColor.quizGreen.withOpacity(
//                           0.9,
//                         ), // Light green bottom
//                       ],
//                     ),
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(25),
//                       bottomRight: Radius.circular(25),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 15,
//                       vertical: 20,
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: AppColor.lightGrey,
//                                 border: Border.all(
//                                   color: AppColor.lightGrey,
//                                   width: 1,
//                                 ),
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8),
//                                 child: Image.asset(
//                                   AppImages.leftArrow,
//                                   height: 17,
//                                   width: 17,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 15),
//                             Text(
//                               'Maths Quiz Result',
//                               style: GoogleFont.ibmPlexSans(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColor.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 15),
//                         CustomTextField.textWithSmall(
//                           fontSize: 40,
//                           fontWeight: FontWeight.w800,
//                           text: 'Great!',
//                           color: AppColor.greenMore1,
//                         ),
//                         SizedBox(height: 10),
//                         CustomTextField.textWithSmall(
//                           text: '2 out of 3',
//                           color: AppColor.black,
//                           fontSize: 18,
//                         ),
//                         SizedBox(height: 30),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: LinearProgressIndicator(
//                             minHeight: 6,
//                             value: 0.9,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               AppColor.greenMore1,
//                             ),
//                             stopIndicatorRadius: 16,
//                             backgroundColor: AppColor.lowGery1,
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         SizedBox(height: 50),
//                       ],
//                     ),
//                   ),
//                 ),
//                 /* : Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: AppColor.lightGrey,
//                                   border: Border.all(
//                                     color: AppColor.lowLightBlue,
//                                     width: 1,
//                                   ),
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                                 child: IconButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   icon: Icon(
//                                     CupertinoIcons.left_chevron,
//                                     color: AppColor.grey,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 15),
//                               Text(
//                                 'Maths Quiz',
//                                 style: GoogleFont.ibmPlexSans(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: AppColor.black,
//                                 ),
//                               ),
//                               Spacer(),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(
//                                     color: AppColor.grayop,
//                                     width: 1,
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 9,
//                                     vertical: 7,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Image.asset(
//                                         AppImages.clockIcon,
//                                         width: 18,
//                                         height: 17,
//                                       ),
//                                       SizedBox(width: 5),
//                                       Text(
//                                         '2.40',
//                                         style: GoogleFont.ibmPlexSans(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColor.lightBlack,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 25),
//                           LinearProgressIndicator(
//                             minHeight: 6,
//                             value: 0.2,
//
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               AppColor.blue,
//                             ),
//                             stopIndicatorRadius: 16,
//                             backgroundColor: AppColor.lowGery1,
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           SizedBox(height: 50),
//                         ],
//                       ),
//                     ),*/
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 15,
//                     vertical: 10,
//                   ),
//                   child: Column(
//                     children: [
//                       CustomTextField.quizQuestion(
//                         sno: '1.',
//                         text: 'What is 7 + 6?',
//                       ),
//                       SizedBox(height: 15),
//                       CustomContainer.quizContainer(
//                         isQuizCompleted: isQuizCompleted,
//                         leftTextNumber: 'A',
//                         leftValue: '11',
//                         rightTextNumber: 'B',
//                         rightValue: "12",
//                         leftSelected: selectedAnswerIndexQ1 == 0,
//                         rightSelected: selectedAnswerIndexQ1 == 1,
//                         leftOnTap: () {
//                           setState(() {
//                             selectedAnswerIndexQ1 = 0;
//                           });
//                         },
//                         rightOnTap: () {
//                           setState(() {
//                             selectedAnswerIndexQ1 = 1;
//                           });
//                         },
//                       ),
//                       SizedBox(height: 20),
//
//                       CustomContainer.quizContainer(
//                         isQuizCompleted: isQuizCompleted,
//                         leftTextNumber: 'C',
//                         leftValue: '13',
//                         rightTextNumber: 'D',
//                         rightValue: "14",
//                         leftSelected: selectedAnswerIndexQ1 == 2,
//                         rightSelected: selectedAnswerIndexQ1 == 3,
//                         leftOnTap: () {
//                           setState(() {
//                             selectedAnswerIndexQ1 = 2;
//                           });
//                         },
//                         rightOnTap: () {
//                           setState(() {
//                             selectedAnswerIndexQ1 = 3;
//                           });
//                         },
//                       ),
//                       SizedBox(height: 35),
//                       CustomTextField.quizQuestion(
//                         sno: '2.',
//                         text: 'What is the value of 5 × 3?',
//                       ),
//
//                       SizedBox(height: 15),
//                       CustomContainer.quizContainer(
//                         isQuizCompleted: isQuizCompleted,
//                         leftTextNumber: 'A',
//                         leftValue: '11',
//                         rightTextNumber: 'B',
//                         rightValue: "12",
//                         leftSelected: selectedAnswerIndexQ2 == 0,
//                         rightSelected: selectedAnswerIndexQ2 == 1,
//                         leftOnTap: () {
//                           setState(() {
//                             selectedAnswerIndexQ2 = 0;
//                           });
//                         },
//                         rightOnTap: () {
//                           setState(() {
//                             selectedAnswerIndexQ2 = 1;
//                           });
//                         },
//                       ),
//                       SizedBox(height: 20),
//
//                       CustomContainer.quizContainer(
//                         isQuizCompleted: isQuizCompleted,
//                         leftSelected: selectedAnswerIndexQ2 == 2,
//                         rightSelected: selectedAnswerIndexQ2 == 3,
//                         leftTextNumber: 'C',
//                         leftValue: '13',
//                         rightTextNumber: 'D',
//                         rightValue: "14",
//                         leftOnTap: () {
//                           setState(() {
//                             selectedAnswerIndexQ2 = 2;
//                           });
//                         },
//                         rightOnTap: () {
//                           setState(() {
//                             selectedAnswerIndexQ2 = 3;
//                           });
//                         },
//                       ),
//                       SizedBox(height: 35),
//                       CustomTextField.quizQuestion(
//                         sno: '3.',
//                         text:
//                             'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//                       ),
//                       SizedBox(height: 20),
//                       CustomContainer.quizContainer1(
//                         isQuizCompleted: isQuizCompleted,
//                         isSelected: selectedAnswers[questionIndex] == 'A',
//                         onTap: () {
//                           setState(() {
//                             selectedAnswers[questionIndex] = 'A';
//                           });
//                         },
//                         leftTextNumber: 'A',
//                         leftValue:
//                             'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
//                       ),
//                       SizedBox(height: 20),
//
//                       CustomContainer.quizContainer1(
//                         isQuizCompleted: isQuizCompleted,
//                         isSelected: selectedAnswers[questionIndex] == 'B',
//                         onTap: () {
//                           setState(() {
//                             selectedAnswers[questionIndex] = 'B';
//                           });
//                         },
//                         leftTextNumber: 'B',
//                         leftValue:
//                             'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
//                       ),
//                       SizedBox(height: 20),
//
//                       CustomContainer.quizContainer1(
//                         isQuizCompleted: isQuizCompleted,
//                         isSelected: selectedAnswers[questionIndex] == 'C',
//                         onTap: () {
//                           setState(() {
//                             selectedAnswers[questionIndex] = 'C';
//                           });
//                         },
//                         leftTextNumber: 'C',
//                         leftValue:
//                             'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
//                       ),
//                       SizedBox(height: 20),
//
//                       CustomContainer.quizContainer1(
//                         isQuizCompleted: isQuizCompleted,
//                         isSelected: selectedAnswers[questionIndex] == 'D',
//                         onTap: () {
//                           setState(() {
//                             selectedAnswers[questionIndex] = 'D';
//                           });
//                         },
//                         leftTextNumber: 'D',
//                         leftValue:
//                             'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(height: 30),
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       isQuizCompleted = !isQuizCompleted;
//                     });
//                   },
//                   child: Center(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         vertical: 15,
//                         horizontal: 25,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(color: AppColor.blue, width: 1),
//                       ),
//                       child: CustomTextField.textWithSmall(
//                         text: 'Go Home',
//                         color: AppColor.blue,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// lib/Presentation/Onboarding/Screens/More Screen/Quiz Screen/quiz_result_screen.dart
import 'package:dotted_border/dotted_border.dart' as dotted;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// project imports
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';

// your model
import 'Quiz Screen/Model/quiz_result_response.dart';

// dotted border
import 'package:dotted_border/dotted_border.dart' as d;

class QuizResultScreen extends StatefulWidget {
  final QuizResultData data;

  const QuizResultScreen({super.key, required this.data});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  late QuizResultData d;
  bool showOnlyCorrect = false;

  @override
  void initState() {
    super.initState();
    d = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    final pct = d.total == 0 ? 0.0 : (d.score / d.total);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context, d, pct),
              const SizedBox(height: 20),

              // Questions / Options
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    for (int i = 0; i < d.questions.length; i++) ...[
                      _questionBlock(
                        index: i,
                        q: d.questions[i],
                        onlyCorrect: showOnlyCorrect,
                      ),
                      const SizedBox(height: 28),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 8),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 22,
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
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Header ----------------
  Widget _header(BuildContext context, QuizResultData d, double pct) {
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
            // Top row
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
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
                ),

                const SizedBox(width: 15),
                Text(
                  '${d.heading} Result',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 15),

            // Big title
            CustomTextField.textWithSmall(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              text: _titleForScore(d.score, d.total),
              color: AppColor.greenMore1,
            ),
            const SizedBox(height: 10),

            // Score line
            CustomTextField.textWithSmall(
              text: '${d.score} out of ${d.total}',
              color: AppColor.black,
              fontSize: 18,
            ),
            const SizedBox(height: 22),

            // Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),

                child: LinearProgressIndicator(
                  minHeight: 6,
                  value: pct.clamp(0.0, 1.0),
                  borderRadius: BorderRadius.circular(16),
                  backgroundColor: AppColor.lowGery1,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColor.greenMore1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${(pct * 100).toStringAsFixed(0)}%',
              style: GoogleFont.ibmPlexSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColor.grey,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _titleForScore(int score, int total) {
    if (total <= 0) return 'No score yet';

    final p = score / total;
    if (p >= 0.9) return 'Great';
    if (p >= 0.7) return 'Average';
    if (p >= 0.5) return 'Need Attention';
    return 'Need Attention';
  }

  Widget _questionBlock({
    required int index,
    required QuestionResult q,
    bool onlyCorrect = false,
  }) {
    // filter list if onlyCorrect is ON
    final List<OptionResult> base =
        onlyCorrect
            ? q.options.where((o) => o.isCorrect || o.isSelected).toList()
            : q.options;

    // Always show up to 4 options, pad with nulls for placeholders
    final real = base.length > 4 ? base.take(4).toList() : base;
    final List<OptionResult?> padded = List<OptionResult?>.from(real);
    while (padded.length < 4) padded.add(null);

    final hasLong = real.any((o) => !_isShort(o.text));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField.quizQuestion(sno: '${index + 1}.', text: q.text),
        const SizedBox(height: 14),

        if (hasLong) ...[
          for (int i = 0; i < padded.length; i++) ...[
            _OptionTileLong(
              letter: padded[i] == null ? '' : _letter(i),
              text: padded[i]?.text ?? '',
              state: _stateForOption(q, padded[i]),
            ),
            const SizedBox(height: 14),
          ],
        ] else ...[
          // two rows of two
          _OptionRow(
            left: _OptionVM(
              letter: padded[0] == null ? '' : _letter(0),
              text: padded[0]?.text ?? '',
              state: _stateForOption(q, padded[0]),
            ),
            right: _OptionVM(
              letter: padded[1] == null ? '' : _letter(1),
              text: padded[1]?.text ?? '',
              state: _stateForOption(q, padded[1]),
            ),
          ),
          const SizedBox(height: 14),
          _OptionRow(
            left: _OptionVM(
              letter: padded[2] == null ? '' : _letter(2),
              text: padded[2]?.text ?? '',
              state: _stateForOption(q, padded[2]),
            ),
            right: _OptionVM(
              letter: padded[3] == null ? '' : _letter(3),
              text: padded[3]?.text ?? '',
              state: _stateForOption(q, padded[3]),
            ),
          ),
        ],

        const SizedBox(height: 2),
        Align(
          alignment: Alignment.centerLeft,
          // You can add a "Correct/Incorrect" badge here if you want
        ),
      ],
    );
  }

  _OptionState _stateForOption(QuestionResult q, OptionResult? opt) {
    if (opt == null) return _OptionState.placeholder;
    if (opt.isCorrect) return _OptionState.correct;
    if (opt.isSelected && !opt.isCorrect) return _OptionState.selectedWrong;
    return _OptionState.neutral;
  }

  // --------------- Small helpers ---------------
  bool _isShort(String s) {
    final t = s.trim();
    return t.length <= 30 && !t.contains('\n');
  }

  String _letter(int index) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (index >= 0 && index < letters.length) return letters[index];
    return '?';
  }
}

// --------------- Option widgets ---------------

enum _OptionState { correct, selectedWrong, neutral, placeholder }

class _OptionVM {
  final String letter;
  final String text;
  final _OptionState state;
  const _OptionVM({
    required this.letter,
    required this.text,
    required this.state,
  });
}

class _OptionRow extends StatelessWidget {
  final _OptionVM left;
  final _OptionVM right;
  const _OptionRow({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OptionTile(
            letter: left.letter,
            text: left.text,
            state: left.state,
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: _OptionTile(
            letter: right.letter,
            text: right.text,
            state: right.state,
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String letter;
  final String text;
  final _OptionState state;

  const _OptionTile({
    super.key,
    required this.letter,
    required this.text,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state == _OptionState.placeholder) {
      // Transparent placeholder keeps grid aligned
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.transparent, width: 2),
        ),
      );
    }

    final colors = _colorsFor(state);

    return _borderWrapper(
      p: colors,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: CustomTextField.textWithSmall(
                text: letter,

                color: colors.letter,
              ),
            ),
            Expanded(
              flex: 3,
              child: CustomTextField.textWithSmall(
                text: text,
                color: colors.text,
                fontWeight:
                    state == _OptionState.correct
                        ? FontWeight.w700
                        : FontWeight.w500,
              ),
            ),
            if (state == _OptionState.correct)
              Icon(
                CupertinoIcons.checkmark_alt_circle_fill,
                size: 18,
                color: colors.icon,
              ),
            if (state == _OptionState.selectedWrong)
              Icon(
                CupertinoIcons.xmark_circle_fill,
                size: 18,
                color: colors.icon,
              ),
          ],
        ),
      ),
    );
  }
}

class _OptionTileLong extends StatelessWidget {
  final String letter;
  final String text;
  final _OptionState state;
  const _OptionTileLong({
    super.key,
    required this.letter,
    required this.text,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state == _OptionState.placeholder) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.transparent, width: 2),
        ),
      );
    }

    final colors = _colorsFor(state);

    return _borderWrapper(
      p: colors,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField.textWithSmall(text: letter, color: colors.letter),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField.textWithSmall(
                text: text,
                color: colors.text,
                fontWeight:
                    state == _OptionState.correct
                        ? FontWeight.w700
                        : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            if (state == _OptionState.correct)
              Icon(
                CupertinoIcons.checkmark_alt_circle_fill,
                size: 18,
                color: colors.icon,
              ),
            if (state == _OptionState.selectedWrong)
              Icon(
                CupertinoIcons.xmark_circle_fill,
                size: 18,
                color: colors.icon,
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Palette + borders ----------------

class _OptionPalette {
  final Color border;
  final Color bg;
  final Color text;
  final Color letter;
  final Color icon;
  final bool dotted; // if true, use dotted border

  const _OptionPalette({
    required this.border,
    required this.bg,
    required this.text,
    required this.letter,
    required this.icon,
    this.dotted = false,
  });
}

_OptionPalette _colorsFor(_OptionState s) {
  switch (s) {
    case _OptionState.correct:
      return const _OptionPalette(
        border: AppColor.greenMore1, // solid bg only for correct
        bg: AppColor.white,
        text: AppColor.greenMore1,
        letter: AppColor.grayop,
        icon: AppColor.greenMore1,
        dotted: false,
      );
    case _OptionState.selectedWrong:
      return const _OptionPalette(
        border: Colors.redAccent, // red dotted
        bg: AppColor.white,
        text: Colors.redAccent,
        letter: AppColor.grayop,
        icon: Colors.redAccent,
        dotted: true, // <— key
      );
    case _OptionState.neutral:
      return const _OptionPalette(
        border: AppColor.lightGrey,
        bg: AppColor.lightGrey,
        text: AppColor.black,
        letter: AppColor.grayop,
        icon: AppColor.grey,
        dotted: false,
      );
    case _OptionState.placeholder:
      return const _OptionPalette(
        border: AppColor.greenMore1,
        bg: Colors.transparent,
        text: AppColor.greenMore1,
        letter: AppColor.grayop,
        icon: AppColor.grey,
        dotted: false,
      );
  }
}

Widget _borderWrapper({
  required _OptionPalette p,
  required Widget child,
  double radius = 16,
  double strokeWidth = 2,
}) {
  if (p.dotted) {
    // Red dotted border for wrong answers
    return dotted.DottedBorder(
      color: p.border, // ✅ exists
      strokeWidth: strokeWidth, // ✅ double
      dashPattern: [6.0, 3.0], // ✅ List<double>
      borderType: dotted.BorderType.RRect, // ✅ enum from dotted_border
      radius: Radius.circular(radius), // ✅ Radius
      strokeCap: StrokeCap.round, // (optional) nicer dots
      padding: EdgeInsets.zero, // ✅
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(color: p.bg, child: child),
      ),
    );
  }

  // Solid/transparent for other states
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: p.border,
        width: p.border == Colors.transparent ? 0 : strokeWidth,
      ),
      color: p.bg,
    ),
    child: child,
  );
}
