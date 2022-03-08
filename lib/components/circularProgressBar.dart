import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgressBar extends CustomPainter {
  List<Color> lineColor;
  double width;
  double progress; //0-1
  late double endAngle;
  double startAngle;
  Color bgColor;

  CircularProgressBar(
      {required this.lineColor,
      required this.width,
      this.progress = 1,
      this.startAngle = pi / 2,
      this.bgColor = Colors.transparent}) {
    this.endAngle = this.progress / 1 * 2 * pi;
  }
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius =
        min(size.width / 2 - width / 2, size.height / 2 - width / 2);

    var paint = Paint()
      ..strokeCap = (1 - progress) <= 0.04 ? StrokeCap.butt : StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = width;

    paint.shader = SweepGradient(
      startAngle: 0,
      endAngle: 2 * pi,
      colors: lineColor,
      transform: GradientRotation(
          this.startAngle - ((1 - progress) <= 0.04 ? 0 : 0.05 * pi)),
    ).createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    var bgpaint = Paint()
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..color = bgColor
      ..isAntiAlias = true
      ..strokeWidth = width;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0, 2 * pi,
        false, bgpaint);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        this.startAngle, endAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as CircularProgressBar).progress != this.progress;
  }
}
