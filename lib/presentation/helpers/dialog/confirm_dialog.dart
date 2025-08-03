import 'package:flutter/material.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/extensions/color_extension.dart';
import 'package:media_guard_v2/presentation/widgets/guard_text_button.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelText,
    this.confirmText,
    required this.onCancel,
    required this.onConfirm,
  });

  final String title;
  final String message;
  final String? cancelText;
  final String? confirmText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          // Message
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacityValue(0.7),
            ),
          ),
          const SizedBox(height: 24),
          // Confirm Button (primary)
          GuardTextButton(
            label: confirmText ?? AppStrings.confirm,
            height: 45,
            width: double.infinity,
            backgroundColor: const Color(0xFF780EEA),
            onTap: onConfirm,
          ),
          const SizedBox(height: 12),
          // Cancel Button (secondary)
          GuardTextButton(
            label: cancelText ?? AppStrings.cancel,
            height: 45,
            width: double.infinity,
            backgroundColor: Colors.grey[700]!,
            onTap: onCancel,
          ),
        ],
      ),
    );
  }
}
