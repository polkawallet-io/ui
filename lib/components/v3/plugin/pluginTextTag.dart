import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PluginTextTag extends StatelessWidget {
  const PluginTextTag(
      {this.margin,
      this.padding,
      this.title = "",
      this.style,
      this.backgroundColor,
      Key? key})
      : super(key: key);
  final String title;
  final TextStyle? style;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TagBgContainer(
        double.infinity,
        margin: margin,
        padding: padding,
        backgroundColor: backgroundColor,
        child: Text(
          title,
          style: style ??
              Theme.of(context).textTheme.headline4?.copyWith(
                  fontWeight: FontWeight.w600, color: Color(0xFF212123)),
        ),
      ),
    );
  }
}

class TagBgContainer extends StatelessWidget {
  const TagBgContainer(this.width,
      {this.margin,
      this.padding,
      this.child,
      this.height,
      this.backgroundColor,
      Key? key})
      : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double width;
  final double? height;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: width,
            child: Row(
              children: [
                SvgPicture.asset(
                  'packages/polkawallet_ui/assets/images/plugin_tag_bg_left.svg',
                  color: backgroundColor ?? Color(0xCCFFFFFF),
                ),
                Expanded(
                    child: Container(
                  color: backgroundColor ?? Color(0xCCFFFFFF),
                )),
                SvgPicture.asset(
                  "packages/polkawallet_ui/assets/images/plugin_tag_bg_right.svg",
                  color: backgroundColor ?? Color(0xCCFFFFFF),
                ),
              ],
            ),
          ),
          Container(width: width, padding: padding, child: child!)
        ],
      ),
    );
  }
}
