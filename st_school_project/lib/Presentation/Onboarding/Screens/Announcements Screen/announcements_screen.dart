import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:intl/intl.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_loader.dart';
import 'package:st_school_project/Core/Widgets/consents.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/controller/announcement_controller.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/model/exam_result_response.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Core/Utility/app_images.dart' show AppImages;
import '../../../../Core/Utility/google_font.dart' show GoogleFont;
import '../../../../Core/Widgets/custom_container.dart' show CustomContainer;
import '../../../../Core/Widgets/custom_textfield.dart';
import '../../../../payment_web_view.dart';
import '../More Screen/more_screen.dart';
import '../More Screen/profile_screen/model/fees_history_response.dart';
import 'model/announcement_details_response.dart';
import 'model/announcement_response.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final AnnouncementController controller = Get.put(AnnouncementController());

  // --------- simple caches to avoid re-fetching while paging ----------
  final Map<int, dynamic> _announcementCache = {};
  final Map<int, dynamic> _examResultCache = {};
  final Map<int, dynamic> _examDetailsCache = {};
  final Map<int, dynamic> _planCache = {};

  // ---------- helpers ----------
  void _openFullScreenNetwork(String url) {
    if (url.isEmpty) return;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder:
          (_) => GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 5,
                child: Image.network(url),
              ),
            ),
          ),
    );
  }

  // filter siblings by same type & sort by date (new -> old)
  List<AnnouncementItem> _siblingsByTypeSorted(
    List<AnnouncementItem> all,
    String type,
  ) {
    final t = (type).toLowerCase();
    final same = all.where((e) => (e.type ?? '').toLowerCase() == t).toList();
    same.sort((a, b) {
      final da = DateTime.tryParse(a.notifyDate.toString()) ?? DateTime(1970);
      final db = DateTime.tryParse(b.notifyDate.toString()) ?? DateTime(1970);
      return db.compareTo(da); // desc
    });
    return same;
  }

  int _indexOfId(List<AnnouncementItem> list, int id) {
    return list.indexWhere((e) => e.id == id);
  }

  // -------- generic paged sheet launcher --------
  // Builds a bottom sheet that keeps localIndex inside the sheet; no Navigator.pop().
  void _openPagedSheet({
    required List<AnnouncementItem> allItems,
    required int initialGlobalId,
    required String
    type, // 'feepayment' | 'exammark' | 'announcement' | 'calendar' | 'exam'
  }) {
    final siblings = _siblingsByTypeSorted(allItems, type);
    int initialIndex = _indexOfId(siblings, initialGlobalId);
    if (initialIndex < 0) return; // safety

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          type == 'announcement' || type == 'calendar' || type == 'exam'
              ? Colors.white
              : Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        int localIndex = initialIndex; // stateful inside sheet
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            final item = siblings[localIndex];
            final hasPrev = localIndex > 0;
            final hasNext = localIndex < siblings.length - 1;

            Widget navHeader() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed:
                      hasPrev
                          ? () => setSheetState(() => localIndex -= 1)
                          : null,
                  icon: const Icon(CupertinoIcons.left_chevron),
                  label: const Text('Previous'),
                ),
                Text(
                  '${localIndex + 1} / ${siblings.length}',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 12,
                    color: AppColor.grey,
                  ),
                ),
                TextButton.icon(
                  onPressed:
                      hasNext
                          ? () => setSheetState(() => localIndex += 1)
                          : null,
                  icon: const Icon(CupertinoIcons.right_chevron),
                  label: const Text('Next'),
                ),
              ],
            );

            // ---- body by type ----
            switch (type) {
              case 'feepayment':
                return _feesBody(sheetContext, setSheetState, item, navHeader);
              case 'exammark':
                return _examResultBody(sheetContext, item, navHeader);
              case 'announcement':
                return _announcementBody(sheetContext, item, navHeader);
              case 'calendar':
                return _eventBody(sheetContext, item, navHeader);
              case 'exam':
                return _examTimetableBody(sheetContext, item, navHeader);
              default:
                return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  // ---------- FEES body (in-sheet paging) ----------
  Widget _feesBody(
    BuildContext ctx,
    void Function(void Function()) setSheetState,
    AnnouncementItem current,
    Widget Function() navHeader,
  ) {
    // planId equals announcement item id (as per your earlier code)
    final int planId = current.id;

    Future<dynamic> _loadPlan() async {
      if (_planCache.containsKey(planId)) return _planCache[planId];
      final planData = await controller.getStudentPaymentPlan(id: planId);
      _planCache[planId] = planData;
      return planData;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.20,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return FutureBuilder<dynamic>(
          future: _loadPlan(),
          builder: (_, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return _sheetContainer(
                child: const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                scrollController: scrollController,
                isTransparent: true,
                navHeader: navHeader,
                showGrip: true,
                showTopImage: true,
              );
            }
            final planData = snap.data;
            if (planData == null || planData.items.isEmpty) {
              return _sheetContainer(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(child: Text('No data found for plan $planId')),
                ),
                scrollController: scrollController,
                isTransparent: true,
                navHeader: navHeader,
                showGrip: true,
                showTopImage: true,
              );
            }

            final plan = planData.items.firstWhere(
              (p) => p.planId == planId,
              orElse: () => planData.items.first,
            );

            // normalize
            final type = (plan.paymentType ?? '').trim().toLowerCase();
            final isOnline = type.contains('online');
            final isCash = type.contains('cash');

            return _sheetContainer(
              scrollController: scrollController,
              isTransparent: true,
              navHeader: navHeader,
              showGrip: true,
              showTopImage: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Title + due date
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
                              DateFormat(
                                "dd-MMM-yy",
                              ).format(DateTime.parse(plan.dueDate)),
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          CupertinoIcons.clock_fill,
                          size: 30,
                          color: AppColor.grayop,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // items list
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(plan.items.length, (idx) {
                        final item = plan.items[idx];
                        final isPaid =
                            (item.status ?? '').trim().toLowerCase() == 'paid';
                        final href = (item.action?.href ?? '').trim();
                        final hasLink = href.isNotEmpty;
                        final hasId = item.studentId != null;
                        final canPay = isOnline && !isPaid && hasLink && hasId;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${idx + 1}. ${item.feeTypeName} - ₹${item.amount} (${item.status})',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 16,
                                  color: AppColor.lightBlack,
                                ),
                              ),
                              const SizedBox(height: 8),

                              if (isOnline && isPaid)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.greenMore1,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppImages.tick,
                                        height: 24,
                                        width: 27,
                                      ),
                                      const SizedBox(width: 8),
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
                              else if (canPay)
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      final newUrl = "$href/${item.studentId}";
                                      showDialog(
                                        context: ctx,
                                        barrierDismissible: false,
                                        builder:
                                            (_) => const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                      );

                                      final result = await Navigator.push(
                                        ctx,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  PaymentWebView(url: newUrl),
                                        ),
                                      );

                                      if (Navigator.canPop(ctx))
                                        Navigator.pop(ctx);

                                      if (result == null) {
                                        ScaffoldMessenger.of(ctx).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Payment not completed.",
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      final status =
                                          (result["status"] ?? '')
                                              .toString()
                                              .toLowerCase();

                                      if (status == 'success') {
                                        Get.snackbar(
                                          "Payment Successful",
                                          "Your payment has been completed successfully.",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                          duration: const Duration(seconds: 2),
                                        );
                                        // refresh this plan in cache
                                        _planCache.remove(planId);
                                        setSheetState(
                                          () {},
                                        ); // re-build & refetch via FutureBuilder
                                        // optional: open receipt screen
                                        if (mounted) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => MoreScreen(
                                                    openReceiptForPlanId:
                                                        planId,
                                                  ),
                                            ),
                                          );
                                        }
                                      } else if (status == 'failure') {
                                        Get.snackbar(
                                          "Payment Failed",
                                          (result["reason"] ??
                                                  "Something went wrong. Please try again.")
                                              .toString(),
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      } else {
                                        ScaffoldMessenger.of(ctx).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Payment finished with status: $status",
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (Navigator.canPop(ctx))
                                        Navigator.pop(ctx);
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                        SnackBar(
                                          content: Text("Payment error: $e"),
                                        ),
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                      EdgeInsets.zero,
                                    ),
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
                                      gradient: const LinearGradient(
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

                    const SizedBox(height: 15),

                    if (isCash)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.lightWhite,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.info,
                              size: 18,
                              color: AppColor.grayop,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'This plan is cash only. Please pay at the office.',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 14,
                                  color: AppColor.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------- EXAM RESULT body ----------
  Widget _examResultBody(
    BuildContext ctx,
    AnnouncementItem current,
    Widget Function() navHeader,
  ) {
    final int id = current.id;

    Future<ExamResultData?> _load() async {
      if (_examResultCache.containsKey(id)) return _examResultCache[id];
      final d = await controller.getExamResultData(id: id);
      if (d != null) _examResultCache[id] = d;
      return d;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.40,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, sc) {
        return FutureBuilder<ExamResultData?>(
          future: _load(),
          builder: (_, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return _sheetWhite(
                child: const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                scrollController: sc,
                navHeader: navHeader,
                showGrip: true,
              );
            }
            final details = snap.data;
            if (details == null) {
              return _sheetWhite(
                child: const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No data')),
                ),
                scrollController: sc,
                navHeader: navHeader,
                showGrip: true,
              );
            }

            return _sheetWhite(
              scrollController: sc,
              navHeader: navHeader,
              showGrip: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    details.exam.heading ?? '',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColor.lightBlack,
                    ),
                  ),
                  const SizedBox(height: 7),
                  RichText(
                    text: TextSpan(
                      text: (details.totals?.grade ?? '').toString(),
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 43,
                        fontWeight: FontWeight.w600,
                        color: AppColor.greenMore1,
                      ),
                      children: [
                        TextSpan(
                          text: ' Grade',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 43,
                            fontWeight: FontWeight.w600,
                            color: AppColor.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35.0),
                    child: DottedLine(
                      dashColor: AppColor.grayop,
                      dashGapLength: 6,
                      dashLength: 7,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          AppImages.examResultBCImage,
                          height: 100,
                          width: 180,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: details.subjects?.length ?? 0,
                        itemBuilder: (context, i) {
                          final subject = details.subjects![i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 38.0,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    subject.subjectName ?? '',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Text(
                                    subject.obtainedMarks?.toString() ?? '-',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35.0),
                    child: DottedLine(
                      dashColor: AppColor.grayop,
                      dashGapLength: 6,
                      dashLength: 7,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 30,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.blue, width: 1),
                        ),
                        child: CustomTextField.textWithSmall(
                          text: 'Close',
                          color: AppColor.blue,
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

  // ---------- ANNOUNCEMENT body ----------
  Widget _announcementBody(
    BuildContext ctx,
    AnnouncementItem current,
    Widget Function() navHeader,
  ) {
    final int id = current.id;

    Future<AnnouncementDetails?> _load() async {
      if (_announcementCache.containsKey(id)) return _announcementCache[id];
      AnnouncementDetails? d;
      final cached = controller.announcementDetails.value;
      if (cached != null && cached.id == id) {
        d = cached;
      } else {
        d = await controller.getAnnouncementDetails(id: id);
      }
      if (d != null) _announcementCache[id] = d;
      return d;
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, sc) {
        return FutureBuilder<AnnouncementDetails?>(
          future: _load(),
          builder: (_, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return _sheetWhite(
                child: const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                scrollController: sc,
                navHeader: navHeader,
                showGrip: true,
              );
            }
            final details = snap.data;
            if (details == null) {
              return _sheetWhite(
                child: const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No data')),
                ),
                scrollController: sc,
                navHeader: navHeader,
                showGrip: true,
              );
            }

            return _sheetWhite(
              scrollController: sc,
              navHeader: navHeader,
              showGrip: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (details.contents.isNotEmpty &&
                      details.contents.first.type == "image")
                    GestureDetector(
                      onTap:
                          () => _openFullScreenNetwork(
                            details.contents.first.content ?? "",
                          ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          details.contents.first.content ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    details.title.toUpperCase(),
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat(
                          'dd-MMM-yyyy',
                        ).format(DateTime.parse(details.notifyDate)),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    details.content,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  if (details.contents.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          details.contents.map((c) {
                            if (c.type == "paragraph") {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  c.content ?? "",
                                  style: const TextStyle(fontSize: 15),
                                ),
                              );
                            } else if (c.type == "list") {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    c.items
                                        ?.map(
                                          (e) => Row(
                                            children: [
                                              const Icon(
                                                Icons.check,
                                                color: Colors.green,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(child: Text(e)),
                                            ],
                                          ),
                                        )
                                        .toList() ??
                                    [],
                              );
                            }
                            return const SizedBox.shrink();
                          }).toList(),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ---------- EVENT body ----------
  Widget _eventBody(
    BuildContext ctx,
    AnnouncementItem current,
    Widget Function() navHeader,
  ) {
    final title = current.title ?? '';
    final time = current.notifyDate;
    final image = current.image;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.50,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, sc) {
        return _sheetWhite(
          scrollController: sc,
          navHeader: navHeader,
          showGrip: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFont.ibmPlexSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat(
                      'dd-MMM-yyyy',
                    ).format(DateTime.parse(time.toString())),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              if ((image ?? '').isNotEmpty)
                GestureDetector(
                  onTap: () => _openFullScreenNetwork(image.toString()),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(image.toString(), fit: BoxFit.cover),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ---------- EXAM TIMETABLE body ----------
  Widget _examTimetableBody(
    BuildContext ctx,
    AnnouncementItem current,
    Widget Function() navHeader,
  ) {
    final int examId = current.id;

    Future<dynamic?> _load() async {
      final cached = _examDetailsCache[examId];
      if (cached != null) return cached;
      if (controller.examDetails.value == null ||
          controller.examDetails.value!.exam.id != examId) {
        await controller.getExamDetailsList(examId: examId);
      }
      final d = controller.examDetails.value;
      if (d != null) _examDetailsCache[examId] = d;
      return d;
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, sc) {
        return FutureBuilder<dynamic?>(
          future: _load(),
          builder: (_, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return _sheetWhite(
                child: const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                scrollController: sc,
                navHeader: navHeader,
                showGrip: true,
              );
            }
            final details = snap.data;
            if (details == null) {
              return _sheetWhite(
                child: const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No data')),
                ),
                scrollController: sc,
                navHeader: navHeader,
                showGrip: true,
              );
            }

            return _sheetWhite(
              scrollController: sc,
              navHeader: navHeader,
              showGrip: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details.exam.heading ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${details.exam.startDate} to ${details.exam.endDate}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (details.exam.timetableUrl != null &&
                      details.exam.timetableUrl.isNotEmpty)
                    GestureDetector(
                      onTap:
                          () =>
                              _openFullScreenNetwork(details.exam.timetableUrl),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          details.exam.timetableUrl,
                          fit: BoxFit.cover,
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

  // --------- small sheet wrappers to reduce repetition ----------
  Widget _sheetContainer({
    required Widget child,
    required ScrollController scrollController,
    required bool isTransparent,
    required Widget Function() navHeader,
    bool showGrip = false,
    bool showTopImage = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          if (showTopImage) Image.asset(AppImages.announcement2),
          if (showGrip) ...[
            const SizedBox(height: 8),
            navHeader(),
            const SizedBox(height: 12),
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
          ] else ...[
            const SizedBox(height: 8),
            navHeader(),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }

  Widget _sheetWhite({
    required Widget child,
    required ScrollController scrollController,
    required Widget Function() navHeader,
    bool showGrip = false,
  }) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 8),
          navHeader(),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // ---------------- lifecycle & UI ----------------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.announcementData.value == null) {
        controller.getAnnouncement();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Obx(() {
          final data = controller.announcementData.value;

          if (controller.isLoading.value) {
            return Center(child: AppLoader.circularLoader());
          }

          if (data == null || data.items.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 160),
              decoration: const BoxDecoration(color: AppColor.white),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'No announcements available',
                      style: GoogleFont.ibmPlexSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColor.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Image.asset(AppImages.noDataFound),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => controller.getAnnouncement(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Announcements',
                        style: GoogleFont.ibmPlexSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Column(
                      children:
                          data.items.asMap().entries.map((entry) {
                            final i = entry.key;
                            final item = entry.value;

                            final formattedDate = DateFormat(
                              "dd-MMM-yy",
                            ).format(
                              DateTime.parse(item.notifyDate.toString()),
                            );

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: CustomContainer.announcementsScreen(
                                mainText: item.announcementCategory,
                                backRoundImage: item.image,
                                iconData: CupertinoIcons.clock_fill,
                                additionalText1: "Date",
                                additionalText2: formattedDate,
                                verticalPadding: 12,
                                gradientStartColor: AppColor.black.withOpacity(
                                  0.01,
                                ),
                                gradientEndColor: AppColor.black,
                                onDetailsTap: () {
                                  final type = (item.type ?? '').toLowerCase();
                                  _openPagedSheet(
                                    allItems: data.items,
                                    initialGlobalId: item.id,
                                    type: type,
                                  );
                                },
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
//   final AnnouncementController controller = Get.put(AnnouncementController());
//   final List<Map<String, String>> subjects = [
//     {'subject': 'Tamil', 'mark': '70'},
//     {'subject': 'English', 'mark': '70'},
//     {'subject': 'Maths', 'mark': '70'},
//     {'subject': 'Science', 'mark': '70'},
//     {'subject': 'Social Science', 'mark': '70'},
//   ];
//
//   void _openFullScreenNetwork(String url) {
//     if (url.isEmpty) return;
//     showDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.9),
//       builder:
//           (_) => GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Center(
//               child: InteractiveViewer(
//                 minScale: 0.5,
//                 maxScale: 5,
//                 child: Image.network(url),
//               ),
//             ),
//           ),
//     );
//   }
//
//   /*  void _feessSheet(BuildContext context, int planId) async {
//     final planData = await controller.getStudentPaymentPlan(id: planId);
//
//     if (planData == null || planData.items.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("No data found for plan $planId")));
//       return;
//     }
//
//     // Find the plan by planId
//     final plan = planData.items.firstWhere(
//       (p) => p.planId == planId,
//       orElse: () => planData.items.first,
//     );
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.65,
//           minChildSize: 0.20,
//           maxChildSize: 0.95,
//           expand: false,
//           builder: (context, scrollController) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: AppColor.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: ListView(
//                 controller: scrollController,
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   Image.asset(AppImages.announcement2),
//                   Center(
//                     child: Container(
//                       height: 4,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: AppColor.grayop,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//
//                   // Plan title + due date
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           plan.name,
//                           style: GoogleFont.ibmPlexSans(
//                             fontSize: 22,
//                             fontWeight: FontWeight.w500,
//                             color: AppColor.black,
//                           ),
//                         ),
//                       ),
//                       Column(
//                         children: [
//                           Text(
//                             'Due date',
//                             style: GoogleFont.ibmPlexSans(
//                               fontSize: 12,
//                               color: AppColor.lowGrey,
//                             ),
//                           ),
//                           Text(
//                             DateFormat(
//                               "dd-MMM-yy",
//                             ).format(DateTime.parse(plan.dueDate)),
//                             style: GoogleFont.ibmPlexSans(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: AppColor.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(width: 4),
//                       Icon(
//                         CupertinoIcons.clock_fill,
//                         size: 30,
//                         color: AppColor.grayop,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//
//                   // Fee Items
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: List.generate(plan.items.length, (idx) {
//                       final item = plan.items[idx];
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '${idx + 1}. ${item.feeTypeName} - ₹${item.amount} (${item.status})',
//                               style: GoogleFont.ibmPlexSans(
//                                 fontSize: 16,
//                                 color: AppColor.lightBlack,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//
//                             if (plan.paymentType == "online")
//                               plan.items[idx].status == "paid"
//                                   ? Container(
//                                     width: double.infinity,
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 12,
//                                       horizontal: 16,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: AppColor.greenMore1,
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Image.asset(
//                                           AppImages.tick,
//                                           height: 24,
//                                           width: 27,
//                                         ),
//                                         SizedBox(width: 8),
//                                         Text(
//                                           "Payment Successful",
//                                           style: GoogleFont.ibmPlexSans(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                   : ElevatedButton(
//                                     onPressed: () async {
//                                       final baseUrl = item.action?.href;
//                                       final studentId = item.studentId;
//                                       print('${baseUrl},${studentId}');
//                                       AppLogger.log.i(
//                                         '${baseUrl},${studentId}',
//                                       );
//
//                                       if (baseUrl != null &&
//                                           studentId != null) {
//                                         final newUrl = "$baseUrl/$studentId";
//
//                                         final result = await Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder:
//                                                 (_) =>
//                                                     PaymentWebView(url: newUrl),
//                                           ),
//                                         );
//
//                                         if (result != null) {
//                                           if (result["status"] == "success") {
//                                             print("✅ Payment successful");
//                                             if (context.mounted) {
//                                               Navigator.pop(context);
//                                             }
//                                             Get.snackbar(
//                                               "Payment Successful",
//                                               "Your payment has been completed successfully.",
//                                               snackPosition:
//                                                   SnackPosition.BOTTOM,
//                                               backgroundColor: Colors.green,
//                                               colorText: Colors.white,
//                                               duration: const Duration(
//                                                 seconds: 2,
//                                               ),
//                                             );
//
//                                             print(
//                                               "OrderId: ${result['orderId']}, tid: ${result['tid']}",
//                                             );
//                                           } else if (result["status"] ==
//                                               "failure") {
//                                             print("❌ Payment failed");
//                                             print(
//                                               "OrderId: ${result['orderId']}, Reason: ${result['reason']}",
//                                             );
//                                             Get.snackbar(
//                                               "Payment Failed",
//                                               "Something went wrong. Please try again.",
//                                               snackPosition:
//                                                   SnackPosition.BOTTOM,
//                                               backgroundColor: Colors.red,
//                                               colorText: Colors.white,
//                                               duration: const Duration(
//                                                 seconds: 2,
//                                               ),
//                                             );
//                                           }
//                                         }
//                                       }
//                                     },
//                                     style: ButtonStyle(
//                                       padding: MaterialStateProperty.all(
//                                         EdgeInsets.zero,
//                                       ),
//                                       shape: MaterialStateProperty.all(
//                                         RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             20,
//                                           ),
//                                         ),
//                                       ),
//                                       elevation: MaterialStateProperty.all(0),
//                                       backgroundColor:
//                                           MaterialStateProperty.all(
//                                             Colors.transparent,
//                                           ),
//                                     ),
//                                     child: Ink(
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             AppColor.blueG1,
//                                             AppColor.blueG2,
//                                           ],
//                                           begin: Alignment.topRight,
//                                           end: Alignment.bottomRight,
//                                         ),
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                       child: Container(
//                                         alignment: Alignment.center,
//                                         height: 45,
//                                         width: double.infinity,
//                                         child: Text(
//                                           'Pay Rs.${item.amount}',
//                                           style: GoogleFont.ibmPlexSans(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w700,
//                                             color: AppColor.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
//                   const SizedBox(height: 15),
//
//                   // If cash → show single bottom button
//                   if (plan.paymentType == "cash")
//                     ElevatedButton(
//                       onPressed: () {
//                         // TODO: call your cash API
//                       },
//                       style: ButtonStyle(
//                         padding: MaterialStateProperty.all(EdgeInsets.zero),
//                         shape: MaterialStateProperty.all(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         elevation: MaterialStateProperty.all(0),
//                         backgroundColor: MaterialStateProperty.all(
//                           Colors.transparent,
//                         ),
//                       ),
//                       child: Ink(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [AppColor.blueG1, AppColor.blueG2],
//                             begin: Alignment.topRight,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Container(
//                           alignment: Alignment.center,
//                           height: 50,
//                           width: double.infinity,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Pay Rs.${plan.summary.totalAmount}',
//                                 style: GoogleFont.ibmPlexSans(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w800,
//                                   color: AppColor.white,
//                                 ),
//                               ),
//                               const SizedBox(width: 5),
//                               const Icon(
//                                 CupertinoIcons.right_chevron,
//                                 size: 14,
//                                 color: AppColor.white,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }*/
//
// /*  void _feessSheet(BuildContext context, int planId) async {
//     final planData = await controller.getStudentPaymentPlan(id: planId);
//
//     if (planData == null || planData.items.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("No data found for plan $planId")));
//       return;
//     }
//
//     final plan = planData.items.firstWhere(
//       (p) => p.planId == planId,
//       orElse: () => planData.items.first,
//     );
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.65,
//           minChildSize: 0.20,
//           maxChildSize: 0.95,
//           expand: false,
//           builder: (context, scrollController) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: AppColor.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: ListView(
//                 controller: scrollController,
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   Image.asset(AppImages.announcement2),
//                   Center(
//                     child: Container(
//                       height: 4,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: AppColor.grayop,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Plan title + due date
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           plan.name,
//                           style: GoogleFont.ibmPlexSans(
//                             fontSize: 22,
//                             fontWeight: FontWeight.w500,
//                             color: AppColor.black,
//                           ),
//                         ),
//                       ),
//                       Column(
//                         children: [
//                           Text(
//                             'Due date',
//                             style: GoogleFont.ibmPlexSans(
//                               fontSize: 12,
//                               color: AppColor.lowGrey,
//                             ),
//                           ),
//                           Text(
//                             DateFormat(
//                               "dd-MMM-yy",
//                             ).format(DateTime.parse(plan.dueDate)),
//                             style: GoogleFont.ibmPlexSans(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: AppColor.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 4),
//                       Icon(
//                         CupertinoIcons.clock_fill,
//                         size: 30,
//                         color: AppColor.grayop,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Fee Items
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: List.generate(plan.items.length, (idx) {
//                       final item = plan.items[idx];
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '${idx + 1}. ${item.feeTypeName} - ₹${item.amount} (${item.status})',
//                               style: GoogleFont.ibmPlexSans(
//                                 fontSize: 16,
//                                 color: AppColor.lightBlack,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//
//                             if (plan.paymentType == "online")
//                               item.status == "paid"
//                                   ? Container(
//                                     width: double.infinity,
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 12,
//                                       horizontal: 16,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: AppColor.greenMore1,
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Image.asset(
//                                           AppImages.tick,
//                                           height: 24,
//                                           width: 27,
//                                         ),
//                                         const SizedBox(width: 8),
//                                         Text(
//                                           "Payment Successful",
//                                           style: GoogleFont.ibmPlexSans(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                   : ElevatedButton(
//                                     onPressed: () async {
//                                       final baseUrl = item.action?.href;
//                                       final studentId = item.studentId;
//                                       print('${baseUrl},${studentId}');
//                                       AppLogger.log.i(
//                                         '${baseUrl},${studentId}',
//                                       );
//
//                                       if (baseUrl != null &&
//                                           studentId != null) {
//                                         final newUrl = "$baseUrl/$studentId";
//
//                                         final result = await Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder:
//                                                 (_) =>
//                                                     PaymentWebView(url: newUrl),
//                                           ),
//                                         );
//
//                                         if (result != null) {
//                                           if (result["status"] == "success") {
//                                             if (context.mounted) {
//                                               Navigator.pop(
//                                                 context,
//                                               ); // close fee sheet
//                                             }
//                                             Get.snackbar(
//                                               "Payment Successful",
//                                               "Your payment has been completed successfully.",
//                                               snackPosition:
//                                               SnackPosition.BOTTOM,
//                                               backgroundColor: Colors.green,
//                                               colorText: Colors.white,
//                                               duration: const Duration(
//                                                 seconds: 2,
//                                               ),
//                                             );
//                                             print(
//                                               "OrderId: ${result['orderId']}, tid: ${result['tid']}",
//                                             );
//                                             // Now navigate to MoreScreen and show receipt there
//                                             if (context.mounted) {
//                                               Navigator.pushReplacement(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder:
//                                                       (_) => MoreScreen(
//                                                         openReceiptForPlanId:
//                                                             planId,
//                                                       ),
//                                                 ),
//                                               );
//                                             }
//                                           } else if (result["status"] ==
//                                               "failure") {
//                                             print("❌ Payment failed");
//                                             print(
//                                               "OrderId: ${result['orderId']}, Reason: ${result['reason']}",
//                                             );
//                                             Get.snackbar(
//                                               "Payment Failed",
//                                               "Something went wrong. Please try again.",
//                                               snackPosition:
//                                                   SnackPosition.BOTTOM,
//                                               backgroundColor: Colors.red,
//                                               colorText: Colors.white,
//                                             );
//                                           }
//                                         }
//                                       }
//                                     },
//                                     style: ButtonStyle(
//                                       padding: MaterialStateProperty.all(
//                                         EdgeInsets.zero,
//                                       ),
//                                       shape: MaterialStateProperty.all(
//                                         RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             20,
//                                           ),
//                                         ),
//                                       ),
//                                       elevation: MaterialStateProperty.all(0),
//                                       backgroundColor:
//                                           MaterialStateProperty.all(
//                                             Colors.transparent,
//                                           ),
//                                     ),
//                                     child: Ink(
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             AppColor.blueG1,
//                                             AppColor.blueG2,
//                                           ],
//                                           begin: Alignment.topRight,
//                                           end: Alignment.bottomRight,
//                                         ),
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                       child: Container(
//                                         alignment: Alignment.center,
//                                         height: 45,
//                                         width: double.infinity,
//                                         child: Text(
//                                           'Pay Rs.${item.amount}',
//                                           style: GoogleFont.ibmPlexSans(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w700,
//                                             color: AppColor.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
//                   const SizedBox(height: 15),
//
//                   // If cash → show single bottom button
//                   if (plan.paymentType == "cash")
//                     ElevatedButton(
//                       onPressed: () {
//                         // TODO: call your cash API
//                       },
//                       style: ButtonStyle(
//                         padding: MaterialStateProperty.all(EdgeInsets.zero),
//                         shape: MaterialStateProperty.all(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         elevation: MaterialStateProperty.all(0),
//                         backgroundColor: MaterialStateProperty.all(
//                           Colors.transparent,
//                         ),
//                       ),
//                       child: Ink(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [AppColor.blueG1, AppColor.blueG2],
//                             begin: Alignment.topRight,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Container(
//                           alignment: Alignment.center,
//                           height: 50,
//                           width: double.infinity,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Pay Rs.${plan.summary.totalAmount}',
//                                 style: GoogleFont.ibmPlexSans(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w800,
//                                   color: AppColor.white,
//                                 ),
//                               ),
//                               const SizedBox(width: 5),
//                               const Icon(
//                                 CupertinoIcons.right_chevron,
//                                 size: 14,
//                                 color: AppColor.white,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }*/
//
//   void _feessSheet(BuildContext context, int planId) async {
//     final planData = await controller.getStudentPaymentPlan(id: planId);
//
//     if (planData == null || planData.items.isEmpty) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("No data found for plan $planId")),
//       );
//       return;
//     }
//
//     final plan = planData.items.firstWhere(
//           (p) => p.planId == planId,
//       orElse: () => planData.items.first,
//     );
//
//     bool _launching = false; // tap guard
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (ctx, setSheetState) {
//             // Normalize/relax checks coming from API
//             final type = (plan.paymentType ?? '').trim().toLowerCase();
//             final isOnline = type.contains('online');
//             final isCash   = type.contains('cash');
//
//             return Stack(
//               children: [
//                 DraggableScrollableSheet(
//                   initialChildSize: 0.65,
//                   minChildSize: 0.20,
//                   maxChildSize: 0.95,
//                   expand: false,
//                   builder: (context, scrollController) {
//                     return Container(
//                       decoration: BoxDecoration(
//                         color: AppColor.white,
//                         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//                       ),
//                       child: ListView(
//                         controller: scrollController,
//                         padding: const EdgeInsets.all(16),
//                         children: [
//                           Image.asset(AppImages.announcement2),
//                           Center(
//                             child: Container(
//                               height: 4,
//                               width: 40,
//                               decoration: BoxDecoration(
//                                 color: AppColor.grayop,
//                                 borderRadius: BorderRadius.circular(2),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//
//                           // Plan title + due date
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   plan.name,
//                                   style: GoogleFont.ibmPlexSans(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColor.black,
//                                   ),
//                                 ),
//                               ),
//                               Column(
//                                 children: [
//                                   Text(
//                                     'Due date',
//                                     style: GoogleFont.ibmPlexSans(
//                                       fontSize: 12,
//                                       color: AppColor.lowGrey,
//                                     ),
//                                   ),
//                                   Text(
//                                     DateFormat("dd-MMM-yy").format(DateTime.parse(plan.dueDate)),
//                                     style: GoogleFont.ibmPlexSans(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                       color: AppColor.black,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(width: 4),
//                               const Icon(CupertinoIcons.clock_fill, size: 30, color: AppColor.grayop),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//
//                           // Fee Items
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: List.generate(plan.items.length, (idx) {
//                               final item = plan.items[idx];
//                               final isPaid  = (item.status ?? '').trim().toLowerCase() == 'paid';
//                               final href    = (item.action?.href ?? '').trim();
//                               final hasLink = href.isNotEmpty;
//                               final hasId   = item.studentId != null;
//
//                               // Show Pay only for ONLINE, UNPAID items with valid link & id
//                               final canPay = isOnline && !isPaid && hasLink && hasId;
//
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: 8),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '${idx + 1}. ${item.feeTypeName} - ₹${item.amount} (${item.status})',
//                                       style: GoogleFont.ibmPlexSans(
//                                         fontSize: 16,
//                                         color: AppColor.lightBlack,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//
//                                     if (isOnline && isPaid)
//                                       Container(
//                                         width: double.infinity,
//                                         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                                         decoration: BoxDecoration(
//                                           color: AppColor.greenMore1,
//                                           borderRadius: BorderRadius.circular(20),
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             Image.asset(AppImages.tick, height: 24, width: 27),
//                                             const SizedBox(width: 8),
//                                             Text(
//                                               "Payment Successful",
//                                               style: GoogleFont.ibmPlexSans(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w600,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     else if (canPay)
//                                       ElevatedButton(
//                                         onPressed: _launching
//                                             ? null
//                                             : () async {
//                                           setSheetState(() => _launching = true);
//
//                                           try {
//                                             final newUrl = "$href/${item.studentId}";
//
//                                             showDialog(
//                                               context: ctx,
//                                               barrierDismissible: false,
//                                               builder: (_) => const Center(child: CircularProgressIndicator()),
//                                             );
//
//                                             final result = await Navigator.push(
//                                               ctx,
//                                               MaterialPageRoute(
//                                                 builder: (_) => PaymentWebView(url: newUrl),
//                                               ),
//                                             );
//
//                                             if (Navigator.canPop(ctx)) Navigator.pop(ctx); // close loader
//
//                                             if (result == null) {
//                                               ScaffoldMessenger.of(ctx).showSnackBar(
//                                                 const SnackBar(content: Text("Payment not completed.")),
//                                               );
//                                               setSheetState(() => _launching = false);
//                                               return;
//                                             }
//
//                                             final status = (result["status"] ?? '').toString().toLowerCase();
//                                             if (status == "success") {
//                                               if (mounted && Navigator.canPop(ctx)) {
//                                                 Navigator.pop(ctx); // close fee sheet
//                                               }
//                                               Get.snackbar(
//                                                 "Payment Successful",
//                                                 "Your payment has been completed successfully.",
//                                                 snackPosition: SnackPosition.BOTTOM,
//                                                 backgroundColor: Colors.green,
//                                                 colorText: Colors.white,
//                                                 duration: const Duration(seconds: 2),
//                                               );
//
//                                               if (mounted) {
//                                                 Navigator.pushReplacement(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (_) => MoreScreen(
//                                                       openReceiptForPlanId: planId,
//                                                     ),
//                                                   ),
//                                                 );
//                                               }
//                                             } else if (status == "failure") {
//                                               Get.snackbar(
//                                                 "Payment Failed",
//                                                 (result["reason"] ?? "Something went wrong. Please try again.").toString(),
//                                                 snackPosition: SnackPosition.BOTTOM,
//                                                 backgroundColor: Colors.red,
//                                                 colorText: Colors.white,
//                                               );
//                                               setSheetState(() => _launching = false);
//                                             } else {
//                                               ScaffoldMessenger.of(ctx).showSnackBar(
//                                                 SnackBar(content: Text("Payment finished with status: $status")),
//                                               );
//                                               setSheetState(() => _launching = false);
//                                             }
//                                           } catch (e) {
//                                             if (Navigator.canPop(ctx)) Navigator.pop(ctx); // close loader
//                                             ScaffoldMessenger.of(ctx).showSnackBar(
//                                               SnackBar(content: Text("Payment error: $e")),
//                                             );
//                                             setSheetState(() => _launching = false);
//                                           }
//                                         },
//                                         style: ButtonStyle(
//                                           padding: MaterialStateProperty.all(EdgeInsets.zero),
//                                           shape: MaterialStateProperty.all(
//                                             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                                           ),
//                                           elevation: MaterialStateProperty.all(0),
//                                           backgroundColor: MaterialStateProperty.all(Colors.transparent),
//                                         ),
//                                         child: Ink(
//                                           decoration: BoxDecoration(
//                                             gradient: const LinearGradient(
//                                               colors: [AppColor.blueG1, AppColor.blueG2],
//                                               begin: Alignment.topRight,
//                                               end: Alignment.bottomRight,
//                                             ),
//                                             borderRadius: BorderRadius.circular(20),
//                                           ),
//                                           child: Container(
//                                             alignment: Alignment.center,
//                                             height: 45,
//                                             width: double.infinity,
//                                             child: Text(
//                                               'Pay Rs.${item.amount}',
//                                               style: GoogleFont.ibmPlexSans(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.w700,
//                                                 color: AppColor.white,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               );
//                             }),
//                           ),
//
//                           const SizedBox(height: 15),
//
//                           // For CASH plans, show no Pay button (optional info note)
//                           if (isCash) ...[
//                             Container(
//                               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                               decoration: BoxDecoration(
//                                 color: AppColor.lightWhite,
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(CupertinoIcons.info, size: 18, color: AppColor.grayop),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       'This plan is cash only. Please pay at the office.',
//                                       style: GoogleFont.ibmPlexSans(fontSize: 14, color: AppColor.grey),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//
//                 // Tap guard overlay
//                 if (_launching)
//                   Positioned.fill(
//                     child: IgnorePointer(
//                       ignoring: false,
//                       child: Container(color: Colors.black12),
//                     ),
//                   ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//
//
//
//   // void _feessSheet(BuildContext context) {
//   //   showModalBottomSheet(
//   //     context: context,
//   //     isScrollControlled: true,
//   //     backgroundColor: Colors.transparent,
//   //     builder: (_) {
//   //       return DraggableScrollableSheet(
//   //         initialChildSize: 0.55,
//   //         minChildSize: 0.20,
//   //         maxChildSize: 0.55,
//   //         expand: false,
//   //         builder: (context, scrollController) {
//   //           final items = ['Shoes', 'Notebooks', 'Tuition Fees'];
//   //
//   //           return Container(
//   //             decoration: BoxDecoration(
//   //               color: AppColor.white,
//   //               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//   //             ),
//   //             child: ListView(
//   //               controller: scrollController,
//   //               padding: const EdgeInsets.all(16),
//   //               children: [
//   //                 Center(
//   //                   child: Container(
//   //                     height: 4,
//   //                     width: 40,
//   //                     decoration: BoxDecoration(
//   //                       color: AppColor.grayop,
//   //                       borderRadius: BorderRadius.circular(2),
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 SizedBox(height: 20),
//   //
//   //                 Image.asset(AppImages.announcement2),
//   //                 SizedBox(height: 20),
//   //
//   //                 Row(
//   //                   children: [
//   //                     Expanded(
//   //                       child: Text(
//   //                         'Third-Term Fees',
//   //                         style: GoogleFont.ibmPlexSans(
//   //                           fontSize: 22,
//   //                           fontWeight: FontWeight.w500,
//   //                           color: AppColor.black,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                     Column(
//   //                       children: [
//   //                         Text(
//   //                           'Due date',
//   //                           style: GoogleFont.ibmPlexSans(
//   //                             fontSize: 12,
//   //                             color: AppColor.lowGrey,
//   //                           ),
//   //                         ),
//   //                         Text(
//   //                           '12-Dec-25',
//   //                           style: GoogleFont.ibmPlexSans(
//   //                             fontSize: 14,
//   //                             fontWeight: FontWeight.w500,
//   //                             color: AppColor.black,
//   //                           ),
//   //                         ),
//   //                       ],
//   //                     ),
//   //                     SizedBox(width: 4),
//   //                     Icon(
//   //                       CupertinoIcons.clock_fill,
//   //                       size: 30,
//   //                       color: AppColor.grayop,
//   //                     ),
//   //                   ],
//   //                 ),
//   //                 SizedBox(height: 20),
//   //                 Column(
//   //                   crossAxisAlignment: CrossAxisAlignment.start,
//   //                   children: List.generate(
//   //                     items.length,
//   //                     (index) => Padding(
//   //                       padding: const EdgeInsets.only(bottom: 8),
//   //                       child: Text(
//   //                         '${index + 1}. ${items[index]}',
//   //                         style: GoogleFont.ibmPlexSans(
//   //                           fontSize: 16,
//   //                           color: AppColor.lightBlack,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 SizedBox(height: 15),
//   //
//   //                 ElevatedButton(
//   //                   onPressed: () {},
//   //                   style: ButtonStyle(
//   //                     padding: MaterialStateProperty.all(EdgeInsets.zero),
//   //                     shape: MaterialStateProperty.all(
//   //                       RoundedRectangleBorder(
//   //                         borderRadius: BorderRadius.circular(20),
//   //                       ),
//   //                     ),
//   //                     elevation: MaterialStateProperty.all(0),
//   //                     backgroundColor: MaterialStateProperty.all(
//   //                       Colors.transparent,
//   //                     ),
//   //                   ),
//   //                   child: Ink(
//   //                     decoration: BoxDecoration(
//   //                       gradient: LinearGradient(
//   //                         colors: [AppColor.blueG1, AppColor.blueG2],
//   //                         begin: Alignment.topRight,
//   //                         end: Alignment.bottomRight,
//   //                       ),
//   //                       borderRadius: BorderRadius.circular(20),
//   //                     ),
//   //                     child: Container(
//   //                       alignment: Alignment.center,
//   //                       height: 50,
//   //                       width: double.infinity,
//   //                       child: Row(
//   //                         mainAxisAlignment: MainAxisAlignment.center,
//   //                         children: [
//   //                           Text(
//   //                             'Pay Rs.15,000',
//   //                             style: GoogleFont.ibmPlexSans(
//   //                               fontSize: 16,
//   //                               fontWeight: FontWeight.w800,
//   //                               color: AppColor.white,
//   //                             ),
//   //                           ),
//   //                           SizedBox(width: 5),
//   //                           Icon(
//   //                             CupertinoIcons.right_chevron,
//   //                             size: 14,
//   //                             weight: 20,
//   //                             color: AppColor.white,
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           );
//   //         },
//   //       );
//   //     },
//   //   );
//   // }
//
//   Future<void> _examResult(BuildContext context, int id) async {
//     ExamResultData? details;
//
//     details = await controller.getExamResultData(id: id);
//     if (details == null) return;
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.85,
//           minChildSize: 0.40,
//           maxChildSize: 0.95,
//           expand: false,
//           builder: (context, scrollController) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: AppColor.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: ListView(
//                 controller: scrollController,
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   Center(
//                     child: Container(
//                       height: 4,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: AppColor.grayop,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 40),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         details?.exam.heading ?? '',
//                         style: GoogleFont.ibmPlexSans(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: AppColor.lightBlack,
//                         ),
//                       ),
//                       SizedBox(height: 7),
//                       RichText(
//                         text: TextSpan(
//                           text: details?.totals?.grade.toString() ?? '',
//                           style: GoogleFont.ibmPlexSans(
//                             fontSize: 43,
//                             fontWeight: FontWeight.w600,
//                             color: AppColor.greenMore1,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: ' Grade',
//                               style: GoogleFont.ibmPlexSans(
//                                 fontSize: 43,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColor.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 26),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 35.0),
//                         child: DottedLine(
//                           dashColor: AppColor.grayop,
//                           dashGapLength: 6,
//                           dashLength: 7,
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Stack(
//                         children: [
//                           Positioned.fill(
//                             child: Image.asset(
//                               AppImages.examResultBCImage,
//                               height: 100,
//                               width: 180,
//                             ),
//                           ),
//
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemCount: details?.subjects?.length ?? 0,
//                             itemBuilder: (context, index) {
//                               final subject = details?.subjects![index];
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 8.0,
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 38.0,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                         subject?.subjectName ?? '',
//                                         style: GoogleFont.ibmPlexSans(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColor.grey,
//                                         ),
//                                       ),
//                                       SizedBox(width: 30),
//                                       Text(
//                                         subject?.obtainedMarks?.toString() ??
//                                             '-',
//                                         style: GoogleFont.ibmPlexSans(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w500,
//                                           color: AppColor.black,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 35.0),
//                         child: DottedLine(
//                           dashColor: AppColor.grayop,
//                           dashGapLength: 6,
//                           dashLength: 7,
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Center(
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               vertical: 12,
//                               horizontal: 30,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: AppColor.blue,
//                                 width: 1,
//                               ),
//                             ),
//                             child: CustomTextField.textWithSmall(
//                               text: 'Close',
//                               color: AppColor.blue,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _showAnnouncementDetails(BuildContext context, int id) async {
//     AnnouncementDetails? details;
//
//     // If already fetched for the same ID, use it directly
//     if (controller.announcementDetails.value != null &&
//         controller.announcementDetails.value!.id == id) {
//       details = controller.announcementDetails.value;
//     } else {
//       // Otherwise fetch from API
//       details = await controller.getAnnouncementDetails(id: id);
//     }
//
//     if (details == null) return;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.75,
//           minChildSize: 0.4,
//           maxChildSize: 0.95,
//           builder: (_, controller) {
//             return SingleChildScrollView(
//               controller: controller,
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Grab Handle
//                   Center(
//                     child: Container(
//                       width: 40,
//                       height: 5,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[400],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Image (if exists)
//                   if (details!.contents.isNotEmpty &&
//                       details.contents.first.type == "image")
//                     GestureDetector(
//                       onTap: () {
//                         _openFullScreenNetwork(
//                           details?.contents.first.content ?? "",
//                         );
//                       },
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(16),
//                         child: Image.network(
//                           details.contents.first.content ?? "",
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//
//                   SizedBox(height: 20),
//
//                   // Title
//                   Text(
//                     details.title.toUpperCase(),
//                     style: GoogleFont.ibmPlexSans(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//
//                   SizedBox(height: 8),
//
//                   // Date
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.calendar_today,
//                         size: 16,
//                         color: Colors.grey,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         DateFormat(
//                           'dd-MMM-yyyy',
//                         ).format(DateTime.parse(details.notifyDate)),
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   // Content
//                   Text(
//                     details.content,
//                     style: const TextStyle(fontSize: 16, height: 1.5),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Extra dynamic contents
//                   if (details.contents.isNotEmpty)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children:
//                           details.contents.map((c) {
//                             if (c.type == "paragraph") {
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: 12),
//                                 child: Text(
//                                   c.content ?? "",
//                                   style: const TextStyle(fontSize: 15),
//                                 ),
//                               );
//                             } else if (c.type == "list") {
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children:
//                                     c.items
//                                         ?.map(
//                                           (e) => Row(
//                                             children: [
//                                               const Icon(
//                                                 Icons.check,
//                                                 color: Colors.green,
//                                                 size: 18,
//                                               ),
//                                               const SizedBox(width: 6),
//                                               Expanded(child: Text(e)),
//                                             ],
//                                           ),
//                                         )
//                                         .toList() ??
//                                     [],
//                               );
//                             } /*else if (c.type == "image") {
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 10,
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: Image.network(c.content ?? ""),
//                                 ),
//                               );
//                             }*/
//                             return const SizedBox.shrink();
//                           }).toList(),
//                     ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _showEventDetails(
//     BuildContext context,
//     String title,
//     DateTime time,
//     String image,
//   ) async {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.50,
//           minChildSize: 0.4,
//           maxChildSize: 0.95,
//           builder: (_, controller) {
//             return SingleChildScrollView(
//               controller: controller,
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Grab Handle
//                   Center(
//                     child: Container(
//                       width: 40,
//                       height: 5,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[400],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//
//                   // Image (if exists)
//                   // if (details!.contents.isNotEmpty &&
//                   //     details.contents.first.type == "image")
//                   SizedBox(height: 8),
//                   // Title
//                   Text(
//                     title.toUpperCase(),
//                     style: GoogleFont.ibmPlexSans(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//
//                   SizedBox(height: 8),
//
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.calendar_today,
//                         size: 16,
//                         color: Colors.grey,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         DateFormat(
//                           'dd-MMM-yyyy',
//                         ).format(DateTime.parse(time.toString())),
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 25),
//                   GestureDetector(
//                     onTap: () {
//                       _openFullScreenNetwork(image.toString() ?? "");
//                     },
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: Image.network(
//                         image.toString() ?? "",
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void showExamTimeTable(BuildContext context, int examId) async {
//     // Fetch details if not already fetched
//     if (controller.examDetails.value == null ||
//         controller.examDetails.value!.exam.id != examId) {
//       await controller.getExamDetailsList(examId: examId);
//     }
//
//     final details = controller.examDetails.value;
//     if (details == null) return;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.75,
//           minChildSize: 0.4,
//           maxChildSize: 0.95,
//           builder: (_, scrollController) {
//             return SingleChildScrollView(
//               controller: scrollController,
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Grab Handle
//                   Center(
//                     child: Container(
//                       width: 40,
//                       height: 5,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[400],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Timetable Image
//                   const SizedBox(height: 20),
//
//                   // Exam Title
//                   Text(
//                     details.exam.heading ?? '',
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   // Exam Dates
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.calendar_today,
//                         size: 16,
//                         color: Colors.grey,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         '${details.exam.startDate} to ${details.exam.endDate}',
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 16),
//                   if (details.exam.timetableUrl != null &&
//                       details.exam.timetableUrl.isNotEmpty)
//                     GestureDetector(
//                       onTap: () {
//                         _openFullScreenNetwork(details.exam.timetableUrl);
//                       },
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(16),
//                         child: Image.network(
//                           details.exam.timetableUrl,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (controller.announcementData.value == null) {
//         controller.getAnnouncement();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.white,
//       body: SafeArea(
//         child: Obx(() {
//           final data = controller.announcementData.value;
//
//           // Loader
//           if (controller.isLoading.value) {
//             return Center(child: AppLoader.circularLoader());
//           }
//
//           // Empty State
//           if (data == null || data.items.isEmpty) {
//             return Container(
//               padding: EdgeInsets.symmetric(vertical: 160),
//               decoration: BoxDecoration(color: AppColor.white),
//               child: Column(
//                 children: [
//                   Center(
//                     child: Text(
//                       'No announcements available',
//                       style: GoogleFont.ibmPlexSans(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                         color: AppColor.grey,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   Image.asset(AppImages.noDataFound),
//                 ],
//               ),
//             );
//           }
//
//           return RefreshIndicator(
//             onRefresh: () async {
//               await controller.getAnnouncement();
//             },
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Text(
//                         'Announcements',
//                         style: GoogleFont.ibmPlexSans(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 26,
//                           color: AppColor.black,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//
//                     Column(
//                       children:
//                           data.items.map((item) {
//                             final formattedDate = DateFormat(
//                               "dd-MMM-yy",
//                             ).format(
//                               DateTime.parse(item.notifyDate.toString()),
//                             );
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 16),
//                               child: CustomContainer.announcementsScreen(
//                                 mainText: item.announcementCategory,
//                                 backRoundImage: item.image,
//                                 iconData: CupertinoIcons.clock_fill,
//                                 additionalText1: "Date",
//                                 additionalText2: formattedDate,
//                                 verticalPadding: 12,
//                                 gradientStartColor: AppColor.black.withOpacity(
//                                   0.01,
//                                 ),
//                                 gradientEndColor: AppColor.black,
//                                 onDetailsTap: () async {
//                                   if (item.type == "exammark") {
//                                     _examResult(context, item.id);
//                                   } else if (item.type == "announcement") {
//                                     _showAnnouncementDetails(context, item.id);
//                                   } else if (item.type == "exam") {
//                                     showExamTimeTable(context, item.id);
//                                   } else if (item.type == "feepayment") {
//                                     print(item.id);
//                                     print('Fees');
//                                     _feessSheet(context, item.id);
//                                   } else if (item.type == "calendar") {
//                                     print(item.id);
//                                     print('calendar');
//                                     _showEventDetails(
//                                       context,
//                                       item.title,
//                                       item.notifyDate,
//                                       item.image,
//                                     );
//                                   }
//                                 },
//                               ),
//                             );
//                           }).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
