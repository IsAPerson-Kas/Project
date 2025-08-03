import 'package:flutter/material.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/extensions/color_extension.dart';
import 'package:media_guard_v2/presentation/widgets/guard_text_button.dart';

class TextFieldDialog extends StatelessWidget {
  final String title;
  final String activeButtonText;
  final VoidCallback onCancel;
  final Function(String) onActive;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  final bool isShowingCamera;

  const TextFieldDialog({
    super.key,
    required this.title,
    required this.activeButtonText,
    required this.onCancel,
    required this.onActive,
    required this.controller,
    required this.hintText,
    this.obscureText = false,

    this.isShowingCamera = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: const Color(0xFFF2F2F2),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey[400]!,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            obscureText: obscureText,
            autofocus: true,
          ),
          const SizedBox(height: 16),
          if (isShowingCamera)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacityValue(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withOpacityValue(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppStrings.warningFrontCameraActive,
                      style: TextStyle(
                        color: Colors.red[300],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: GuardTextButton(
                  label: AppStrings.cancel,
                  onTap: onCancel,
                  height: 48,
                  backgroundColor: const Color(0xFFF2F2F2),
                  textColor: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GuardTextButton(
                  label: activeButtonText,
                  onTap: () {
                    if (controller.text.isNotEmpty) {
                      onActive(controller.text);
                    }
                  },
                  height: 48,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
