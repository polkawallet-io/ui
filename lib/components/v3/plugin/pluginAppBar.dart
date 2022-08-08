import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginIconButton.dart';

class PluginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PluginAppBar(
      {Key? key,
      this.title,
      this.toolbarHeight,
      this.backgroundColor = Colors.transparent,
      this.centerTitle = true,
      this.leading,
      this.titleTextStyle,
      this.isShowLeading = true,
      this.leadingWidth,
      this.actions})
      : super(key: key);

  final double? toolbarHeight;
  final Widget? title;
  final Color? backgroundColor;
  final bool? centerTitle;
  final Widget? leading;
  final bool isShowLeading;
  final TextStyle? titleTextStyle;
  final List<Widget>? actions;
  final double? leadingWidth;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      automaticallyImplyLeading: false,
      titleTextStyle: titleTextStyle ??
          Theme.of(context)
              .appBarTheme
              .titleTextStyle
              ?.copyWith(color: Colors.white),
      backgroundColor: backgroundColor,
      toolbarHeight: toolbarHeight,
      centerTitle: centerTitle,
      leadingWidth: leadingWidth,
      leading: leading ??
          (isShowLeading
              ? PluginIconButton(
                  icon: Image.asset(
                    "packages/polkawallet_ui/assets/images/icon_back_plugin.png",
                    width: 9,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight);
}
