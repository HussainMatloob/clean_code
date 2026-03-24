import 'dart:math';
import 'package:flutter/widgets.dart';

class Scale {
  static late double _width;
  static late double _height;

  static late double _wRatio;
  static late double _hRatio;
  static late double _textRatio;
  static late double _radiusRatio;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;

    // Base design
    const baseWidth = 375;
    const baseHeight = 812;

    _wRatio = _width / baseWidth;
    _hRatio = _height / baseHeight;

    // Text scaling logic per platform size
    if (_width < 600) {
      // Mobile
      _textRatio = _wRatio.clamp(0.85, 1.05);
    } else if (_width < 1024) {
      // Tablet
      _textRatio = (_wRatio * 0.95).clamp(1.0, 1.15);
    } else {
      // Desktop
      _textRatio = (_wRatio * 0.75).clamp(1.1, 1.3);
    }

    // Radius should scale gently
    _radiusRatio = min(_wRatio, _hRatio).clamp(0.9, 1.4);
  }

  static double w(num v) => v * _wRatio;
  static double h(num v) => v * _hRatio;
  static double sp(num v) => v * _textRatio;
  static double r(num v) => v * _radiusRatio;
}
