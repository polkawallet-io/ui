import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PluginButton extends StatelessWidget {
  PluginButton(
      {Key? key,
      this.onPressed,
      this.title = "",
      this.style,
      this.icon,
      this.submitting = false,
      this.backgroundColor,
      this.height})
      : super(key: key);
  final Function()? onPressed;
  final String title;
  final Widget? icon;
  final bool submitting;
  final double? height;
  final TextStyle? style;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.all(0),
      onPressed: !submitting ? onPressed : null,
      child: BgContainer(
        double.infinity,
        height: height ?? 48,
        alignment: Alignment.center,
        backgroundColor: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: submitting,
              child: Container(
                margin: EdgeInsets.only(right: 8),
                child: CupertinoActivityIndicator(),
              ),
            ),
            Text(title,
                style: style ??
                    Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: Color(0xFF17161F))),
            icon != null ? icon! : Container(),
          ],
        ),
      ),
    );
  }
}

class BgContainer extends StatelessWidget {
  const BgContainer(this.width,
      {this.margin,
      this.padding,
      this.child,
      this.alignment,
      this.height,
      this.backgroundColor,
      Key? key})
      : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: width,
            child: Row(
              children: [
                SvgPicture.asset(
                  'packages/polkawallet_ui/assets/images/bg_plugin_left.svg',
                  color: backgroundColor ?? Color(0xFFFC8156),
                  fit: BoxFit.fill,
                ),
                Expanded(
                    child: Container(
                  color: backgroundColor ?? Color(0xFFFC8156),
                )),
                SvgPicture.asset(
                  "packages/polkawallet_ui/assets/images/bg_plugin_right.svg",
                  color: backgroundColor ?? Color(0xFFFC8156),
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
          Container(
              margin: margin,
              width: width,
              padding: padding,
              alignment: alignment,
              child: child!)
        ],
      ),
    );
  }
}
