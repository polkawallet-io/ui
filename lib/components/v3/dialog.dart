import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    if (title != null) {
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
    if (content != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(
          left: _kActionSheetContentHorizontalPadding,
          right: _kActionSheetContentHorizontalPadding,
          bottom: 0.0,
          top: 0.0,
        ),
        child: DefaultTextStyle(
          style: _kCupertinoDialogContentStyle,
          textAlign: TextAlign.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 50),
            child: content!,
          ),
        ),
      ));
    }

    if (actions.isNotEmpty) {
      children.add(Padding(
          padding: const EdgeInsets.only(
            top: 22.0,
          ),
          child: Column(
            children: [
              const Divider(height: 1),
              Row(
                children: [
                  ...actions.map((e) {
                    final index = actions.indexOf(e);
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1),
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
              )
            ],
          )));
    }
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 28, left: 60, right: 60),
            padding: const EdgeInsets.only(top: 32),
            width: double.infinity,
            decoration: const BoxDecoration(
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

const double _kBlurAmount = 20.0;
const double _kCornerRadius = 8.0;
const Color _kActionSheetButtonDividerColor = Color(0xFFABABAB);

const double _kActionSheetEdgeHorizontalPadding = 8.0;
const double _kActionSheetEdgeVerticalPadding = 10.0;
const double _kActionSheetCancelButtonPadding = 8.0;
const Color _kActionSheetPressedColor = Color(0xFFDFDEDD);
const Color _kActionSheetCancelColor = Color(0xFFDFDEDD);
const Color _kActionSheetActionColor = Color(0xFFF9F8F6);

const TextStyle _kActionSheetTitleStyle = TextStyle(
    fontFamily: 'TitilliumWeb',
    inherit: false,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    textBaseline: TextBaseline.alphabetic,
    color: Color(0xB2363737));
const TextStyle _kActionSheetMessageStyle = TextStyle(
    fontFamily: 'TitilliumWeb',
    inherit: false,
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    color: Color(0xB2363737));

class PolkawalletActionSheet extends StatelessWidget {
  final Widget? title;
  final Widget? message;
  final List<Widget> actions;
  final Widget? cancelButton;

  const PolkawalletActionSheet({
    Key? key,
    this.title,
    this.message,
    required this.actions,
    this.cancelButton,
  }) : super(key: key);

  Widget _buildActions() {
    return _CupertinoActionSheetButton(
      onTapBgColor: _kActionSheetPressedColor,
      bgColor: _kActionSheetActionColor,
      children: actions,
    );
  }

  Widget _buildCancelButton() {
    final double cancelPadding =
        actions.isNotEmpty ? _kActionSheetCancelButtonPadding : 0.0;
    return Padding(
      padding: EdgeInsets.only(top: cancelPadding),
      child: _CupertinoActionCancelSheetButton(
        onTapBgColor: _kActionSheetPressedColor,
        bgColor: _kActionSheetCancelColor,
        child: cancelButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));

    final List<Widget> children = <Widget>[
      Flexible(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          child: BackdropFilter(
            filter:
                ImageFilter.blur(sigmaX: _kBlurAmount, sigmaY: _kBlurAmount),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                title != null || message != null
                    ? Semantics(
                        button: true,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              color: _kActionSheetActionColor,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 10.0,
                              ),
                              child: DefaultTextStyle(
                                style: _kActionSheetActionStyle,
                                textAlign: TextAlign.center,
                                child: Column(
                                  children: [
                                    title != null
                                        ? DefaultTextStyle(
                                            style: _kActionSheetTitleStyle,
                                            textAlign: TextAlign.center,
                                            child: title!,
                                          )
                                        : Container(),
                                    message != null
                                        ? DefaultTextStyle(
                                            style: _kActionSheetMessageStyle,
                                            textAlign: TextAlign.center,
                                            child: message!,
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                                height: 0.5,
                                color: _kActionSheetButtonDividerColor)
                          ],
                        ),
                      )
                    : Container(),
                _buildActions()
              ],
            ),
            // child: _CupertinoDialogRenderWidget(
            //   contentSection: Builder(builder: _buildContent),
            //   actionsSection: _buildActions(),
            //   dividerColor: _kActionSheetButtonDividerColor,
            //   isActionSheet: true,
            // ),
          ),
        ),
      ),
      if (cancelButton != null) _buildCancelButton(),
    ];

    final Orientation orientation = MediaQuery.of(context).orientation;
    final double actionSheetWidth;
    if (orientation == Orientation.portrait) {
      actionSheetWidth = MediaQuery.of(context).size.width -
          (_kActionSheetEdgeHorizontalPadding * 2);
    } else {
      actionSheetWidth = MediaQuery.of(context).size.height -
          (_kActionSheetEdgeHorizontalPadding * 2);
    }

    return SafeArea(
      child: ScrollConfiguration(
        // A CupertinoScrollbar is built-in below
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Semantics(
          namesRoute: true,
          scopesRoute: true,
          explicitChildNodes: true,
          label: 'Alert',
          child: CupertinoUserInterfaceLevel(
            data: CupertinoUserInterfaceLevelData.elevated,
            child: Container(
              width: actionSheetWidth,
              margin: const EdgeInsets.symmetric(
                horizontal: _kActionSheetEdgeHorizontalPadding,
                vertical: _kActionSheetEdgeVerticalPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CupertinoActionSheetButton extends StatefulWidget {
  const _CupertinoActionSheetButton(
      {Key? key,
      this.children,
      required this.onTapBgColor,
      required this.bgColor})
      : super(key: key);

  final List<Widget>? children;
  final Color onTapBgColor;
  final Color bgColor;

  @override
  State<_CupertinoActionSheetButton> createState() =>
      __CupertinoActionSheetButtonState();
}

class __CupertinoActionSheetButtonState
    extends State<_CupertinoActionSheetButton> {
  int isBeingPressedIndex = -1;

  void _onTapDown(int index) {
    setState(() {
      isBeingPressedIndex = index;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      isBeingPressedIndex = -1;
    });
  }

  void _onTapCancel() {
    setState(() {
      isBeingPressedIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final Color backgroundColor = isBeingPressedIndex == index
              ? widget.onTapBgColor
              : widget.bgColor;
          return GestureDetector(
            excludeFromSemantics: true,
            onTapDown: (details) {
              _onTapDown(index);
            },
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
              ),
              child: widget.children![index],
            ),
          );
        },
        separatorBuilder: (context, index) =>
            const Divider(height: 0.5, color: _kActionSheetButtonDividerColor),
        itemCount: widget.children?.length ?? 0);
  }
}

class _CupertinoActionCancelSheetButton extends StatefulWidget {
  const _CupertinoActionCancelSheetButton(
      {Key? key, this.child, required this.onTapBgColor, required this.bgColor})
      : super(key: key);

  final Widget? child;
  final Color onTapBgColor;
  final Color bgColor;

  @override
  _CupertinoActionCancelSheetButtonState createState() =>
      _CupertinoActionCancelSheetButtonState();
}

class _CupertinoActionCancelSheetButtonState
    extends State<_CupertinoActionCancelSheetButton> {
  bool isBeingPressed = false;

  void _onTapDown(TapDownDetails event) {
    setState(() {
      isBeingPressed = true;
    });
  }

  void _onTapUp(TapUpDetails event) {
    setState(() {
      isBeingPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      isBeingPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isBeingPressed ? widget.onTapBgColor : widget.bgColor;
    return GestureDetector(
      excludeFromSemantics: true,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoDynamicColor.resolve(backgroundColor, context),
          borderRadius: const BorderRadius.all(Radius.circular(_kCornerRadius)),
        ),
        child: widget.child,
      ),
    );
  }
}

const TextStyle _kActionSheetActionStyle = TextStyle(
    fontFamily: 'SF_Pro',
    inherit: false,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    color: Color(0xFF363737));

const double _kActionSheetButtonHeight = 56.0;

class PolkawalletActionSheetAction extends StatelessWidget {
  const PolkawalletActionSheetAction({
    Key? key,
    required this.onPressed,
    this.isDefaultAction = false,
    required this.child,
  }) : super(key: key);

  final VoidCallback? onPressed;

  /// Whether this action is the default choice in the action sheet.
  ///
  /// Default buttons have bold text.
  final bool isDefaultAction;

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    TextStyle style = _kActionSheetActionStyle;

    if (isDefaultAction) {
      style = style.copyWith(color: const Color(0xFFFF7849));
    }

    return MouseRegion(
      cursor: onPressed != null && kIsWeb
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: _kActionSheetButtonHeight,
          ),
          child: Semantics(
            button: true,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 10.0,
              ),
              child: DefaultTextStyle(
                style: style,
                textAlign: TextAlign.center,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
