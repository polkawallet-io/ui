import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTextTag.dart';

class PluginTagCard extends StatelessWidget {
  const PluginTagCard(
      {Key? key,
      this.margin,
      this.padding,
      this.titleTag,
      this.child,
      this.radius = const Radius.circular(4),
      this.backgroundColor = const Color(0x24FFFFFF)})
      : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final String? titleTag;
  final Widget? child;
  final Radius radius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PluginTextTag(
            padding: EdgeInsets.zero,
            title: titleTag!,
            backgroundColor: Color(0xCCFFFFFF),
          ),
          Container(
              padding: padding,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: this.radius,
                      topRight: this.radius,
                      bottomRight: this.radius)),
              child: child)
        ],
      ),
    );
  }
}
