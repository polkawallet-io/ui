import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      this.actions})
      : super(key: key);

  final double? toolbarHeight;
  final Widget? title;
  final Color? backgroundColor;
  final bool? centerTitle;
  final Widget? leading;
  final TextStyle? titleTextStyle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      titleTextStyle: titleTextStyle ??
          Theme.of(context)
              .appBarTheme
              .titleTextStyle
              ?.copyWith(color: Colors.white),
      backgroundColor: backgroundColor,
      toolbarHeight: toolbarHeight,
      centerTitle: centerTitle,
      leading: leading ??
          PluginIconButton(
            icon: SvgPicture.asset(
              "packages/polkawallet_ui/assets/images/icon_back_24.svg",
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(this.toolbarHeight ?? kToolbarHeight);
}
