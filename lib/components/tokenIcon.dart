import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TokenIcon extends StatelessWidget {
  TokenIcon(this.id, this.tokenIcons, {this.small = false, this.symbol});
  final String id;
  final String? symbol;
  final Map<String, Widget> tokenIcons;
  final bool small;
  @override
  Widget build(BuildContext context) {
    if (id.contains('-')) {
      final pair = id.toUpperCase().split('-');
      return SizedBox(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16),
              child: tokenIcons[pair[1]],
            ),
            SizedBox(width: 29, child: tokenIcons[pair[0]])
          ],
        ),
        width: 45,
      );
    }
    return SizedBox(
        child: tokenIcons[id.toUpperCase()] ??
            CircleAvatar(child: Text((symbol ?? id).substring(0, 2))),
        width: small ? 24 : 32);
  }
}
