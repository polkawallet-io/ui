import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PluginTokenIcon extends StatelessWidget {
  PluginTokenIcon(this.id, this.tokenIcons,
      {this.size = 19, this.symbol, this.isHighlighted = true});
  final String id;
  final String? symbol;
  final Map<String, Widget> tokenIcons;
  final double size;
  final bool isHighlighted;
  @override
  Widget build(BuildContext context) {
    if (id.contains('-')) {
      final pair = id.toUpperCase().split('-');
      return Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size / 2)),
          color: Color(0xFFFF7849),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: size, child: tokenIcons[pair[1]]),
            SizedBox(width: size, child: tokenIcons[pair[0]])
          ],
        ),
        width: size * 2 + 4,
      );
    }
    return SizedBox(
        child: Stack(
          children: [
            tokenIcons[id.toUpperCase()] ??
                CircleAvatar(
                    child: Text((symbol ?? id).substring(
                        0,
                        (symbol ?? id).length > 2
                            ? 2
                            : (symbol ?? id).length))),
            Visibility(
                visible: !isHighlighted,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(size / 2)),
                    color: Color(0x33000000),
                  ),
                ))
          ],
        ),
        width: size);
  }
}
