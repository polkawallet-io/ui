import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TokenIcon extends StatelessWidget {
  TokenIcon(this.id, this.tokenIcons, {this.size = 32, this.symbol});
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
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: distance),
              child: SizedBox(width: size, child: tokenIcons[pair[1]]),
            ),
            SizedBox(width: size, child: tokenIcons[pair[0]])
          ],
        ),
        width: size + distance,
      );
    }
    return SizedBox(
        child: tokenIcons[id.toUpperCase()] ??
            CircleAvatar(
                child: Text((symbol ?? id).substring(
                    0, (symbol ?? id).length > 2 ? 2 : (symbol ?? id).length))),
        width: size);
  }
}
