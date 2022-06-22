import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/index.dart' as v3;
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/index.dart';

class PluginAccountInfoAction extends StatefulWidget {
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
      this.addressStyle,
      this.iconDefaultColor,
      this.hasShadow = false});
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
  final Color? iconDefaultColor;
  final bool? hasShadow;

  @override
  State<PluginAccountInfoAction> createState() =>
      _PluginAccountInfoActionState();
}

class _PluginAccountInfoActionState extends State<PluginAccountInfoAction> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 16.w),
        child: v3.PopupMenuButton(
            iconSize: 30,
            offset: widget.offset ?? Offset(-10, 52),
            itemWidth: widget.itemWidth ?? 160.w,
            color: Theme.of(context).cardColor,
            padding: widget.padding ?? EdgeInsets.zero,
            elevation: widget.elevation ?? 3,
            shape: widget.shape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
            onSelected: (value) {
              widget.onSelected?.call(value as String);
              _updateStatus();
            },
            onCanceled: () {
              _updateStatus();
            },
            onShow: () {
              _updateStatus();
            },
            itemBuilder: (BuildContext context) {
              return <v3.PopupMenuEntry<String>>[
                v3.PopupMenuItem(
                  value: "0",
                  height: widget.itemHeight ?? 52.h,
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 7, 0),
                        child: AddressIcon(widget.keyring.current.address,
                            svg: widget.keyring.current.icon,
                            size: widget.itemIconSize ?? 30.w),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                              child: Text(
                                UI.accountName(context, widget.keyring.current),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: widget.nameStyle ??
                                    TextStyle(
                                        height: 1,
                                        fontFamily: "Titillium Web SemiBold",
                                        fontSize: UI.getTextSize(14, context)),
                              ),
                            ),
                            Text(
                              Fmt.address(widget.keyring.current.address),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: widget.addressStyle ??
                                  TextStyle(
                                      height: 1,
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
              hasShadow: widget.hasShadow,
              bgColor: _isSelected
                  ? Color(0xFFFF7849)
                  : widget.iconDefaultColor ?? Colors.white,
              icon: AddressIcon(
                widget.keyring.current.address,
                svg: widget.keyring.current.icon,
                size: widget.iconSize ?? 22.w,
                tapToCopy: false,
              ),
            )));
  }

  _updateStatus() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }
}
