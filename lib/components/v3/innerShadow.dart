import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_ui/utils/index.dart';

class InnerShadowBGCar extends StatelessWidget {
  InnerShadowBGCar(
      {Key? key,
      @required this.child,
      this.margin,
      this.padding,
      this.isWhite = false})
      : super(key: key);
  Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: UI.isDarkTheme(context)
          ? Container(
              padding: padding?.add(EdgeInsets.only(top: 8.h, bottom: 8.h)) ??
                  EdgeInsets.only(
                      left: 16.w, right: 16.w, top: 8.h, bottom: 8.h),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: isWhite
                      ? const Color(0x52000000)
                      : const Color(0x19FFFFFF),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: const Color(0x66FFFFFF), width: 1)),
              child: child,
            )
          : Column(
              children: [
                _InnerShadowTop(isWhite),
                Container(
                  padding: padding ?? EdgeInsets.only(left: 16.w, right: 16.w),
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
  const _InnerShadowTop(this.isWhite);
  final bool isWhite;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Image.asset(
          'packages/polkawallet_ui/assets/images/bg_input_top${isWhite ? "_white" : ""}.png'),
    );
  }
}

class _InnerShadowBottom extends StatelessWidget {
  const _InnerShadowBottom(this.isWhite);
  final bool isWhite;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Image.asset(
          'packages/polkawallet_ui/assets/images/bg_input_bottom${isWhite ? "_white" : ""}.png'),
    );
  }
}
