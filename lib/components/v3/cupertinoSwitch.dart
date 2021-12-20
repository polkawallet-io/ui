import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CupertinoSwitch extends StatelessWidget {
  const CupertinoSwitch(
      {required this.value, required this.onChanged, Key? key})
      : super(key: key);
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.onChanged!(!this.value);
      },
      child: Image.asset(
        "packages/polkawallet_ui/assets/images/switch_${this.value ? 'open' : 'close'}.png",
        width: 42.w,
      ),
    );
  }
}
