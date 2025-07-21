import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';

import '../../../../Core/Utility/app_color.dart' show AppColor;
import '../../../../Core/Utility/google_font.dart' show GoogleFont;

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.moreSbackImage),
                    fit: BoxFit.cover,
                    alignment: Alignment(-10, -0.8),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [AppColor.white, AppColor.lowWhite],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(AppImages.moreStopImage, fit: BoxFit.cover),
                        SizedBox(height: 20),
                        ListTile(
                          title: RichText(
                            text: TextSpan(
                              text: 'Jelastin',
                              style: GoogleFont.ibmPlexSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: AppColor.black,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '+91 900 000 0000',
                                    style: GoogleFont.ibmPlexSans(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: AppColor.lightBlack,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Image.asset(
                                    AppImages.moreSnumberAdd,
                                    height: 13,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              RichText(
                                text: TextSpan(
                                  text: '7',
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 12,
                                    color: AppColor.grey,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'th ',
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 8,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Grade - ',
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 12,
                                        color: AppColor.grey,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'C ',
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 12,
                                        color: AppColor.grey,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Section',
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: Image.asset(
                            AppImages.moreSimage2,
                            height: 150,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 60,
                bottom: 0,
                child: Image.asset(AppImages.moreSimage1, height: 95),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Third-Term Fees',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Rs. 15000',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blue,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColor.blueG1, AppColor.blueG2],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(),
                                onPressed: () {},
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
                                text: ' 8 Jan 26',
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
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: RichText(
                          text: TextSpan(
                            text: 'Paid for',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 12,
                              color: AppColor.lowGrey,
                            ),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 7),
                            Text(
                              'Second-Term Fees',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                color: AppColor.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              '12.30Pm - 8 Dec 25',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 12,
                                color: AppColor.grey,
                              ),
                            ),

                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {},
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
                          ],
                        ),
                        trailing: Text(
                          'Rs. 15000',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 20,
                            color: AppColor.greenMore1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
