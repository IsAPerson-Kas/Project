import 'package:flutter/material.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/extensions/color_extension.dart';
import 'package:media_guard_v2/presentation/widgets/guard_text_button.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    required this.onClose,
  });

  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback onClose;

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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.red,
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
          // Close Button
          GuardTextButton(
            label: buttonText ?? AppStrings.close,
            height: 45,
            width: double.infinity,
            backgroundColor: Colors.red,
            onTap: () {
              onClose();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
