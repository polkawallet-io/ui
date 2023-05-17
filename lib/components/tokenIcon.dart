import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/uniSwapTokenIcon.dart';
import 'package:polkawallet_ui/utils/format.dart';

class TokenIcon extends StatelessWidget {
  const TokenIcon(this.id, this.tokenIcons,
      {Key? key, this.size = 32, this.symbol})
      : super(key: key);
  final String id;
  final String? symbol;
  final Map<String, Widget> tokenIcons;
  final double size;
  @override
  Widget build(BuildContext context) {
    if (id.contains('-')) {
      final distance = size / 2;
      final pair = id.toUpperCase().split('-');
      return SizedBox(
        width: size + distance,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: distance),
              child: TokenIcon(pair[1], tokenIcons, size: size),
            ),
            TokenIcon(pair[0], tokenIcons, size: size)
          ],
        ),
      );
    }
    Map<String, Widget> tokenIconMap = tokenIcons;
    if (Fmt.isAddressETH(id) && tokenIcons[id] == null) {
      tokenIconMap = {
        id: UniSwapTokenIcon(
          contractAddress: id,
          key: Key(id),
        )
      };
    }
    return SizedBox(
      width: size,
      height: size,
      child: tokenIconMap[id] != null
          ? Container(
              child: tokenIconMap[id],
            )
          : CircleAvatar(
              child: Text((symbol ?? id).substring(
                  0, (symbol ?? id).length > 2 ? 2 : (symbol ?? id).length))),
    );
  }
}
