import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Presentation/Admssion/Screens/submit_the_admission.dart';

class RequiredPhotoScreens extends StatefulWidget {
  const RequiredPhotoScreens({super.key});

  @override
  State<RequiredPhotoScreens> createState() => _RequiredPhotoScreensState();
}

class _RequiredPhotoScreensState extends State<RequiredPhotoScreens> {
  List<bool> isChecked = [false, false, false, false, false];
  List<String> text = [
    'New online downloaded birth certifcate',
    'Community Certificate',
    'Baptism certifcate ',
    'Parents last received academic certificate',
    'Proof of Residence ',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.1, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.lightGrey,
                          border: Border.all(
                            color: AppColor.lowLightBlue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            AppImages.leftArrow,
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      '2025 - 2026 LKG Admission',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                LinearProgressIndicator(
                  minHeight: 6,
                  value: 0.9,

                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.blue),
                  stopIndicatorRadius: 16,
                  backgroundColor: AppColor.lowGery1,
                  borderRadius: BorderRadius.circular(16),
                ),
                SizedBox(height: 40),
                CustomTextField.textWith600(
                  text: 'Required Photo Copies',
                  fontSize: 26,
                ),
                SizedBox(height: 10),
                CustomTextField.textWithSmall(
                  text:
                      'Required Photo copies of the certificates to be attached with the downloaded application form',
                  color: AppColor.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                SizedBox(height: 20),
                CustomTextField.textWithSmall(
                  text: 'Xerox copy of',
                  color: AppColor.lightBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 20),
                Column(
                  children: List.generate(isChecked.length, (index) {
                    return Column(
                      children: [
                        CustomContainer.tickContainer(
                          text2:
                              index == 2
                                  ? 'for Catholics'
                                  : index == 4
                                  ? 'Ration Card | Aadhar Card | Voter Id'
                                  : '',

                          text: text[index],
                          isChecked: isChecked[index], // Pass a single bool
                          onTap: () {
                            setState(() {
                              isChecked[index] = !isChecked[index];
                            });
                          },
                        ),
                        SizedBox(height: 20),

                      ],
                    );
                  }),
                ),
                AppButton.button(
                  text: 'Save & Continue',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubmitTheAdmission(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
