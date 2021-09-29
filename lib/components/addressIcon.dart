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
      this.borderColor,
      this.borderWidth = 0.5});
  final String? address;
  final String? svg;
  final double? size;
  final bool tapToCopy;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: size ?? 40,
        height: size ?? 40,
        decoration: borderColor == null
            ? null
            : BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular((size ?? 40) / 2.0)),
                border: Border.all(color: borderColor!, width: borderWidth),
              ),
        child: ClipOval(child:svg == null
            ? Image.asset(
                'packages/polkawallet_ui/assets/images/polkadot_avatar.png',
                bundle: rootBundle,
              )
            : SvgPicture.string(svg!)),
      ),
      onTap: tapToCopy ? () => UI.copyAndNotify(context, address) : null,
    );
  }
}
