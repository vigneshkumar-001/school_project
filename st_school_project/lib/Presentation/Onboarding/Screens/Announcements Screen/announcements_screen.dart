import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:st_school_project/Core/Utility/app_color.dart';
import 'package:st_school_project/Core/Utility/app_loader.dart';
import 'package:st_school_project/Presentation/Onboarding/Screens/Announcements%20Screen/controller/announcement_controller.dart';
import '../../../../Core/Utility/app_images.dart' show AppImages;
import '../../../../Core/Utility/google_font.dart' show GoogleFont;
import '../../../../Core/Widgets/bottom_navigationbar.dart';
import '../../../../Core/Widgets/custom_container.dart' show CustomContainer;
import '../../../../Core/Widgets/custom_textfield.dart';
import '../../../../payment_web_view.dart';
import 'model/announcement_details_response.dart';
import 'model/announcement_response.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final AnnouncementController controller = Get.put(AnnouncementController());

  @override
  bool get wantKeepAlive => true; // important!

  int _asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString()) ?? fallback;
  }

  double? _asDoubleOrNull(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  List<int> _asIntList(dynamic v) {
    if (v == null) return <int>[];
    if (v is List) {
      return v.map((e) => _asInt(e)).toList();
    }
    return <int>[];
  }

  Map<String, List<int>> _asMapOfIntLists(dynamic v) {
    final Map<String, List<int>> out = {};
    if (v is Map) {
      v.forEach((key, value) {
        out[key.toString()] = _asIntList(value);
      });
    }
    return out;
  }

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

  String _norm(String? t) => (t ?? '').trim().toLowerCase();

  List<int> _dateSortedIdsSameTypeAs({
    required AnnouncementData data,
    required int id,
    String? fallbackType, // optional: use when you *know* the type
  }) {
    // find the clicked item
    AnnouncementItem? base;
    try {
      base = data.items.firstWhere((e) => e.id == id);
    } catch (_) {
      base = null;
    }

    // decide the wanted type
    String wanted = _norm(base?.type ?? fallbackType ?? '');

    // if we still don't know the type, safest is to scope to just the current id
    if (wanted.isEmpty) return [id];

    // matcher with tolerant synonyms
    bool _typeMatches(String? raw) {
      final v = _norm(raw);

      if (v == wanted) return true;

      // normalizations / synonyms
      if (wanted == 'exammark' &&
          (v == 'exam_mark' || v == 'examresult' || v == 'exam_result'))
        return true;

      if (wanted == 'exam' && (v == 'exams')) return true;

      if (wanted == 'calendar' &&
          (v == 'event' || v == 'events' || v == 'calendar_event'))
        return true;

      if (wanted == 'announcement' && (v == 'announcements')) return true;

      if (wanted == 'feepayment' &&
          (v == 'fee' || v == 'fees' || v == 'fee_payment' || v == 'fee-pay'))
        return true;

      return false;
    }

    DateTime _asDate(dynamic v) {
      if (v is DateTime) return v;
      return DateTime.tryParse(v?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
    }

    // strictly filter same-type items
    final list = data.items.where((e) => _typeMatches(e.type)).toList();

    // if for some reason we ended up empty, pin to the current id only
    if (list.isEmpty) return [id];

    list.sort((a, b) {
      final c = _asDate(a.notifyDate).compareTo(_asDate(b.notifyDate));
      if (c != 0) return c;
      return a.id.compareTo(b.id);
    });

    return list.map((e) => e.id).toList();
  }

  // Return IDs sorted by notifyDate ASC (oldest -> newest)
  // If `type` is given, constrain within that type; else across all items.
  List<int> _dateSortedIds({AnnouncementData? data, String? type}) {
    final d = data ?? controller.announcementData.value;
    if (d == null) return const [];

    final wanted = (type ?? '').trim().toLowerCase();

    bool _typeMatches(String? t) {
      final v = (t ?? '').trim().toLowerCase();
      if (wanted.isEmpty) return true; // no filter
      if (v == wanted) return true;

      // tolerate common synonyms/variants from API
      if (wanted == 'exammark' &&
          (v == 'exam_mark' || v == 'examresult' || v == 'exam_result'))
        return true;
      if (wanted == 'exam' && (v == 'exams')) return true;
      if (wanted == 'calendar' &&
          (v == 'event' || v == 'events' || v == 'calendar_event'))
        return true;
      if (wanted == 'announcement' && (v == 'announcements')) return true;

      return false;
    }

    final List<AnnouncementItem> list =
        wanted.isEmpty
            ? List<AnnouncementItem>.from(d.items)
            : d.items.where((e) => _typeMatches(e.type)).toList();

    DateTime _asDate(dynamic v) {
      if (v is DateTime) return v;
      return DateTime.tryParse(v?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
    }

    list.sort((a, b) {
      final c = _asDate(a.notifyDate).compareTo(_asDate(b.notifyDate));
      if (c != 0) return c;
      return a.id.compareTo(b.id);
    });

    return list.map((e) => e.id).toList();
  }

  void _openById(
    BuildContext ctx,
    int id, {
    List<int>? order,
    int? index,
    String? forceType, // <— NEW
  }) {
    final data = controller.announcementData.value;
    if (data == null) return;

    AnnouncementItem? item;

    try {
      if (forceType == null || forceType.isEmpty) {
        item = data.items.firstWhere((e) => e.id == id);
      } else {
        final wanted = forceType.trim().toLowerCase();
        bool _matches(AnnouncementItem e) {
          final v = (e.type ?? '').trim().toLowerCase();
          if (v == wanted) return true;
          if (wanted == 'exammark' &&
              (v == 'exam_mark' || v == 'examresult' || v == 'exam_result'))
            return true;
          if (wanted == 'exam' && (v == 'exams')) return true;
          if (wanted == 'calendar' &&
              (v == 'event' || v == 'events' || v == 'calendar_event'))
            return true;
          if (wanted == 'announcement' && (v == 'announcements')) return true;
          return false;
        }

        item = data.items.firstWhere((e) => e.id == id && _matches(e));
      }
    } catch (_) {
      return;
    }

    if (item == null) return;

    switch (item.type) {
      case "feepayment":
        {
          // fees can keep its type-scoped order (works already)
          final navOrder = _dateSortedIds(data: data, type: "feepayment");
          final currIndex = navOrder.indexOf(item.id);
          _feessSheet(ctx, item.id, order: navOrder, index: currIndex);
        }
        break;

      case "announcement":
        // sheet builds its own type-only order internally
        _showAnnouncementDetails(ctx, item.id);
        break;

      case "exam":
        // sheet builds its own type-only order internally
        showExamTimeTable(ctx, item.id);
        break;

      case "exammark":
        // sheet builds its own type-only order internally
        _examResult(ctx, item.id);
        break;

      case "calendar":
        // pass current id only for cursor, and enforce type on reopen
        _showEventDetails(
          ctx,
          item.title,
          item.notifyDate,
          item.image,
          currentId: item.id, // used to position; not an order
        );
        break;

      default:
        _showAnnouncementDetails(ctx, item.id);
    }
  }

  /// header that never pops — only calls callbacks
  /*
  Widget _navHeader({
    required BuildContext ctx,
    required List<int>? order,
    required int? index,
    required bool disabled,
    VoidCallback? onPrev,
    VoidCallback? onNext,
  }) {
    final hasOrder = order != null && index != null && order.isNotEmpty;
    final atStart = hasOrder ? index! <= 0 : true;
    final atEnd = hasOrder ? index! >= order!.length - 1 : true;

    return Row(
      children: [
        // TextButton(
        //   onPressed: (!hasOrder || atStart || disabled) ? null : onPrev,
        //   child: Row(
        //     children: [
        //       SizedBox(width: 15,),
        //       Icon(CupertinoIcons.chevron_left),
        //       Text(
        //         'Previous',
        //         style: GoogleFont.ibmPlexSans(
        //           fontWeight: FontWeight.w600,
        //           fontSize: 16,
        //           color: AppColor.black,
        //         ),
        //       ),
        //
        //     ],
        //   ),
        // ),
        IconButton(
          icon: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.blue),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Row(
                children: [
                  Icon(CupertinoIcons.chevron_left, color: AppColor.blue),
                  SizedBox(width: 8),
                  Text(
                    'Previous',
                    style: GoogleFont.ibmPlexSans(
                      fontWeight: FontWeight.w600,
                      color: AppColor.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onPressed: (!hasOrder || atStart || disabled) ? null : onPrev,
        ),
        Spacer(),
        // Expanded(
        //   child: Center(
        //     child: Text(
        //       hasOrder ? '${index! + 1} / ${order!.length}' : '',
        //       style: GoogleFont.ibmPlexSans(
        //         fontSize: 13,
        //         color: AppColor.lowGrey,
        //       ),
        //     ),
        //   ),
        // ),
        // TextButton(
        //   onPressed: (!hasOrder || atEnd || disabled) ? null : onNext,
        //   child: Row(
        //     children: [
        //       Text(
        //         'Next',
        //         style: GoogleFont.ibmPlexSans(
        //           fontWeight: FontWeight.w600,
        //           fontSize: 16,
        //           color: AppColor.black,
        //         ),
        //       ),
        //       SizedBox(width: 10,),
        //       Icon(CupertinoIcons.chevron_right),
        //     ],
        //   ),
        // ),
        IconButton(
          icon:  Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.blue),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10),
              child: Row(
                children: [
                  Text(
                    'Next',
                    style: GoogleFont.ibmPlexSans(
                      fontWeight: FontWeight.w600,
                      color: AppColor.blue,
                    ),
                  ),
                  SizedBox(width: 4,),
                  Icon(CupertinoIcons.chevron_right,color: AppColor.blue),
                ],
              ),
            ),
          ),
          onPressed: (!hasOrder || atEnd || disabled) ? null : onNext,
        ),
      ],
    );
  }
*/

  Widget _navHeader({
    required BuildContext ctx,
    required List<int>? order,
    required int? index,
    required bool disabled,
    VoidCallback? onPrev,
    VoidCallback? onNext,
  }) {
    final hasOrder = order != null && index != null && order.isNotEmpty;
    final atStart = hasOrder ? index! <= 0 : true;
    final atEnd = hasOrder ? index! >= order!.length - 1 : true;

    // Treat these as "disabled" states for color + onPressed
    final prevIsDisabled = (!hasOrder || atStart || disabled);
    final nextIsDisabled = (!hasOrder || atEnd || disabled);

    // Pick colors: low color when disabled, blue when active
    final prevColor =
        prevIsDisabled ? AppColor.blue.withOpacity(0.2) : AppColor.blue;
    final nextColor =
        nextIsDisabled ? AppColor.blue.withOpacity(0.2) : AppColor.blue;

    return Row(
      children: [
        // PREVIOUS
        IconButton(
          icon: Container(
            decoration: BoxDecoration(
              border: Border.all(color: prevColor),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Icon(CupertinoIcons.chevron_left, color: prevColor),
                  const SizedBox(width: 8),
                  Text(
                    'Previous',
                    style: GoogleFont.ibmPlexSans(
                      fontWeight: FontWeight.w600,
                      color: prevColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onPressed: prevIsDisabled ? null : onPrev,
        ),

        const Spacer(),

        // NEXT
        IconButton(
          icon: Container(
            decoration: BoxDecoration(
              border: Border.all(color: nextColor),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Text(
                    'Next',
                    style: GoogleFont.ibmPlexSans(
                      fontWeight: FontWeight.w600,
                      color: nextColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(CupertinoIcons.chevron_right, color: nextColor),
                ],
              ),
            ),
          ),
          onPressed: nextIsDisabled ? null : onNext,
        ),
      ],
    );
  }

  /// header that never pops — only calls callbacks
  /*  Widget _navHeader({
    required BuildContext ctx,
    required List<int>? order,
    required int? index,
    required bool disabled,
    VoidCallback? onPrev,
    VoidCallback? onNext,
  }) {
    final hasOrder = order != null && index != null && order!.isNotEmpty;
    final atStart  = hasOrder ? index! <= 0 : true;
    final atEnd    = hasOrder ? index! >= order!.length - 1 : true;

    final showPrev = hasOrder && !atStart && !disabled;
    final showNext = hasOrder && !atEnd   && !disabled;

    Widget _pillPrev() => InkWell(
      onTap: onPrev,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.blue),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.chevron_left, color: AppColor.blue),
            const SizedBox(width: 8),
            Text(
              'Previous',
              style: GoogleFont.ibmPlexSans(
                fontWeight: FontWeight.w600,
                color: AppColor.blue,
              ),
            ),
          ],
        ),
      ),
    );

    Widget _pillNext() => InkWell(
      onTap: onNext,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.blue),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Next',
              style: GoogleFont.ibmPlexSans(
                fontWeight: FontWeight.w600,
                color: AppColor.blue,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(CupertinoIcons.chevron_right, color: AppColor.blue),
          ],
        ),
      ),
    );

    return Row(
      children: [
        if (showPrev) _pillPrev() else const SizedBox.shrink(),
        const Spacer(),
        if (showNext) _pillNext() else const SizedBox.shrink(),
      ],
    );
  }*/

  // ===========================
  // FEES SHEET (in-place navigation)
  // ===========================
  // void _feessSheet(
  //   BuildContext context,
  //   int planId, {
  //   List<int>? order,
  //   int? index,
  // }) async {
  //   final firstPlanData = await controller.getStudentPaymentPlan(id: planId);
  //   if (firstPlanData == null || firstPlanData.items.isEmpty) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("No data found for plan $planId")));
  //     return;
  //   }
  //
  //   final initialPlan = firstPlanData.items.firstWhere(
  //     (p) => p.planId == planId,
  //     orElse: () => firstPlanData.items.first,
  //   );
  //
  //   final List<dynamic> items = List<dynamic>.from(initialPlan.items);
  //   final BuildContext parentCtx = context;
  //
  //   bool _launching = false;
  //   bool _loaderOpen = false;
  //   bool _didNavigate = false;
  //   final Set<int> _locallyPaid = <int>{};
  //
  //   // HOISTED state (persists for the lifetime of this bottom sheet)
  //   int _currIndexFs =
  //       (() {
  //         final i = (order ?? const []).indexOf(planId);
  //         return i >= 0 ? i : 0;
  //       })();
  //   final List<int> _orderFs =
  //       (order == null || order.isEmpty)
  //           ? <int>[planId]
  //           : List<int>.from(order);
  //
  //   String _planName = initialPlan.name;
  //   String _planDue = initialPlan.dueDate;
  //   String _planType = initialPlan.paymentType ?? '';
  //
  //   String _extractStatus(dynamic result) {
  //     if (result == null) return '';
  //     if (result is String) return result;
  //     if (result is Map) {
  //       final candidates = [
  //         result['status'],
  //         result['payment_status'],
  //         result['order_status'],
  //         result['transaction_status'],
  //         if (result['data'] is Map) (result['data'] as Map)['status'],
  //         if (result['response'] is Map) (result['response'] as Map)['status'],
  //       ];
  //       for (final c in candidates) {
  //         if (c != null && c.toString().trim().isNotEmpty) return c.toString();
  //       }
  //     }
  //     return '';
  //   }
  //
  //   bool _isSuccess(String s) {
  //     final v = s.toLowerCase();
  //     return v == 'success' ||
  //         v == 'paid' ||
  //         v == 'captured' ||
  //         v == 'completed' ||
  //         v == 'ok' ||
  //         v == 'authorized' ||
  //         v == 'authorised';
  //   }
  //
  //   void _closeLoaderIfOpen(BuildContext anyCtx) {
  //     if (_loaderOpen && Navigator.of(anyCtx, rootNavigator: true).canPop()) {
  //       Navigator.of(anyCtx, rootNavigator: true).pop();
  //       _loaderOpen = false;
  //     }
  //   }
  //
  //   Future<void> _closeSheetThenNavigate() async {
  //     if (_didNavigate) return;
  //     _didNavigate = true;
  //
  //     _closeLoaderIfOpen(parentCtx);
  //
  //     if (Navigator.of(parentCtx).canPop()) {
  //       Navigator.of(parentCtx).pop(); // close bottom sheet
  //     }
  //
  //     await Future.delayed(const Duration(milliseconds: 120));
  //     if (!mounted) return;
  //
  //     Navigator.of(parentCtx, rootNavigator: true).pushReplacement(
  //       MaterialPageRoute(
  //         builder:
  //             (_) => CommonBottomNavigation(
  //               initialIndex: 4,
  //               openReceiptForPlanId: initialPlan.planId,
  //             ),
  //       ),
  //     );
  //   }
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) {
  //       return StatefulBuilder(
  //         builder: (ctx, setSheetState) {
  //           bool _modelItemPaid(dynamic it) =>
  //               ((it.status ?? '').toString().trim().toLowerCase() == 'paid');
  //
  //           bool _hasPayLink(dynamic it) =>
  //               ((it.action?.href ?? '').toString().trim().isNotEmpty);
  //
  //           bool _hasStudentId(dynamic it) => it.studentId != null;
  //
  //           bool _paidEffective(dynamic it, int idx) =>
  //               _modelItemPaid(it) || _locallyPaid.contains(idx);
  //
  //           bool _payableEffective(
  //             dynamic it,
  //             int idx, {
  //             required bool online,
  //           }) {
  //             if (!online) return false;
  //             if (_paidEffective(it, idx)) return false;
  //             return _hasPayLink(it) && _hasStudentId(it);
  //           }
  //
  //           int _remainingEffective({required bool online}) {
  //             int c = 0;
  //             for (var i = 0; i < items.length; i++) {
  //               if (_payableEffective(items[i], i, online: online)) c++;
  //             }
  //             return c;
  //           }
  //
  //           Future<void> _gotoDelta(int delta) async {
  //             if (_orderFs.length <= 1) return;
  //             final next = _currIndexFs + delta;
  //             if (next < 0 || next >= _orderFs.length) return;
  //
  //             final nextId = _orderFs[next];
  //             setSheetState(() => _launching = true);
  //             try {
  //               final nextPlanData = await controller.getStudentPaymentPlan(
  //                 id: nextId,
  //               );
  //               if (nextPlanData == null || nextPlanData.items.isEmpty) {
  //                 Get.snackbar('Info', 'No data found for plan $nextId');
  //                 return;
  //               }
  //
  //               final nextPlan = nextPlanData.items.firstWhere(
  //                 (p) => p.planId == nextId,
  //                 orElse: () => nextPlanData.items.first,
  //               );
  //
  //               // swap in new content (keep SAME sheet open)
  //               items
  //                 ..clear()
  //                 ..addAll(List<dynamic>.from(nextPlan.items));
  //               _locallyPaid.clear(); // reset optimistic flags
  //
  //               // update hoisted fields
  //               _planName = nextPlan.name;
  //               _planDue = nextPlan.dueDate;
  //               _planType = nextPlan.paymentType ?? '';
  //
  //               _currIndexFs = next;
  //             } finally {
  //               setSheetState(() => _launching = false);
  //             }
  //           }
  //
  //           final bool online = _planType.toLowerCase().contains('online');
  //           final bool cash = _planType.toLowerCase().contains('cash');
  //           final int remainingNow = _remainingEffective(online: online);
  //
  //           return Stack(
  //             children: [
  //               DraggableScrollableSheet(
  //                 initialChildSize: 0.65,
  //                 minChildSize: 0.20,
  //                 maxChildSize: 0.95,
  //                 expand: false,
  //                 builder: (contextSheet, scrollController) {
  //                   return Container(
  //                     decoration: BoxDecoration(
  //                       color: AppColor.white,
  //                       borderRadius: const BorderRadius.vertical(
  //                         top: Radius.circular(20),
  //                       ),
  //                       boxShadow: const [
  //                         BoxShadow(
  //                           color: Colors.black26,
  //                           blurRadius: 8,
  //                           offset: Offset(0, -3),
  //                         ),
  //                       ],
  //                     ),
  //                     child: ListView(
  //                       controller: scrollController,
  //                       padding: const EdgeInsets.all(16),
  //                       children: [
  //                         Image.asset(AppImages.announcement2),
  //                         Center(
  //                           child: Container(
  //                             height: 4,
  //                             width: 40,
  //                             decoration: BoxDecoration(
  //                               color: AppColor.grayop,
  //                               borderRadius: BorderRadius.circular(2),
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(height: 20),
  //
  //                         // header
  //                         Row(
  //                           children: [
  //                             Expanded(
  //                               child: Text(
  //                                 _planName,
  //                                 style: GoogleFont.ibmPlexSans(
  //                                   fontSize: 22,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: AppColor.black,
  //                                 ),
  //                               ),
  //                             ),
  //                             Column(
  //                               children: [
  //                                 Text(
  //                                   'Due date',
  //                                   style: GoogleFont.ibmPlexSans(
  //                                     fontSize: 12,
  //                                     color: AppColor.lowGrey,
  //                                   ),
  //                                 ),
  //                                 Text(
  //                                   DateFormat(
  //                                     "dd-MMM-yy",
  //                                   ).format(DateTime.parse(_planDue)),
  //                                   style: GoogleFont.ibmPlexSans(
  //                                     fontSize: 14,
  //                                     fontWeight: FontWeight.w500,
  //                                     color: AppColor.black,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             const SizedBox(width: 4),
  //                             const Icon(
  //                               CupertinoIcons.clock_fill,
  //                               size: 30,
  //                               color: AppColor.grayop,
  //                             ),
  //                           ],
  //                         ),
  //
  //                         if (online) ...[
  //                           const SizedBox(height: 12),
  //                           Text(
  //                             'Pending payments: $remainingNow',
  //                             style: GoogleFont.ibmPlexSans(
  //                               fontSize: 13,
  //                               color: AppColor.lowGrey,
  //                             ),
  //                           ),
  //                         ],
  //
  //                         const SizedBox(height: 12),
  //
  //                         // items
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: List.generate(items.length, (idx) {
  //                             final item = items[idx];
  //                             final paid = _paidEffective(item, idx);
  //                             final canPay = _payableEffective(
  //                               item,
  //                               idx,
  //                               online: online,
  //                             );
  //
  //                             return Padding(
  //                               key: ValueKey(
  //                                 'fee-$idx-${(item.status ?? "").toLowerCase()}-$paid',
  //                               ),
  //                               padding: const EdgeInsets.only(bottom: 8),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Text(
  //                                     '${idx + 1}. ${item.feeTypeName} - ₹${item.amount} (${paid ? "paid" : (item.status ?? "")})',
  //                                     style: GoogleFont.ibmPlexSans(
  //                                       fontSize: 16,
  //                                       color: AppColor.lightBlack,
  //                                     ),
  //                                   ),
  //                                   const SizedBox(height: 8),
  //
  //                                   if (online && paid)
  //                                     Container(
  //                                       width: double.infinity,
  //                                       padding: const EdgeInsets.symmetric(
  //                                         vertical: 12,
  //                                         horizontal: 16,
  //                                       ),
  //                                       decoration: BoxDecoration(
  //                                         color: AppColor.greenMore1,
  //                                         borderRadius: BorderRadius.circular(
  //                                           20,
  //                                         ),
  //                                       ),
  //                                       child: Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.center,
  //                                         children: [
  //                                           Image.asset(
  //                                             AppImages.tick,
  //                                             height: 24,
  //                                             width: 27,
  //                                           ),
  //                                           const SizedBox(width: 8),
  //                                           Text(
  //                                             "Payment Successful",
  //                                             style: GoogleFont.ibmPlexSans(
  //                                               fontSize: 16,
  //                                               fontWeight: FontWeight.w600,
  //                                               color: Colors.white,
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     )
  //                                   else if (canPay)
  //                                     ElevatedButton(
  //                                       onPressed:
  //                                           _launching
  //                                               ? null
  //                                               : () async {
  //                                                 setSheetState(
  //                                                   () => _launching = true,
  //                                                 );
  //
  //                                                 // loader
  //                                                 showDialog(
  //                                                   context: parentCtx,
  //                                                   barrierDismissible: false,
  //                                                   builder: (_) {
  //                                                     _loaderOpen = true;
  //                                                     return const Center(
  //                                                       child:
  //                                                           CircularProgressIndicator(),
  //                                                     );
  //                                                   },
  //                                                 );
  //
  //                                                 try {
  //                                                   final href =
  //                                                       (item.action?.href ??
  //                                                               '')
  //                                                           .toString()
  //                                                           .trim();
  //                                                   final newUrl =
  //                                                       "$href/${item.studentId}";
  //
  //                                                   final result =
  //                                                       await Navigator.push(
  //                                                         parentCtx,
  //                                                         MaterialPageRoute(
  //                                                           builder:
  //                                                               (_) =>
  //                                                                   PaymentWebView(
  //                                                                     url:
  //                                                                         newUrl,
  //                                                                   ),
  //                                                         ),
  //                                                       );
  //
  //                                                   final status =
  //                                                       _extractStatus(
  //                                                         result,
  //                                                       ).toLowerCase();
  //                                                   final success =
  //                                                       _isSuccess(status) ||
  //                                                       (result is Map &&
  //                                                           result['success'] ==
  //                                                               true);
  //
  //                                                   if (success) {
  //                                                     setSheetState(() {
  //                                                       _locallyPaid.add(
  //                                                         idx,
  //                                                       ); // optimistic
  //                                                       _launching = false;
  //                                                     });
  //
  //                                                     final left =
  //                                                         _remainingEffective(
  //                                                           online: online,
  //                                                         );
  //
  //                                                     Get.snackbar(
  //                                                       "Payment Successful",
  //                                                       left > 0
  //                                                           ? "Paid ${idx + 1}/${items.length}. Pending: $left"
  //                                                           : "All payments completed.",
  //                                                       snackPosition:
  //                                                           SnackPosition
  //                                                               .BOTTOM,
  //                                                       backgroundColor:
  //                                                           Colors.green,
  //                                                       colorText: Colors.white,
  //                                                       duration:
  //                                                           const Duration(
  //                                                             seconds: 2,
  //                                                           ),
  //                                                     );
  //
  //                                                     if (left == 0) {
  //                                                       await _closeSheetThenNavigate();
  //                                                     }
  //                                                   } else {
  //                                                     final reason =
  //                                                         (result is Map
  //                                                             ? result["reason"]
  //                                                             : null) ??
  //                                                         "Payment not completed.";
  //                                                     Get.snackbar(
  //                                                       "Payment Failed",
  //                                                       reason.toString(),
  //                                                       snackPosition:
  //                                                           SnackPosition
  //                                                               .BOTTOM,
  //                                                       backgroundColor:
  //                                                           Colors.red,
  //                                                       colorText: Colors.white,
  //                                                     );
  //                                                     setSheetState(
  //                                                       () =>
  //                                                           _launching = false,
  //                                                     );
  //                                                   }
  //                                                 } catch (e, st) {
  //                                                   // ignore: avoid_print
  //                                                   print(
  //                                                     'Payment exception: $e\n$st',
  //                                                   );
  //
  //                                                   if (mounted) {
  //                                                     setSheetState(
  //                                                       () =>
  //                                                           _launching = false,
  //                                                     );
  //                                                     Get.snackbar(
  //                                                       "Payment Failed",
  //                                                       "Something went wrong. Please try again.",
  //                                                       snackPosition:
  //                                                           SnackPosition
  //                                                               .BOTTOM,
  //                                                       backgroundColor:
  //                                                           Colors.red,
  //                                                       colorText: Colors.white,
  //                                                     );
  //                                                   }
  //                                                 } finally {
  //                                                   _closeLoaderIfOpen(
  //                                                     parentCtx,
  //                                                   );
  //                                                 }
  //                                               },
  //                                       style: ButtonStyle(
  //                                         padding: MaterialStateProperty.all<
  //                                           EdgeInsets
  //                                         >(EdgeInsets.zero),
  //                                         shape: MaterialStateProperty.all(
  //                                           RoundedRectangleBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(20),
  //                                           ),
  //                                         ),
  //                                         elevation: MaterialStateProperty.all(
  //                                           0,
  //                                         ),
  //                                         backgroundColor:
  //                                             MaterialStateProperty.all(
  //                                               Colors.transparent,
  //                                             ),
  //                                       ),
  //                                       child: Ink(
  //                                         decoration: BoxDecoration(
  //                                           gradient: const LinearGradient(
  //                                             colors: [
  //                                               AppColor.blueG1,
  //                                               AppColor.blueG2,
  //                                             ],
  //                                             begin: Alignment.topRight,
  //                                             end: Alignment.bottomRight,
  //                                           ),
  //                                           borderRadius: BorderRadius.circular(
  //                                             20,
  //                                           ),
  //                                         ),
  //                                         child: Container(
  //                                           alignment: Alignment.center,
  //                                           height: 45,
  //                                           width: double.infinity,
  //                                           child: Text(
  //                                             'Pay Rs.${item.amount}',
  //                                             style: GoogleFont.ibmPlexSans(
  //                                               fontSize: 15,
  //                                               fontWeight: FontWeight.w700,
  //                                               color: AppColor.white,
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                 ],
  //                               ),
  //                             );
  //                           }),
  //                         ),
  //
  //                         const SizedBox(height: 15),
  //
  //                         if (cash)
  //                           Container(
  //                             padding: const EdgeInsets.symmetric(
  //                               vertical: 12,
  //                               horizontal: 16,
  //                             ),
  //                             decoration: BoxDecoration(
  //                               color: AppColor.lightWhite,
  //                               borderRadius: BorderRadius.circular(14),
  //                             ),
  //                             child: Row(
  //                               children: [
  //                                 const Icon(
  //                                   CupertinoIcons.info,
  //                                   size: 18,
  //                                   color: AppColor.grayop,
  //                                 ),
  //                                 const SizedBox(width: 8),
  //                                 Expanded(
  //                                   child: Text(
  //                                     'This plan is cash only. Please pay at the office.',
  //                                     style: GoogleFont.ibmPlexSans(
  //                                       fontWeight: FontWeight.w500,
  //                                       fontSize: 13,
  //                                       color: AppColor.black,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //
  //                         const SizedBox(height: 10),
  //
  //                         GestureDetector(
  //                           onTap:
  //                               () => _downloadAndOpenPdf(
  //                                 items.isNotEmpty
  //                                     ? items[0].instructionUrl
  //                                     : null,
  //                               ),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Container(
  //                                 padding: const EdgeInsets.symmetric(
  //                                   vertical: 16,
  //                                   horizontal: 27,
  //                                 ),
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(16),
  //                                 ),
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: [
  //                                     Image.asset(
  //                                       AppImages.downloadImage,
  //                                       height: 20,
  //                                     ),
  //                                     const SizedBox(width: 10),
  //                                     CustomTextField.textWithSmall(
  //                                       fontSize: 13,
  //                                       text: 'Download Payment Instructions',
  //                                       color: AppColor.blue,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         SizedBox(height: 20),
  //                         _navHeader(
  //                           ctx: context,
  //                           order: _orderFs,
  //                           index: _currIndexFs,
  //                           disabled: _launching || _orderFs.length <= 1,
  //                           onPrev: () => _gotoDelta(-1),
  //                           onNext: () => _gotoDelta(1),
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //               ),
  //               if (_launching)
  //                 Positioned.fill(
  //                   child: IgnorePointer(
  //                     ignoring: false,
  //                     child: Container(color: Colors.black12),
  //                   ),
  //                 ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // ===========================
  // EXAM RESULT (in-place navigation)
  // ===========================
  void _feessSheet(
    BuildContext context,
    int planId, {
    List<int>? order,
    int? index,
  }) async {
    final firstPlanData = await controller.getStudentPaymentPlan(id: planId);
    if (firstPlanData == null || firstPlanData.items.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No data found for plan $planId")));
      return;
    }

    final initialPlan = firstPlanData.items.firstWhere(
      (p) => p.planId == planId,
      orElse: () => firstPlanData.items.first,
    );

    final List<dynamic> items = List<dynamic>.from(initialPlan.items);
    final BuildContext parentCtx = context;

    bool _launching = false;
    bool _loaderOpen = false;
    bool _didNavigate = false;
    final Set<int> _locallyPaid = <int>{};

    // ---- Dynamic sizing state (auto-height) ----
    double _minSize = 0.20; // floor
    double _initSize = 0.65; // starting guess; will get recomputed
    double _maxSize = 0.95; // ceiling
    final GlobalKey _contentKey = GlobalKey();
    bool _queuedMeasure = false;
    void _queueRecalc(
      BuildContext ctx,
      void Function(void Function()) setSheetState,
    ) {
      if (_queuedMeasure) return;
      _queuedMeasure = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _queuedMeasure = false;
        final ro = _contentKey.currentContext?.findRenderObject();
        if (ro is RenderBox) {
          final contentH = ro.size.height;
          final screenH = MediaQuery.of(ctx).size.height;
          const double chromePad = 32.0; // for handle/top padding
          final desired = ((contentH + chromePad) / screenH).clamp(
            _minSize,
            _maxSize,
          );
          final newInit = desired;
          final newMin = desired.clamp(_minSize, newInit);
          setSheetState(() {
            _initSize = newInit;
            _minSize = newMin;
          });
        }
      });
    }

    // HOISTED state (persists for the lifetime of this bottom sheet)
    int _currIndexFs =
        (() {
          final i = (order ?? const []).indexOf(planId);
          return i >= 0 ? i : 0;
        })();
    final List<int> _orderFs =
        (order == null || order.isEmpty)
            ? <int>[planId]
            : List<int>.from(order);

    String _planName = initialPlan.name;
    String _planDue = initialPlan.dueDate;
    String _planType = initialPlan.paymentType ?? '';

    String _extractStatus(dynamic result) {
      if (result == null) return '';
      if (result is String) return result;
      if (result is Map) {
        final candidates = [
          result['status'],
          result['payment_status'],
          result['order_status'],
          result['transaction_status'],
          if (result['data'] is Map) (result['data'] as Map)['status'],
          if (result['response'] is Map) (result['response'] as Map)['status'],
        ];
        for (final c in candidates) {
          if (c != null && c.toString().trim().isNotEmpty) return c.toString();
        }
      }
      return '';
    }

    bool _isSuccess(String s) {
      final v = s.toLowerCase();
      return v == 'success' ||
          v == 'paid' ||
          v == 'captured' ||
          v == 'completed' ||
          v == 'ok' ||
          v == 'authorized' ||
          v == 'authorised';
    }

    void _closeLoaderIfOpen(BuildContext anyCtx) {
      if (_loaderOpen && Navigator.of(anyCtx, rootNavigator: true).canPop()) {
        Navigator.of(anyCtx, rootNavigator: true).pop();
        _loaderOpen = false;
      }
    }

    Future<void> _closeSheetThenNavigate() async {
      if (_didNavigate) return;
      _didNavigate = true;

      _closeLoaderIfOpen(parentCtx);

      if (Navigator.of(parentCtx).canPop()) {
        Navigator.of(parentCtx).pop(); // close bottom sheet
      }

      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;

      Navigator.of(parentCtx, rootNavigator: true).pushReplacement(
        MaterialPageRoute(
          builder:
              (_) => CommonBottomNavigation(
                initialIndex: 4,
                openReceiptForPlanId: initialPlan.planId,
              ),
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            // initial measure after first layout
            _queueRecalc(ctx, setSheetState);

            bool _modelItemPaid(dynamic it) =>
                ((it.status ?? '').toString().trim().toLowerCase() == 'paid');

            bool _hasPayLink(dynamic it) =>
                ((it.action?.href ?? '').toString().trim().isNotEmpty);

            bool _hasStudentId(dynamic it) => it.studentId != null;

            bool _paidEffective(dynamic it, int idx) =>
                _modelItemPaid(it) || _locallyPaid.contains(idx);

            bool _payableEffective(
              dynamic it,
              int idx, {
              required bool online,
            }) {
              if (!online) return false;
              if (_paidEffective(it, idx)) return false;
              return _hasPayLink(it) && _hasStudentId(it);
            }

            int _remainingEffective({required bool online}) {
              int c = 0;
              for (var i = 0; i < items.length; i++) {
                if (_payableEffective(items[i], i, online: online)) c++;
              }
              return c;
            }

            Future<void> _gotoDelta(int delta) async {
              if (_orderFs.length <= 1) return;
              final next = _currIndexFs + delta;
              if (next < 0 || next >= _orderFs.length) return;

              final nextId = _orderFs[next];
              setSheetState(() => _launching = true);
              try {
                final nextPlanData = await controller.getStudentPaymentPlan(
                  id: nextId,
                );
                if (nextPlanData == null || nextPlanData.items.isEmpty) {
                  Get.snackbar('Info', 'No data found for plan $nextId');
                  return;
                }

                final nextPlan = nextPlanData.items.firstWhere(
                  (p) => p.planId == nextId,
                  orElse: () => nextPlanData.items.first,
                );

                // swap in new content (keep SAME sheet open)
                items
                  ..clear()
                  ..addAll(List<dynamic>.from(nextPlan.items));
                _locallyPaid.clear(); // reset optimistic flags

                // update hoisted fields
                _planName = nextPlan.name;
                _planDue = nextPlan.dueDate;
                _planType = nextPlan.paymentType ?? '';
                _currIndexFs = next;

                // re-measure after content change
                _queueRecalc(ctx, setSheetState);
              } finally {
                setSheetState(() => _launching = false);
              }
            }

            final bool online = _planType.toLowerCase().contains('online');
            final bool cash = _planType.toLowerCase().contains('cash');
            final int remainingNow = _remainingEffective(online: online);

            return Stack(
              children: [
                DraggableScrollableSheet(
                  initialChildSize: _initSize,
                  minChildSize: _minSize,
                  maxChildSize: _maxSize,
                  expand: false,
                  builder: (contextSheet, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          key: _contentKey, // <-- measured
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Banner image; when first frame is drawn, re-measure
                            Image.asset(
                              AppImages.announcement2,
                              frameBuilder: (c, child, frame, wasSync) {
                                if (frame != null || wasSync) {
                                  _queueRecalc(ctx, setSheetState);
                                }
                                return child;
                              },
                            ),
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

                            // header
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _planName,
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
                                      ).format(DateTime.parse(_planDue)),
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

                            if (online) ...[
                              const SizedBox(height: 12),
                              Text(
                                'Pending payments: $remainingNow',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 13,
                                  color: AppColor.lowGrey,
                                ),
                              ),
                            ],

                            const SizedBox(height: 12),

                            // items
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(items.length, (idx) {
                                final item = items[idx];
                                final paid = _paidEffective(item, idx);
                                final canPay = _payableEffective(
                                  item,
                                  idx,
                                  online: online,
                                );

                                return Padding(
                                  key: ValueKey(
                                    'fee-$idx-${(item.status ?? "").toLowerCase()}-$paid',
                                  ),
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${idx + 1}. ${item.feeTypeName} - ₹${item.amount} (${paid ? "paid" : (item.status ?? "")})',
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 16,
                                          color: AppColor.lightBlack,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      if (online && paid)
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.greenMore1,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
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
                                          onPressed:
                                              _launching
                                                  ? null
                                                  : () async {
                                                    setSheetState(
                                                      () => _launching = true,
                                                    );

                                                    // loader
                                                    showDialog(
                                                      context: parentCtx,
                                                      barrierDismissible: false,
                                                      builder: (_) {
                                                        _loaderOpen = true;
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      },
                                                    );

                                                    try {
                                                      final href =
                                                          (item.action?.href ??
                                                                  '')
                                                              .toString()
                                                              .trim();
                                                      final newUrl =
                                                          "$href/${item.studentId}";

                                                      final result =
                                                          await Navigator.push(
                                                            parentCtx,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (
                                                                    _,
                                                                  ) => PaymentWebView(
                                                                    url: newUrl,
                                                                  ),
                                                            ),
                                                          );

                                                      final status =
                                                          _extractStatus(
                                                            result,
                                                          ).toLowerCase();
                                                      final success =
                                                          _isSuccess(status) ||
                                                          (result is Map &&
                                                              result['success'] ==
                                                                  true);

                                                      if (success) {
                                                        setSheetState(() {
                                                          _locallyPaid.add(
                                                            idx,
                                                          ); // optimistic
                                                          _launching = false;
                                                        });

                                                        final left =
                                                            _remainingEffective(
                                                              online: online,
                                                            );

                                                        Get.snackbar(
                                                          "Payment Successful",
                                                          left > 0
                                                              ? "Paid ${idx + 1}/${items.length}. Pending: $left"
                                                              : "All payments completed.",
                                                          snackPosition:
                                                              SnackPosition
                                                                  .BOTTOM,
                                                          backgroundColor:
                                                              Colors.green,
                                                          colorText:
                                                              Colors.white,
                                                          duration:
                                                              const Duration(
                                                                seconds: 2,
                                                              ),
                                                        );

                                                        // re-measure if visual state changed
                                                        _queueRecalc(
                                                          ctx,
                                                          setSheetState,
                                                        );

                                                        if (left == 0) {
                                                          await _closeSheetThenNavigate();
                                                        }
                                                      } else {
                                                        final reason =
                                                            (result is Map
                                                                ? result["reason"]
                                                                : null) ??
                                                            "Payment not completed.";
                                                        Get.snackbar(
                                                          "Payment Failed",
                                                          reason.toString(),
                                                          snackPosition:
                                                              SnackPosition
                                                                  .BOTTOM,
                                                          backgroundColor:
                                                              Colors.red,
                                                          colorText:
                                                              Colors.white,
                                                        );
                                                        setSheetState(
                                                          () =>
                                                              _launching =
                                                                  false,
                                                        );
                                                      }
                                                    } catch (e, st) {
                                                      // ignore: avoid_print
                                                      print(
                                                        'Payment exception: $e\n$st',
                                                      );
                                                      if (mounted) {
                                                        setSheetState(
                                                          () =>
                                                              _launching =
                                                                  false,
                                                        );
                                                        Get.snackbar(
                                                          "Payment Failed",
                                                          "Something went wrong. Please try again.",
                                                          snackPosition:
                                                              SnackPosition
                                                                  .BOTTOM,
                                                          backgroundColor:
                                                              Colors.red,
                                                          colorText:
                                                              Colors.white,
                                                        );
                                                      }
                                                    } finally {
                                                      _closeLoaderIfOpen(
                                                        parentCtx,
                                                      );
                                                    }
                                                  },
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                              EdgeInsets
                                            >(EdgeInsets.zero),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            elevation:
                                                MaterialStateProperty.all(0),
                                            backgroundColor:
                                                MaterialStateProperty.all(
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
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

                            if (cash)
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
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: AppColor.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 10),

                            GestureDetector(
                              onTap:
                                  () => _downloadAndOpenPdf(
                                    items.isNotEmpty
                                        ? items[0].instructionUrl
                                        : null,
                                  ),
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
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AppImages.downloadImage,
                                          height: 20,
                                        ),
                                        const SizedBox(width: 10),
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

                            const SizedBox(height: 20),

                            _navHeader(
                              ctx: context,
                              order: _orderFs,
                              index: _currIndexFs,
                              disabled: _launching || _orderFs.length <= 1,
                              onPrev: () => _gotoDelta(-1),
                              onNext: () => _gotoDelta(1),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                if (_launching)
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: false,
                      child: Container(color: Colors.black12),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _examResult(
    BuildContext context,
    int id, {
    List<int>? order, // ignored on purpose to enforce type-scope
    int? index, // ignored on purpose to enforce type-scope
  }) async {
    // Build a strict type-only order
    final allData = controller.announcementData.value;
    if (allData == null || allData.items.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No data found for item $id")));
      return;
    }

    final List<int> _orderEr = _dateSortedIdsSameTypeAs(
      data: allData,
      id: id,
      fallbackType: 'exammark',
    );

    // Index of current id inside exammark-only order
    int _currIndexEr = _orderEr.indexOf(id);
    if (_currIndexEr < 0) _currIndexEr = 0;

    final initial = await controller.getExamResultData(
      id: _orderEr[_currIndexEr],
    );
    if (initial == null) return;

    dynamic _detailsEr = initial;
    bool _loadingEr = false;

    // ----- Auto-height state -----
    double _minSize = 0.40; // floor
    double _initSize = 0.60; // starting guess; will be recomputed
    double _maxSize = 0.95; // ceiling
    final GlobalKey _contentKey = GlobalKey();
    bool _queuedMeasure = false;

    void _queueRecalc(
      BuildContext ctx,
      void Function(void Function()) setSheetState,
    ) {
      if (_queuedMeasure) return;
      _queuedMeasure = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _queuedMeasure = false;
        final ro = _contentKey.currentContext?.findRenderObject();
        if (ro is RenderBox) {
          final contentH = ro.size.height;
          final screenH = MediaQuery.of(ctx).size.height;
          const double chromePad = 32.0; // top handle & padding
          final desired = ((contentH + chromePad) / screenH).clamp(
            _minSize,
            _maxSize,
          );

          final newInit = desired;
          final newMin = desired.clamp(_minSize, newInit);
          setSheetState(() {
            _initSize = newInit;
            _minSize = newMin;
          });
        }
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            String _txt(Object? v) => v?.toString() ?? '';

            Future<void> _gotoDelta(int d) async {
              if (_orderEr.isEmpty) return;
              final next = _currIndexEr + d;
              if (next < 0 || next >= _orderEr.length) return;

              setSheetState(() => _loadingEr = true);
              final nd = await controller.getExamResultData(id: _orderEr[next]);
              if (nd != null) {
                _currIndexEr = next;
                _detailsEr = nd;
                // re-measure after data swap
                _queueRecalc(ctx, setSheetState);
              }
              setSheetState(() => _loadingEr = false);
            }

            final details = _detailsEr;

            // initial measure after first layout
            _queueRecalc(ctx, setSheetState);

            return Stack(
              children: [
                DraggableScrollableSheet(
                  initialChildSize: _initSize,
                  minChildSize: _minSize,
                  maxChildSize: _maxSize,
                  expand: false,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          key: _contentKey, // <-- measured
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            const SizedBox(height: 40),

                            // header
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _txt(details?.exam?.heading),
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.lightBlack,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                RichText(
                                  text: TextSpan(
                                    text: _txt(details?.totals?.grade),
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 35.0,
                                  ),
                                  child: DottedLine(
                                    dashColor: AppColor.grayop,
                                    dashGapLength: 6,
                                    dashLength: 7,
                                  ),
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),

                            // subjects
                            Column(
                              children: List.generate(
                                (details?.subjects as List?)?.length ?? 0,
                                (i) {
                                  final subject =
                                      (details?.subjects as List)[i];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 38.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          _txt(subject?.subjectName),
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 30),
                                        Text(
                                          _txt(subject?.obtainedMarks),
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 35.0,
                              ),
                              child: DottedLine(
                                dashColor: AppColor.grayop,
                                dashGapLength: 6,
                                dashLength: 7,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // close
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
                                    border: Border.all(
                                      color: AppColor.blue,
                                      width: 1,
                                    ),
                                  ),
                                  child: CustomTextField.textWithSmall(
                                    text: 'Close',
                                    color: AppColor.blue,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // nav
                            _navHeader(
                              ctx: context,
                              order: _orderEr,
                              index: _currIndexEr,
                              disabled: _loadingEr || _orderEr.length <= 1,
                              onPrev: () => _gotoDelta(-1),
                              onNext: () => _gotoDelta(1),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                if (_loadingEr)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(color: Colors.black12),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  // ===========================
  // ANNOUNCEMENT DETAILS (in-place navigation)
  // ===========================
  // void _showAnnouncementDetails(
  //   BuildContext context,
  //   int id, {
  //   List<int>? order, // ignored to enforce type-scope
  //   int? index, // ignored to enforce type-scope
  // }) async {
  //   // Build strict type-only order
  //   final allData = controller.announcementData.value;
  //   if (allData == null) return;
  //   // final List<int> _orderAd = _dateSortedIds(
  //   //   data: allData,
  //   //   type: 'announcement',
  //   // );
  //   final List<int> _orderAd = _dateSortedIdsSameTypeAs(
  //     data: allData,
  //     id: id,
  //     fallbackType: 'announcement',
  //   );
  //   if (_orderAd.isEmpty) return;
  //
  //   // Current index inside announcement-only order
  //   int _currIndexAd = _orderAd.indexOf(id);
  //   if (_currIndexAd < 0) _currIndexAd = 0;
  //
  //   // Load initial announcement details
  //   final initial = await controller.getAnnouncementDetails(
  //     id: _orderAd[_currIndexAd],
  //   );
  //   if (initial == null) return;
  //
  //   dynamic _detailsAd = initial;
  //   bool _loadingAd = false;
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (ctx, setSheetState) {
  //           String _txt(Object? v) => v?.toString() ?? '';
  //           Future<void> _gotoDelta(int d) async {
  //             if (_orderAd.isEmpty) return; // no announcements available
  //             final next = _currIndexAd + d;
  //             if (next < 0 || next >= _orderAd.length) return;
  //             setSheetState(() => _loadingAd = true);
  //             final nd = await controller.getAnnouncementDetails(
  //               id: _orderAd[next],
  //             );
  //             if (nd != null) {
  //               _currIndexAd = next;
  //               _detailsAd = nd;
  //             }
  //             setSheetState(() => _loadingAd = false);
  //           }
  //
  //           /*  Future<void> _gotoDelta(int d) async {
  //
  //             final next = _currIndexAd + d;
  //             if (next < 0 || next >= _orderAd.length) return;
  //             setSheetState(() => _loadingAd = true);
  //             final nd = await controller.getAnnouncementDetails(
  //               id: _orderAd[next],
  //             );
  //             if (nd != null) {
  //               _currIndexAd = next;
  //               _detailsAd = nd;
  //             }
  //             setSheetState(() => _loadingAd = false);
  //           }*/
  //
  //           final d = _detailsAd as AnnouncementDetails;
  //           return Stack(
  //             children: [
  //               DraggableScrollableSheet(
  //                 expand: false,
  //                 initialChildSize: 0.40,
  //                 minChildSize: 0.4,
  //                 maxChildSize: 0.95,
  //                 builder: (_, scrollCtl) {
  //                   return SingleChildScrollView(
  //                     controller: scrollCtl,
  //                     padding: const EdgeInsets.all(20),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Center(
  //                           child: Container(
  //                             width: 40,
  //                             height: 5,
  //                             decoration: BoxDecoration(
  //                               color: Colors.grey[400],
  //                               borderRadius: BorderRadius.circular(10),
  //                             ),
  //                           ),
  //                         ),
  //
  //                         // if (d.contents.isNotEmpty &&
  //                         //     d.contents.first.type == "image")
  //                         //   GestureDetector(
  //                         //     onTap:
  //                         //         () => _openFullScreenNetwork(
  //                         //           d.contents.first.content ?? "",
  //                         //         ),
  //                         //     child: ClipRRect(
  //                         //       borderRadius: BorderRadius.circular(16),
  //                         //       child: Image.network(
  //                         //         d.contents.first.content ?? "",
  //                         //         fit: BoxFit.cover,
  //                         //       ),
  //                         //     ),
  //                         //   ),
  //                         const SizedBox(height: 16),
  //
  //                         // Image section
  //                         if (d.contents.isNotEmpty &&
  //                             d.contents.first.type == "image" &&
  //                             (d.contents.first.content?.isNotEmpty ?? false))
  //                           GestureDetector(
  //                             onTap:
  //                                 () => _openFullScreenNetwork(
  //                                   d.contents.first.content!,
  //                                 ),
  //                             child: ClipRRect(
  //                               borderRadius: BorderRadius.circular(16),
  //                               child: Image.network(
  //                                 d.contents.first.content!,
  //                                 fit: BoxFit.cover,
  //                               ),
  //                             ),
  //                           )
  //                         else
  //                           Container(
  //                             width: double.infinity,
  //                             padding: const EdgeInsets.all(20),
  //                             alignment: Alignment.center,
  //                             decoration: BoxDecoration(
  //                               color: Colors.grey[200],
  //                               borderRadius: BorderRadius.circular(16),
  //                             ),
  //                             child: const Text(
  //                               "No image found",
  //                               style: TextStyle(
  //                                 color: Colors.grey,
  //                                 fontSize: 16,
  //                                 fontStyle: FontStyle.italic,
  //                               ),
  //                             ),
  //                           ),
  //
  //                         const SizedBox(height: 20),
  //                         Text(
  //                           d.title.toUpperCase(),
  //                           style: GoogleFont.ibmPlexSans(
  //                             fontSize: 22,
  //                             fontWeight: FontWeight.w700,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 8),
  //                         Row(
  //                           children: [
  //                             const Icon(
  //                               Icons.calendar_today,
  //                               size: 16,
  //                               color: Colors.grey,
  //                             ),
  //                             const SizedBox(width: 6),
  //                             Text(
  //                               DateFormat(
  //                                 'dd-MMM-yyyy',
  //                               ).format(DateTime.parse(d.notifyDate)),
  //                               style: const TextStyle(color: Colors.grey),
  //                             ),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 16),
  //                         Text(
  //                           d.content,
  //                           style: const TextStyle(fontSize: 16, height: 1.5),
  //                         ),
  //                         const SizedBox(height: 20),
  //
  //                         if (d.contents.isNotEmpty)
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children:
  //                                 d.contents.map((c) {
  //                                   if (c.type == "paragraph") {
  //                                     return Padding(
  //                                       padding: const EdgeInsets.only(
  //                                         bottom: 12,
  //                                       ),
  //                                       child: Text(
  //                                         c.content ?? "",
  //                                         style: const TextStyle(fontSize: 15),
  //                                       ),
  //                                     );
  //                                   } else if (c.type == "list") {
  //                                     return Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children:
  //                                           c.items
  //                                               ?.map(
  //                                                 (e) => Row(
  //                                                   children: [
  //                                                     const Icon(
  //                                                       Icons.check,
  //                                                       color: Colors.green,
  //                                                       size: 18,
  //                                                     ),
  //                                                     const SizedBox(width: 6),
  //                                                     Expanded(child: Text(e)),
  //                                                   ],
  //                                                 ),
  //                                               )
  //                                               .toList() ??
  //                                           [],
  //                                     );
  //                                   }
  //                                   return const SizedBox.shrink();
  //                                 }).toList(),
  //                           ),
  //
  //                         const SizedBox(height: 20),
  //                         // _navHeader(
  //                         //   ctx: context,
  //                         //   order: _orderAd,
  //                         //   index: _currIndexAd,
  //                         //   disabled: _loadingAd,
  //                         //   onPrev: () => _gotoDelta(-1),
  //                         //   onNext: () => _gotoDelta(1),
  //                         // ),
  //                         _navHeader(
  //                           ctx: context,
  //                           order: _orderAd,
  //                           index: _currIndexAd,
  //                           disabled: _loadingAd || _orderAd.length <= 1,
  //                           onPrev: () => _gotoDelta(-1),
  //                           onNext: () => _gotoDelta(1),
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //               ),
  //               if (_loadingAd)
  //                 Positioned.fill(
  //                   child: IgnorePointer(
  //                     child: Container(color: Colors.black12),
  //                   ),
  //                 ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  //*****old******
  /*  // ===========================
  // CALENDAR EVENT (static content, header disabled)
  // ===========================
  void _showEventDetails(
    BuildContext context,
    String title,
    DateTime time,
    String image, {
    List<int>? order,
    int? index,
  }) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.50,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, controller) {
            int _currIndex = index ?? (order?.indexOf(-1) ?? 0); // not used
            final List<int> _order = order ?? [];

            return SingleChildScrollView(
              controller: controller,
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
                        DateFormat('dd-MMM-yyyy').format(time),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () => _openFullScreenNetwork(image),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(image, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _navHeader(
                    ctx: context,
                    order: _order.isEmpty ? null : _order,
                    index: _order.isEmpty ? null : _currIndex,
                    disabled: true,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }*/

  void _showAnnouncementDetails(
    BuildContext context,
    int id, {
    List<int>? order, // ignored to enforce type-scope
    int? index, // ignored to enforce type-scope
  }) async {
    // Build strict type-only order
    final allData = controller.announcementData.value;
    if (allData == null) return;

    final List<int> _orderAd = _dateSortedIdsSameTypeAs(
      data: allData,
      id: id,
      fallbackType: 'announcement',
    );

    // Current index inside announcement-only order
    int _currIndexAd = _orderAd.indexOf(id);
    if (_currIndexAd < 0) _currIndexAd = 0;

    // Load initial announcement details
    final initial = await controller.getAnnouncementDetails(
      id: _orderAd[_currIndexAd],
    );
    if (initial == null) return;

    dynamic _detailsAd = initial;
    bool _loadingAd = false;

    // ---- Dynamic sizing state ----
    double _minSize = 0.30; // hard floor
    double _initSize = 0.40; // will be recalculated
    double _maxSize = 0.95; // hard ceiling
    final GlobalKey _contentKey = GlobalKey();
    bool _queuedMeasure = false;

    void _queueRecalc(
      BuildContext ctx,
      void Function(void Function()) setSheetState,
    ) {
      if (_queuedMeasure) return;
      _queuedMeasure = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _queuedMeasure = false;
        final renderObj = _contentKey.currentContext?.findRenderObject();
        if (renderObj is RenderBox) {
          final contentH = renderObj.size.height;
          final screenH = MediaQuery.of(ctx).size.height;

          // extra padding for top drag handle & sheet chrome
          const double chromePad = 32.0;
          final desired = ((contentH + chromePad) / screenH).clamp(
            _minSize,
            _maxSize,
          );

          // Keep min <= init <= max, but prefer hugging content
          final newInit = desired;
          final newMin = desired.clamp(_minSize, newInit);
          setSheetState(() {
            _initSize = newInit;
            _minSize = newMin;
          });
        }
      });
    }

    Future<void> _gotoDelta(
      int d,
      BuildContext ctx,
      void Function(void Function()) setSheetState,
    ) async {
      if (_orderAd.isEmpty) return;
      final next = _currIndexAd + d;
      if (next < 0 || next >= _orderAd.length) return;
      setSheetState(() => _loadingAd = true);
      final nd = await controller.getAnnouncementDetails(id: _orderAd[next]);
      if (nd != null) {
        _currIndexAd = next;
        _detailsAd = nd;
        // after new data loads, re-measure once built
        _queueRecalc(ctx, setSheetState);
      }
      setSheetState(() => _loadingAd = false);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            String _txt(Object? v) => v?.toString() ?? '';
            final d = _detailsAd as AnnouncementDetails;

            Future<void> _gotoDelta(int d, BuildContext ctx, StateSetter setSheetState) async {
              final next = _currIndexAd + d;
              if (next < 0 || next >= _orderAd.length) return;
              setSheetState(() => _loadingAd = true);
              final nd = await controller.getAnnouncementDetails(
                id: _orderAd[next],
              );
              if (nd != null) {
                _currIndexAd = next;
                _detailsAd = nd;
              }
              setSheetState(() => _loadingAd = false);
            }

            return Stack(
              children: [
                DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: _initSize,
                  minChildSize: _minSize,
                  maxChildSize: _maxSize,
                  builder: (_, scrollCtl) {
                    return SingleChildScrollView(
                      controller: scrollCtl,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        key: _contentKey, // <-- we measure this
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
                          const SizedBox(height: 16),

                          // Image section (re-measure after load OR on error)
                          if (d.contents.isNotEmpty &&
                              d.contents.first.type == "image" &&
                              (d.contents.first.content?.isNotEmpty ?? false))
                            GestureDetector(
                              onTap:
                                  () => _openFullScreenNetwork(
                                    d.contents.first.content!,
                                  ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  d.contents.first.content!,
                                  fit: BoxFit.cover,
                                  // Re-measure when the image finishes loading
                                  loadingBuilder: (c, child, progress) {
                                    if (progress == null) {
                                      _queueRecalc(ctx, setSheetState);
                                    }
                                    return child;
                                  },
                                  // 🔴 If 404/timeout/any network error → show fallback (no red error)
                                  errorBuilder: (c, error, stack) {
                                    // After swapping to fallback, re-measure the sheet height
                                    _queueRecalc(ctx, setSheetState);
                                    return Text(
                                      "",
                                      style: GoogleFont.ibmPlexSans(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          else
                            SizedBox.shrink(),

                          SizedBox(height: 20),
                          Text(
                            d.title.toUpperCase(),
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
                                ).format(DateTime.parse(d.notifyDate)),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            d.content,
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                          const SizedBox(height: 20),

                          if (d.contents.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  d.contents.map((c) {
                                    if (c.type == "paragraph") {
                                      return const SizedBox(height: 12);
                                    } else if (c.type == "list") {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            (c.items ?? [])
                                                .map(
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
                                                .toList(),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }).toList(),
                            ),

                          const SizedBox(height: 20),
                          _navHeader(
                            ctx: context,
                            order: _orderAd,
                            index: _currIndexAd,
                            disabled: _loadingAd || _orderAd.length <= 1,
                            onPrev: () => _gotoDelta(-1, ctx, setSheetState),
                            onNext: () => _gotoDelta(1, ctx, setSheetState),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (_loadingAd)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(color: Colors.black12),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  //********new***********

  // ===========================
  // CALENDAR EVENT (with working prev/next)
  // ===========================
  // CALENDAR EVENT (in-place navigation, type-scoped)
  void _showEventDetails(
    BuildContext context,
    String _titleIgnored,
    DateTime _timeIgnored,
    String _imageIgnored, {
    List<int>? order, // ignored to enforce type-scope
    int? index, // ignored to enforce type-scope
    int? currentId, // <- REQUIRED to position
  }) {
    final allData = controller.announcementData.value;
    if (allData == null) return;

    // Build order using the REAL type of currentId
    final List<int> _orderCal = _dateSortedIdsSameTypeAs(
      data: allData,
      id: currentId ?? -1,
      fallbackType: 'calendar',
    );

    int _currIndex = (currentId != null) ? _orderCal.indexOf(currentId) : 0;
    if (_currIndex < 0) _currIndex = 0;
    if (_orderCal.isNotEmpty && _currIndex >= _orderCal.length) {
      _currIndex = _orderCal.length - 1;
    }

    AnnouncementItem? _currItem() {
      if (_orderCal.isEmpty) return null;
      final idNow = _orderCal[_currIndex];
      try {
        return allData.items.firstWhere(
          (e) => e.id == idNow,
        ); // same type guaranteed by order
      } catch (_) {
        return null;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (_, setSheetState) {
            final item = _currItem();
            if (item == null) {
              return const SizedBox.shrink();
            }

            // Live fields from item (never trust incoming args)
            final String title = (item.title ?? '').toString();
            final DateTime when =
                (item.notifyDate is DateTime)
                    ? item.notifyDate as DateTime
                    : (DateTime.tryParse(item.notifyDate.toString()) ??
                        DateTime.fromMillisecondsSinceEpoch(0));
            final String image = (item.image ?? '').toString();

            // ---------- Auto-height state ----------
            double _minSize = 0.40; // floor
            double _initSize = 0.50; // starting guess; recomputed next frame
            double _maxSize = 0.95; // ceiling
            final GlobalKey _contentKey = GlobalKey();
            bool _queuedMeasure = false;

            void _queueRecalc() {
              if (_queuedMeasure) return;
              _queuedMeasure = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _queuedMeasure = false;
                final ro = _contentKey.currentContext?.findRenderObject();
                if (ro is RenderBox) {
                  final contentH = ro.size.height;
                  final screenH = MediaQuery.of(ctx).size.height;
                  const double chromePad = 32.0; // top handle/padding
                  final desired = ((contentH + chromePad) / screenH).clamp(
                    _minSize,
                    _maxSize,
                  );
                  final newInit = desired;
                  final newMin = desired.clamp(_minSize, newInit);
                  setSheetState(() {
                    _initSize = newInit;
                    _minSize = newMin;
                  });
                }
              });
            }

            Future<void> _gotoDelta(int delta) async {
              if (_orderCal.isEmpty) return;
              final next = _currIndex + delta;
              if (next < 0 || next >= _orderCal.length) return;
              setSheetState(() {
                _currIndex = next; // move cursor; UI will rebuild
              });
              _queueRecalc(); // re-measure after content changes
            }

            // initial measure after first layout
            _queueRecalc();

            final bool hasOrder = _orderCal.isNotEmpty;
            final bool atStart = hasOrder ? _currIndex <= 0 : true;
            final bool atEnd =
                hasOrder ? _currIndex >= _orderCal.length - 1 : true;

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: _initSize,
              minChildSize: _minSize,
              maxChildSize: _maxSize,
              builder: (_, controller) {
                return SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    key: _contentKey, // <-- measured
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
                            DateFormat('dd-MMM-yyyy').format(when),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      if (image.isNotEmpty)
                        GestureDetector(
                          onTap: () => _openFullScreenNetwork(image),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                              // re-measure once the image actually paints
                              loadingBuilder: (c, child, progress) {
                                if (progress == null) {
                                  _queueRecalc();
                                }
                                return child;
                              },
                            ),
                          ),
                        )
                      else
                        SizedBox.shrink(),

                      SizedBox(height: 20),

                      _navHeader(
                        ctx: context,
                        order: _orderCal,
                        index: _currIndex,
                        disabled: !hasOrder,
                        onPrev:
                            (!hasOrder || atStart)
                                ? null
                                : () => _gotoDelta(-1),
                        onNext:
                            (!hasOrder || atEnd) ? null : () => _gotoDelta(1),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // ===========================
  // EXAM TIMETABLE (in-place navigation)
  // ===========================
  void showExamTimeTable(
    BuildContext context,
    int examId, {
    List<int>? order, // ignored to enforce type-scope
    int? index, // ignored to enforce type-scope
  }) async {
    final allData = controller.announcementData.value;
    if (allData == null) return;

    final List<int> _orderEt = _dateSortedIdsSameTypeAs(
      data: allData,
      id: examId,
      fallbackType: 'exam',
    );
    if (_orderEt.isEmpty) return;

    // Current index inside exam-only order
    int _currIndexEt = _orderEt.indexOf(examId);
    if (_currIndexEt < 0) _currIndexEt = 0;

    if (controller.examDetails.value == null ||
        controller.examDetails.value!.exam.id != _orderEt[_currIndexEt]) {
      await controller.getExamDetailsList(examId: _orderEt[_currIndexEt]);
    }
    final initial = controller.examDetails.value;
    if (initial == null) return;

    dynamic _detailsEt = initial;
    bool _loadingEt = false;

    // ---- Auto-height state ----
    double _minSize = 0.40; // floor
    double _initSize = 0.55; // starting guess; will be recomputed
    double _maxSize = 0.95; // ceiling
    final GlobalKey _contentKey = GlobalKey();
    bool _queuedMeasure = false;

    void _queueRecalc(
      BuildContext ctx,
      void Function(void Function()) setSheetState,
    ) {
      if (_queuedMeasure) return;
      _queuedMeasure = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _queuedMeasure = false;
        final ro = _contentKey.currentContext?.findRenderObject();
        if (ro is RenderBox) {
          final contentH = ro.size.height;
          final screenH = MediaQuery.of(ctx).size.height;
          const double chromePad = 32.0; // handle/padding
          final desired = ((contentH + chromePad) / screenH).clamp(
            _minSize,
            _maxSize,
          );
          final newInit = desired;
          final newMin = desired.clamp(_minSize, newInit);
          setSheetState(() {
            _initSize = newInit;
            _minSize = newMin;
          });
        }
      });
    }

    String _txt(Object? v) => v?.toString() ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            Future<void> _gotoDelta(int d) async {
              if (_orderEt.isEmpty) return;
              final next = _currIndexEt + d;
              if (next < 0 || next >= _orderEt.length) return;
              setSheetState(() => _loadingEt = true);
              await controller.getExamDetailsList(examId: _orderEt[next]);
              final nd = controller.examDetails.value;
              if (nd != null) {
                _currIndexEt = next;
                _detailsEt = nd;
                _queueRecalc(ctx, setSheetState); // re-measure after data swap
              }
              setSheetState(() => _loadingEt = false);
            }

            final details = _detailsEt;

            // initial measurement after first layout
            _queueRecalc(ctx, setSheetState);

            return Stack(
              children: [
                DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: _initSize,
                  minChildSize: _minSize,
                  maxChildSize: _maxSize,
                  builder: (_, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        key: _contentKey, // <-- measured
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
                          const SizedBox(height: 16),
                          Text(
                            _txt(details?.exam?.heading),
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
                                '${_txt(details?.exam?.startDate)} to ${_txt(details?.exam?.endDate)}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          if (_txt(details?.exam?.timetableUrl).isNotEmpty)
                            GestureDetector(
                              onTap:
                                  () => _openFullScreenNetwork(
                                    _txt(details?.exam?.timetableUrl),
                                  ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  _txt(details?.exam?.timetableUrl),
                                  fit: BoxFit.cover,
                                  // re-measure once the image paints
                                  loadingBuilder: (c, child, progress) {
                                    if (progress == null) {
                                      _queueRecalc(ctx, setSheetState);
                                    }
                                    return child;
                                  },
                                ),
                              ),
                            )
                          else
                            SizedBox.shrink(),

                          const SizedBox(height: 20),

                          _navHeader(
                            ctx: context,
                            order: _orderEt,
                            index: _currIndexEt,
                            disabled: _loadingEt || _orderEt.length <= 1,
                            onPrev: () => _gotoDelta(-1),
                            onNext: () => _gotoDelta(1),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (_loadingEt)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(color: Colors.black12),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  // ===========================
  // INIT
  // ===========================
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.announcementData.value == null) {
        controller.getAnnouncement();
      }
    });
  }

  // ===========================
  // UI
  // ===========================
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
            return RefreshIndicator(
              onRefresh: () async => controller.getAnnouncement(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
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
                  ),
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => controller.getAnnouncement(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                            children: data.items.map((item) {
                              final formattedDate =
                              DateFormat("dd-MMM-yy").format(item.notifyDate);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: CustomContainer.announcementsScreen(
                                  mainText: item.announcementCategory,
                                  backRoundImage: item.image,
                                  iconData: CupertinoIcons.clock_fill,
                                  additionalText1: "Date",
                                  additionalText2: formattedDate,
                                  verticalPadding: 12,
                                  gradientStartColor: AppColor.black.withOpacity(0.01),
                                  gradientEndColor: AppColor.black,
                                  onDetailsTap: () => _openById(
                                    context,
                                    item.id,
                                    forceType: item.type,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );


          /*return RefreshIndicator(
            onRefresh: () async => controller.getAnnouncement(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
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
                          data.items.map((item) {
                            final formattedDate = DateFormat(
                              "dd-MMM-yy",
                            ).format(item.notifyDate);
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
                                onDetailsTap:
                                    () => _openById(
                                      context,
                                      item.id,
                                      forceType: item.type,
                                    ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );*/
        }),
      ),
    );
  }

  // ===========================
  // DOWNLOAD PDF (unchanged)
  // ===========================
  Future<void> _downloadAndOpenPdf(String? url) async {
    if (url == null || url.isEmpty) {
      Get.snackbar('Error', 'Download URL not available');
      return;
    }

    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        final openSettings = await Get.dialog(
          AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'Storage permission is required to download the receipt. Please enable it.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text('OK'),
              ),
            ],
          ),
          barrierDismissible: false,
        );

        if (openSettings == true) {
          final isOpened = await openAppSettings();
          if (!isOpened) {
            Get.snackbar('Error', 'Cannot open settings');
            return;
          }
          status = await Permission.manageExternalStorage.request();
          if (!status.isGranted) {
            Get.snackbar('Permission Denied', 'Storage permission not granted');
            return;
          }
        } else {
          return;
        }
      }
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        Get.back();
        Get.snackbar('Error', 'Failed to download file');
        return;
      }

      Directory dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final file = File(
        '${dir.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(response.bodyBytes);

      Get.back();
      Get.snackbar(
        'Success',
        'PDF saved to ${file.path}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        shouldIconPulse: false,
        duration: const Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
        padding: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString());
    }
  }
}

// navigate fees
/*  void _feessSheet(BuildContext context, int planId) async {
    final planData = await controller.getStudentPaymentPlan(id: planId);

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

    bool _launching = false; // tap guard

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            // Normalize/relax checks coming from API
            final type = (plan.paymentType ?? '').trim().toLowerCase();
            final isOnline = type.contains('online');
            final isCash = type.contains('cash');

            return Stack(
              children: [
                DraggableScrollableSheet(
                  initialChildSize: 0.65,
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
                          Image.asset(AppImages.announcement2),
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

                          // Plan title + due date
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

                          // Fee Items
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(plan.items.length, (idx) {
                              final item = plan.items[idx];
                              final isPaid =
                                  (item.status ?? '').trim().toLowerCase() ==
                                  'paid';
                              final href = (item.action?.href ?? '').trim();
                              final hasLink = href.isNotEmpty;
                              final hasId = item.studentId != null;

                              // Show Pay only for ONLINE, UNPAID items with valid link & id
                              final canPay =
                                  isOnline && !isPaid && hasLink && hasId;

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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
                                        onPressed:
                                            _launching
                                                ? null
                                                : () async {
                                                  setSheetState(
                                                    () => _launching = true,
                                                  );

                                                  try {
                                                    final newUrl =
                                                        "$href/${item.studentId}";

                                                    showDialog(
                                                      context: ctx,
                                                      barrierDismissible: false,
                                                      builder:
                                                          (_) => const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                    );

                                                    final result =
                                                        await Navigator.push(
                                                          ctx,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (_) =>
                                                                    PaymentWebView(
                                                                      url:
                                                                          newUrl,
                                                                    ),
                                                          ),
                                                        );

                                                    if (Navigator.canPop(ctx))
                                                      Navigator.pop(
                                                        ctx,
                                                      ); // close loader

                                                    if (result == null) {
                                                      ScaffoldMessenger.of(
                                                        ctx,
                                                      ).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            "Payment not completed.",
                                                          ),
                                                        ),
                                                      );
                                                      setSheetState(
                                                        () =>
                                                            _launching = false,
                                                      );
                                                      return;
                                                    }

                                                    final status =
                                                        (result["status"] ?? '')
                                                            .toString()
                                                            .toLowerCase();
                                                    if (status == "success") {
                                                      if (mounted &&
                                                          Navigator.canPop(
                                                            ctx,
                                                          )) {
                                                        Navigator.pop(
                                                          ctx,
                                                        ); // close fee sheet
                                                      }
                                                      Get.snackbar(
                                                        "Payment Successful",
                                                        "Your payment has been completed successfully.",
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        backgroundColor:
                                                            Colors.green,
                                                        colorText: Colors.white,
                                                        duration:
                                                            const Duration(
                                                              seconds: 2,
                                                            ),
                                                      );

                                                      if (mounted) {
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (
                                                                  _,
                                                                ) => CommonBottomNavigation(
                                                                  initialIndex:
                                                                      4,
                                                                  openReceiptForPlanId:
                                                                      planId,
                                                                ),
                                                          ),
                                                        );
                                                      }
                                                    } else if (status ==
                                                        "failure") {
                                                      Get.snackbar(
                                                        "Payment Failed",
                                                        (result["reason"] ??
                                                                "Something went wrong. Please try again.")
                                                            .toString(),
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        backgroundColor:
                                                            Colors.red,
                                                        colorText: Colors.white,
                                                      );
                                                      setSheetState(
                                                        () =>
                                                            _launching = false,
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                        ctx,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            "Payment finished with status: $status",
                                                          ),
                                                        ),
                                                      );
                                                      setSheetState(
                                                        () =>
                                                            _launching = false,
                                                      );
                                                    }
                                                  } catch (e) {
                                                    if (Navigator.canPop(ctx))
                                                      Navigator.pop(
                                                        ctx,
                                                      ); // close loader
                                                    ScaffoldMessenger.of(
                                                      ctx,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "Payment error: $e",
                                                        ),
                                                      ),
                                                    );
                                                    setSheetState(
                                                      () => _launching = false,
                                                    );
                                                  }
                                                },
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                            EdgeInsets.zero,
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          elevation: MaterialStateProperty.all(
                                            0,
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
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
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
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

                          if (isCash) ...[
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
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: AppColor.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              _downloadAndOpenPdf(plan.items[0].instructionUrl);
                              // downloadAndOpenPdf(
                              //   plan.items[0].instructionUrl,
                              // );

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
                                      Image.asset(
                                        AppImages.downloadImage,
                                        height: 20,
                                      ),
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
                ),

                // Tap guard overlay
                if (_launching)
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: false,
                      child: Container(color: Colors.black12),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }*/
