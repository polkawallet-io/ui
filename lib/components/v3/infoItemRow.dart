import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoItemRow extends StatelessWidget {
  const InfoItemRow(
    this.label,
    this.content, {
    Key? key,
    this.labelStyle,
    this.contentStyle,
  }) : super(key: key);
  final String label;
  final String? content;
  final TextStyle? labelStyle;
  final TextStyle? contentStyle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: <Widget>[
          Text(
            label,
            style: labelStyle ?? Theme.of(context).textTheme.headline5,
          ),
          Expanded(
            child: Text(
              content!,
              textAlign: TextAlign.right,
              style: contentStyle ??
                  Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
