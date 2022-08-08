import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/index.dart';

class BorderedTitle extends StatelessWidget {
  const BorderedTitle({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 30,
          margin: const EdgeInsets.only(right: 6),
          child: Image.asset(
              'packages/polkawallet_ui/assets/images/icon_bordered${UI.isDarkTheme(context) ? "_dark" : ""}.png'),
        ),
        Text(
          title!,
          style: Theme.of(context)
              .textTheme
              .headline3
              ?.copyWith(fontSize: UI.getTextSize(16, context)),
        )
      ],
    );
  }
}
