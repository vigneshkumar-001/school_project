import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:st_school_project/Core/Utility/snack_bar.dart';

// class DownloadFile {
//   static Future<void> downloadAndSavePdf(
//       String url, {
//         required BuildContext context,
//         String baseName = 'document',
//         bool closeBottomSheet = true,
//       }) async {
//     _showLoading(context);
//
//     try {
//       final fileName =
//       baseName.toLowerCase().endsWith('.pdf') ? baseName : '$baseName.pdf';
//
//       // Download PDF bytes
//       final response = await Dio().get<List<int>>(
//         url,
//         options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: true,
//         ),
//       );
//
//       final bytes = Uint8List.fromList(response.data ?? <int>[]);
//
//       if (bytes.isEmpty) {
//         CustomSnackBar.showError('Download failed');
//         return;
//       }
//
//       // Save file using FilePicker
//       final savedPath = await FilePicker.platform.saveFile(
//         dialogTitle: 'Save PDF as',
//         fileName: fileName,
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//         bytes: bytes,
//       );
//
//       if (savedPath == null) return; // user cancelled
//
//       // Open file automatically
//       await OpenFilex.open(savedPath);
//
//       // Show success snackbar
//       Get.snackbar(
//         'Success',
//         'Saved & opened: ${p.basename(savedPath)}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green.shade600,
//         colorText: Colors.white,
//         borderRadius: 12,
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         icon: const Icon(Icons.check_circle_outline, color: Colors.white),
//         shouldIconPulse: false,
//         duration: const Duration(seconds: 3),
//         snackStyle: SnackStyle.FLOATING,
//         padding: const EdgeInsets.all(16),
//       );
//     } catch (e) {
//       CustomSnackBar.showError('$e');
//     } finally {
//       _hideLoading(context);
//       if (closeBottomSheet && Navigator.canPop(context)) {
//         Navigator.of(context).pop();
//       }
//     }
//   }
//
//   static void _showLoading(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(child: CircularProgressIndicator()),
//     );
//   }
//
//   static void _hideLoading(BuildContext context) {
//     if (Navigator.canPop(context)) Navigator.of(context).pop();
//   }
// }
///new///
// class DownloadFile {
//   static Future<void> downloadAndSavePdf(
//     String url, {
//     required BuildContext context,
//     String baseName = 'document',
//   }) async {
//     // Show loader
//     _showLoading(context);
//
//     try {
//       final fileName =
//           baseName.toLowerCase().endsWith('.pdf') ? baseName : '$baseName.pdf';
//
//       // Download PDF bytes
//       final response = await Dio().get<List<int>>(
//         url,
//         options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: true,
//         ),
//       );
//
//       final bytes = Uint8List.fromList(response.data ?? <int>[]);
//
//       if (bytes.isEmpty) {
//         CustomSnackBar.showError('Download failed');
//         return;
//       }
//
//       // Save file using FilePicker
//       final savedPath = await FilePicker.platform.saveFile(
//         dialogTitle: 'Save PDF as',
//         fileName: fileName,
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//         bytes: bytes,
//       );
//
//       if (savedPath == null) return; // user cancelled
//
//       // Open file automatically
//       await OpenFilex.open(savedPath);
//
//       // Show success snackbar
//       Get.snackbar(
//         'Success',
//         'Saved & opened: ${p.basename(savedPath)}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green.shade600,
//         colorText: Colors.white,
//         borderRadius: 12,
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         icon: const Icon(Icons.check_circle_outline, color: Colors.white),
//         shouldIconPulse: false,
//         duration: const Duration(seconds: 3),
//         snackStyle: SnackStyle.FLOATING,
//         padding: const EdgeInsets.all(16),
//       );
//     } catch (e) {
//       CustomSnackBar.showError('$e');
//     } finally {
//       _hideLoading(context);
//     }
//   }
//
//   static void _showLoading(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(child: CircularProgressIndicator()),
//     );
//   }
//
//   static void _hideLoading(BuildContext context) {
//     if (Navigator.canPop(context)) {
//       Navigator.of(context).pop(); // only pop the loader dialog
//     }
//   }
// }
///chromeOpen///
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class DownloadFile {
//   /// Receipt / PDF URL-a direct-ah browser la open pannum
//   static Future<void> openInBrowser(
//       String url, {
//         required BuildContext context,
//       }) async {
//     try {
//       final uri = Uri.parse(url);
//
//       final can = await canLaunchUrl(uri);
//       if (!can) {
//         Get.snackbar(
//           'Error',
//           'Could not open link',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red.shade600,
//           colorText: Colors.white,
//         );
//         return;
//       }
//
//       final ok = await launchUrl(
//         uri,
//         mode: LaunchMode.externalApplication, // 👉 phone-oda default browser (Chrome etc.)
//       );
//
//       if (!ok) {
//         Get.snackbar(
//           'Error',
//           'Failed to open browser',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red.shade600,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         '$e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.shade600,
//         colorText: Colors.white,
//       );
//     }
//   }
// }

///newChromeOpen///
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadFile {
  /// Opens the given [url] directly in Chrome (shows Chrome’s download option for PDFs).
  static Future<void> openInBrowser(
    String url, {
    required BuildContext context,
  }) async {
    try {
      url = url.trim();

      if (url.isEmpty) {
        _showError('Empty download link');
        return;
      }

      // Ensure proper protocol
      if (!url.startsWith(RegExp(r'https?://'))) {
        url = 'https://$url';
      }

      final Uri normalUri = Uri.parse(url);
      bool launched = false;

      if (Platform.isAndroid) {
        // Try Chrome app scheme
        final Uri chromeUri = Uri.parse("googlechrome://$url");
        if (await canLaunchUrl(chromeUri)) {
          launched = await launchUrl(chromeUri);
        }
      } else if (Platform.isIOS) {
        // iOS Chrome uses 'googlechromes://' for HTTPS
        final String chromeScheme =
            url.startsWith('https') ? 'googlechromes://' : 'googlechrome://';
        final String chromeUrl = url.replaceFirst(RegExp(r'^https?://'), '');
        final Uri chromeUri = Uri.parse('$chromeScheme$chromeUrl');

        if (await canLaunchUrl(chromeUri)) {
          launched = await launchUrl(chromeUri);
        }
      }

      // Fallback: open in default browser if Chrome unavailable
      if (!launched) {
        launched = await launchUrl(
          normalUri,
          mode: LaunchMode.externalApplication,
        );
      }

      if (!launched) {
        _showError('Could not open link in Chrome or browser');
      }
    } catch (e) {
      _showError('Unexpected error: $e');
    }
  }

  static void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
    );
  }
}
