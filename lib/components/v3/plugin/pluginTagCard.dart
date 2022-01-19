import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTextTag.dart';

class PluginTagCard extends StatelessWidget {
  const PluginTagCard(
      {Key? key, this.margin, this.padding, this.titleTag, this.child})
      : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final String? titleTag;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              margin: margin,
              decoration: BoxDecoration(
                  color: Color(0x24FFFFFF),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4))),
              child: child)
        ],
      ),
    );
  }
}
