import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                        color: AppColor.grey,
                        CupertinoIcons.left_chevron,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
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
                      border: Border.all(color: AppColor.grayop, width: 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 9,
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
              SizedBox(height: 20),
              LinearProgressIndicator(value: 0.2),
            ],
          ),
        ),
      ),
    );
  }
}
