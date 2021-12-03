import 'package:flutter/material.dart';

class BackBtn extends StatelessWidget {
  BackBtn({required this.onBack, this.margin, Key? key}) : super(key: key);

  Function onBack;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onBack(),
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

class name extends StatefulWidget {
  name({Key? key}) : super(key: key);

  @override
  _nameState createState() => _nameState();
}

class _nameState extends State<name> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
