import 'package:flutter/material.dart' hide IconButton;
import 'package:polkawallet_ui/components/v3/iconButton.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({this.onBack, this.margin, Key? key}) : super(key: key);

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
          child: IconButton(
        icon: Image.asset(
          "packages/polkawallet_ui/assets/images/icon_back.png",
          width: 8,
        ),
      )),
    );
  }
}
