import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetContainer extends StatelessWidget {
  BottomSheetContainer({required this.title, required this.content});

  final Widget title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom -
          kToolbarHeight -
          20.h,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 7.h),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Color(0xFFF0ECE6),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 4.0,
                    spreadRadius: 0.0,
                    offset: Offset(
                      0.0,
                      2.0,
                    ),
                  )
                ],
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
                            color: Theme.of(context).disabledColor,
                            size: 15,
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
