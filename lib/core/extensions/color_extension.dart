import 'package:flutter/material.dart';

extension ColorOpacity on Color {
  Color withOpacityValue(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((255 * opacity).round());
  }
}
