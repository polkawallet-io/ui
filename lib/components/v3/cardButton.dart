import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_ui/components/v3/roundedCard.dart';
import 'package:polkawallet_ui/utils/index.dart';

class CardButton extends StatelessWidget {
  const CardButton(
      {this.onPressed, required this.text, required this.icon, Key? key})
      : super(key: key);
  final Function()? onPressed;
  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        Text(
          text,
          style: Theme.of(context).textTheme.headline6!.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: UI.getFontFamily('TitilliumWeb', context)),
        ),
      ],
    );
    return GestureDetector(
        onTap: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: UI.isDarkTheme(context)
            ? RoundedCard(
                padding: EdgeInsets.only(top: 3.h, bottom: 10),
                child: child,
              )
            : Container(
                padding: EdgeInsets.only(top: 3.h, bottom: 10, right: 3),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                      image: AssetImage(
                          "packages/polkawallet_ui/assets/images/btn_card_bg.png"),
                      fit: BoxFit.fill),
                ),
                alignment: Alignment.center,
                child: child,
              ));
  }
}
