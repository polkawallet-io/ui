import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BorderedTitle extends StatelessWidget {
  BorderedTitle({this.title, this.lineWidth = 6});
  final String title;
  final double lineWidth;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: lineWidth,
          height: 18,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Theme.of(context).primaryColor),
        ),
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black54),
        )
      ],
    );
  }
}
