import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/announcements_screen.dart';

import '../../Presentation/Admssion/Screens/student_info_screen.dart';
import '../Utility/app_color.dart';
import '../Utility/app_images.dart';
import '../Utility/google_font.dart' show GoogleFont;
import 'package:cached_network_image/cached_network_image.dart';

class InputFormatterUtil {
  static List<TextInputFormatter> languageFormatter({required bool isTamil}) {
    return [
      FilteringTextInputFormatter.allow(
        RegExp(isTamil ? r'[\u0B80-\u0BFF\s]' : r'[a-zA-Z\s]'),
      ),
    ];
  }
}

final FocusNode nextFieldFocusNode = FocusNode();

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (homeWorkImage != null &&
                                homeWorkImage.toString().isNotEmpty)
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
                          maxLines: 2,
                          mainText,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColor.lightBlack,
                          ),
                        ),
                        Row(
                          children: [
                            subText.toString().isEmpty
                                ? Container()
                                : Expanded(
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    subText ?? '',
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.lightBlack,
                                    ),
                                  ),
                                ),
                            SizedBox(width: 40),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 20, // smaller than 25
                        backgroundColor:
                            Colors.transparent, // optional: remove background
                        child: ClipOval(
                          child: Image.network(
                            avatarImage,
                            fit: BoxFit.cover,
                            width: 40, // control size of image
                            height: 40, // same as width
                          ),
                        ),
                      ),

                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            CustomTextField.limitTo6(aText1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: AppColor.grey,
                            ),
                          ),
                          Text(
                            CustomTextField.limitTo6(aText2),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColor.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 6),
              Text(
                smaleText,
                style: GoogleFonts.inter(fontSize: 12, color: AppColor.grey),
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
                        border: Border.all(color: AppColor.lightGrey, width: 1),
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
      ),
    );
  }

  static Widget messageScreen({
    required String time,
    required String Date, // keep same param name to avoid breaking calls
    String? Reacts, // optional
    required Color backRoundColor,
    required String mainText,
    String? ImagePath, // optional
    String sentTo = '',
    VoidCallback? IconOntap,
  }) {
    final bool hasReacts = (Reacts != null && Reacts.trim().isNotEmpty);
    final bool hasImage = (ImagePath != null && ImagePath.trim().isNotEmpty);
    final bool hasExtras = hasReacts || hasImage; // controls alignment

    return Container(
      decoration: BoxDecoration(
        color: backRoundColor,
        border: Border.all(color: AppColor.lightGrey, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Send To: ',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColor.grey,
                  ),
                ),
                Text(
                  sentTo,
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColor.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // main text
            Text(
              mainText,
              style: GoogleFont.ibmPlexSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          // date
                          Text(
                            '${Date.toString()} ${time.toString()}',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColor.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (hasReacts) ...[
                  SizedBox(width: 5),
                  Text(
                    Reacts!,
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColor.grey,
                    ),
                  ),
                  SizedBox(width: 5),
                  InkWell(
                    onTap: IconOntap,
                    child: Image.asset(
                      ImagePath!,
                      height: 42,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ],
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
          // ✅ Network image with loader + error handling
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: CachedNetworkImage(
              imageUrl: backRoundImage,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder:
                  (context, url) => Container(
                    height: 180, // adjust to your card height
                    alignment: Alignment.center,
                    child: const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => const Icon(
                    Icons.broken_image,
                    size: 40,
                    color: Colors.grey,
                  ),
            ),
          ),

          // ✅ Gradient overlay
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
                borderRadius: const BorderRadius.only(
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
                        const Spacer(),
                        if (iconData != null)
                          Icon(iconData, size: 22, color: AppColor.white),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (additionalText1.isNotEmpty)
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
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  /*
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
          Image.network(backRoundImage),
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
*/

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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.grey.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Teacher Name
          Text(
            teachresName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFont.ibmPlexSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColor.black,
            ),
            textAlign: TextAlign.center,
          ),

          // Subject/Class title
          Text(
            classTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFont.ibmPlexSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColor.blue,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: teacherImage,
              height: 120,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder:
                  (context, url) => Container(
                    height: 180,
                    alignment: Alignment.center,
                    child: const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => const Icon(
                    Icons.broken_image,
                    size: 40,
                    color: Colors.grey,
                  ),
            ),
          ),
          /* ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: 120, // Fixed height
              width: double.infinity, // Stretch full width of container
              child: Image.network(
                teacherImage,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) =>
                        Container(color: AppColor.grey), // fallback placeholder
              ),
            ),
          ),*/
        ],
      ),
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

  /*
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
*/

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
    final bool leftIsPlaceholder =
        (leftOnTap == null &&
            leftTextNumber.trim().isEmpty &&
            leftValue.trim().isEmpty);
    final bool rightIsPlaceholder =
        (rightOnTap == null &&
            rightTextNumber.trim().isEmpty &&
            rightValue.trim().isEmpty);

    return Row(
      children: [
        // LEFT
        Expanded(
          child: GestureDetector(
            onTap: leftIsPlaceholder ? null : leftOnTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                gradient:
                    leftIsPlaceholder
                        ? null
                        : (leftSelected
                            ? const LinearGradient(
                              colors: [Colors.white, Colors.white],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                            : null),
                color:
                    leftIsPlaceholder
                        ? Colors.transparent
                        : (leftSelected ? null : AppColor.lightGrey),
                borderRadius: BorderRadius.circular(16),
                border:
                    leftIsPlaceholder
                        ? null
                        : Border.all(
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
                    child:
                        leftIsPlaceholder
                            ? const SizedBox.shrink()
                            : CustomTextField.textWithSmall(
                              text: leftTextNumber,
                            ),
                  ),
                  Expanded(
                    child:
                        leftIsPlaceholder
                            ? const SizedBox.shrink()
                            : CustomTextField.textWithSmall(
                              text: leftValue,
                              fontWeight:
                                  leftSelected
                                      ? FontWeight.w800
                                      : FontWeight.w500,
                              color:
                                  leftSelected
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

        const SizedBox(width: 20),

        // RIGHT
        Expanded(
          child: GestureDetector(
            onTap: rightIsPlaceholder ? null : rightOnTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                gradient:
                    rightIsPlaceholder
                        ? null
                        : (rightSelected
                            ? const LinearGradient(
                              colors: [Colors.white, Colors.white],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                            : null),
                color:
                    rightIsPlaceholder
                        ? Colors.transparent
                        : (rightSelected ? null : AppColor.lightGrey),
                borderRadius: BorderRadius.circular(16),
                border:
                    rightIsPlaceholder
                        ? null
                        : Border.all(
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
                    child:
                        rightIsPlaceholder
                            ? const SizedBox.shrink()
                            : CustomTextField.textWithSmall(
                              text: rightTextNumber,
                            ),
                  ),
                  Expanded(
                    child:
                        rightIsPlaceholder
                            ? const SizedBox.shrink()
                            : CustomTextField.textWithSmall(
                              text: rightValue,
                              fontWeight:
                                  rightSelected
                                      ? FontWeight.w800
                                      : FontWeight.w500,
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

  static Widget quizContainer1({
    required String leftTextNumber,
    required String leftValue,
    required bool isSelected,
    VoidCallback? onTap,
    required bool isQuizCompleted,
  }) {
    final bool isPlaceholder =
        (onTap == null &&
            leftTextNumber.trim().isEmpty &&
            leftValue.trim().isEmpty);

    return GestureDetector(
      onTap: isPlaceholder ? null : onTap,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color:
                    isPlaceholder
                        ? Colors.transparent
                        : (isSelected ? Colors.white : AppColor.lightGrey),
                borderRadius: BorderRadius.circular(16),
                border:
                    isPlaceholder
                        ? null
                        : Border.all(
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
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child:
                          isPlaceholder
                              ? const SizedBox.shrink()
                              : CustomTextField.textWithSmall(
                                text: leftTextNumber,
                                color: AppColor.grayop,
                              ),
                    ),
                    Expanded(
                      flex: 6,
                      child:
                          isPlaceholder
                              ? const SizedBox.shrink()
                              : CustomTextField.textWithSmall(
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
    Function(String)? onChanged,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
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
    FocusNode? focusNode,
    Color borderColor = AppColor.lightRed,
  }) {
    DateTime today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColor.lowGery1,
            border: Border.all(
              color: isError ? AppColor.lightRed : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  flex: flex,
                  child: GestureDetector(
                    onTap:
                        isDOB && context != null
                            ? () async {
                              final DateTime startDate = DateTime(2021, 6, 1);
                              final DateTime endDate = DateTime(2022, 5, 31);
                              final DateTime initialDate = DateTime(2021, 6, 2);

                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: initialDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2025),
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
                                if (pickedDate.isBefore(startDate) ||
                                    pickedDate.isAfter(endDate)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Invalid Date of Birth!\nPlease select a date between 01-06-2021 and 31-05-2022.',
                                      ),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                } else {
                                  controller.text =
                                      "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";

                                  FocusScope.of(
                                    context,
                                  ).requestFocus(nextFieldFocusNode);
                                }
                              }
                            }
                            : null,

                    child: AbsorbPointer(
                      absorbing: isDOB,
                      child: TextFormField(
                        focusNode: focusNode,
                        onChanged: onChanged,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller,
                        validator: validator,
                        maxLines: maxLine,
                        maxLength:
                            isMobile
                                ? 10
                                : isAadhaar
                                ? 14
                                : isPincode
                                ? 6
                                : null,
                        keyboardType: keyboardType,
                        inputFormatters:
                            isMobile
                                ? [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ]
                                : isAadhaar
                                ? [
                                  FilteringTextInputFormatter.digitsOnly,
                                  AadhaarInputFormatter(),
                                ]
                                : isPincode
                                ? [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ]
                                : [],
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 14,
                          color: AppColor.black,
                        ),
                        decoration: InputDecoration(
                          hintText: '',
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: InputBorder.none,
                          isDense: true,
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
        ),
        if (errorText != null && errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 4),
            child: Text(
              errorText,
              style: GoogleFont.ibmPlexSans(
                color: AppColor.lightRed,
                fontSize: 12,
              ),
            ),
          ),
      ],
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
    String text2 = '',
    bool isError = false,

    Color borderColor = Colors.transparent,
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
              color: isChecked ? AppColor.white : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor ?? Colors.transparent,
                width: 1.5,
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
