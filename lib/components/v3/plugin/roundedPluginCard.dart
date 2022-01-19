import 'package:flutter/material.dart';

class RoundedPluginCard extends StatelessWidget {
  const RoundedPluginCard(
      {this.margin,
      this.padding,
      this.child,
      this.color = const Color(0x1FFFFFFF),
      this.borderRadius = const BorderRadius.all(const Radius.circular(6)),
      Key? key})
      : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final Color color;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: child,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: this.color,
      ),
    );
  }
}
