import 'package:flutter/material.dart';

class BackBtn extends StatelessWidget {
  BackBtn({this.onBack, this.margin, Key? key}) : super(key: key);

  final Function? onBack;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onBack != null) {
          onBack!();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Center(
        child: Image.asset(
          'packages/polkawallet_ui/assets/images/icon_back.png',
          width: 30,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
