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
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              colors: [Color(0xFF27292F), Color(0xFF202020)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        appBar: appBar,
        body: body,
      ),
    );
  }
}
