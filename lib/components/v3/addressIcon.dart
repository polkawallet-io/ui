import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkawallet_ui/utils/index.dart';

class AddressIcon extends StatelessWidget {
  AddressIcon(this.address,
      {this.size,
      this.svg,
      this.tapToCopy = true,
      this.decoration,
      this.padding = EdgeInsets.zero,
      this.border});
  final String? address;
  final String? svg;
  final double? size;
  final bool tapToCopy;
  final Decoration? decoration;
  final double defaultSize = 32;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: size ?? defaultSize,
        height: size ?? defaultSize,
        padding: padding,
        decoration: decoration ??
            BoxDecoration(
                color: Colors.transparent,
                border: border ??
                    Border.all(
                        color: Theme.of(context).toggleableActiveColor,
                        width: 2),
                borderRadius: BorderRadius.all(
                    Radius.circular((size ?? defaultSize) / 2))),
        child: Container(
          decoration: decoration ??
              BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular((size ?? defaultSize) / 2))),
          child: svg == null
              ? Image.asset(
                  'packages/polkawallet_ui/assets/images/polkadot_avatar.png',
                  bundle: rootBundle,
                )
              : SvgPicture.string(svg!),
        ),
      ),
      onTap: tapToCopy ? () => UI.copyAndNotify(context, address) : null,
    );
  }
}
