import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PluginLinearProgressbar extends StatelessWidget {
  PluginLinearProgressbar(
      {this.color,
      this.backgroundColor,
      this.width,
      this.progress,
      this.margin});
  final Color? color;
  final Color? backgroundColor;
  final double? width;
  final double? progress;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final progressWidth = ((progress ?? 0.5) < 1 ? (progress ?? 0.5) : 1) *
        (width ?? MediaQuery.of(context).size.width);
    final thumbWidth = 25.0;
    final thumbHeithg = 17.0;
    var thumbLeft = progressWidth != 0 ? progressWidth - thumbWidth / 2 : 0.0;
    thumbLeft =
        thumbLeft + thumbWidth > (width ?? MediaQuery.of(context).size.width)
            ? (width ?? MediaQuery.of(context).size.width) - thumbWidth
            : thumbLeft;
    thumbLeft = thumbLeft < 0 ? 0 : thumbLeft;
    return Container(
      margin: margin ?? EdgeInsets.only(top: 16, bottom: 8),
      child: Stack(
        children: [
          Container(
            height: 11,
            width: width ?? double.infinity,
            padding: EdgeInsets.all(1.5),
            margin: EdgeInsets.only(top: (thumbHeithg - 11) / 2),
            decoration: BoxDecoration(
                border: Border.all(color: Color(0x88FFFFFF), width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(2))),
            child: Container(
              color: backgroundColor ?? Colors.black12,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Visibility(
              visible: progressWidth != 0,
              child: Container(
                height: 11,
                width: progressWidth < 8 ? 16 : progressWidth,
                margin: EdgeInsets.only(top: (thumbHeithg - 11) / 2),
                padding: EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(2))),
                child: Container(
                  color: color ?? Colors.blue,
                  height: double.infinity,
                  width: double.infinity,
                ),
              )),
          Container(
              width: thumbWidth,
              height: thumbHeithg,
              margin: EdgeInsets.only(left: thumbLeft),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80ffffff),
                    blurRadius: 4.0, // has the effect of softening the shadow
                    spreadRadius: 0.0, // has the effect of extending the shadow
                    offset: Offset(
                      0.0, // horizontal, move right 10
                      0.0, // vertical, move down 10
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
