import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/announcements_screen.dart';

import '../Utility/app_color.dart';
import '../Utility/app_images.dart';
import '../Utility/google_font.dart' show GoogleFont;

class InputFormatterUtil {
  static List<TextInputFormatter> languageFormatter({required bool isTamil}) {
    return [
      FilteringTextInputFormatter.allow(
        RegExp(isTamil ? r'[\u0B80-\u0BFF\s]' : r'[a-zA-Z\s]'),
      ),
    ];
  }
}

class CustomContainer {
  static taskScreen({
    required String homeWorkText,
    required String avatarImage,
    required String mainText,
    String? subText,
    required String smaleText,
    required String time,
    required String aText1,
    required String aText2,
    required Color backRoundColor,
    Color? backRoundColors,
    Gradient? gradient,
    VoidCallback? onIconTap,
    String? homeWorkImage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: backRoundColor,
          border: Border.all(color: AppColor.lightGrey, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 20,
              top: 22,
              child: Column(
                children: [
                  CircleAvatar(radius: 25, child: Image.asset(avatarImage)),
                  SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      text: aText1,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColor.grey,
                      ),
                      children: [
                        TextSpan(
                          text: aText2,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColor.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (homeWorkImage != null && homeWorkImage.toString().isNotEmpty)
                      ? Image.asset(homeWorkImage, height: 60)
                      : Text(
                        homeWorkText,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColor.grey,
                        ),
                      ),

                  SizedBox(height: 6),
                  Text(
                    mainText,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.lightBlack,
                    ),
                  ),
                  SizedBox(height: 6),
                  subText.toString().isEmpty
                      ? Container()
                      : Text(
                        subText ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColor.lightBlack,
                        ),
                      ),
                  SizedBox(height: 6),
                  Text(
                    smaleText,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColor.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                          child: Text(
                            time,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColor.grey,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onIconTap,
                        child: Container(
                          decoration: BoxDecoration(
                            color: gradient == null ? backRoundColors : null,
                            gradient: gradient,
                            border: Border.all(
                              color: AppColor.lightGrey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Icon(
                              color: AppColor.white,
                              CupertinoIcons.right_chevron,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static announcementsScreen({
    required String mainText,
    required String backRoundImage,
    required String additionalText1,
    required String additionalText2,
    VoidCallback? onDetailsTap,
    IconData? iconData,
    double verticalPadding = 9,
    Color? gradientStartColor,
    Color? gradientEndColor,
  }) {
    return InkWell(
      onTap: onDetailsTap,
      child: Stack(
        children: [
          Image.asset(backRoundImage),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,

            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradientStartColor ?? AppColor.black.withOpacity(0.01),
                    gradientEndColor ?? AppColor.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: verticalPadding,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          mainText,
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.white,
                          ),
                        ),
                        Spacer(),
                        Icon(iconData, size: 22, color: AppColor.white),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (additionalText1 != '')
                              Text(
                                additionalText1,
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 12,
                                  color: AppColor.lightGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            Text(
                              additionalText2,
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 14,
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static moreScreen({
    required String termTitle,
    required String timeDate,
    required String amount,
    bool isPaid = true,
    VoidCallback? onDetailsTap,
  }) {
    return InkWell(
      onTap: onDetailsTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(15),
        ),
        child:
            isPaid
                ? ListTile(
                  title: Text(
                    'Paid for',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 12,
                      color: AppColor.lowGrey,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 7),
                      Text(
                        termTitle,
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 16,
                          color: AppColor.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        timeDate,
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 12,
                          color: AppColor.grey,
                        ),
                      ),
                      SizedBox(height: 7),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              'Details',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 10,
                                color: AppColor.lowGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 1),
                            Icon(
                              CupertinoIcons.right_chevron,
                              size: 10,
                              color: AppColor.lowGrey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    amount,
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 20,
                      color: AppColor.greenMore1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                : Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        termTitle,
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            amount,
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColor.blue,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: onDetailsTap,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColor.blueG1, AppColor.blueG2],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Pay Now',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      RichText(
                        text: TextSpan(
                          text: 'Due Date',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColor.grey,
                          ),
                          children: [
                            TextSpan(
                              text: ' $timeDate',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColor.lightBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  static teacherTab({
    required String teachresName,
    required String classTitle,
    required String teacherImage,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColor.grey.withOpacity(0.1)),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  teachresName,
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                ),
                Text(
                  classTitle,
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColor.blue,
                  ),
                ),
                SizedBox(height: 10),
                Image.asset(teacherImage, height: 135, width: 135),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static checkMark({required VoidCallback onTap, String? imagePath}) {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.blueG1, AppColor.blueG2],
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(17.0),
              child: Image.asset(imagePath ?? '', height: 20, width: 20),
            ),
          ),
        ),
      ),
    );
  }

  static Widget quizContainer({
    required String leftTextNumber,
    required String leftValue,
    required String rightTextNumber,
    required String rightValue,
    required bool leftSelected,
    required bool rightSelected,
    required bool isQuizCompleted,
    VoidCallback? leftOnTap,
    VoidCallback? rightOnTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: leftOnTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                gradient:
                    leftSelected
                        ? LinearGradient(
                          colors: [Colors.white, AppColor.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                        : null,
                color: leftSelected ? null : AppColor.lightGrey,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      leftSelected
                          ? (isQuizCompleted
                              ? AppColor.greenMore1
                              : AppColor.blue)
                          : AppColor.lightGrey,
                  width: leftSelected ? 3 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField.textWithSmall(text: leftTextNumber),
                  ),
                  Expanded(
                    child: CustomTextField.textWithSmall(
                      text: leftValue,
                      fontWeight:
                          leftSelected ? FontWeight.w800 : FontWeight.w500,
                      // color: leftSelected ? AppColor.blue : AppColor.black,
                      color:
                          leftSelected
                              ? (isQuizCompleted
                                  ? AppColor.greenMore1
                                  : AppColor.black)
                              : AppColor.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(width: 20),

        Expanded(
          child: GestureDetector(
            onTap: rightOnTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                gradient:
                    rightSelected
                        ? LinearGradient(
                          colors: [Colors.white, AppColor.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                        : null,
                color: rightSelected ? null : AppColor.lightGrey,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      rightSelected
                          ? (isQuizCompleted
                              ? AppColor.greenMore1
                              : AppColor.blue)
                          : AppColor.lightGrey,
                  width: rightSelected ? 3 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField.textWithSmall(text: rightTextNumber),
                  ),
                  Expanded(
                    child: CustomTextField.textWithSmall(
                      text: rightValue,
                      fontWeight:
                          rightSelected ? FontWeight.w800 : FontWeight.w500,

                      color:
                          rightSelected
                              ? (isQuizCompleted
                                  ? AppColor.greenMore1
                                  : AppColor.blue)
                              : AppColor.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static quizContainer1({
    required String leftTextNumber,
    required String leftValue,
    required bool isSelected,
    VoidCallback? onTap,
    required bool isQuizCompleted,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.white : AppColor.lightGrey,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      isSelected
                          ? (isQuizCompleted
                              ? AppColor.greenMore1
                              : AppColor.blue)
                          : AppColor.lightGrey,
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomTextField.textWithSmall(
                        text: leftTextNumber,

                        color: AppColor.grayop,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: CustomTextField.textWithSmall(
                        text: leftValue,

                        color:
                            isSelected
                                ? (isQuizCompleted
                                    ? AppColor.greenMore1
                                    : AppColor.blue)
                                : AppColor.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static leftSaitArrow({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.lightGrey,
          border: Border.all(color: AppColor.lowLightBlue, width: 1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Image.asset(
            AppImages.leftArrow,
            height: 14,
            color: AppColor.grey,
          ),
        ),
      ),
    );
  }

  static Widget studentInfoScreen({
    required String text,
    required TextEditingController controller,
    String? imagePath,
    bool verticalDivider = true,
    double imageSize = 20,
    int? maxLine,
    int flex = 4,
    bool isTamil = false,
    bool isAadhaar = false,
    bool isDOB = false,
    bool isMobile = false,
    bool isPincode = false,
    BuildContext? context,
    FormFieldValidator<String>? validator,
    bool isError = false,
    String? errorText,
    bool? hasError = false,
    Color borderColor = AppColor.lightRed,
  }) {
    DateTime today = DateTime.now();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColor.lowGery1,
        border: Border.all(
          color: isError ? AppColor.lightRed : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: flex,
              child: GestureDetector(
                onTap:
                    isDOB
                        ? () async {
                          DateTime firstDate = DateTime(today.year - 120);
                          DateTime lastDate = DateTime(
                            today.year - 3,
                            today.month,
                            today.day,
                          );

                          final pickedDate = await showDatePicker(
                            context: context!,
                            initialDate: lastDate,
                            firstDate: firstDate,
                            lastDate: lastDate,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  dialogBackgroundColor: AppColor.white,
                                  colorScheme: ColorScheme.light(
                                    primary: AppColor.blueG2,
                                    onPrimary: Colors.white,
                                    onSurface: AppColor.black,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColor.blueG2,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (pickedDate != null) {
                            int age = today.year - pickedDate.year;
                            if (pickedDate.month > today.month ||
                                (pickedDate.month == today.month &&
                                    pickedDate.day > today.day)) {
                              age--;
                            }

                            if (age < 3 || age > 120) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Date of Birth is Not eligible',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              controller.text =
                                  "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                            }
                          }
                        }
                        : null,
                child: AbsorbPointer(
                  absorbing: isDOB,
                  child: TextFormField(
                    controller: controller,
                    validator: validator,
                    maxLines: maxLine,
                    maxLength:
                        isMobile
                            ? 10
                            : isAadhaar
                            ? 12
                            : isPincode
                            ? 6
                            : null,
                    keyboardType:
                        isMobile || isAadhaar || isPincode
                            ? TextInputType.number
                            : isDOB
                            ? TextInputType.none
                            : TextInputType.text,
                    inputFormatters:
                        isMobile || isAadhaar || isPincode
                            ? [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                isMobile
                                    ? 10
                                    : isAadhaar
                                    ? 12
                                    : 6,
                              ),
                            ]
                            : InputFormatterUtil.languageFormatter(
                              isTamil: isTamil,
                            ),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: '',
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      errorText: errorText,
                    ),
                  ),
                ),
              ),
            ),

            if (verticalDivider)
              Container(
                width: 2,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey.shade200,
                      Colors.grey.shade300,
                      Colors.grey.shade200,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            const SizedBox(width: 20),

            if (imagePath == null)
              Expanded(
                child: CustomTextField.textWithSmall(
                  text: text,
                  fontSize: 14,
                  color: AppColor.grey,
                ),
              ),
            if (imagePath != null)
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Image.asset(
                  imagePath,
                  height: imageSize,
                  width: imageSize,
                ),
              ),
          ],
        ),
      ),
    );
  }

  static parentInfo({bool isSelected = true, required String text}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border:
            isSelected
                ? Border.all(color: AppColor.blue, width: 2)
                : Border.all(color: Colors.transparent, width: 0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: CustomTextField.textWithSmall(
          text: text,
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColor.blue : AppColor.grey,
        ),
      ),
    );
  }

  static Widget tickContainer({
    required bool isChecked,
    required VoidCallback onTap,
    required String text,
    String? text2,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: isChecked ? Colors.white : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isChecked ? AppColor.blue : Colors.transparent,
                width: 3,
              ),
            ),
            child:
                isChecked
                    ? Center(
                      child: Image.asset(
                        AppImages.tick,
                        height: 15,
                        color: AppColor.blue,
                      ),
                    )
                    : null,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: CustomTextField.richText(
            text: text,
            text2: text2 ?? '',
            fontWeight1: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  static myadmissions({
    required String maintext,
    required String subtext1,
    required String subtext2,
    required String iconText,
    VoidCallback? onTap,

    String imagepath = '',
    Color? backRoundColors,
    Color? iconColor,
    Color? iconTextColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.lightGrey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: backRoundColors,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                child: Column(
                  children: [
                    Image.asset(imagepath, height: 29, color: iconColor),
                    SizedBox(height: 4),
                    Text(
                      iconText,
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: iconTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maintext,
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.lightBlack,
                  ),
                ),
                SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    text: subtext1,
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 12,
                      color: AppColor.lowGrey,
                    ),
                    children: [
                      TextSpan(
                        text: subtext2,
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 12,
                          color: AppColor.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: onTap,
              child: Column(
                children: [
                  Image.asset(AppImages.downloadImage, height: 29),
                  SizedBox(height: 5),
                  Text(
                    'Download',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColor.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
