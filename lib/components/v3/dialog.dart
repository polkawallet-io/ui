import 'package:flutter/material.dart';

enum DialogType { warn, inform }

const TextStyle _kCupertinoDialogTitleStyle = TextStyle(
    fontFamily: 'SF_Pro',
    inherit: false,
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.5,
    textBaseline: TextBaseline.alphabetic,
    color: Color(0xFF373636));

const TextStyle _kCupertinoDialogContentStyle = TextStyle(
    fontFamily: 'SF_Pro',
    inherit: false,
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    height: 1.35,
    letterSpacing: -0.2,
    textBaseline: TextBaseline.alphabetic,
    color: Color(0xFF373636));

const TextStyle _kCupertinoDialogActionStyle = TextStyle(
    fontFamily: 'SF_Pro',
    inherit: false,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    height: 1.0,
    color: Color(0xFF373636));

const double _kActionSheetContentHorizontalPadding = 16.0;
const double _kActionSheetContentVerticalPadding = 4.0;

class PolkawalletAlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget> actions;
  final DialogType type;
  const PolkawalletAlertDialog(
      {Key? key,
      this.title,
      this.content,
      this.actions = const <Widget>[],
      this.type = DialogType.inform})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (this.title != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(
          left: _kActionSheetContentHorizontalPadding,
          right: _kActionSheetContentHorizontalPadding,
          bottom: _kActionSheetContentVerticalPadding,
          top: _kActionSheetContentVerticalPadding,
        ),
        child: DefaultTextStyle(
          style: _kCupertinoDialogTitleStyle,
          textAlign: TextAlign.center,
          child: title!,
        ),
      ));
    }
    if (this.content != null) {
      children.add(Padding(
        padding: EdgeInsets.only(
          left: _kActionSheetContentHorizontalPadding,
          right: _kActionSheetContentHorizontalPadding,
          bottom: title == null ? _kActionSheetContentVerticalPadding : 22.0,
          top: title == null ? _kActionSheetContentVerticalPadding : 0.0,
        ),
        child: DefaultTextStyle(
          style: _kCupertinoDialogContentStyle,
          textAlign: TextAlign.center,
          child: content!,
        ),
      ));
    }
    if (this.actions.length > 0) {
      children.add(Column(
        children: [
          Divider(height: 1),
          Container(
            child: Row(
              children: [
                ...this.actions.map((e) {
                  final index = this.actions.indexOf(e);
                  return index == 0
                      ? Expanded(
                          child: DefaultTextStyle(
                          style: _kCupertinoDialogActionStyle,
                          textAlign: TextAlign.center,
                          child: e,
                        ))
                      : Expanded(
                          child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1),
                              child: Container(
                                  width: 0.5,
                                  height: 45,
                                  color: Theme.of(context).dividerColor),
                            ),
                            Expanded(
                                child: DefaultTextStyle(
                              style: _kCupertinoDialogActionStyle,
                              textAlign: TextAlign.center,
                              child: e,
                            ))
                          ],
                        ));
                }).toList()
              ],
            ),
          )
        ],
      ));
    }
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: 28, left: 60, right: 60),
            padding: EdgeInsets.only(top: 32),
            decoration: BoxDecoration(
                color: Color(0xFFF9F8F6),
                borderRadius: BorderRadius.all(Radius.circular(14))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
          Image.asset('packages/polkawallet_ui/assets/images/${type.name}.png',
              width: 56)
        ],
      ),
    );
  }
}
