import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/announcements_screen.dart';

import '../Utility/app_color.dart';
import '../Utility/app_images.dart';
import '../Utility/google_font.dart' show GoogleFont;

class CustomContainer {
  static homeScreen({String? text}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      // child: Container(
      //   decoration: BoxDecoration(
      //     border: Border.all(color: AppColor.grey.withOpacity(0.1)),
      //
      //     borderRadius: BorderRadius.circular(15),
      //   ),
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      //     child: Column(
      //       children: [
      //         Row(
      //           children: [
      //             Text(
      //               'Science Homework',
      //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      //             ),
      //          Spacer()        ,
      //             TextButton(
      //               onPressed: () {},
      //               child: Row(
      //                 children: [
      //                   Text(
      //                     'View',
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.w500,
      //                       color: AppColor.blue,
      //                     ),
      //                   ),
      //                   Padding(
      //                     padding: const EdgeInsets.only(left: 5.0),
      //                     child: Icon(
      //                       Icons.arrow_forward_ios_outlined,
      //                       color: AppColor.blue,
      //                       size: 11,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //         Text(
      //           'Lorem ipsum dolor sit amet, consectetur adipiscing elit \nMaecenas laoreet ullamcorper nulla...',
      //           style: TextStyle(fontSize: 12, color: AppColor.grey),
      //         ),
      //         SizedBox(height: 10),
      //         Divider(),
      //         SizedBox(height: 10),
      //         Row(
      //           children: [
      //             Text(
      //               'Assigned By',
      //               style: TextStyle(fontSize: 12, color: AppColor.grey),
      //             ),
      //             SizedBox(width: 4),
      //             Text(
      //               'Flora',
      //               style: TextStyle(
      //                 fontSize: 12,
      //                 color: Colors.black87,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //      Spacer(),
      //             Text(
      //               '4.35Pm | 18.7.25',
      //               style: TextStyle(color: AppColor.lowGrey, fontSize: 12),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  static taskScreen({
    required String homeWorkText,
    required String avatarImage,
    required String mainText,
    required String smaleText,
    required String time,
    required String aText1,
    required String aText2,
    required Color backRoundColor,
    Color? backRoundColors,
    Gradient? gradient,
    onIconTap,
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
                  Text(
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
                      Container(
                        decoration: BoxDecoration(
                          color: gradient == null ? backRoundColors : null,
                          gradient: gradient,
                          border: Border.all(
                            color: AppColor.lightGrey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          onPressed: onIconTap,
                          icon: Icon(
                            color: AppColor.white,
                            CupertinoIcons.right_chevron,
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
    IconData? iconData,
    double verticalPadding = 9,
    Color? gradientStartColor,
    Color? gradientEndColor,
  }) {
    return Stack(
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
    );
  }


}
