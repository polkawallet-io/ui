import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTextTag.dart';
import 'package:polkawallet_ui/utils/consts.dart';

class PluginTagCard extends StatelessWidget {
  const PluginTagCard(
      {Key? key,
      this.margin,
      this.padding,
      this.titleTag,
      this.child,
      this.radius = const Radius.circular(4),
      this.backgroundColor = const Color(0xFF3c3d40)})
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
            title: titleTag!,
            backgroundColor: PluginColorsDark.headline1,
          ),
          Container(
              width: double.infinity,
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
