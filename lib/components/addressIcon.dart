import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkawallet_ui/utils/index.dart';

class AddressIcon extends StatelessWidget {
  const AddressIcon(this.address,
      {Key? key, this.size,
      this.svg,
      this.tapToCopy = true,
      this.borderColor,
      this.borderWidth = 0.5}) : super(key: key);
  final String? address;
  final String? svg;
  final double? size;
  final bool tapToCopy;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapToCopy ? () => UI.copyAndNotify(context, address) : null,
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
        child: svg == null
            ? Image.asset(
                'packages/polkawallet_ui/assets/images/polkadot_avatar.png',
                bundle: rootBundle,
              )
            : SvgPicture.string(svg!),
      ),
    );
  }
}
