import 'package:flutter/material.dart';

class PluginIconButton extends StatelessWidget {
  const PluginIconButton(
      {Key? key,
      this.color = const Color(0x24FFFFFF),
      this.icon,
      this.onPressed})
      : super(key: key);
  final Color? color;
  final Widget? icon;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Center(
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: color,
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}
