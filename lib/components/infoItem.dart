import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/tapTooltip.dart';
import 'package:polkawallet_ui/utils/index.dart';

class InfoItem extends StatelessWidget {
  InfoItem({
    this.title,
    this.content,
    this.color,
    this.titleColor,
    this.crossAxisAlignment,
    this.flex = 1,
    this.lowTitle = false,
    this.titleToolTip,
  });
  final String? title;
  final String? content;
  final Color? color;
  final Color? titleColor;
  final CrossAxisAlignment? crossAxisAlignment;
  final int flex;
  final bool lowTitle;
  final String? titleToolTip;
  @override
  Widget build(BuildContext context) {
    final textColor = color ?? Theme.of(context).unselectedWidgetColor;
    final List<Widget> res = [
      titleToolTip != null
          ? Container(
              child: TapTooltip(
                message: titleToolTip!,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info,
                      color: Theme.of(context).disabledColor,
                      size: 14,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4),
                      child: Text(title!,
                          style: TextStyle(
                              fontSize: UI.getTextSize(12, context),
                              color: titleColor)),
                    )
                  ],
                )),
              ),
            )
          : Text(title!,
              style: TextStyle(
                  fontSize: UI.getTextSize(12, context), color: titleColor)),
      Text(
        content ?? '-',
        style: TextStyle(
          fontSize: UI.getTextSize(14, context),
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    ];
    if (lowTitle) {
      res.reversed;
    }
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        children: lowTitle ? res.reversed.toList() : res,
      ),
    );
  }
}
