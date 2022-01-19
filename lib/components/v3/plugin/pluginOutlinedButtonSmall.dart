import 'package:flutter/material.dart';

class PluginOutlinedButtonSmall extends StatelessWidget {
  PluginOutlinedButtonSmall(
      {this.content,
      this.active = false,
      this.color,
      this.margin,
      this.padding,
      this.onPressed});
  final String? content;
  final bool active;
  final Color? color;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Function? onPressed;
  @override
  Widget build(BuildContext context) {
    final bgColor =
        active ? color ?? Theme.of(context).primaryColor : Color(0x33FFFFFF);
    final textColor = active ? Color(0xFF26272C) : Color(0xaa26272C);
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
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(fontWeight: FontWeight.w600, color: textColor),
          textAlign: TextAlign.center,
        ),
      ),
      onTap: onPressed as void Function()?,
    );
  }
}
