import 'package:flutter/material.dart';

class PluginLoadingWidget extends StatefulWidget {
  PluginLoadingWidget({Key? key}) : super(key: key);

  @override
  _PluginLoadingWidgetState createState() => _PluginLoadingWidgetState();
}

class _PluginLoadingWidgetState extends State<PluginLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Function(AnimationStatus) _listener;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _controller.forward();

    _listener = (status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    };
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      child: RotationTransition(
        child: Image.asset(
          "packages/polkawallet_ui/assets/images/loading.png",
          width: 24,
        ),
        turns: _controller..addStatusListener(_listener),
      ),
    );
  }
}
