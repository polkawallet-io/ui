import 'package:flutter/material.dart';

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
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: tokenIcons[id.toUpperCase()] != null
            ? Container(
                child: tokenIcons[id.toUpperCase()],
              )
            : CircleAvatar(
                child: Text((symbol ?? id).substring(
                    0, (symbol ?? id).length > 2 ? 2 : (symbol ?? id).length))),
      ),
    );
  }
}
