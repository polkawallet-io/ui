import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    this.text,
    this.textColor,
    this.onPressed,
    this.icon,
    this.color,
    this.borderRadius = 80,
    this.submitting = false,
  }) : super(key: key);

  final String? text;
  final Color? textColor;
  final Function? onPressed;
  final Widget? icon;
  final Color? color;
  final double borderRadius;
  final bool submitting;

  @override
  Widget build(BuildContext context) {
    List<Widget> row = <Widget>[];
    if (submitting) {
      row.add(const CupertinoActivityIndicator());
    }
    if (icon != null) {
      row.add(Container(
          padding: EdgeInsets.only(right: text == null ? 0 : 4), child: icon));
    }
    if (text != null) {
      row.add(Expanded(
          flex: 0,
          child: Text(
            text!,
            style: textColor != null
                ? TextStyle(color: textColor)
                : Theme.of(context).textTheme.button,
            overflow: TextOverflow.ellipsis,
          )));
    }

    final bgColor = onPressed == null || submitting
        ? Theme.of(context).dividerColor
        : (color ?? Theme.of(context).primaryColor);
    final gradientColor = onPressed == null || submitting
        ? Theme.of(context).dividerColor
        : (color ?? Theme.of(context).hoverColor);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        // color: color ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
      ),
      onPressed: submitting ? null : onPressed as void Function()?,
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [bgColor, gradientColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.1, 0.9],
            ),
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          constraints: const BoxConstraints(minHeight: 50.0, minWidth: 88),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row,
          ),
        ),
      ),
    );
  }
}
