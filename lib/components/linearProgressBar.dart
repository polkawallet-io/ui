import 'package:flutter/material.dart';

class LinearProgressbar extends StatelessWidget {
  const LinearProgressbar(
      {Key? key,
      this.color,
      this.backgroundColor,
      this.width,
      this.height,
      this.progress,
      this.borderRadius,
      this.margin})
      : super(key: key);
  final Color? color;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final double? progress;
  final double? borderRadius;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final num progressWidth = ((progress ?? 0.5) < 1 ? (progress ?? 0.5) : 1) *
        (width ?? MediaQuery.of(context).size.width);
    return Container(
      margin: margin ?? const EdgeInsets.only(top: 16, bottom: 8),
      child: Stack(
        children: [
          Container(
            height: height ?? 16,
            width: width ?? double.infinity,
            decoration: BoxDecoration(
                color: backgroundColor ?? Colors.black12,
                borderRadius:
                    BorderRadius.all(Radius.circular(borderRadius ?? 8))),
          ),
          Visibility(
              visible: progressWidth != 0,
              child: Container(
                height: height ?? 16,
                width: progressWidth < 8 ? 16 : progressWidth as double?,
                decoration: BoxDecoration(
                    color: color ?? Colors.blue,
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius ?? 8))),
              )),
        ],
      ),
    );
  }
}
