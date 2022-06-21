import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InnerShadowBGCar extends StatelessWidget {
  InnerShadowBGCar(
      {@required this.child, this.margin, this.padding, this.isWhite = false});
  Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.margin ?? EdgeInsets.zero,
      child: Column(
        children: [
          _InnerShadowTop(isWhite),
          Container(
            padding: this.padding ?? EdgeInsets.only(left: 16.w, right: 16.w),
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(
                  'packages/polkawallet_ui/assets/images/bg_input_mid${isWhite ? "_white" : ""}.png'),
              fit: BoxFit.fill,
            )),
            child: child,
          ),
          _InnerShadowBottom(isWhite),
        ],
      ),
    );
  }
}

class _InnerShadowTop extends StatelessWidget {
  _InnerShadowTop(this.isWhite);
  final bool isWhite;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Image.asset(
          'packages/polkawallet_ui/assets/images/bg_input_top${isWhite ? "_white" : ""}.png'),
    );
  }
}

class _InnerShadowBottom extends StatelessWidget {
  _InnerShadowBottom(this.isWhite);
  final bool isWhite;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Image.asset(
          'packages/polkawallet_ui/assets/images/bg_input_bottom${isWhite ? "_white" : ""}.png'),
    );
  }
}
