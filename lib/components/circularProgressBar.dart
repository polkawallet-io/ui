import 'dart:math';

import 'package:flutter/material.dart';

class AnimationCircularProgressBar extends StatefulWidget {
  AnimationCircularProgressBar(
      {required this.lineColor,
      required this.width,
      required this.progress,
      this.size = 96,
      this.startAngle = pi / 2,
      this.bgColor = Colors.transparent,
      Key? key})
      : super(key: key);
  final double progress;
  final double size;
  List<Color> lineColor;
  double width;
  double startAngle;
  Color bgColor;

  @override
  State<AnimationCircularProgressBar> createState() =>
      AnimationCircularProgressBarState();
}

class AnimationCircularProgressBarState
    extends State<AnimationCircularProgressBar> with TickerProviderStateMixin {
  AnimationController? controller;
  double animationNumber = 0;
  late Animation<double> animation;

  void _startAnimation(double progress) {
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation =
        Tween(begin: animationNumber, end: progress).animate(controller!);
    animation.addListener(() {
      setState(() {
        animationNumber = animation.value;
      });
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      controller!.forward();
    });
  }

  @override
  void didUpdateWidget(covariant AnimationCircularProgressBar oldWidget) {
    if (controller == null ||
        (!controller!.isAnimating && oldWidget.progress != widget.progress)) {
      _startAnimation(widget.progress);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: CircularProgressBar(
            startAngle: widget.startAngle,
            width: widget.width,
            lineColor: widget.lineColor,
            progress: controller != null && controller!.isAnimating
                ? animationNumber
                : widget.progress,
            bgColor: widget.bgColor),
      ),
    );
  }
}

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
    endAngle = progress / 1 * 2 * pi;
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
          startAngle - ((1 - progress) <= 0.04 ? 0 : 0.05 * pi)),
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

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        endAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as CircularProgressBar).progress != progress;
  }
}
