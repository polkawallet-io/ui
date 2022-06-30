import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PluginOutlinedButtonSmall extends StatelessWidget {
  const PluginOutlinedButtonSmall(
      {Key? key,
      this.content,
      this.active = false,
      this.color,
      this.margin,
      this.padding,
      this.onPressed,
      this.activeTextcolor,
      this.unActiveTextcolor,
      this.minSize = 33,
      this.fontSize})
      : super(key: key);
  final String? content;
  final bool active;
  final Color? color;
  final Color? activeTextcolor;
  final Color? unActiveTextcolor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Function? onPressed;
  final double? fontSize;
  final double? minSize;
  @override
  Widget build(BuildContext context) {
    final bgColor = active
        ? (color ?? Theme.of(context).primaryColor)
        : const Color(0xFF737675);
    final textColor = active
        ? activeTextcolor ?? const Color(0xFF26272C)
        : unActiveTextcolor ?? const Color(0xaa26272C);
    return Container(
        margin: margin ?? const EdgeInsets.only(right: 8),
        child: CupertinoButton(
            onPressed: onPressed as void Function()?,
            color: bgColor,
            disabledColor: const Color(0xFF737675),
            minSize: minSize,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            padding: padding ?? EdgeInsets.zero,
            child: Text(
              content!,
              style: Theme.of(context).textTheme.headline4?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                  color: textColor),
              textAlign: TextAlign.center,
            )));
  }
}
