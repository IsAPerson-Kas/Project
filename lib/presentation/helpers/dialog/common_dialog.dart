import 'package:flutter/material.dart';
import 'package:media_guard_v2/core/constaints/global_keys.dart';

class CommonDialog {
  CommonDialog._();

  /// Show a common dialog with a child widget.
  ///
  /// [context] is the BuildContext where the dialog will be shown.
  /// [child] is the widget to display inside the dialog.
  /// [barrierDismissible] determines if tapping outside the dialog dismisses it.
  /// [barrierColor] is the color of the barrier behind the dialog.
  /// [backgroundColor] is the background color of the dialog.
  static Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    Color backgroundColor = const Color(0xFF1A1A1A),
    double borderRadius = 12.0,
    EdgeInsets insetPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
  }) {
    final context = GlobalKeys.navigatorKey.currentContext!;
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) {
        return Dialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          insetPadding: insetPadding,
          child: child,
        );
      },
    );
  }
}
