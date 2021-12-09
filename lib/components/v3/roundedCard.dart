import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  const RoundedCard(
      {this.border,
      this.margin,
      this.padding,
      this.child,
      Key? key,
      this.color})
      : super(key: key);

  final BoxBorder? border;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: child,
      decoration: BoxDecoration(
        border: border,
        borderRadius: const BorderRadius.all(const Radius.circular(10)),
        color: this.color ?? Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 3.0, // has the effect of softening the shadow
            spreadRadius: 1.0, // has the effect of extending the shadow
            offset: Offset(
              2.0, // horizontal, move right 10
              2.0, // vertical, move down 10
            ),
          )
        ],
      ),
    );
  }
}
