import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/index.dart';

class CollapsedContainer extends StatefulWidget {
  CollapsedContainer(
      {required this.child,
      this.title = '',
      this.onCollapse,
      this.isPlugin = false});
  final Widget child;
  final String title;
  final Function(bool)? onCollapse;
  final bool isPlugin;
  @override
  _CollapsedContainerState createState() => _CollapsedContainerState();
}

class _CollapsedContainerState extends State<CollapsedContainer> {
  bool _collapsed = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                    fontFamily: UI.getFontFamily('TitilliumWeb', context),
                    color: widget.isPlugin ? Colors.white : null,
                    fontWeight: widget.isPlugin ? FontWeight.w600 : null),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 8,
                  top: _collapsed ? 6 : 10,
                  bottom: _collapsed ? 4 : 0,
                ),
                child: Transform.rotate(
                  angle: pi / 2,
                  child: Icon(
                    _collapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                    size: 18,
                    color: widget.isPlugin
                        ? Colors.white
                        : Theme.of(context).unselectedWidgetColor,
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              _collapsed = !_collapsed;
            });

            if (widget.onCollapse != null) {
              widget.onCollapse!(_collapsed);
            }
          },
        ),
        Visibility(visible: !_collapsed, child: widget.child)
      ],
    );
  }
}
