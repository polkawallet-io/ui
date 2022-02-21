import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgressBar extends CustomPainter {
  List<Color> lineColor;
  double width;
  double progress; //0-1
  late double endAngle;
  double startAngle;

  CircularProgressBar(
      {required this.lineColor,
      required this.width,
      this.progress = 1,
      this.startAngle = pi / 2}) {
    this.endAngle = this.progress / 1 * 2 * pi;
  }
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius =
        min(size.width / 2 - width / 2, size.height / 2 - width / 2);

    var paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = width;

    paint.shader = SweepGradient(
      startAngle: 0,
      endAngle: 2 * pi,
      colors: lineColor,
      transform: GradientRotation(this.startAngle - 0.2 * pi),
    ).createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        this.startAngle, endAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as CircularProgressBar).progress != this.progress;
  }
}
