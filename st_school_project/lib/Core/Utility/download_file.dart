import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:st_school_project/Core/Utility/snack_bar.dart';

class DownloadFile {
  static Future<void> downloadAndSavePdf(
      String url, {
        required BuildContext context,
        String baseName = 'document',
        bool closeBottomSheet = true,
      }) async {
    _showLoading(context);

    try {
      final fileName =
      baseName.toLowerCase().endsWith('.pdf') ? baseName : '$baseName.pdf';

      // Download PDF bytes
      final response = await Dio().get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      final bytes = Uint8List.fromList(response.data ?? <int>[]);

      if (bytes.isEmpty) {
        CustomSnackBar.showError('Download failed');
        return;
      }

      // Save file using FilePicker
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save PDF as',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        bytes: bytes,
      );

      if (savedPath == null) return; // user cancelled

      // Open file automatically
      await OpenFilex.open(savedPath);

      // Show success snackbar
      Get.snackbar(
        'Success',
        'Saved & opened: ${p.basename(savedPath)}',
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
      CustomSnackBar.showError('$e');
    } finally {
      _hideLoading(context);
      if (closeBottomSheet && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }
  }

  static void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  static void _hideLoading(BuildContext context) {
    if (Navigator.canPop(context)) Navigator.of(context).pop();
  }
}
