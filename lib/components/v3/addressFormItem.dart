import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
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
    Key? key,
  }) : super(key: key);
  final String? label;
  final String? svg;
  final bool isShowSubtitle;
  final bool isGreyBg;
  final KeyPairData? account;
  final Future<void> Function()? onTap;
  final Color? color;
  final double borderWidth;
  final double imageRight;
  final EdgeInsetsGeometry? margin;
  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    final grey = Theme.of(context).unselectedWidgetColor;
    final child = Row(
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
                style: Theme.of(context).textTheme.headline5,
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
            child: rightIcon ??
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: color ?? grey,
                ))
      ],
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Visibility(visible: label != null, child: Text(label ?? "")),
        InnerShadowBGCar(
            padding: const EdgeInsets.only(left: 8),
            isWhite: !isGreyBg,
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
