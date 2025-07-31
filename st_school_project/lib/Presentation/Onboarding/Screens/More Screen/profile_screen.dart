import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Utility/google_font.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import '../../../../Core/Utility/app_color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder:
          (_) => Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take from Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (source == ImageSource.camera) {
        status = await Permission.camera.request();
      } else {
        if (sdkInt >= 33) {
          status = await Permission.photos.request();
        } else {
          status = await Permission.storage.request();
        }
      }
    } else if (Platform.isIOS) {
      if (source == ImageSource.camera) {
        status = await Permission.camera.request();
      } else {
        status = await Permission.photos.request();
      }
    } else {
      return;
    }

    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettingsDialog();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Permission denied.')));
    }
  }

  void openAppSettingsDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Permission Required'),
            content: Text(
              'Permission is permanently denied. Please enable it from app settings to continue.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
                child: Text('Open Settings'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.lightGrey,
                      border: Border.all(
                        color: AppColor.lowLightBlue,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        CupertinoIcons.left_chevron,
                        color: AppColor.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Apply Profile Picture",
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppColor.lightBlack,
                  ),
                ),
                const SizedBox(height: 30),

                GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Stack(
                    children: [
                      Container(
                        width: 350,
                        height: 582,
                        decoration: BoxDecoration(
                          color: AppColor.black,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 2,
                          ),
                          image: DecorationImage(
                            image:
                                _imageFile != null
                                    ? FileImage(_imageFile!)
                                    : AssetImage(AppImages.profilePicture)
                                        as ImageProvider,
                          ),
                        ),
                      ),
                      // Positioned(
                      //   bottom: 12,
                      //   right: 12,
                      //   child: CircleAvatar(
                      //     radius: 20,
                      //     backgroundColor: Colors.blue,
                      //     child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                CustomContainer.checkMark(
                  onTap: () => Navigator.pop(context),
                  imagePath: AppImages.tick,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
