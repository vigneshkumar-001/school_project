import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';

import '../../../../Core/Utility/app_color.dart' show AppColor;
import '../../../../Core/Utility/google_font.dart' show GoogleFont;
import 'change_mobile_number.dart' show ChangeMobileNumber;

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                          Image.asset(
                            AppImages.moreStopImage,
                            fit: BoxFit.cover,
                          ),
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
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ChangeMobileNumber(),
                                      ),
                                    );
                                  },
                                  child: Row(
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
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.white,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        child: Image.asset(
                                          AppImages.moreSnumberAdd,
                                          height: 13,
                                        ),
                                      ),
                                    ],
                                  ),
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
                              height: 60,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 70,
                  bottom: 1,
                  child: Image.asset(AppImages.moreSimage1, height: 90),
                ),
              ],
            ),
            SizedBox(height: 20),
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Payment History'),
                      Tab(text: 'Teachers'),
                      Tab(text: 'Contact School'),
                    ],
                    controller: _tabController,
                    labelColor: AppColor.lightBlack,
                    unselectedLabelColor: AppColor.grey,
                    indicatorColor: AppColor.lightBlack,
                    labelStyle: GoogleFont.ibmPlexSans(
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: GoogleFont.ibmPlexSans(
                      fontWeight: FontWeight.w600,
                    ),
                    dividerColor: Colors.transparent,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 600,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        CustomContainer.moreScreen(
                          termTitle: 'Third-Term Fees',
                          timeDate: '8 Jan 26',
                          amount: 'Rs. 15000',
                          isPaid: false,
                          onDetailsTap: () {},
                        ),

                        CustomContainer.moreScreen(
                          termTitle: 'Second-Term Fees',
                          timeDate: '12.30Pm - 8 Dec 25',
                          amount: 'Rs. 15000',
                          isPaid: true,
                          onDetailsTap: () {},
                        ),
                        CustomContainer.moreScreen(
                          termTitle: 'First-Term Fees',
                          timeDate: '12.30Pm - 2 Jun 25',
                          amount: 'Rs. 15000',
                          isPaid: true,
                          onDetailsTap: () {},
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 17,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              CustomContainer.teacherTab(
                                teachresName: 'Vasanth',
                                classTitle: 'Tamil - Class Teacher',
                                teacherImage: AppImages.teacher1,
                              ),
                              SizedBox(width: 17),
                              Column(
                                children: [
                                  CustomContainer.teacherTab(
                                    teachresName: 'Abishiek',
                                    classTitle: 'English',
                                    teacherImage: AppImages.teacher2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                CustomContainer.teacherTab(
                                  teachresName: 'Kumari',
                                  classTitle: 'Maths',
                                  teacherImage: AppImages.teacher3,
                                ),
                              ],
                            ),
                            SizedBox(width: 17),
                            Column(
                              children: [
                                CustomContainer.teacherTab(
                                  teachresName: 'Ponnamma',
                                  classTitle: 'Science',
                                  teacherImage: AppImages.teacher4,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Center(child: Text('Third Term Fees')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
