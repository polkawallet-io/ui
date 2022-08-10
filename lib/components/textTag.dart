import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/index.dart';

class TextTag extends StatelessWidget {
  TextTag(this.text,
      {this.margin, this.padding, this.color, this.textColor, this.fontSize});
  final String? text;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(2),
      padding: padding ?? const EdgeInsets.fromLTRB(4, 2, 4, 2),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Text(
        text!,
        style: TextStyle(
          fontSize: fontSize ?? UI.getTextSize(10, context),
          color: textColor ?? Theme.of(context).cardColor,
        ),
      ),
    );
  }
}
