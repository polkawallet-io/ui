import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PluginTokenIcon extends StatelessWidget {
  PluginTokenIcon(this.id, this.tokenIcons,
      {this.size = 19,
      this.symbol,
      this.isHighlighted = true,
      this.isFold = false});
  final String id;
  final String? symbol;
  final Map<String, Widget> tokenIcons;
  final double size;
  final bool isHighlighted;
  final bool isFold;
  @override
  Widget build(BuildContext context) {
    if (id.contains('-') && !isFold) {
      final pair = id.replaceAll(" LP", "").toUpperCase().split('-');
      return Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size / 2)),
          color: Color(0xFFFF7849),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PluginTokenIcon(pair[0], tokenIcons, size: size),
            PluginTokenIcon(pair[1], tokenIcons, size: size)
          ],
        ),
        width: size * 2 + 4,
      );
    } else if (id.contains('-')) {
      final distance = size / 2;
      final pair = id.replaceAll(" LP", "").toUpperCase().split('-');
      return SizedBox(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: distance),
              child: PluginTokenIcon(pair[1], tokenIcons, size: size),
            ),
            PluginTokenIcon(pair[0], tokenIcons, size: size)
          ],
        ),
        width: size + distance,
      );
    }

    return SizedBox(
        child: Stack(
          children: [
            Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(size)),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(size),
                    child: tokenIcons[id.toUpperCase()] ??
                        CircleAvatar(
                            child: Text((symbol ?? id).substring(
                                0,
                                (symbol ?? id).length > 2
                                    ? 2
                                    : (symbol ?? id).length))))),
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
