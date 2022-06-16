import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/consts.dart';

class PluginRadioButton extends StatelessWidget {
  const PluginRadioButton({Key? key, this.value = false}) : super(key: key);
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
          color: value ? PluginColorsDark.primary : Color(0x66FFFFFF),
          borderRadius: BorderRadius.circular(7)),
      child: value
          ? Center(
              child: Icon(
                Icons.check,
                size: 9,
                color: Colors.white,
              ),
            )
          : Container(),
    );
  }
}
