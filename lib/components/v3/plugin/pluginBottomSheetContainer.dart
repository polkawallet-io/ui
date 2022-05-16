import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PluginBottomSheetContainer extends StatelessWidget {
  PluginBottomSheetContainer(
      {required this.title, required this.content, this.height});

  final Widget title;
  final Widget content;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      height: height ??
          (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              kToolbarHeight -
              20.h),
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF262628),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 7.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Color(0xFF393B3D),
              ),
              height: 48.h,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: title,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.w),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Expanded(child: content)
          ],
        ),
      ),
    );
  }
}
