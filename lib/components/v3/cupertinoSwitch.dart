import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CupertinoSwitch extends StatelessWidget {
  const CupertinoSwitch(
      {required this.value,
      required this.onChanged,
      this.isPlugin = false,
      Key? key})
      : super(key: key);
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isPlugin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged!(!value);
      },
      child: Image.asset(
        "packages/polkawallet_ui/assets/images/${isPlugin ? 'plugin_' : ''}switch_${value ? 'open' : 'close'}.png",
        width: 42.w,
      ),
    );
  }
}
