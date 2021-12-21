import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BorderedTitle extends StatelessWidget {
  BorderedTitle({this.title});
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 34,
          margin: EdgeInsets.only(right: 6),
          child: Image.asset(
              'packages/polkawallet_ui/assets/images/icon_bordered.png'),
        ),
        Text(
          title!,
          style: Theme.of(context).textTheme.headline3,
        )
      ],
    );
  }
}
