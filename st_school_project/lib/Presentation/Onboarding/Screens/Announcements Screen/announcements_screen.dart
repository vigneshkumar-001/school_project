import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:st_school_project/Core/Utility/app_color.dart';

import '../../../../Core/Utility/app_images.dart' show AppImages;
import '../../../../Core/Utility/google_font.dart' show GoogleFont;
import '../../../../Core/Widgets/custom_container.dart' show CustomContainer;

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Announcements',
                    style: GoogleFont.ibmPlexSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      color: AppColor.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomContainer.announcementsScreen(
                  mainText: 'Today Special',
                  backRoundImage: AppImages.announcement1,
                  additionalText1: '',
                  additionalText2: '',
                  verticalPadding: 12,
                  gradientStartColor: AppColor.black.withOpacity(0.1),
                  gradientEndColor: AppColor.black,
                ),

                SizedBox(height: 20),
                CustomContainer.announcementsScreen(
                  mainText: 'Third-Term Fees',
                  backRoundImage: AppImages.announcement2,
                  iconData: CupertinoIcons.clock_fill,
                  additionalText1: 'Due date',
                  additionalText2: '12-Dec-25',
                  verticalPadding: 6,
                  gradientStartColor: AppColor.black.withOpacity(0.1),
                  gradientEndColor: AppColor.black,
                ),

                SizedBox(height: 20),
                CustomContainer.announcementsScreen(
                  mainText: 'Sports Day',
                  backRoundImage: AppImages.announcement3,
                  iconData: CupertinoIcons.clock_fill,
                  additionalText1: '',
                  additionalText2: '18-Jun-25',
                  verticalPadding: 12,
                  gradientStartColor: AppColor.black.withOpacity(0.1),
                  gradientEndColor: AppColor.black,
                ),
                SizedBox(height: 20),
                CustomContainer.announcementsScreen(
                  mainText: 'Parents Meeting',
                  backRoundImage: AppImages.announcement4,
                  iconData: CupertinoIcons.clock_fill,
                  additionalText1: '',
                  additionalText2: '20-Jun-25',
                  verticalPadding: 15,
                  gradientStartColor: AppColor.black.withOpacity(0.01),
                  gradientEndColor: AppColor.black,
                ),
                SizedBox(height: 20),
                CustomContainer.announcementsScreen(
                  mainText: 'Mid-Term Exam',
                  backRoundImage: AppImages.announcement5,
                  iconData: CupertinoIcons.clock_fill,
                  additionalText1: 'Starts on',
                  additionalText2: '20-Jun-25',
                  verticalPadding: 1,
                  gradientStartColor: AppColor.black.withOpacity(0.05),
                  gradientEndColor: AppColor.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
