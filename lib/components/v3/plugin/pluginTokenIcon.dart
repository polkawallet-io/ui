import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/uniSwapTokenIcon.dart';
import 'package:polkawallet_ui/utils/format.dart';

class PluginTokenIcon extends StatelessWidget {
  const PluginTokenIcon(
    this.id,
    this.tokenIcons, {
    Key? key,
    this.size = 19,
    this.symbol,
    this.isHighlighted = true,
    this.isFold = false,
    this.bgColor = const Color(0xFFFF7849),
  }) : super(key: key);
  final String id;
  final String? symbol;
  final Map<String, Widget> tokenIcons;
  final double size;
  final bool isHighlighted;
  final bool isFold;
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    if (id.contains('-') && !isFold) {
      final pair = id.replaceAll(" LP", "").toUpperCase().split('-');
      return Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size / 2)),
          color: bgColor,
        ),
        width: size * 2 + 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PluginTokenIcon(pair[0], tokenIcons, size: size),
            PluginTokenIcon(pair[1], tokenIcons, size: size)
          ],
        ),
      );
    } else if (id.contains('-')) {
      final distance = size / 2;
      final pair = id.replaceAll(" LP", "").toUpperCase().split('-');
      return SizedBox(
        width: size + distance,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: distance),
              child: PluginTokenIcon(pair[1], tokenIcons, size: size),
            ),
            PluginTokenIcon(pair[0], tokenIcons, size: size)
          ],
        ),
      );
    }

    Map<String, Widget> tokenIconMap = tokenIcons;
    if (Fmt.isAddressETH(id) && tokenIcons[id] == null) {
      tokenIconMap = {id: UniSwapTokenIcon(contractAddress: id)};
    }
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          tokenIconMap[id] ??
              CircleAvatar(
                  child: Text((symbol ?? id).substring(0,
                      (symbol ?? id).length > 2 ? 2 : (symbol ?? id).length))),
          Visibility(
              visible: !isHighlighted,
              child: Container(
                width: size,
                height: size,
                decoration: const BoxDecoration(
                  color: Color(0x33000000),
                ),
              ))
        ],
      ),
    );
  }
}
