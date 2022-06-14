import 'package:flutter/material.dart';

class RoundedPluginCard extends StatelessWidget {
  const RoundedPluginCard(
      {this.margin,
      this.padding,
      this.child,
      this.color = const Color(0xFF3A3D40),
      this.borderRadius = const BorderRadius.all(const Radius.circular(8)),
      this.width,
      Key? key})
      : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final Color color;
  final BorderRadiusGeometry borderRadius;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      width: width,
      child: child,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: this.color,
      ),
    );
  }
}
