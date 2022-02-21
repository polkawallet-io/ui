import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTextTag.dart';

class PluginInputItem extends StatelessWidget {
  PluginInputItem(
      {this.label,
      this.labelStyle,
      this.labelBgColor,
      this.margin,
      required this.child,
      this.bgHeight});
  final String? label;
  final TextStyle? labelStyle;
  final Color? labelBgColor;
  final EdgeInsetsGeometry? margin;
  final Widget child;
  final double? bgHeight;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        children: [
          label != null
              ? PluginTextTag(
                  padding: EdgeInsets.zero,
                  title: label!,
                  style: labelStyle,
                  backgroundColor: labelBgColor ?? Color(0xFFFFFFFF),
                )
              : Container(),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: bgHeight ?? 52,
                decoration: BoxDecoration(
                    color: Color(0x24FFFFFF),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                        bottomRight: Radius.circular(6))),
              ),
              child
            ],
          )
        ],
      ),
    );
  }
}
