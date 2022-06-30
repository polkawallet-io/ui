import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OutlinedCircle extends StatelessWidget {
  const OutlinedCircle({Key? key, this.icon, this.color}) : super(key: key);
  final IconData? icon;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 1, color: color!),
      ),
      child: Icon(
        icon,
        color: color,
        size: 16,
      ),
    );
  }
}
