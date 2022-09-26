import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/innerShadow.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/index.dart';

class AddressFormItem extends StatelessWidget {
  const AddressFormItem(
    this.account, {
    this.label,
    this.svg,
    this.onTap,
    this.isShowSubtitle = true,
    this.isGreyBg = true,
    this.color,
    this.borderWidth = 0.5,
    this.imageRight = 8.0,
    this.margin,
    this.rightIcon,
    this.isDarkTheme = false,
    Key? key,
  }) : super(key: key);
  final String? label;
  final String? svg;
  final bool isShowSubtitle;
  final bool isGreyBg;
  final dynamic? account;
  final Future<void> Function()? onTap;
  final Color? color;
  final double borderWidth;
  final double imageRight;
  final EdgeInsetsGeometry? margin;
  final Widget? rightIcon;
  final bool isDarkTheme;

  @override
  Widget build(BuildContext context) {
    final grey =
        isDarkTheme ? Colors.white : Theme.of(context).unselectedWidgetColor;
    final child = Stack(children: [
      Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 4, right: imageRight),
            child: AddressIcon(
              account!.address,
              svg: svg ?? account!.icon,
              size: 32,
              tapToCopy: false,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  UI.accountName(context, account!),
                  style: isDarkTheme
                      ? Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(color: Colors.white)
                      : Theme.of(context).textTheme.headline5
                    ?..color?.withAlpha(255),
                ),
                Visibility(
                    visible: isShowSubtitle,
                    child: Text(
                      Fmt.address(account!.address),
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: color ?? grey,
                          fontSize: UI.getTextSize(10, context)),
                    ))
              ],
            ),
          ),
          Visibility(
              visible: rightIcon != null || onTap != null,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: rightIcon ??
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: color ?? grey,
                    ),
              ))
        ],
      ),
      Visibility(
          visible: isGreyBg && (UI.isDarkTheme(context) || isDarkTheme),
          child: Container(
            height: 32,
            width: double.infinity,
            color: const Color(0x593A3B3F),
          ))
    ]);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Visibility(visible: label != null, child: Text(label ?? "")),
        InnerShadowBGCar(
            padding: const EdgeInsets.only(left: 8),
            isWhite: !isGreyBg,
            isDarkTheme: isDarkTheme,
            child: child)
      ],
    );

    if (onTap == null) {
      return content;
    }
    return GestureDetector(
      child: content,
      onTap: () => onTap!(),
    );
  }
}
