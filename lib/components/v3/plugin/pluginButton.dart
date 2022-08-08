import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/consts.dart';

class PluginButton extends StatelessWidget {
  const PluginButton(
      {Key? key,
      this.onPressed,
      this.title = "",
      this.style,
      this.icon,
      this.submitting = false,
      this.backgroundColor,
      this.height})
      : super(key: key);
  final Function()? onPressed;
  final String title;
  final Widget? icon;
  final bool submitting;
  final double? height;
  final TextStyle? style;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: !submitting ? onPressed : null,
      child: BgContainer(
        double.infinity,
        height: height ?? 44,
        alignment: Alignment.center,
        backgroundColor: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: submitting,
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                child: const CupertinoActivityIndicator(),
              ),
            ),
            Text(title,
                style: style ??
                    Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: const Color(0xFF17161F))),
            icon != null ? icon! : Container(),
          ],
        ),
      ),
    );
  }
}

class BgContainer extends StatelessWidget {
  const BgContainer(this.width,
      {this.margin,
      this.padding,
      this.child,
      this.alignment,
      this.height,
      this.backgroundColor,
      Key? key})
      : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin,
        width: width,
        height: height,
        padding: padding,
        alignment: alignment,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: backgroundColor ?? PluginColorsDark.primary,
        ),
        child: child!);
    // const sWidth = 20.0;
    // return SizedBox(
    //   width: width,
    //   height: height,
    //   child: Stack(
    //     alignment: Alignment.center,
    //     children: [
    //       SizedBox(
    //         width: width,
    //         height: height,
    //         child: Stack(
    //           children: [
    //             Align(
    //                 alignment: Alignment.centerLeft,
    //                 child: SizedBox(
    //                     width: sWidth,
    //                     height: height,
    //                     child: Column(
    //                       children: [
    //                         Expanded(
    //                             child: Container(
    //                           width: double.infinity,
    //                           decoration: BoxDecoration(
    //                             borderRadius: const BorderRadius.only(
    //                                 topLeft: Radius.circular(2)),
    //                             color:
    //                                 backgroundColor ?? PluginColorsDark.primary,
    //                           ),
    //                         )),
    //                         Expanded(
    //                             child: Container(
    //                           width: double.infinity,
    //                           decoration: BoxDecoration(
    //                             borderRadius: const BorderRadius.only(
    //                                 bottomLeft: Radius.circular(2)),
    //                             color:
    //                                 backgroundColor ?? PluginColorsDark.primary,
    //                           ),
    //                         ))
    //                       ],
    //                     ))),
    //             Container(
    //               margin: const EdgeInsets.symmetric(horizontal: sWidth - 1),
    //               width: width,
    //               height: height,
    //               color: backgroundColor ?? PluginColorsDark.primary,
    //             ),
    //             Align(
    //                 alignment: Alignment.centerRight,
    //                 child: SizedBox(
    //                     width: sWidth,
    //                     height: height,
    //                     child: Column(
    //                       children: [
    //                         Expanded(
    //                             child: Container(
    //                           width: double.infinity,
    //                           decoration: ShapeDecoration(
    //                             color:
    //                                 backgroundColor ?? PluginColorsDark.primary,
    //                             shape: const BeveledRectangleBorder(
    //                                 borderRadius: BorderRadius.only(
    //                                     topRight: Radius.circular(5))),
    //                           ),
    //                         )),
    //                         Expanded(
    //                             child: Container(
    //                           width: double.infinity,
    //                           decoration: BoxDecoration(
    //                             borderRadius: const BorderRadius.only(
    //                                 bottomRight: Radius.circular(2)),
    //                             color:
    //                                 backgroundColor ?? PluginColorsDark.primary,
    //                           ),
    //                         ))
    //                       ],
    //                     ))),
    //           ],
    //         ),
    //       ),
    //       Container(
    //           margin: margin,
    //           width: width,
    //           height: height,
    //           padding: padding,
    //           alignment: alignment,
    //           child: child!)
    //     ],
    //   ),
    // );
  }
}
