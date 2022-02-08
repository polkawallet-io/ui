import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconButton extends StatelessWidget {
  const IconButton(
      {Key? key, this.margin, this.icon, this.isBlueBg = false, this.onPressed})
      : super(key: key);

  final EdgeInsetsGeometry? margin;
  final Widget? icon;
  final bool isBlueBg;
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
            decoration: BoxDecoration(
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
