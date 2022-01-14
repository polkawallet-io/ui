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
