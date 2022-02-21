import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/tapTooltip.dart';

class PluginInfoItem extends StatelessWidget {
  PluginInfoItem(
      {this.title,
      this.content,
      this.style,
      this.titleStyle,
      this.crossAxisAlignment,
      this.flex = 1,
      this.lowTitle = false,
      this.titleToolTip,
      this.contentCrossAxisAlignment});
  final String? title;
  final String? content;
  final TextStyle? style;
  final TextStyle? titleStyle;
  final CrossAxisAlignment? crossAxisAlignment;
  final CrossAxisAlignment? contentCrossAxisAlignment;
  final int flex;
  final bool lowTitle;
  final String? titleToolTip;
  @override
  Widget build(BuildContext context) {
    final textStyle = style ??
        Theme.of(context).textTheme.headline4?.copyWith(color: Colors.white);
    final titleStyleCopy = titleStyle ??
        Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600);
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
                      child: Text(title!, style: titleStyleCopy),
                    )
                  ],
                )),
              ),
            )
          : Text(title!, style: titleStyleCopy),
      Text(
        content ?? '-',
        style: textStyle,
      ),
    ];
    if (lowTitle) {
      res.reversed;
    }
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment:
                contentCrossAxisAlignment ?? CrossAxisAlignment.center,
            children: lowTitle ? res.reversed.toList() : res,
          )
        ],
      ),
    );
  }
}
