import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_ui/components/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/index.dart' as v3;
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/index.dart';

class PluginAccountInfoAction extends StatefulWidget {
  const PluginAccountInfoAction(this.keyring,
      {Key? key,
      this.offset,
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
      this.isPlugin = true,
      this.hasShadow = false})
      : super(key: key);
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
  final bool? isPlugin;
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
        margin: const EdgeInsets.only(right: 16),
        child: v3.PopupMenuButton(
            iconSize: widget.iconSize ?? 30,
            offset: widget.offset ?? const Offset(-10, 52),
            itemWidth: widget.itemWidth ?? 160,
            color: Colors.white,
            padding: widget.padding ?? EdgeInsets.zero,
            elevation: widget.elevation ?? 3,
            shape: widget.shape ??
                const RoundedRectangleBorder(
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
                  height: widget.itemHeight ?? 52,
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 7, 0),
                        child: AddressIcon(
                          widget.keyring.current.address,
                          svg: widget.keyring.current.icon,
                          size: widget.itemIconSize ?? 30,
                          borderColor: widget.isPlugin == false
                              ? Theme.of(context).toggleableActiveColor
                              : null,
                          borderWidth: 2,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                              child: Text(
                                UI.accountName(context, widget.keyring.current),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: widget.nameStyle ??
                                    TextStyle(
                                        color: Colors.black,
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
                                      color: Colors.black,
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
            icon: Container(
              foregroundDecoration: _isSelected
                  ? BoxDecoration(
                      color: Colors.black.withOpacity(0.24),
                      borderRadius: BorderRadius.circular(8))
                  : null,
              width: widget.iconSize ?? 30,
              height: widget.iconSize ?? 30,
              child: v3.IconButton(
                padding: widget.hasShadow == true
                    ? const EdgeInsets.only(left: 1, top: 1)
                    : EdgeInsets.zero,
                iconSize: widget.iconSize ?? 30,
                boxShadows: widget.hasShadow == true
                    ? (UI.isDarkTheme(context)
                        ? [
                            const BoxShadow(
                              offset: Offset(1, 1),
                              blurRadius: 1,
                              spreadRadius: 0, //阴影范围
                              blurStyle: BlurStyle.inner,
                              color: Color(0xFFD9A126), //阴影颜色
                            )
                          ]
                        : [
                            BoxShadow(
                              offset: const Offset(1, 1),
                              blurRadius: 1,
                              spreadRadius: 0, //阴影范围
                              blurStyle: BlurStyle.outer,
                              color: Colors.black.withOpacity(0.33), //阴影颜色
                            ),
                            const BoxShadow(
                              offset: Offset(1, 1),
                              blurRadius: 1,
                              spreadRadius: 0, //阴影范围
                              blurStyle: BlurStyle.inner,
                              color: Color(0xFF5066AC), //阴影颜色
                            )
                          ])
                    : null,
                bgColor: widget.isPlugin == false
                    ? (UI.isDarkTheme(context)
                        ? Theme.of(context).toggleableActiveColor
                        : const Color(0xFF7D97EE))
                    : _isSelected
                        ? const Color(0xFFFF7849)
                        : const Color(0x24FFFFFF),
                icon: AddressIcon(
                  widget.keyring.current.address,
                  svg: widget.keyring.current.icon,
                  size: widget.iconSize != null ? widget.iconSize! * 0.7 : 22,
                  tapToCopy: false,
                  borderColor: const Color(0xFF242528),
                  borderWidth: 2,
                ),
              ),
            )));
  }

  _updateStatus() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }
}
