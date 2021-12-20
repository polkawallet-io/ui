import 'package:flutter/material.dart';

class Checkbox extends StatelessWidget {
  const Checkbox({required this.value, required this.onChanged, Key? key})
      : super(key: key);
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 10),
      child: GestureDetector(
        onTap: () {
          this.onChanged!(!this.value);
        },
        child: Image.asset(
          "packages/polkawallet_ui/assets/images/checkbox_${this.value ? 'true' : 'false'}.png",
          width: 16,
        ),
      ),
    );
  }
}
