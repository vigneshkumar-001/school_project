import 'package:flutter/material.dart';

class CustomSnackBar {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void _showSnackBar(
    String title,
    String message,
    Color backgroundColor,
    IconData icon,
  ) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$title: $message',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  static void showSuccess(String message) {
    _showSnackBar('Success', message, Colors.green, Icons.check_circle);
  }

  static void showError(String message, {String title = 'Error'}) {
    _showSnackBar(title, message, Colors.red, Icons.error);
  }

  static void showInfo(String message) {
    _showSnackBar('Notice', message, Colors.blueAccent, Icons.info);
  }
}
