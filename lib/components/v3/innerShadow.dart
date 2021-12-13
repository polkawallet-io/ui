import 'package:flutter/cupertino.dart';

class InnerShadowTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child:
          Image.asset('packages/polkawallet_ui/assets/images/bg_input_top.png'),
    );
  }
}

class InnerShadowBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Image.asset(
          'packages/polkawallet_ui/assets/images/bg_input_bottom.png'),
    );
  }
}
