import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class NumberLoader extends StatelessWidget {
  const NumberLoader(
      {Key? key,
      required this.child,
      this.height = 16,
      this.width = 60,
      this.isDarkTheme = true,
      required this.isLoading})
      : super(key: key);
  final bool isLoading;
  final Widget child;
  final double height;
  final double width;
  final bool isDarkTheme;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
            width: width,
            height: height,
            child: SkeletonLoader(
              builder: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.all(Radius.circular(height / 4))),
              ),
              items: 1,
              period: const Duration(seconds: 2),
              highlightColor: isDarkTheme || UI.isDarkTheme(context)
                  ? const Color(0xFF6D6D6D)
                  : const Color(0xFFC0C0C0),
              baseColor: isDarkTheme || UI.isDarkTheme(context)
                  ? const Color(0xFF3A3B3D)
                  : const Color(0xFFE0E0E0),
              direction: SkeletonDirection.ltr,
            ),
          )
        : child;
  }
}
