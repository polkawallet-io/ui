import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconButton extends StatelessWidget {
  const IconButton(
      {Key? key,
      this.margin,
      this.icon,
      this.isBlueBg = false,
      this.hasShadow = false,
      this.onPressed,
      this.bgColor})
      : super(key: key);

  final EdgeInsetsGeometry? margin;
  final Widget? icon;
  final bool isBlueBg;
  final Color? bgColor;
  final bool? hasShadow;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.only(right: 1, bottom: 1),
            margin: margin,
            width: 32.h,
            height: 32.h,
            decoration: bgColor != null
                ? BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    boxShadow: hasShadow == true
                        ? [
                            BoxShadow(
                              offset: Offset(1, 1),
                              blurRadius: 1,
                              spreadRadius: 0, //阴影范围
                              color: Colors.black.withOpacity(0.33), //阴影颜色
                            ),
                          ]
                        : [],
                  )
                : BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(!isBlueBg
                            ? "packages/polkawallet_ui/assets/images/icon_bg_grey.png"
                            : "packages/polkawallet_ui/assets/images/icon_bg_blue.png"),
                        fit: BoxFit.fill)),
            child: Center(
              child: icon,
            ),
          )),
    );
  }
}
