import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTextTag.dart';

class PluginInputItem extends StatelessWidget {
  PluginInputItem(
      {this.label,
      this.labelStyle,
      this.labelBgColor,
      this.margin,
      required this.child,
      this.bgHeight,
      this.bgColor});
  final String? label;
  final TextStyle? labelStyle;
  final Color? labelBgColor;
  final EdgeInsetsGeometry? margin;
  final Widget child;
  final double? bgHeight;
  final Color? bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        children: [
          label != null
              ? PluginTextTag(
                  title: label!,
                  style: labelStyle,
                  backgroundColor: labelBgColor,
                )
              : Container(),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: bgHeight ?? 52,
                decoration: BoxDecoration(
                    color: bgColor ?? Color(0x24FFFFFF),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(label == null ? 4 : 0),
                        bottomLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4))),
              ),
              child
            ],
          )
        ],
      ),
    );
  }
}
