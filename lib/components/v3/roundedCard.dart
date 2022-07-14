import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/index.dart';

class RoundedCard extends StatelessWidget {
  const RoundedCard(
      {this.border,
      this.margin,
      this.padding,
      this.child,
      Key? key,
      this.color,
      this.radius})
      : super(key: key);

  final BoxBorder? border;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final Color? color;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return UI.isDarkTheme(context)
        ? Container(
            margin: margin,
            padding: const EdgeInsets.all(0.75),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 8)),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0x43FFFFFF),
                  Color(0x21FFFFFF),
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3D000000),
                  blurRadius: 1.0, // has the effect of softening the shadow
                  spreadRadius: 0.0, // has the effect of extending the shadow
                  offset: Offset(
                    0.5, // horizontal, move right 10
                    0.5, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(radius ?? 8),
                child: Container(
                    padding: padding,
                    color: color ?? Theme.of(context).cardColor,
                    child: child)),
          )
        : Container(
            margin: margin,
            padding: padding,
            decoration: BoxDecoration(
              border: border,
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 8)),
              color: color ?? Theme.of(context).cardColor,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x24000000),
                  blurRadius: 1.0, // has the effect of softening the shadow
                  spreadRadius: 0.0, // has the effect of extending the shadow
                  offset: Offset(
                    1.0, // horizontal, move right 10
                    1.0, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: child,
          );
  }
}
