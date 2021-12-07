import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends StatelessWidget {
  Button({Key? key, this.onPressed, @required this.title = ""})
      : super(key: key);
  Function()? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
            image: AssetImage(
                "packages/polkawallet_ui/assets/images/button_blue.png"),
            fit: BoxFit.fill),
      ),
      alignment: Alignment.center,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }
}
