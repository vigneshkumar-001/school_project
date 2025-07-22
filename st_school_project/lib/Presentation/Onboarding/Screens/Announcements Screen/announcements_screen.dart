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
  void _feessSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.30,
          minChildSize: 0.15,
          maxChildSize: 0.50,
          expand: false,
          builder: (context, scrollController) {
            final items = [
              'Shoes',
              'Notebooks',
              'Tuition Fees',

            ];

            return Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColor.grayop,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Image.asset(AppImages.announcement2),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Third-Term Fees',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: AppColor.black,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'Due date',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 12,
                              color: AppColor.lowGrey,
                            ),
                          ),
                          Text(
                            '12-Dec-25',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 4),
                      Icon(
                        CupertinoIcons.clock_fill,
                        size: 30,
                        color: AppColor.grayop,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      items.length,
                          (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '${index + 1}. ${items[index]}',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 16,
                            color: AppColor.lightBlack,
                          ),
                        ),
                      ),
                    ),
                  ),SizedBox(height: 15,),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColor.blueG1, AppColor.blueG2],
                          begin: Alignment.topRight,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pay Rs.15,000',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColor.white,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              CupertinoIcons.right_chevron,
                              size: 14,
                              weight: 20,
                              color: AppColor.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
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
                  onDetailsTap: () => _feessSheet(context),
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
