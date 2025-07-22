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
  // Map to store selected option per question
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
