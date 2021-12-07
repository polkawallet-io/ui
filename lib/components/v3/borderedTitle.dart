import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BorderedTitle extends StatelessWidget {
  BorderedTitle({this.title});
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18.w,
          height: 34.h,
          margin: EdgeInsets.only(right: 9.w),
          child: Image.asset(
              'packages/polkawallet_ui/assets/images/icon_bordered.png'),
        ),
        Text(
          title!,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: Theme.of(context).textSelectionColor,
              fontFamily: "TitilliumWeb"),
        )
      ],
    );
  }
}
