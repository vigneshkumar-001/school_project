import 'package:flutter/cupertino.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';

class CustomTextField {
  static textWith600({
    required String text,
    double fontSize = 18,
    Color? color = AppColor.lightBlack,
  }) {
    return Text(
      text,
      style: GoogleFont.ibmPlexSans(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static quizQuestion({required String sno, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sno, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  static textWithSmall({
    required String text,
    Color? color = AppColor.grayop,
    FontWeight? fontWeight = FontWeight.w500,
    double? fontSize = 16,
  }) {
    return Text(
      text,
      style: GoogleFont.ibmPlexSans(
        fontSize: fontSize!,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
