import 'dart:math' as math;

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Widgets/custom_container.dart';
import 'package:st_school_project/Core/Widgets/custom_textfield.dart';
import 'package:st_school_project/Core/Widgets/swicth_profile_sheet.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen/controller/fees_history_controller.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen/controller/teacher_list_controller.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More%20Screen/profile_screen/screen/profile_screen.dart';

import '../../../../Core/Utility/app_color.dart' show AppColor;
import '../../../../Core/Utility/google_font.dart' show GoogleFont;
import '../../../Admssion/Screens/admission_1.dart';
import '../Home Screen/controller/student_home_controller.dart';
import 'Login_screen/controller/login_controller.dart';
import 'change_mobile_number.dart' show ChangeMobileNumber;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import 'profile_screen/model/fees_history_response.dart';
// --- grayscale matrix
const List<double> _kGrayscaleMatrix = <double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
];

Widget _avatarBox({
  required String? url,
  required double size,
  required bool isActive,
  required bool grayscale,
  required String fallbackAsset,
  required Color activeBorderColor,
}) {
  final img =
      (url != null && url.isNotEmpty)
          ? Image.network(
            url,
            height: size,
            width: size,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => Image.asset(
                  fallbackAsset,
                  height: size,
                  width: size,
                  fit: BoxFit.cover,
                ),
          )
          : Image.asset(
            fallbackAsset,
            height: size,
            width: size,
            fit: BoxFit.cover,
          );

  final filtered =
      grayscale
          ? ColorFiltered(
            colorFilter: const ColorFilter.matrix(_kGrayscaleMatrix),
            child: img,
          )
          : img;

  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: isActive ? activeBorderColor : Colors.white,
        width: isActive ? 2 : 1.5,
      ),
      boxShadow: [
        if (isActive)
          BoxShadow(
            color: activeBorderColor.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
      ],
    ),
    child: ClipRRect(borderRadius: BorderRadius.circular(15), child: filtered),
  );
}

class TwoProfileStack extends StatelessWidget {
  final dynamic active; // expects .avatar, .id
  final dynamic other; // expects .avatar, .id (can be null)
  final double size; // front(active) size
  final double? backSize; // grayscale(back) size
  final double overlapFraction; // 0..1 overlap based on min(front, back)
  final VoidCallback? onTap;
  final String fallbackAsset;
  final Color activeBorderColor;

