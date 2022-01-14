import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PluginCurrencyWithIcon extends StatelessWidget {
  PluginCurrencyWithIcon(
    this.symbol,
    this.icon, {
    this.textStyle,
    this.trailing,
    this.mainAxisAlignment,
  });

  final String symbol;
  final Widget icon;
  final TextStyle? textStyle;
  final MainAxisAlignment? mainAxisAlignment;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 2),
          child: icon,
        ),
        Expanded(
          flex: 0,
          child: Text(
            symbol,
            style: textStyle,
          ),
        ),
        trailing ?? Container()
      ],
    );
  }
}
