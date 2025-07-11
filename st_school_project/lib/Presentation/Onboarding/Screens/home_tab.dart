import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/task_screen.dart';

import '../../../Core/Widgets/common_bottom_navigation_bar.dart'
    show CommonBottomNavigationBar;
import '../../../Core/Widgets/custom_container.dart';

class HomeTab extends StatefulWidget {
  final VoidCallback? onBackPressed;
  const HomeTab({super.key, this.onBackPressed});

  @override
  State<HomeTab> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeTab> {
  int index = 0;

  String selectedSubject = 'All'; // default selected

  final List<String> subjects = [
    'All',
    'Science',
    'English',
    'Social Science',
    'Maths',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  AppImages.schoolLogo,
                  height: 58,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                    ), // Add color!
                    text: 'Hi ',
                    children: [
                      TextSpan(
                        text: 'Jelastin',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ), // Optional
                      ),
                      TextSpan(
                        text: '!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColor.blue,
                        ),
                      ),
                    ],
                  ),
                ),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        text: '7',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.grey,
                          fontWeight: FontWeight.w800,
                        ),
                        children: [
                          TextSpan(text: 'th ', style: TextStyle(fontSize: 10)),
                          TextSpan(
                            text: 'Grade - ',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: 'C ',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.grey,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: 'Section',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: SizedBox(
                  height: 100,
                  width: 80,
                  child: Image.asset(AppImages.jesus, fit: BoxFit.cover),
                ),
              ),
              // SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColor.white, // light blue
                      AppColor.linear, // cyan
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [AppColor.blueG1, AppColor.blueG2],
                            ),
                            // border: Border.all(color: Colors.black12),
                            //  color: AppColor.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 15,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 20,
                                        ),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Image.asset(
                                                  AppImages.morning,
                                                  height: 48,
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  'Morning',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColor.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 9),
                                            SizedBox(
                                              height: 70,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: List.generate(7, (
                                                  index,
                                                ) {
                                                  return Container(
                                                    width: 2,
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          AppColor.lightGrey
                                                              .withOpacity(0.2),
                                                          AppColor.white
                                                              .withOpacity(0.2),
                                                        ], // gradient top to bottom
                                                        begin:
                                                            Alignment.topCenter,
                                                        end:
                                                            Alignment
                                                                .bottomCenter,
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                            SizedBox(width: 9),
                                            Column(
                                              children: [
                                                Image.asset(
                                                  AppImages.afternoon,
                                                  height: 48,
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  'Afternon',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColor.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Today',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.white,
                                            ),
                                          ),
                                          Text(
                                            '---',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: AppColor.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          height: 1,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                AppColor.lightGrey.withOpacity(
                                                  0.3,
                                                ),
                                                AppColor.lightGrey.withOpacity(
                                                  0.2,
                                                ),

                                                AppColor.white.withOpacity(0.1),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    TextButton(
                                      onPressed: () {
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'View All',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.lightGrey,
                                            ),
                                          ),
                                          SizedBox(width: 7),
                                          Image.asset(
                                            AppImages.rightArrow,
                                            height: 11,
                                            color: AppColor.lightGrey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  child: Image.asset(
                                    AppImages.greenTick,
                                    height: 20,
                                  ),
                                  top: 100,
                                  left: 35,
                                ),
                                Positioned(
                                  child: Image.asset(
                                    AppImages.greenTick,
                                    height: 20,
                                  ),
                                  top: 100,
                                  right: 35,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.centerRight,
                                  colors: [
                                    AppColor.orangeG1, // light blue
                                    AppColor.orangeG2, // cyan
                                    AppColor.orangeG3, // cyan
                                  ],
                                ),
                                // border: Border.all(color: Colors.black12),
                                // color: AppColor.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 95,
                                  right: 10,
                                  left: 10,
                                  bottom: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 50,
                                          right: 20,
                                          left: 20,
                                          bottom: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Prepare for',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.lightBlack,
                                              ),
                                            ),
                                            Text(
                                              'Examinations',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.black,
                                              ),
                                            ),
                                            SizedBox(height: 11),
                                            Text(
                                              'First Term Exam will \nbe nconducted on \n11.Jun.25 ',
                                              style: TextStyle(
                                                color: AppColor.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              child: Image.asset(AppImages.clock, height: 90),
                              left: 15,
                              top: 40,
                            ),
                            Positioned(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    AppColor.brown,
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Jun 11',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColor.yellow,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              right: 25,
                              top: 70,
                            ),
                          ],
                        ),

                        SizedBox(width: 15),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColor.greenG4.withOpacity(0.05),
                                AppColor.greenG2.withOpacity(0.5),
                                AppColor.greenG1,
                                AppColor.greenG4.withOpacity(0.6),
                              ],
                            ),
                            // border: Border.all(color: Colors.black12),
                            //  color: AppColor.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              left: 8,
                              right: 8,
                              bottom: 20,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColor.white,
                                            AppColor.white.withOpacity(0.1),
                                          ],
                                        ),

                                        borderRadius: BorderRadius.circular(10),
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 15,
                                          left: 15,
                                          right: 15,
                                          bottom: 60,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Upcoming Saturday\nHalf day School',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColor.black,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              textAlign: TextAlign.start,
                                              '16-Jun-25',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColor.grey,
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            IconButton(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 55,
                                              ),
                                              onPressed: () {},
                                              icon: Image.asset(
                                                AppImages.greenButtomArrow,
                                                height: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 25),
                                    Text(
                                      'Notice Board',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.lightBlack,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  child: Image.asset(AppImages.bag, height: 65),
                                  top: 160,
                                  left: 53,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.centerRight,
                                  colors: [
                                    AppColor.blueCG1, // light blue
                                    AppColor.blueCG2, // cyan
                                    AppColor.blueCG3, // cyan
                                  ],
                                ),
                                // border: Border.all(color: Colors.black12),
                                // color: AppColor.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 65,
                                  right: 10,
                                  left: 10,
                                  bottom: 8,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 30,
                                          right: 20,
                                          left: 15,
                                          bottom: 8,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                      AppColor.lightBlue,
                                                    ),
                                              ),
                                              onPressed: () {},
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                    ),
                                                child: Text(
                                                  'Jun 11',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColor.textBlue,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Second-Term \nFees',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.black,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Know More',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColor.blueG2,
                                                    ),
                                                  ),
                                                  SizedBox(width: 7),
                                                  Image.asset(
                                                    AppImages.rightArrow,
                                                    height: 10,
                                                    color: AppColor.blueG2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              child: Image.asset(AppImages.wallet, height: 100),
                              left: 20,
                              top: 8,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.centerRight,
                    colors: [AppColor.lightGrey, AppColor.white],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Your Tasks',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Text(
                                  'Today',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              subjects.map((subject) {
                                final isSelected = selectedSubject == subject;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      elevation: MaterialStatePropertyAll(0),
                                      backgroundColor: MaterialStatePropertyAll(
                                        isSelected
                                            ? AppColor.white
                                            : AppColor.lightGrey,
                                      ),
                                      side: MaterialStatePropertyAll(
                                        BorderSide(
                                          color:
                                              isSelected
                                                  ? AppColor.blue
                                                  : AppColor.lightGrey,
                                          width: 2,
                                        ),
                                      ),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        selectedSubject = subject;
                                      });
                                    },
                                    child: Text(
                                      subject,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? AppColor.blue
                                                : AppColor.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: CustomContainer.homeScreen(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: CustomContainer.homeScreen(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
