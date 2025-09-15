import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_school_project/Core/Utility/app_images.dart';
import 'package:st_school_project/Core/Widgets/custom_app_button.dart';
import '../../../../Core/Utility/app_color.dart';
import '../../../../Core/Utility/google_font.dart';

import '../../../../Core/Widgets/custom_container.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late final TextEditingController textController;
  static const _kLastSentKey = 'last_message_sent_yyyy_mm_dd';
  String? _lastSentYmd; // e.g., "2025-09-15"
  Timer? _ticker; // ticks every second to update countdown
  Duration _timeToMidnight = Duration.zero;
  bool _initializing = true;

  @override
  void initState() {
    super.initState();
    // 1) CREATE CONTROLLER ONCE (not inside build)
    textController = TextEditingController();
    _initDailyLimit();
  }

  Future<void> _initDailyLimit() async {
    final prefs = await SharedPreferences.getInstance();
    _lastSentYmd = prefs.getString(_kLastSentKey);

    _updateTimeToMidnight();
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateTimeToMidnight(),
    );

    setState(() {
      _initializing = false;
    });
  }

  void _updateTimeToMidnight() {
    final now = DateTime.now();
    final nextMidnight = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1));
    setState(() {
      _timeToMidnight = nextMidnight.difference(now);
    });
  }

  bool get _sentToday {
    final now = DateTime.now();
    final ymd = _fmtYmd(now);
    return _lastSentYmd == ymd;
  }

  String _fmtYmd(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  String _fmtHms(Duration d) {
    final total = d.isNegative ? Duration.zero : d;
    final hh = total.inHours.toString().padLeft(2, '0');
    final mm = (total.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (total.inSeconds % 60).toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  Future<void> _markSentToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _fmtYmd(DateTime.now());
    await prefs.setString(_kLastSentKey, today);
    setState(() {
      _lastSentYmd = today;
    });
  }

  Future<void> _handleSend() async {
    if (_sentToday) {
      // Already sent—optional feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You can send only once per day. Next in ${_fmtHms(_timeToMidnight)}',
          ),
        ),
      );
      return;
    }

    final text = textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Type a message before sending.')),
      );
      return;
    }

    // TODO: call your API here
    // await sendToClassTeacher(text);

    // Mark as sent for today
    await _markSentToday();

    // Optional: clear the field
    textController.clear();

    // Feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message sent to Class Teacher')),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel(); // <-- stop the ticking timer
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            _initializing
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomContainer.leftSaitArrow(
                          onTap: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 33),
                        Text(
                          'Today Message to Teacher',
                          style: GoogleFont.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: AppColor.black,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // =======================
                        // IF ALREADY SENT TODAY:
                        // =======================
                        if (_sentToday) ...[
                          // Nice countdown card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColor.lowLightBlue,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColor.grayop.withOpacity(.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Limit reached for today',
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Next message available in ${_fmtHms(_timeToMidnight)}',
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.grayop,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          // =======================
                          // NOT SENT YET: Show input + Send
                          // =======================
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 11,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.lightGrey,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color:
                                    textController.text.isNotEmpty
                                        ? AppColor.black
                                        : AppColor.lightGrey,
                                width: textController.text.isNotEmpty ? 2 : 1,
                              ),
                            ),
                            child: TextFormField(
                              controller: textController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: GoogleFont.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              minLines: 5,
                              maxLines: 10,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: 'Type Here',
                                hintStyle: GoogleFont.inter(
                                  color: AppColor.grayop,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                suffixIcon:
                                    textController.text.isNotEmpty
                                        ? GestureDetector(
                                          onTap: () {
                                            textController.clear();
                                            setState(() {});
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 12,
                                              right: 8,
                                            ),
                                            child: Text(
                                              'Clear',
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.grayop,
                                              ),
                                            ),
                                          ),
                                        )
                                        : null,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'You can send 1 message today',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          AppButton.button(
                            text: 'Send to Class Teacher',
                            onTap: _handleSend,
                            image: AppImages.rightSaitArrow,
                            width: double.infinity,
                          ),
                        ],

                        const SizedBox(height: 20),
                        Text(
                          'History',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColor.black,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Your existing history tiles...
                        CustomContainer.messageScreen(
                          IconOntap: () {},
                          Reacts: 'Teacher Reacts',
                          ImagePath: AppImages.likeImage,
                          mainText:
                              'Praghadheeswari has fever from yesterday night, i gives the tablet to her, please ensure she will eat the table',
                          backRoundColor: AppColor.lowLightBlue,
                          Date: '18-07-2025',
                          time: '4.30Pm',
                        ),
                        const SizedBox(height: 15),
                        CustomContainer.messageScreen(
                          mainText:
                              'Praghadheeswari has fever from yesterday night, i gives the tablet to her, please ensure she will eat the table',
                          backRoundColor: AppColor.lowLightYellow,
                          Date: '18-07-2025',
                          time: '4.30Pm',
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  /*  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer.leftSaitArrow(
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(height: 33),
                Text(
                  'Today Message to Teacher',
                  style: GoogleFont.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                ),
                SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.lightGrey,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color:
                          textController.text.isNotEmpty
                              ? AppColor.black
                              : AppColor.lightGrey,
                      width: textController.text.isNotEmpty ? 2 : 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: textController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: GoogleFont.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),

                    // multiline text
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 5,
                    maxLines: 10,

                    onChanged: (_) => setState(() {}),

                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Type Here',
                      hintStyle: GoogleFont.inter(
                        color: AppColor.grayop,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      suffixIcon:
                          textController.text.isNotEmpty
                              ? GestureDetector(
                                onTap: () {
                                  textController.clear();
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12,
                                    right: 8,
                                  ),
                                  child: Text(
                                    'Clear',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.grayop,
                                    ),
                                  ),
                                ),
                              )
                              : null,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _sentToday
                          ? 'Limit reached for today'
                          : 'You can send 1 message today',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _sentToday ? AppColor.grayop : AppColor.black,
                      ),
                    ),
                    if (_sentToday)
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: AppColor.grayop,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _fmtHms(_timeToMidnight),
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColor.grayop,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 20),
                AppButton.button(
                  text: 'Send to Class Teacher',
                  onTap: _handleSend,
                  image: AppImages.rightSaitArrow,
                  width: double.infinity,
                ),
                SizedBox(height: 20),
                Text(
                  'History',
                  style: GoogleFont.ibmPlexSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColor.black,
                  ),
                ),
                SizedBox(height: 15),
                CustomContainer.messageScreen(
                  IconOntap: () {},
                  Reacts: 'Teacher Reacts',
                  ImagePath: AppImages.likeImage,
                  mainText:
                      'Praghadheeswari has fever from yesterday night, i gives the tablet to her, please ensure she will eat the table',
                  backRoundColor: AppColor.lowLightBlue,
                  Date: '18-07-2025',
                  time: '4.30Pm',
                ),
                SizedBox(height: 15),
                CustomContainer.messageScreen(
                  mainText:
                      'Praghadheeswari has fever from yesterday night, i gives the tablet to her, please ensure she will eat the table',
                  backRoundColor: AppColor.lowLightYellow,
                  Date: '18-07-2025',
                  time: '4.30Pm',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }*/
}
