import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';

class AppButton {
  static button({
    BuildContext? context,
    VoidCallback? onTap,
    required String text,
  }) {
    return Center(
      child: SizedBox(
        width: 200,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.blueG1.withOpacity(0.9),
                AppColor.blueG2.withOpacity(0.8),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.white,
                  ),
                ),

                Image.asset(
                  AppImages.arrow,
                  height: 35,
                  width: 35,
                  color: AppColor.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
