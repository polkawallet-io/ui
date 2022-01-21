import 'package:flutter/material.dart';

class PluginOutlinedButtonSmall extends StatelessWidget {
  PluginOutlinedButtonSmall(
      {this.content,
      this.active = false,
      this.color,
      this.margin,
      this.padding,
      this.onPressed,
      this.activeTextcolor,
      this.unActiveTextcolor,
      this.fontSize});
  final String? content;
  final bool active;
  final Color? color;
  final Color? activeTextcolor;
  final Color? unActiveTextcolor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Function? onPressed;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    final bgColor =
        active ? color ?? Theme.of(context).primaryColor : Color(0x33FFFFFF);
    final textColor = active
        ? activeTextcolor ?? Color(0xFF26272C)
        : unActiveTextcolor ?? Color(0xaa26272C);
    return GestureDetector(
      child: Container(
        margin: margin ?? EdgeInsets.only(right: 8),
        padding: padding ?? EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Text(
          content!,
          style: Theme.of(context).textTheme.headline4?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
              color: textColor),
          textAlign: TextAlign.center,
        ),
      ),
      onTap: onPressed as void Function()?,
    );
  }
}
