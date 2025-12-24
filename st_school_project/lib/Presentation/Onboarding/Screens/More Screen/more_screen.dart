
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
import '../../../../Core/Utility/download_file.dart';
import '../../../../Core/Utility/google_font.dart' show GoogleFont;
import '../../../../Core/Widgets/date_and_time_convert.dart';
import '../../../../payment_web_view.dart';
import '../Announcements Screen/controller/announcement_controller.dart';
import '../Home Screen/controller/student_home_controller.dart';
import 'Login_screen/controller/login_controller.dart';
import 'Refresh/Controller/refresh_controller.dart' show RefreshController;
import 'change_mobile_number.dart' show ChangeMobileNumber;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/More Screen/profile_screen/model/fees_history_response.dart';


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
  final int? openReceiptForPlanId; // 👈 add this

  const MoreScreen({super.key, this.openReceiptForPlanId});

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
  final AnnouncementController announcementController = Get.put(
    AnnouncementController(),
  );
  final TeacherListController teacherListController = Get.put(
    TeacherListController(),
  );
  final RefreshController refreshController = Get.put(RefreshController());

  Future<void> _handleReconcile(int planId, {bool showLoader = false}) async {
    // Call your RefreshController API
    final res = await refreshController.refreshData(
      id: planId,
      showLoader: showLoader,
    );

    if (!mounted) return;

    if (res == null) {
      // API failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to reconcile. Please try again.')),
      );
      return;
    }

    //  Show result bottom sheet
    // _showReconcileResultSheet(res);

    // 🔄 Refresh the fees list so UI updates
    await feesController.feesHistoryList();
  }

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

  int? _consumedReceiptPlanId; // which planId we've already shown a receipt for
  bool _isShowingReceipt = false; // in-flight guard
  Future<void>? _receiptModalFuture; // the active bottom-sheet future (if any)

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // warm data
      if (feesController.feesData.value == null) {
        await feesController.feesHistoryList();
      }
      if (teacherListController.teacherListResponse.value == null) {
        await teacherListController.teacherListData();
      }
      await _maybeShowReceipt();
      // open receipt only if navigated here after final payment
      /*  final id = widget.openReceiptForPlanId;
      if (id != null && !_receiptOpened && mounted) {
        _receiptOpened = true;                 // 👈 prevent duplicates
        await _paymentReceipt(context, id);    // 👈 show the bottom sheet
      }*/
    });
  }

  @override
  void didUpdateWidget(covariant MoreScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If parent sends a NEW plan id, allow one auto-open for that id
    if (widget.openReceiptForPlanId != oldWidget.openReceiptForPlanId) {
      _consumedReceiptPlanId = null; // reset so the new id can trigger once
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _maybeShowReceipt(); // helper handles all guards + awaiting
      });
    }
  }

  static bool _gReceiptBusy = false;
  static int? _gLastOpenedId;

  Future<void> _maybeShowReceipt() async {
    if (!mounted) return;

    final id = widget.openReceiptForPlanId;
    if (id == null) return;

    // do not open if we're not the visible route
    final route = ModalRoute.of(context);
    if (route == null || !route.isCurrent) return;

    // already consumed in this instance?
    if (_consumedReceiptPlanId == id) return;

    // global guards: stop parallel or repeated opens across instances
    if (_gReceiptBusy || _gLastOpenedId == id) return;

    // local guards
    if (_isShowingReceipt || _receiptModalFuture != null) return;

    _isShowingReceipt = true;
    _gReceiptBusy = true;
    _gLastOpenedId = id;
    _consumedReceiptPlanId = id;

    _receiptModalFuture = _paymentReceipt(context, id);
    try {
      await _receiptModalFuture;
    } finally {
      _receiptModalFuture = null;
      _isShowingReceipt = false;
      _gReceiptBusy = false;
      // keep _gLastOpenedId as last opened to avoid immediate re-open on rebuilds
    }
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

  // void _showReconcileResultSheet(ReconcileResponse res) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: false,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) {
  //       final bool success = res.status && res.code == 200;
  //
  //       return Container(
  //         padding: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           color: AppColor.white,
  //           borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Container(
  //               height: 4,
  //               width: 40,
  //               decoration: BoxDecoration(
  //                 color: AppColor.grayop,
  //                 borderRadius: BorderRadius.circular(2),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //
  //             // Icon + Title
  //             Row(
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.all(14),
  //                   decoration: BoxDecoration(
  //                     color:
  //                         success
  //                             ? AppColor.greenMore1.withOpacity(0.08)
  //                             : AppColor.red01G1.withOpacity(0.08),
  //                     borderRadius: BorderRadius.circular(16),
  //                   ),
  //                   child: Icon(
  //                     success ? Icons.verified_rounded : Icons.error_outline,
  //                     color: success ? AppColor.greenMore1 : AppColor.red01G1,
  //                     size: 28,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 16),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         success
  //                             ? 'Reconciliation Complete'
  //                             : 'Reconciliation Failed',
  //                         style: GoogleFont.ibmPlexSans(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.w600,
  //                           color: AppColor.black,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4),
  //                       Text(
  //                         res.message.isNotEmpty
  //                             ? res.message
  //                             : (success
  //                                 ? 'Payment status has been synchronized.'
  //                                 : 'Unable to sync payment status.'),
  //                         style: GoogleFont.ibmPlexSans(
  //                           fontSize: 13,
  //                           color: AppColor.grey,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //
  //             const SizedBox(height: 18),
  //
  //             // Count tile
  //             Container(
  //               width: double.infinity,
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 16,
  //                 vertical: 14,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: AppColor.lowWhite,
  //                 borderRadius: BorderRadius.circular(14),
  //                 border: Border.all(color: AppColor.grey.withOpacity(0.15)),
  //               ),
  //               child: Row(
  //                 children: [
  //                   Icon(
  //                     Icons.receipt_long,
  //                     size: 22,
  //                     color: AppColor.lightBlack,
  //                   ),
  //                   const SizedBox(width: 10),
  //                   Expanded(
  //                     child: Text(
  //                       'Transactions reconciled',
  //                       style: GoogleFont.ibmPlexSans(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500,
  //                         color: AppColor.lightBlack,
  //                       ),
  //                     ),
  //                   ),
  //                   Text(
  //                     res.data.reconciled.toString(),
  //                     style: GoogleFont.ibmPlexSans(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.w700,
  //                       color: success ? AppColor.greenMore1 : AppColor.red01G1,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //             const SizedBox(height: 18),
  //
  //             // Close button
  //             SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: AppColor.blue,
  //                   foregroundColor: Colors.white,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(14),
  //                   ),
  //                   padding: const EdgeInsets.symmetric(vertical: 12),
  //                   elevation: 0,
  //                 ),
  //                 onPressed: () => Navigator.pop(context),
  //                 child: Text(
  //                   'Close',
  //                   style: GoogleFont.ibmPlexSans(
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //
  //             const SizedBox(height: 6),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildHeaderStudentTile() {
    return Obx(() {
      final data = teacherListController.teacherListResponse.value?.data;
      final siblings = controller.siblingsList;

      if (siblings.isEmpty) return const SizedBox.shrink();

      final activeStudent = siblings.firstWhere(
        (s) => s.isActive == true,
        orElse: () => siblings.first,
      );

      dynamic otherStudent;
      for (final s in siblings) {
        if (s.id != activeStudent.id) {
          otherStudent = s;
          break;
        }
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          title: Text(
            data?.studentName.toString() ?? '',
            style: GoogleFont.ibmPlexSans(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: AppColor.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _OTPonMobileNoEdit(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.asset(
                            AppImages.moreSnumberAdd,
                            height: 13,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      data?.student_email.toString() ?? '',
                      style: GoogleFont.ibmPlexSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppColor.lightBlack,
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
                      style: GoogleFont.ibmPlexSans(fontSize: 8),
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
          trailing:
              (siblings.isEmpty)
                  ? const SizedBox.shrink()
                  : TwoProfileStack(
                    active: activeStudent,
                    other: siblings.length > 1 ? otherStudent : null,
                    size: 80,
                    backSize: 55,
                    overlapFraction: 0.44,
                    fallbackAsset: AppImages.moreSimage1,
                    activeBorderColor: Colors.transparent,
                    onTap: () {
                      SwitchProfileSheet.show(
                        context,
                        students: controller.siblingsList,
                        selectedStudent: controller.selectedStudent,
                        onSwitch: (student) async {
                          await controller.switchSiblings(id: student.id);
                          controller.selectStudent(student);
                        },
                        onLogout: () async {
                          await loginController.logout();
                        },
                      );
                    },
                  ),
        ),
      );
    });
  }

  void _OTPonMobileNoEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.40,
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
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          color: AppColor.lightGrey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.email),
                      ),
                      title: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeMobileNumber(page: 'email'),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Change Email Id',
                              style: GoogleFont.ibmPlexSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColor.grey,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              data?.student_email.toString() ?? "",
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
                              builder: (_) => ChangeMobileNumber(page: 'email'),
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
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            final items = plan.items;

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
                          plan.name,
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
                            plan.dueDate,
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

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(items.length, (index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}. ${item.feeTypeName} - Rs.${item.amount} (${item.status})',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                color: AppColor.lightBlack,
                              ),
                            ),
                            SizedBox(height: 25),

                            if (plan.paymentType == "online")
                              plan.items[index].status == "paid"
                                  ? Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.greenMore1,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AppImages.tick,
                                          height: 24,
                                          width: 27,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Payment Successful",
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : ElevatedButton(
                                    onPressed: () async {
                                      final baseUrl = item.action?.href;
                                      final studentId = item.studentId;

                                      if (baseUrl != null &&
                                          studentId != null) {
                                        final newUrl = "$baseUrl/$studentId";

                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) =>
                                                    PaymentWebView(url: newUrl),
                                          ),
                                        );
                                        if (result != null) {
                                          if (result["status"] == "success") {
                                            print(" Payment successful");
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                            Get.snackbar(
                                              "Payment Successful",
                                              "Your payment has been completed successfully.",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                            );

                                            await feesController
                                                .feesHistoryList();

                                            print(
                                              "OrderId: ${result['orderId']}, tid: ${result['tid']}",
                                            );
                                          } else if (result["status"] ==
                                              "failure") {
                                            print("❌ Payment failed");
                                            print(
                                              "OrderId: ${result['orderId']}, Reason: ${result['reason']}",
                                            );
                                            Get.snackbar(
                                              "Payment Failed",
                                              "Something went wrong. Please try again.",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                        EdgeInsets.zero,
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                            Colors.transparent,
                                          ),
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColor.blueG1,
                                            AppColor.blueG2,
                                          ],
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 45,
                                        width: double.infinity,
                                        child: Text(
                                          'Pay Rs.${item.amount}',
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      );
                    }),
                  ),

                  // If cash → show single bottom button
                  if (plan.paymentType == "cash")
                    ElevatedButton(
                      onPressed: () {
                        // TODO: call your cash API
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
                                color: AppColor.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () async {
                      await DownloadFile.openInBrowser(
                        plan.items[0].instructionUrl,
                        context: context,
                        // baseName: 'ST Joseph Payment Receipt',
                      );
                      //downloadAndOpenPdf(plan.items[0].instructionUrl);

                      print(plan.items[0].instructionUrl);
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
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.downloadImage, height: 20),
                              SizedBox(width: 10),
                              CustomTextField.textWithSmall(
                                fontSize: 13,
                                text: 'Download Payment Instructions',
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
            );
          },
        );
      },
    );
  }

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

  Future<void> _paymentReceipt(BuildContext context, int planId) async {
    final planData = await announcementController.getStudentPaymentPlan(
      id: planId,
    );
    if (planData == null || planData.items.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No data found for plan $planId")));
      return;
    }

    final plan = planData.items.firstWhere(
      (p) => p.planId == planId,
      orElse: () => planData.items.first,
    );

    //  IMPORTANT: return the Future so callers can await and avoid double-open
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true, // helps avoid nested navigator dupes
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.90,
          minChildSize: 0.20,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
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

                  Column(
                    children: [
                      Image.asset(AppImages.paidImage, height: 98),
                      const SizedBox(height: 14),
                      Text(
                        'Rs. ${plan.summary.totalAmount}',
                        style: GoogleFont.ibmPlexSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 34,
                          color: AppColor.greenMore1,
                        ),
                      ),

                      Text(
                        'Paid to ${plan.name}',
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
                      const SizedBox(height: 40),

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
                              // Receipt No
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
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
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
                                        const SizedBox(height: 5),
                                        Text(
                                          plan.items
                                              .map((e) => e.receiptNo)
                                              .whereType<String>()
                                              .join(', '),
                                          style: GoogleFont.ibmPlexSans(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: AppColor.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 25),
                              // Admission No
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
                                  const SizedBox(width: 15),
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
                                      const SizedBox(height: 5),
                                      Text(
                                        plan.items.isNotEmpty
                                            ? (plan.items[0].admissionNo ?? '')
                                                .toString()
                                            : '',
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

                              const SizedBox(height: 25),
                              // Time
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
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
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
                                        const SizedBox(height: 5),
                                        Text(
                                          plan.items
                                              .where((e) => e.paidAt != null)
                                              .map(
                                                (e) =>
                                                    DateAndTimeConvert.timeAndDate(
                                                      e.paidAt.toString(),
                                                    ),
                                              )
                                              .join(', '),
                                          style: GoogleFont.ibmPlexSans(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: AppColor.black,
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

                      const SizedBox(height: 40),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.0),
                        child: DottedLine(
                          dashColor: AppColor.grayop,
                          dashGapLength: 6,
                          dashLength: 7,
                        ),
                      ),
                      const SizedBox(height: 40),

                      GestureDetector(
                        onTap: () async {
                          await DownloadFile.openInBrowser(
                            plan.combinedDownloadUrl,
                            context: context,
                            // baseName: 'ST Joseph Payment Receipt',
                          );
                        },

                        ///
                        // onTap:
                        //     () async => _downloadAndOpenPdf(
                        //       plan.combinedDownloadUrl,
                        //       context: context,
                        //     ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
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
                                  const SizedBox(width: 10),
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
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder:
                (context, innerScrolled) => [
                  // HEADER (your big top area)
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
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
                                Image.asset(
                                  AppImages.moreStopImage,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 10),
                                // === your Obx(ListTile + avatars) unchanged ===
                                _buildHeaderStudentTile(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // PINNED TAB BAR ROW (TabBar + "Contact School")
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    automaticallyImplyLeading: false,
                    toolbarHeight: 50,
                    titleSpacing: 0,
                    flexibleSpace: Container(color: Colors.white),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
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
                              dividerColor: Colors.transparent,
                              labelStyle: GoogleFont.ibmPlexSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
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
                    ),
                  ),
                ],

            // ==== FULL-SCREEN, INDEPENDENTLY SCROLLING TABS ====
            body: TabBarView(
              controller: _tabController,
              children: [

                Obx(() {
                  final data = feesController.feesData.value;
                  final isLoading = feesController.isLoading.value;

                  if (isLoading)
                    return const Center(child: CircularProgressIndicator());

                  if (data == null || data.items.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () => feesController.feesHistoryList(),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 20,
                        ),
                        children: [
                          const SizedBox(height: 120),
                          Column(
                            children: [
                              Image.asset(AppImages.noDataFound, height: 150),
                              const SizedBox(height: 10),
                              Text(
                                "No fees available",
                                textAlign: TextAlign.center,
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 16,
                                  color: AppColor.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => feesController.feesHistoryList(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 20,
                      ),
                      itemCount: data.items.length,
                      itemBuilder: (context, index) {
                        final plan = data.items[index];

                        return CustomContainer.moreScreen(
                          termTitle: plan.name ?? '',
                          timeDate: plan.dueDate ?? '',
                          amount: "Rs. ${plan.summary.totalAmount}",
                          isPaid: plan.summary.unpaidCount == 0,
                          onDetailsTap:
                              () => _paymentReceipt(context, plan.planId),

                          onRefresh: plan.items.any((e) => e.canRefresh),

                          onRefresh1: () async {
                            await _handleReconcile(
                              plan.planId,
                              // showLoader: true,
                            );
                          },

                          payNowButton: () => _feessSheet(context, plan),
                        );
                      },

                      //   CustomContainer.moreScreen(
                      //   onRefresh1: () {},
                      //   onRefresh2: () {},
                      //   onRefresh3: () {},
                      //   onRefresh4: () {},
                      //   onDetailsTap:
                      //       () => _paymentReceipt(context, plan.planId),
                      //   termTitle: plan.name ?? '',
                      //   timeDate: plan.dueDate ?? '',
                      //   amount: "Rs. ${plan.summary.totalAmount}",
                      //   isPaid: plan.summary.unpaidCount == 0,
                      //   payNowButton: () => _feessSheet(context, plan),
                      // );
                    ),
                  );
                }),

                // --- Teachers tab ---
                Obx(() {
                  if (teacherListController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final res = teacherListController.teacherListResponse.value;
                  final data = res?.data;
                  if (data == null || data.teachers.isEmpty) {
                    return ListView(
                      children: [
                        const SizedBox(height: 120),
                        Center(child: Text("No teachers available")),
                        const SizedBox(height: 10),
                        Image.asset(AppImages.noDataFound),
                      ],
                    );
                  }

                  final teachers = data.teachers;

                  // choose one layout:
                  // A) grid (scrolls full screen)
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 20,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.73,
                        ),
                    itemCount: teachers.length,
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

                  // B) or your 2-per-row IntrinsicHeight (also full-screen):
                  // return ListView.builder(...);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
