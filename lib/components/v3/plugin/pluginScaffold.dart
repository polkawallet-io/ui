import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginAppBar.dart';

export 'package:polkawallet_ui/components/v3/plugin/pluginAppBar.dart';

class PluginScaffold extends StatelessWidget {
  const PluginScaffold(
      {this.body,
      this.appBar = const PluginAppBar(),
      this.extendBodyBehindAppBar = false,
      Key? key})
      : super(key: key);
  final Widget? body;
  final PluginAppBar? appBar;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212224),
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      body: body,
    );
  }
}
