import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkawallet_ui/utils/index.dart';

class AddressIcon extends StatelessWidget {
  AddressIcon(this.address,
      {this.size, this.svg, this.tapToCopy = true, this.decoration});
  final String? address;
  final String? svg;
  final double? size;
  final bool tapToCopy;
  final Decoration? decoration;
  final double defaultSize = 32;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: size ?? defaultSize,
        height: size ?? defaultSize,
        decoration: decoration ??
            BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Theme.of(context).toggleableActiveColor, width: 2),
                borderRadius: BorderRadius.all(
                    Radius.circular((size ?? defaultSize) / 2))),
        child: svg == null
            ? Image.asset(
                'packages/polkawallet_ui/assets/images/polkadot_avatar.png',
                bundle: rootBundle,
              )
            : SvgPicture.string(svg!),
      ),
      onTap: tapToCopy ? () => UI.copyAndNotify(context, address) : null,
    );
  }
}
