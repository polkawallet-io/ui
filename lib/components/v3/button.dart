import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/index.dart';

class Button extends StatelessWidget {
  const Button(
      {Key? key,
      this.onPressed,
      this.title = "",
      this.style,
      this.icon,
      this.submitting = false,
      this.isBlueBg = true,
      this.height,
      this.child})
      : super(key: key);
  final Function()? onPressed;
  final String title;
  final Widget? icon;
  final bool submitting;
  final double? height;
  final TextStyle? style;
  final bool isBlueBg;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: !submitting ? onPressed : null,
      child: BgContainer(
        double.infinity,
        height: height ?? 48,
        isBlueBg: isBlueBg,
        alignment: Alignment.center,
        child: child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: submitting,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: const CupertinoActivityIndicator(),
                  ),
                ),
                Text(title, style: style ?? Theme.of(context).textTheme.button),
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
      this.isBlueBg = false,
      this.alignment,
      this.height,
      Key? key})
      : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double width;
  final double? height;
  final bool isBlueBg;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: width,
            child: Row(
              children: [
                Image.asset(
                  "packages/polkawallet_ui/assets/images/bg_${isBlueBg ? "blue" : "grey"}_left${UI.isDarkTheme(context) ? "_dark" : ""}.png",
                  fit: BoxFit.fill,
                ),
                Expanded(
                    child: Image.asset(
                  "packages/polkawallet_ui/assets/images/bg_${isBlueBg ? "blue" : "grey"}_center${UI.isDarkTheme(context) ? "_dark" : ""}.png",
                  fit: BoxFit.fill,
                )),
                Image.asset(
                  "packages/polkawallet_ui/assets/images/bg_${isBlueBg ? "blue" : "grey"}_right${UI.isDarkTheme(context) ? "_dark" : ""}.png",
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
