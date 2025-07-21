import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../Core/Utility/app_color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColor.lightGrey,
                  border: Border.all(color: AppColor.lowLightBlue, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(color: AppColor.grey, CupertinoIcons.left_chevron),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
