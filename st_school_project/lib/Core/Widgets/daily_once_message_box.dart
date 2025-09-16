import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// your theme wrappers
import '../Utility/app_color.dart';
import '../Utility/google_font.dart' show GoogleFont;

/// A text composer that:
///  - sends a message via [onSend]
///  - hides itself after successful send
///  - allows sending only once per calendar day (local time) per [storageKey]
class DailyOnceMessageBox extends StatefulWidget {
  const DailyOnceMessageBox({
    super.key,
    required this.storageKey,
    required this.onSend,
    this.hintText = 'Type your message…',
    this.isTamil = false,
    this.maxLines = 6,
    this.maxLength,
    this.inputFormatters,
    this.autoHideAfterSend = true,
    this.decoration,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
    this.sendIcon,
    this.disabledNotice,
  });

  /// Unique key to mark "sent today".
  /// Example: "msg_parent_<studentId>"
  final String storageKey;

  /// Your async send handler. Throw to indicate failure.
  final Future<void> Function(String text) onSend;

  final String hintText;
  final bool isTamil;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  /// If true, composer becomes hidden after send.
  final bool autoHideAfterSend;

  final BoxDecoration? decoration;
  final EdgeInsetsGeometry padding;
  final IconData? sendIcon;

  /// Optional notice to show instead of the composer when locked.
  final Widget? disabledNotice;

  @override
  State<DailyOnceMessageBox> createState() => _DailyOnceMessageBoxState();
}

class _DailyOnceMessageBoxState extends State<DailyOnceMessageBox> {
  late final TextEditingController _ctrl;
  bool _hasSentToday = false;
  bool _hideComposer = false;
  bool _sending = false;

  String get _todayStr {
    final now = DateTime.now();
    return "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  String get _prefsKey => 'daily_once_${widget.storageKey}';

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
    _loadLock();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _loadLock() async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getString(_prefsKey);
    final locked = (last == _todayStr);
    setState(() {
      _hasSentToday = locked;
      _hideComposer = locked; // hide if already sent
    });
  }

  Future<void> _markSent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _todayStr);
  }

  Future<void> _onTapSend() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;

    if (_hasSentToday) {
      _snack('You can send only one message today.');
      return;
    }

    setState(() => _sending = true);
    try {
      await widget.onSend(text);
      await _markSent();
      if (!mounted) return;
      setState(() {
        _hasSentToday = true;
        _hideComposer = widget.autoHideAfterSend;
        _ctrl.clear();
      });
      _snack('Message sent ✅');
    } catch (e) {
      _snack('Failed to send: $e');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_hideComposer) {
      // Either show nothing or a small banner if provided
      return widget.disabledNotice ??
          const SizedBox
              .shrink(); // You can replace with a small info container if you want.
    }

    final formatters = widget.inputFormatters ??
        <TextInputFormatter>[
          FilteringTextInputFormatter.allow(
            RegExp(widget.isTamil
                ? r"[\u0B80-\u0BFF\s.,\-()'’]+"
                : r"[A-Za-z0-9\s.,\-()'’]+"),
          ),
          if (widget.maxLength != null)
            LengthLimitingTextInputFormatter(widget.maxLength),
        ];

    return Container(
      decoration: widget.decoration ??
          BoxDecoration(
            color: AppColor.lightGrey,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: _ctrl.text.isNotEmpty ? AppColor.black : AppColor.lightGrey,
              width: _ctrl.text.isNotEmpty ? 2 : 1,
            ),
          ),
      child: Padding(
        padding: widget.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _ctrl,
                builder: (_, value, __) {
                  final hasText = value.text.trim().isNotEmpty;
                  return TextField(
                    controller: _ctrl,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: widget.maxLines,
                    inputFormatters: formatters,
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 16,
                      color: AppColor.black,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: GoogleFont.ibmPlexSans(
                        color: AppColor.grayop,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      counterText: '',
                      suffixIcon: hasText
                          ? GestureDetector(
                        onTap: () => _ctrl.clear(),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12, right: 8),
                          child: Text(
                            'Clear',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColor.grayop,
                            ),
                          ),
                        ),
                      )
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: _sending ? null : _onTapSend,
              borderRadius: BorderRadius.circular(30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _sending ? AppColor.grey : AppColor.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: _sending
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Icon(
                  widget.sendIcon ?? Icons.send_rounded,
                  color: AppColor.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
