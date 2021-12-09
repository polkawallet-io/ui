import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends StatelessWidget {
  Button(
      {Key? key,
      this.onPressed,
      this.title = "",
      this.style,
      this.icon,
      this.submitting = false,
      this.height})
      : super(key: key);
  final Function()? onPressed;
  final String title;
  final Widget? icon;
  final bool submitting;
  final double? height;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.all(0),
      onPressed: !submitting ? onPressed : null,
      child: Container(
        width: double.infinity,
        height: height ?? 58,
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
              image: AssetImage(
                  "packages/polkawallet_ui/assets/images/button_blue.png"),
              fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
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
            Text(title, style: style ?? Theme.of(context).textTheme.button),
            icon != null ? icon! : Container(),
          ],
        ),
      ),
    );
  }
}

class ShortButton extends StatelessWidget {
  ShortButton(
      {Key? key,
      this.onPressed,
      required this.title,
      this.style,
      this.isBlueBg = false,
      this.icon})
      : super(key: key);
  final Function()? onPressed;
  final String title;
  final TextStyle? style;
  final bool isBlueBg;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15.h),
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
                image: AssetImage(isBlueBg
                    ? "packages/polkawallet_ui/assets/images/button_blue_short.png"
                    : "packages/polkawallet_ui/assets/images/button_grey_short.png"),
                fit: BoxFit.fill),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: style ?? Theme.of(context).textTheme.button,
              ),
              icon != null ? icon! : Container(),
            ],
          ),
        ));
  }
}
