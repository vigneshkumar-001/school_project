import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
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

  static richText({required String text, required String text2,double secondFontSize = 15,FontWeight fontWeight = FontWeight.normal}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: GoogleFont.ibmPlexSans(fontSize: 15, color: AppColor.lightBlack),
        children: [
          if(text2 .isNotEmpty)
          TextSpan(
            text: '( ${text2} )',
            style: GoogleFont.ibmPlexSans(
              fontWeight: fontWeight,
              fontSize: secondFontSize,
              color: AppColor.lowGrey,
            ),
          ),
        ],
      ),
    );
  }
}
