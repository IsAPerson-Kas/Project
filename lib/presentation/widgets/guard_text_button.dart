import 'package:flutter/material.dart';

class GuardTextButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String label;
  final Function onTap;
  final Color backgroundColor;
  final Color textColor;
  const GuardTextButton({
    super.key,
    required this.label,
    this.backgroundColor = const Color(0xFF780EEA),
    this.textColor = Colors.white,
    this.width,
    this.height = 50.0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: backgroundColor,
        ),
        child: IgnorePointer(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
