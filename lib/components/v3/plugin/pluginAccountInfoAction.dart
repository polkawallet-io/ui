import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/index.dart' as v3;
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/index.dart';

class PluginAccountInfoAction extends StatelessWidget {
  PluginAccountInfoAction(this.keyring,
      {this.offset,
      this.itemWidth,
      this.iconSize,
      this.itemHeight,
      this.itemIconSize,
      this.padding,
      this.shape,
      this.elevation,
      this.onSelected,
      this.nameStyle,
      this.addressStyle});
  final Keyring keyring;
  final Offset? offset;
  final double? iconSize;
  final double? itemHeight;
  final double? itemWidth;
  final double? itemIconSize;
  final EdgeInsetsGeometry? padding;
  final ShapeBorder? shape;
  final double? elevation;
  final void Function(String)? onSelected;
  final TextStyle? nameStyle;
  final TextStyle? addressStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 6.w),
        child: v3.PopupMenuButton(
            offset: offset ?? Offset(-10, 52),
            itemWidth: itemWidth ?? 160.w,
            color: Theme.of(context).cardColor,
            padding: padding ?? EdgeInsets.zero,
            elevation: elevation ?? 3,
            shape: shape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
            onSelected: onSelected ?? (value) {},
            itemBuilder: (BuildContext context) {
              return <v3.PopupMenuEntry<String>>[
                v3.PopupMenuItem(
                  value: "0",
                  height: itemHeight ?? 52.h,
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 7, 0),
                        child: AddressIcon(keyring.current.address,
                            svg: keyring.current.icon,
                            size: itemIconSize ?? 30.w),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UI.accountName(context, keyring.current),
                              style: nameStyle ??
                                  TextStyle(
                                      height: 1.5,
                                      fontFamily: "Titillium Web SemiBold",
                                      fontSize: UI.getTextSize(14, context)),
                            ),
                            Text(
                              Fmt.address(keyring.current.address),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: addressStyle ??
                                  TextStyle(
                                      height: 1.5,
                                      fontFamily: "Titillium Web Regular",
                                      fontSize: UI.getTextSize(10, context)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ];
            },
            icon: v3.IconButton(
              icon: AddressIcon(
                keyring.current.address,
                svg: keyring.current.icon,
                size: iconSize ?? 22.w,
                tapToCopy: false,
              ),
            )));
  }
}
