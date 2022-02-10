import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InnerShadowBGCar extends StatelessWidget {
  InnerShadowBGCar({@required this.child, this.margin, this.padding});
  Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.margin ?? EdgeInsets.zero,
      child: Column(
        children: [
          _InnerShadowTop(),
          Container(
            padding: this.padding ?? EdgeInsets.only(left: 16.w, right: 16.w),
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(
                  'packages/polkawallet_ui/assets/images/bg_input_mid.png'),
              fit: BoxFit.fill,
            )),
            child: child,
          ),
          _InnerShadowBottom(),
        ],
      ),
    );
  }
}

class _InnerShadowTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child:
          Image.asset('packages/polkawallet_ui/assets/images/bg_input_top.png'),
    );
  }
}

class _InnerShadowBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Image.asset(
          'packages/polkawallet_ui/assets/images/bg_input_bottom.png'),
    );
  }
}
