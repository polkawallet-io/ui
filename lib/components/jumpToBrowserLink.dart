import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/index.dart';

class JumpToBrowserLink extends StatefulWidget {
  const JumpToBrowserLink(this.url,
      {Key? key, this.text, this.mainAxisAlignment, this.color})
      : super(key: key);

  final String? text;
  final String url;
  final MainAxisAlignment? mainAxisAlignment;
  final Color? color;

  @override
  createState() => _JumpToBrowserLinkState();
}

class _JumpToBrowserLinkState extends State<JumpToBrowserLink> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              widget.mainAxisAlignment ?? MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                widget.text ?? widget.url,
                style: TextStyle(
                    color: widget.color ?? Theme.of(context).primaryColor,
                    fontSize: UI.getTextSize(14, context)),
              ),
            ),
            Icon(Icons.open_in_new,
                size: 14, color: widget.color ?? Theme.of(context).primaryColor)
          ],
        ),
        onTap: () {
          UI.launchURL(widget.url);
        });
  }
}
