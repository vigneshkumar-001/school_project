import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Presentation/Onboarding/Screens/More Screen/Login_screen/controller/login_controller.dart';
import '../Utility/app_color.dart';
import '../Utility/app_images.dart';
import '../Utility/google_font.dart';

class SwitchProfileSheet extends StatelessWidget {

  final RxList students; // List of student objects
  final Rx selectedStudent; // Currently selected student
  final Function(dynamic student) onSwitch; // Callback when a student is tapped
  final VoidCallback onLogout; // Callback for logout

   SwitchProfileSheet({
    super.key,
    required this.students,
    required this.selectedStudent,
    required this.onSwitch,
    required this.onLogout,
  });
  final LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.25,
      maxChildSize: 0.6,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Obx(() {
            if (students.isEmpty) {
              return Center(child: Text("No students available"));
            }

            return ListView(
              controller: scrollController,
              padding: EdgeInsets.all(16),
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 30,
                    decoration: BoxDecoration(color: Colors.grey[300]),
                  ),
                ),
                SizedBox(height: 20),

                // Header Row
                Row(
                  children: [
                    Text(
                      'Switch Profile',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: AppColor.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                              title: Text(
                                'Logout',
                                style: GoogleFont.ibmPlexSans(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'Are you sure you want to log out?',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 14,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFont.ibmPlexSans(
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.grey,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    loginController.logout();
                                    onLogout();
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder:
                                    //         (context) =>
                                    //   ChangeMobileNumber(
                                    //               page: 'splash',
                                    //             ),
                                    //
                                    //   ),
                                    // );
                                  },
                                  child: Text(
                                    'Log Out',
                                    style: GoogleFont.ibmPlexSans(
                                      color: AppColor.red01G1,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Image.asset(AppImages.logOut, height: 20),
                          SizedBox(width: 15),
                          Text(
                            'Logout',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColor.red01G1,
                            ),
                          ),
                        ],
                      ),
                    ),
                   /* InkWell(
                      onTap: onLogout,
                      child: Row(
                        children: [
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.logout, color: Colors.redAccent),
                        ],
                      ),
                    ),*/
                  ],
                ),
                SizedBox(height: 32),

                // Students List
                ...students.map((student) {
                  final isActive = student.id == selectedStudent.value?.id;
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      onSwitch(student);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isActive
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            isActive
                                ? Border.all(color: Colors.blue, width: 1.5)
                                : null,
                      ),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.network(
                              student.avatar ?? '',
                              width: 58,
                              height: 58,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  AppImages.moreSimage1,
                                  width: 58,
                                  height: 58,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  student.name ?? '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Class ${student.studentClass ?? ''} - ${student.section ?? ''}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 10),
                          if (isActive)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                'Active',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          }),
        );
      },
    );
  }

  static void show(
    BuildContext context, {
    required RxList students,
    required Rx selectedStudent,
    required Function(dynamic student) onSwitch,
    required VoidCallback onLogout,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => SwitchProfileSheet(
            students: students,
            selectedStudent: selectedStudent,
            onSwitch: onSwitch,
            onLogout: onLogout,
          ),
    );
  }
}