  const TwoProfileStack({
    super.key,
    required this.active,
    required this.other,
    this.size = 49,
    this.backSize, // if null => size * 0.86
    this.overlapFraction = 0.45,
    this.onTap,
    required this.fallbackAsset,
    required this.activeBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final double _back = backSize ?? size * 0.86;
    final double h = math.max(size, _back);
    final double overlapPx = math.min(size, _back) * overlapFraction;

    final double w = (other == null) ? size : math.max(_back, overlapPx + size);
    final double frontTop = (h - size) / 2;
    final double backTop = (h - _back) / 2;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: w,
        height: h,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (other != null)
              Positioned(
                right: 0,
                top: backTop,
                child: _avatarBox(
                  url: other.avatar,
                  size: _back,
                  isActive: false,
                  grayscale: true, // back one B/W
                  fallbackAsset: fallbackAsset,
                  activeBorderColor: activeBorderColor,
                ),
              ),
            Positioned(
              right: other == null ? 0 : overlapPx,
              top: frontTop,
              child: _avatarBox(
                url: active?.avatar,
                size: size,
                isActive: true, // front active & color
                grayscale: false,
                fallbackAsset: fallbackAsset,
                activeBorderColor: activeBorderColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _lastValidTabIndex = 0;
  final double latitude = 9.91437026701036;
  final double longitude = 78.12740990716632;

  final StudentHomeController controller = Get.put(StudentHomeController());
  final LoginController loginController = Get.put(LoginController());
  final FeesHistoryController feesController = Get.put(FeesHistoryController());
  final TeacherListController teacherListController = Get.put(
    TeacherListController(),
  );

  Future<void> _openGoogleMap() async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch Google Maps');
    }
  }

  Future<void> _openPhoneBook() async {
    const phoneNumber = 'tel:+918248191110';

    final Uri url = Uri.parse(phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch dialer');
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    teacherListController.teacherListData();
    feesController.feesHistoryList();
  }

  void _handleTabChange() {
    if (_tabController.index == 2 && _tabController.indexIsChanging) {
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

  void _OTPonMobileNoEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.30,
          minChildSize: 0.20,
          maxChildSize: 0.50,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Obx(() {
                final data =
                    teacherListController.teacherListResponse.value?.data;
                return ListView(
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
                      title: GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // <- close bottom sheet first
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeMobileNumber(),
                            ),
                          );
                        },
                        child: Column(
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
                              data?.student_phone.toString() ?? "",
                              style: GoogleFont.ibmPlexSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: AppColor.lightBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.pop(context);
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

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProfileScreen()),
                        );
                      },
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            data?.student_image.toString() ?? '',
                            height: 55,
                            fit: BoxFit.cover,
                            width: 55,
                          ),
                        ),

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
                              MaterialPageRoute(
                                builder: (_) => ProfileScreen(),
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
                    ),
                  ],
                );
              }),
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
          initialChildSize: 0.32,
          minChildSize: 0.15,
          maxChildSize: 0.40,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Obx(() {
                final data =
                    teacherListController.teacherListResponse.value?.data;
                return ListView(
                  controller: scrollController,
                  shrinkWrap: true,

                  children: [
                    SizedBox(height: 15),
                    Center(
                      child: Container(
                        height: 4,
                        width: 30,
                        decoration: BoxDecoration(
                          color: AppColor.grayop,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField.textWith600(
                                color: AppColor.grey,
                                text: 'Call Landline Number',
                                fontSize: 14,
                              ),
                              CustomTextField.textWith600(
                                text: data?.school_contact.toString() ?? '',
                                fontSize: 24,
                              ),
                            ],
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () async {
                              final phoneNumber =
                                  'tel:${data?.school_contact.toString() ?? ''}';

                              final Uri url = Uri.parse(phoneNumber);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                print('Could not launch dialer');
                              }
                            },
                            child: Image.asset(
                              AppImages.phoneGreenIcon,
                              height: 55,
                              width: 55,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Stack(
                      children: [
                        Card(
                          margin: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                          child: InkWell(
                            onTap: _openGoogleMap,
                            child: SizedBox(
                              height: 122,

                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: FlutterMap(
                                  options: MapOptions(
                                    center: LatLng(
                                      9.914366964318729,
                                      78.12744008201622,
                                    ),

                                    zoom: 16,
                                    onTap: (tapPosition, point) {
                                      _openGoogleMap();
                                    },
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName:
                                          'com.fenizo.st_school_project.st_school_project',
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: LatLng(
                                            9.914366964318729,
                                            78.12744008201622,
                                          ),
                                          width: 50,
                                          height: 50,
                                          child: Icon(
                                            Icons.location_pin,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 22,
                          left: 25,
                          child: InkWell(
                            onTap: () => _openGoogleMap(),
                            child: Card(
                              elevation: 2,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  'View Large Map',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            );
          },
        );
      },
    );
  }

  void _feessSheet(BuildContext context, PlanItem plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.20,
          maxChildSize: 0.55,
          expand: false,
          builder: (context, scrollController) {
            final items = plan.items; // ✅ FeeItem list

            return Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // handle bar
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
                  const SizedBox(height: 20),

                  Image.asset(AppImages.announcement2),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          plan.name, // Plan title (Third Term Fee)
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
                            plan.dueDate, // ✅ from PlanItem
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        CupertinoIcons.clock_fill,
                        size: 30,
                        color: AppColor.grayop,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Fee breakdown list
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      items.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '${index + 1}. ${items[index].feeTypeName} - Rs.${items[index].amount} (${items[index].status})',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 16,
                            color: AppColor.lightBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () {
                      // TODO: payment API call
                    },
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
                              'Pay Rs.${plan.summary.totalAmount}',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColor.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
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

  /*  void _fessSheet(BuildContext context, PlanItem plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.20,
          maxChildSize: 0.55,
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
  }*/

  void Switchprofileorlogout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.30,
          minChildSize: 0.20,
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
                  Row(
                    children: [
                      Text(
                        'Switch Profile',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Logout',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightRed,
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: AppColor.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                title: Text(
                                  'Logout',
                                  style: GoogleFont.ibmPlexSans(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to log out?',
                                  style: GoogleFont.ibmPlexSans(fontSize: 14),
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
                    ],
                  ),
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Image.asset(AppImages.moreSimage1, height: 58),
                      SizedBox(width: 5),
                      Text(
                        'Anushka',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 18,
                          color: AppColor.black,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {},
                        child: Image.asset(AppImages.rightArrow, height: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset(AppImages.moreSimage1, height: 58),
                      SizedBox(width: 5),
                      Text(
                        'Swathi',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 18,
                          color: AppColor.black,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColor.blue, width: 1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                            child: Text(
                              'Active',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 7),
                      InkWell(
                        onTap: () {},
                        child: Image.asset(AppImages.rightArrow, height: 16),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _paymentReceipt(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.20,
          maxChildSize: 0.90,
          expand: false,
          builder: (context, scrollController) {
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
                  Column(
                    children: [
                      Image.asset(AppImages.paidImage, height: 98),
                      SizedBox(height: 14),
                      Text(
                        'Rs. 3500',
                        style: GoogleFont.ibmPlexSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 34,
                          color: AppColor.greenMore1,
                        ),
                      ),
                      Text(
                        'Paid to Third term fees',
                        style: GoogleFont.ibmPlexSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: AppColor.lightBlack,
                        ),
                      ),
                      SizedBox(height: 34),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.0),
                        child: DottedLine(
                          dashColor: AppColor.grayop,
                          dashGapLength: 6,
                          dashLength: 7,
                        ),
                      ),
                      SizedBox(height: 40),
                      Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              AppImages.examResultBCImage,
                              height: 250,
                              width: 280,
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.lightGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(17.0),
                                      child: Image.asset(
                                        AppImages.receiptNo,
                                        height: 24,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Receipt No',
                                        style: GoogleFont.ibmPlexSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: AppColor.grey,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'GJGFH87GHJG8II',
                                        style: GoogleFont.ibmPlexSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: AppColor.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 25),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.lightGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(17.0),
                                      child: Image.asset(
                                        AppImages.admissionNo,
                                        height: 24,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Admission No',
                                        style: GoogleFont.ibmPlexSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: AppColor.grey,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'SJIG9M4JK',
                                        style: GoogleFont.ibmPlexSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: AppColor.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 25),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.lightGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(17.0),
                                      child: Image.asset(
                                        AppImages.timeImage,
                                        height: 24,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Time',
                                        style: GoogleFont.ibmPlexSans(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: AppColor.grey,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      RichText(
                                        text: TextSpan(
                                          text: '12.00Pm   ',
                                          style: GoogleFont.ibmPlexSans(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: AppColor.black,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '16 Jun 2025',
                                              style: GoogleFont.ibmPlexSans(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                                color: AppColor.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.0),
                        child: DottedLine(
                          dashColor: AppColor.grayop,
                          dashGapLength: 6,
                          dashLength: 7,
                        ),
                      ),
                      SizedBox(height: 40),
                      GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 27,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColor.blue,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppImages.downloadImage,
                                    height: 20,
                                  ),
                                  SizedBox(width: 10),
                                  CustomTextField.textWithSmall(
                                    text: 'Download Receipt',
                                    color: AppColor.blue,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.moreSbackImage),
                      fit: BoxFit.cover,
                      alignment: const Alignment(-2, -0.8),
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [AppColor.white, AppColor.lowWhite],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 15,
                      left: 15,
                      bottom: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(AppImages.moreStopImage, fit: BoxFit.cover),
                        const SizedBox(height: 10),

                        Obx(() {
                          final data =
                              teacherListController
                                  .teacherListResponse
                                  .value
                                  ?.data;
                          final siblings = controller.siblingsList;

                          if (siblings.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          final activeStudent = siblings.firstWhere(
                            (s) => s.isActive == true,
                            orElse: () => siblings.first,
                          );

                          // find first "other" student (if exists)
                          final remainingStudent = siblings.firstWhere(
                            (s) => s.id != activeStudent.id,
                            orElse: () => siblings.first,
                          );

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: ListTile(
                              title: RichText(
                                text: TextSpan(
                                  text: data?.studentName.toString() ?? '',
                                  style: GoogleFont.ibmPlexSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    color: AppColor.black,
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => _OTPonMobileNoEdit(context),
                                    child: Row(
                                      children: [
                                        Text(
                                          data?.student_phone.toString() ?? '',
                                          style: GoogleFont.ibmPlexSans(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: AppColor.lightBlack,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
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
                                  const SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      text: data?.studentClass.toString() ?? '',
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
                                          text: data?.section.toString() ?? '',
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 12,
                                            color: AppColor.grey,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' Section',
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

                              // 👉 two-avatar stack as trailing
                              trailing: Builder(
                                builder: (context) {
                                  final siblings = controller.siblingsList;
                                  if (siblings.isEmpty)
                                    return const SizedBox.shrink();

                                  // pick active (front) + one other (back)
                                  dynamic activeStudent;
                                  try {
                                    activeStudent = siblings.firstWhere(
                                      (s) => s.isActive == true,
                                    );
                                  } catch (_) {
                                    activeStudent = siblings.first;
                                  }

                                  dynamic otherStudent;
                                  for (final s in siblings) {
                                    if (s.id != activeStudent.id) {
                                      otherStudent = s;
                                      break;
                                    }
                                  }

                                  return TwoProfileStack(
                                    active: activeStudent,
                                    other:
                                        siblings.length > 1
                                            ? otherStudent
                                            : null, // only show back if >1
                                    size: 80, // front (color) avatar
                                    backSize:
                                        55, // 🔥 back (B/W) avatar size — customize here
                                    overlapFraction:
                                        0.44, // tweak overlap if you like
                                    fallbackAsset: AppImages.moreSimage1,
                                    activeBorderColor: Colors.transparent,
                                    onTap: () {
                                      SwitchProfileSheet.show(
                                        context,
                                        students: controller.siblingsList,
                                        selectedStudent:
                                            controller.selectedStudent,
                                        onSwitch: (student) async {
                                          await controller.switchSiblings(
                                            id: student.id,
                                          );
                                          controller.selectStudent(student);
                                        },
                                        onLogout: () async {
                                          await loginController.logout();
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Payment History'),
                      Tab(text: 'Teachers'),
                    ],
                    labelColor: AppColor.lightBlack,
                    unselectedLabelColor: AppColor.grey,
                    indicatorColor: AppColor.lightBlack,
                    labelStyle: GoogleFont.ibmPlexSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                    dividerColor: Colors.transparent,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showContactSchoolSheet(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Text(
                      'Contact School',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColor.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Obx(() {
                    final data = feesController.feesData.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 20,
                      ),
                      child: ListView.builder(
                        itemCount: data?.items.length,
                        itemBuilder: (context, index) {
                          final plan = data?.items[index];
                          return CustomContainer.moreScreen(
                            onDetailsTap: () {
                              _paymentReceipt(context);
                            },
                            termTitle:
                                plan?.name.toString() ??
                                '', // e.g. "Third Term Fee – Sep 2025"
                            timeDate:
                                plan?.announcementDate.toString() ??
                                '', // or format with intl
                            amount: "Rs. ${plan?.summary.totalAmount}",
                            isPaid:
                                plan?.summary.unpaidCount ==
                                0, // true if all paid
                            payNowButton:
                                () => _feessSheet(
                                  context,
                                  plan!,
                                ), // pass plan if needed
                          );
                        },
                      ),
                    );
                  }),
                  // Teachers Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 20,
                    ),
                    child: Obx(() {
                      if (teacherListController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (teacherListController.teacherListResponse.value ==
                              null ||
                          teacherListController
                                  .teacherListResponse
                                  .value!
                                  .data ==
                              null ||
                          teacherListController
                              .teacherListResponse
                              .value!
                              .data!
                              .teachers
                              .isEmpty) {
                        return Column(
                          children: [
                            const Center(child: Text("No teachers available")),
                            SizedBox(height: 10),
                            Image.asset(AppImages.noDataFound),
                          ],
                        );
                      }

                      final teachers =
                          teacherListController
                              .teacherListResponse
                              .value!
                              .data!
                              .teachers;

                      return Column(
                        children: [
                          /*  for (int i = 0; i < teachers.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomContainer.teacherTab(
                    teachresName: teachers[i].teacherName,
                    classTitle:
                    teachers[i].classTeacher
                        ? "${teachers[i].subject} - Class Teacher"
                        : teachers[i].subject,
                    teacherImage:
                    teachers[i].teacherImage.isNotEmpty
                        ? teachers[i].teacherImage
                        : AppImages.teacher1,
                  ),
                ),
                const SizedBox(width: 18),
                if (i + 1 < teachers.length)
                  Expanded(
                    child: CustomContainer.teacherTab(
                      teachresName:
                      teachers[i + 1].teacherName,
                      classTitle:
                      teachers[i + 1].classTeacher
                          ? "${teachers[i + 1].subject} - Class Teacher"
                          : teachers[i + 1].subject,
                      teacherImage:
                      teachers[i + 1]
                          .teacherImage
                          .isNotEmpty
                          ? teachers[i + 1].teacherImage
                          : AppImages.teacher2,
                    ),
                  )
                else
                  Spacer(),
              ],
            ),
          ),*/
                          for (int i = 0; i < teachers.length; i += 2)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: CustomContainer.teacherTab(
                                        teachresName: teachers[i].teacherName,
                                        classTitle:
                                            teachers[i].classTeacher
                                                ? "${teachers[i].subject} - Class Teacher"
                                                : teachers[i].subject,
                                        teacherImage:
                                            teachers[i].teacherImage.isNotEmpty
                                                ? teachers[i].teacherImage
                                                : AppImages.teacher1,
                                      ),
                                    ),
                                    const SizedBox(width: 18),
                                    if (i + 1 < teachers.length)
                                      Expanded(
                                        child: CustomContainer.teacherTab(
                                          teachresName:
                                              teachers[i + 1].teacherName,
                                          classTitle:
                                              teachers[i + 1].classTeacher
                                                  ? "${teachers[i + 1].subject} - Class Teacher"
                                                  : teachers[i + 1].subject,
                                          teacherImage:
                                              teachers[i + 1]
                                                      .teacherImage
                                                      .isNotEmpty
                                                  ? teachers[i + 1].teacherImage
                                                  : AppImages.teacher2,
                                        ),
                                      )
                                    else
                                      const Expanded(
                                        child: SizedBox(),
                                      ), // Fill space if odd
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ),

                  /* SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 20,
                    ),
                    child: Obx(() {
                      if (teacherListController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (teacherListController.teacherListResponse.value ==
                              null ||
                          teacherListController
                                  .teacherListResponse
                                  .value!
                                  .data ==
                              null ||
                          teacherListController
                              .teacherListResponse
                              .value!
                              .data!
                              .teachers
                              .isEmpty) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 160),
                          decoration: BoxDecoration(color: AppColor.white),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  'No teachers available',
                                  style: GoogleFont.ibmPlexSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: AppColor.grey,
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Image.asset(AppImages.noDataFound),
                            ],
                          ),
                        );
                      }

                      final teachers =
                          teacherListController
                              .teacherListResponse
                              .value!
                              .data!
                              .teachers;

                      // ⬇️ REPLACE your old `return Column(children:[...])` with THIS:
                      return GridView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(), // inside SingleChildScrollView
                        padding: EdgeInsets.zero,
                        itemCount: teachers.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 columns
                              crossAxisSpacing: 18, // horizontal gap
                              mainAxisSpacing: 15, // vertical gap
                              childAspectRatio:
                                  0.73, // adjust card height if needed
                            ),
                        itemBuilder: (context, i) {
                          final t = teachers[i];
                          return CustomContainer.teacherTab(
                            teachresName: t.teacherName,
                            classTitle:
                                t.classTeacher
                                    ? "${t.subject} - Class Teacher"
                                    : t.subject,
                            teacherImage:
                                t.teacherImage.isNotEmpty
                                    ? t.teacherImage
                                    : AppImages.teacher1,
                          );
                        },
                      );
                    }),
                  ),*/

                  // SingleChildScrollView(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 18,
                  //     vertical: 20,
                  //   ),
                  //   child: Obx(() {
                  //     if (teacherListController.isLoading.value) {
                  //       return const Center(child: CircularProgressIndicator());
                  //     }
                  //     if (teacherListController.teacherListResponse.value ==
                  //             null ||
                  //         teacherListController
                  //                 .teacherListResponse
                  //                 .value!
                  //                 .data ==
                  //             null ||
                  //         teacherListController
                  //             .teacherListResponse
                  //             .value!
                  //             .data!
                  //             .teachers
                  //             .isEmpty) {
                  //       return Column(
                  //         children: [
                  //           const Center(
                  //             child: Text("No teachers available"),
                  //           ),
                  //           SizedBox(height: 10),
                  //           Image.asset(AppImages.noDataFound),
                  //         ],
                  //       );
                  //     }
                  //
                  //     final teachers =
                  //         teacherListController
                  //             .teacherListResponse
                  //             .value!
                  //             .data!
                  //             .teachers;
                  //
                  //     return Column(
                  //       children: [
                  //       /*  for (int i = 0; i < teachers.length; i += 2)
                  //           Padding(
                  //             padding: const EdgeInsets.only(bottom: 15.0),
                  //             child: Row(
                  //               children: [
                  //                 Expanded(
                  //                   child: CustomContainer.teacherTab(
                  //                     teachresName: teachers[i].teacherName,
                  //                     classTitle:
                  //                     teachers[i].classTeacher
                  //                         ? "${teachers[i].subject} - Class Teacher"
                  //                         : teachers[i].subject,
                  //                     teacherImage:
                  //                     teachers[i].teacherImage.isNotEmpty
                  //                         ? teachers[i].teacherImage
                  //                         : AppImages.teacher1,
                  //                   ),
                  //                 ),
                  //                 const SizedBox(width: 18),
                  //                 if (i + 1 < teachers.length)
                  //                   Expanded(
                  //                     child: CustomContainer.teacherTab(
                  //                       teachresName:
                  //                       teachers[i + 1].teacherName,
                  //                       classTitle:
                  //                       teachers[i + 1].classTeacher
                  //                           ? "${teachers[i + 1].subject} - Class Teacher"
                  //                           : teachers[i + 1].subject,
                  //                       teacherImage:
                  //                       teachers[i + 1]
                  //                           .teacherImage
                  //                           .isNotEmpty
                  //                           ? teachers[i + 1].teacherImage
                  //                           : AppImages.teacher2,
                  //                     ),
                  //                   )
                  //                 else
                  //                   Spacer(),
                  //               ],
                  //             ),
                  //           ),*/
                  //
                  //         for (int i = 0; i < teachers.length; i += 2)
                  //           Padding(
                  //             padding: const EdgeInsets.only(bottom: 15.0),
                  //             child: IntrinsicHeight(
                  //               child: Row(
                  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
                  //                 children: [
                  //                   Expanded(
                  //                     child: CustomContainer.teacherTab(
                  //                       teachresName: teachers[i].teacherName,
                  //                       classTitle: teachers[i].classTeacher
                  //                           ? "${teachers[i].subject} - Class Teacher"
                  //                           : teachers[i].subject,
                  //                       teacherImage: teachers[i].teacherImage.isNotEmpty
                  //                           ? teachers[i].teacherImage
                  //                           : AppImages.teacher1,
                  //                     ),
                  //                   ),
                  //                   const SizedBox(width: 18),
                  //                   if (i + 1 < teachers.length)
                  //                     Expanded(
                  //                       child: CustomContainer.teacherTab(
                  //                         teachresName: teachers[i + 1].teacherName,
                  //                         classTitle: teachers[i + 1].classTeacher
                  //                             ? "${teachers[i + 1].subject} - Class Teacher"
                  //                             : teachers[i + 1].subject,
                  //                         teacherImage: teachers[i + 1].teacherImage.isNotEmpty
                  //                             ? teachers[i + 1].teacherImage
                  //                             : AppImages.teacher2,
                  //                       ),
                  //                     )
                  //                   else
                  //                     const Expanded(child: SizedBox()), // Fill space if odd
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //
                  //
                  //       ],
                  //     );
                  //   }),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
