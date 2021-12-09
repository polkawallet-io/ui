import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button(
      {Key? key,
      this.onPressed,
      required this.title,
      this.submitting = false,
      this.height})
      : super(key: key);
  final Function()? onPressed;
  final String title;
  final bool submitting;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: !submitting ? onPressed : null,
      child: Container(
        width: double.infinity,
        height: height ?? 58,
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
              image: AssetImage(
                  "packages/polkawallet_ui/assets/images/button_blue.png"),
              fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: submitting,
              child: Container(
                margin: EdgeInsets.only(right: 8),
                child: CupertinoActivityIndicator(),
              ),
            ),
            Text(title, style: Theme.of(context).textTheme.button)
          ],
        ),
      ),
    );
  }
}
