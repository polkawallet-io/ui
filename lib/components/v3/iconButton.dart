import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_ui/utils/index.dart';

class IconButton extends StatelessWidget {
  const IconButton(
      {Key? key,
      this.margin,
      this.icon,
      this.isBlueBg = false,
      this.onPressed,
      this.bgColor,
      this.iconSize,
      this.padding,
      this.boxShadow})
      : super(key: key);

  final EdgeInsetsGeometry? margin;
  final Widget? icon;
  final double? iconSize;
  final bool isBlueBg;
  final BoxShadow? boxShadow;
  final Color? bgColor;
  final Function()? onPressed;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: padding ??
                (UI.isDarkTheme(context)
                    ? EdgeInsets.zero
                    : const EdgeInsets.only(right: 2, bottom: 1)),
            margin: margin,
            width: iconSize ?? 32.h,
            height: iconSize ?? 32.h,
            decoration: bgColor != null
                ? BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    boxShadow: boxShadow != null ? [boxShadow!] : [],
                  )
                : BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(!isBlueBg
                            ? "packages/polkawallet_ui/assets/images/icon_bg_grey${UI.isDarkTheme(context) ? "_dark" : ""}.png"
                            : "packages/polkawallet_ui/assets/images/icon_bg_blue${UI.isDarkTheme(context) ? "_dark" : ""}.png"),
                        fit: BoxFit.fill)),
            child: Center(
              child: icon,
            ),
          )),
    );
  }
}
