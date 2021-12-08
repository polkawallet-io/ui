import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends StatelessWidget {
  Button({Key? key, this.onPressed, @required this.title = "", this.style})
      : super(key: key);
  Function()? onPressed;
  final String title;
  final TextStyle? style;

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
                image: AssetImage(
                    "packages/polkawallet_ui/assets/images/button_blue.png"),
                fit: BoxFit.fill),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: style ?? Theme.of(context).textTheme.button,
          ),
        ));
  }
}
