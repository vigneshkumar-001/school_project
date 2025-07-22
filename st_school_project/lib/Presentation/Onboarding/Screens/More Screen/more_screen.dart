import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen.dart';

import '../../../../Core/Utility/app_color.dart' show AppColor;
import '../../../../Core/Utility/google_font.dart' show GoogleFont;
import 'change_mobile_number.dart' show ChangeMobileNumber;

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _lastValidTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.index == 3 && _tabController.indexIsChanging) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showContactSchoolSheet(context);

        _tabController.index = _lastValidTabIndex;
      });
    } else if (_tabController.index < 2) {
      _lastValidTabIndex = _tabController.index;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _showEditProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.30,
          minChildSize: 0.20,
          maxChildSize: 0.30,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 30,
                      decoration: BoxDecoration(color: AppColor.grayop),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: AppColor.lightGrey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(AppImages.phoneIcon, height: 24),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Change Mobile Number',
                          style: GoogleFont.ibmPlexSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColor.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '+91 900 000 0000',
                          style: GoogleFont.ibmPlexSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: AppColor.lightBlack,
                          ),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeMobileNumber(),
                          ),
                        );
                      },
                      child: Image.asset(
                        AppImages.rightArrow,
                        height: 16,
                        width: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  ListTile(
                    leading: Image.asset(AppImages.moreSimage1, height: 58),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Change',
                          style: GoogleFont.ibmPlexSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColor.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Profile Picture',
                          style: GoogleFont.ibmPlexSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: AppColor.lightBlack,
                          ),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProfileScreen()),
                        );
                      },
                      child: Image.asset(
                        AppImages.rightArrow,
                        height: 16,
                        width: 16,
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

  void _showContactSchoolSheet(BuildContext context) {
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
            return Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                padding: EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 30,
                      decoration: BoxDecoration(color: AppColor.grayop),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Call Landline Number',
                          style: GoogleFont.ibmPlexSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColor.grey,
                          ),
                        ),

                        Text(
                          '045 6000 0000 00',
                          style: GoogleFont.ibmPlexSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: AppColor.lightBlack,
                          ),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChangeMobileNumber(),
                          ),
                        );
                      },
                      child: Image.asset(
                        AppImages.phoneGreenIcon,
                        height: 58,
                        width: 58,
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

  void _feessSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.90,
          minChildSize: 0.15,
          maxChildSize: 0.70,
          expand: false,
          builder: (context, scrollController) {
            final items = ['Shoes', 'Notebooks', 'Tuition Fees'];

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
                  ),
                  SizedBox(height: 15),
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
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.moreSbackImage),
                        fit: BoxFit.cover,
                        alignment: Alignment(-6, -0.8),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [AppColor.white, AppColor.lowWhite],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(right: 15, left: 15, bottom: 25),
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
                                  onTap: () => _showEditProfileSheet(context),
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
                                      SizedBox(width: 5),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
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
                                          fontSize: 13,
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
                  Positioned(
                    right: 70,
                    bottom: 33,
                    child: Image.asset(AppImages.moreSimage1, height: 90),
                  ),
                ],
              ),
              SizedBox(height: 15),

              Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Payment History'),
                      Tab(text: 'Teachers'),
                      Tab(text: 'Contact School'),
                    ],
                    labelColor: AppColor.lightBlack,
                    unselectedLabelColor: AppColor.grey,
                    indicatorColor: AppColor.lightBlack,
                    labelStyle: GoogleFont.ibmPlexSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                    dividerColor: Colors.transparent,

                    onTap: (index) {
                      if (index == 2) {
                        _showContactSchoolSheet(context);

                        _tabController.index = _lastValidTabIndex;
                      }
                    },
                  ),

                  SizedBox(
                    height: 500,
                    child: TabBarView(
                      controller: _tabController,

                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              CustomContainer.moreScreen(
                                termTitle: 'Third-Term Fees',
                                timeDate: '8 Jan 26',
                                amount: 'Rs. 15000',
                                isPaid: false,
                                onDetailsTap: () => _feessSheet(context),
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 17,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CustomContainer.teacherTab(
                                    teachresName: 'Vasanth',
                                    classTitle: 'Tamil - Class Teacher',
                                    teacherImage: AppImages.teacher1,
                                  ),
                                  SizedBox(width: 17),
                                  CustomContainer.teacherTab(
                                    teachresName: 'Abishiek',
                                    classTitle: 'English',
                                    teacherImage: AppImages.teacher2,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  CustomContainer.teacherTab(
                                    teachresName: 'Kumari',
                                    classTitle: 'Maths',
                                    teacherImage: AppImages.teacher3,
                                  ),
                                  SizedBox(width: 17),
                                  CustomContainer.teacherTab(
                                    teachresName: 'Ponnamma',
                                    classTitle: 'Science',
                                    teacherImage: AppImages.teacher4,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox.shrink(),
                      ],
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
}
