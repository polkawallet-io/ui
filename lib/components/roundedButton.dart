import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    this.text,
    this.onPressed,
    this.icon,
    this.color,
    this.gradientColor,
    this.expand,
    this.submitting = false,
  }) : assert(text != null);

  final String text;
  final Function onPressed;
  final Widget icon;
  final Color color;
  final Color gradientColor;
  final bool expand;
  final bool submitting;

  @override
  Widget build(BuildContext context) {
    List<Widget> row = <Widget>[];
    if (submitting) {
      row.add(CupertinoActivityIndicator());
    }
    if (icon != null) {
      row.add(Container(
        padding: EdgeInsets.only(right: 12),
        width: 32,
        child: icon,
      ));
    }
    row.add(Text(
      text ?? '',
      style: Theme.of(context).textTheme.button,
    ));

    return RaisedButton(
      padding: EdgeInsets.all(0),
      // color: color ?? Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                gradientColor ?? Theme.of(context).primaryColor
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              stops: [0.1, 0.9],
            ),
            borderRadius: BorderRadius.circular(80.0)),
        child: Container(
          constraints: BoxConstraints(minHeight: 50.0),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row,
          ),
        ),
      ),
      onPressed: submitting ? null : onPressed,
    );
  }
}
