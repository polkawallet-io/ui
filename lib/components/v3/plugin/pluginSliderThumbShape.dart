import 'dart:async';
import 'package:flutter/material.dart';

class PluginSliderThumbShape extends SliderComponentShape {
  const PluginSliderThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(25, 17);
  }

  @override
  Future<void> paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) async {
    final Canvas canvas = context.canvas;
    final rrect = RRect.fromLTRBXY(center.dx - 12.5, center.dy - 8.5,
        center.dx + 12.5, center.dy + 8.5, 6.0, 6.0);
    canvas.drawShadow(
        Path()
          ..addRRect(
            RRect.fromLTRBXY(rrect.left - 1, rrect.top - 1, rrect.right + 1,
                rrect.bottom + 1, 6.0, 6.0),
          )
          ..close(),
        const Color(0x80FFFFFF),
        0.5,
        true);
    canvas.drawRRect(
        rrect,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);
  }
}
