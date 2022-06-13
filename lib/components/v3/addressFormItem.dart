import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/innerShadow.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/index.dart';

class AddressFormItem extends StatelessWidget {
  AddressFormItem(
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
              Text(UI.accountName(context, account!)),
              Visibility(
                  visible: isShowSubtitle,
                  child: Text(
                    Fmt.address(account!.address),
                    style: TextStyle(fontSize: 14, color: color ?? grey),
                  ))
            ],
          ),
        ),
        Visibility(
            visible: this.rightIcon != null || onTap != null,
            child: this.rightIcon ??
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
        isGreyBg
            ? InnerShadowBGCar(padding: EdgeInsets.only(left: 8), child: child)
            : Container(
                margin: this.margin ?? EdgeInsets.only(top: 4, bottom: 4),
                padding: EdgeInsets.all(8),
                decoration: isGreyBg
                    ? BoxDecoration(
                        color: Color(0xFFE3DED8),
                        borderRadius: BorderRadius.all(Radius.circular(10)))
                    : BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "packages/polkawallet_ui/assets/images/bg_input.png"),
                            fit: BoxFit.fill)),
                child: child,
              )
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
