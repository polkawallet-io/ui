import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TokenIcon extends StatelessWidget {
  TokenIcon(this.symbol, this.tokenIcons, {this.small = false});
  final String symbol;
  final Map<String, Widget> tokenIcons;
  final bool small;
  @override
  Widget build(BuildContext context) {
    if (symbol.contains('-')) {
      final pair = symbol.toUpperCase().split('-');
      return SizedBox(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16),
              child: tokenIcons[pair[1]],
            ),
            SizedBox(
              width: 29,
              child: tokenIcons[pair[0]],
            )
          ],
        ),
        width: 45,
      );
    }
    return SizedBox(
        child: tokenIcons[symbol.toUpperCase()] ??
            CircleAvatar(
              child: Text(symbol.substring(0, 2)),
            ),
        width: small ? 24 : 32);
  }
}
