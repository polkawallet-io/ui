import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LinearProgressbar extends StatelessWidget {
  LinearProgressbar(
      {this.color, this.backgroundColor, this.width, this.progress, this.margin});
  final Color color;
  final Color backgroundColor;
  final double width;
  final double progress;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    final progressWidth = ((progress ?? 0.5) < 1 ? (progress ?? 0.5) : 1) *
        (width ?? MediaQuery.of(context).size.width);
    return Container(
      margin: margin ?? EdgeInsets.only(top: 16, bottom: 8),
      child: Stack(
        children: [
          Container(
            height: 16,
            width: width ?? double.infinity,
            decoration: BoxDecoration(
                color: backgroundColor ?? Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
          progressWidth == 0 ? Container() : Container(
            height: 16,
            width: progressWidth < 8 ? 16 : progressWidth,
            decoration: BoxDecoration(
                color: color ?? Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
        ],
      ),
    );
  }
}
