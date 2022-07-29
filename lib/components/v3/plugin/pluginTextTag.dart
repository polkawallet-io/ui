import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/consts.dart';

class PluginTextTag extends StatelessWidget {
  const PluginTextTag(
      {this.margin,
      this.padding,
      this.title = "",
      this.style,
      this.backgroundColor,
      this.child,
      this.height = 25,
      Key? key})
      : super(key: key);
  final String title;
  final TextStyle? style;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: TagBgContainer(
          margin: margin,
          padding: padding,
          height: height,
          backgroundColor: backgroundColor,
          child: child ??
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: style ??
                        Theme.of(context).textTheme.headline5?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF212123),
                            height: 1.0),
                  )
                ],
              )),
    );
  }
}

class TagBgContainer extends StatelessWidget {
  const TagBgContainer(
      {this.width,
      this.margin,
      this.padding,
      this.child,
      this.height,
      this.backgroundColor,
      Key? key})
      : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? PluginColorsDark.headline1,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2), topRight: Radius.circular(6)),
      ),
      child: child,
    );
  }
}
