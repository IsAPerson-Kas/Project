import 'package:flutter/material.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/extensions/color_extension.dart';
import 'package:media_guard_v2/presentation/widgets/guard_text_button.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    required this.onAcknowledge,
  });

  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback onAcknowledge;

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
          // OK Button
          GuardTextButton(
            label: buttonText ?? AppStrings.ok,
            height: 45,
            width: double.infinity,
            backgroundColor: const Color(0xFF780EEA),
            onTap: () {
              onAcknowledge();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
