import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

enum NomStatus { active, over, inactive, waiting }

class AddressIconTag extends StatelessWidget {
  const AddressIconTag(this.address, this.nomStatus,
      {Key? key, this.size, this.svg, this.tapToCopy = true, this.decoration})
      : super(key: key);
  final String? address;
  final String? svg;
  final double? size;
  final bool tapToCopy;
  final Decoration? decoration;
  final double defaultSize = 32;

  final NomStatus nomStatus;

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    final status = nomStatus.toString().split('.')[1];
    return Stack(
      alignment: Alignment.center,
      children: [
        AddressIcon(
          address,
          size: size,
          svg: svg,
          tapToCopy: tapToCopy,
          decoration: decoration,
        ),
        Container(
          margin: EdgeInsets.only(top: (size ?? defaultSize) - 5),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            color: nomStatus == NomStatus.active || nomStatus == NomStatus.over
                ? const Color(0xFF81FEB9)
                : const Color(0xFFB9B9B9),
          ),
          child: Text(
            dic['nominate.$status']!,
            style: Theme.of(context).textTheme.headline6?.copyWith(
                fontSize: UI.getTextSize(8, context),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3a3d40)),
          ),
        )
      ],
    );
  }
}

class AddressIcon extends StatelessWidget {
  const AddressIcon(this.address,
      {Key? key, this.size, this.svg, this.tapToCopy = true, this.decoration})
      : super(key: key);
  final String? address;
  final String? svg;
  final double? size;
  final bool tapToCopy;
  final Decoration? decoration;
  final double defaultSize = 32;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapToCopy ? () => UI.copyAndNotify(context, address) : null,
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
        child: ClipOval(
          child: svg == null
              ? Image.asset(
                  'packages/polkawallet_ui/assets/images/polkadot_avatar.png',
                  bundle: rootBundle,
                )
              : SvgPicture.string(svg!),
        ),
      ),
    );
  }
}
