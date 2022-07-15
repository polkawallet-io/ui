import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_ui/components/v3/iconButton.dart';
import 'package:polkawallet_ui/utils/index.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({this.onBack, this.margin, Key? key}) : super(key: key);

  final Function? onBack;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onBack != null) {
          onBack!();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Row(
            children: [
              IconButton(
                icon: Image.asset(
                  "packages/polkawallet_ui/assets/images/icon_back${UI.isDarkTheme(context) ? "_plugin" : ""}.png",
                  width: 8,
                ),
              )
            ],
          )),
    );
  }
}
