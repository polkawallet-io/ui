import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:polkawallet_sdk/plugin/index.dart';

class ConnectionChecker extends StatefulWidget {
  const ConnectionChecker(this.plugin,
      {Key? key, required this.onConnected, this.checker})
      : super(key: key);
  final PolkawalletPlugin plugin;
  final Function onConnected;
  final bool Function()? checker;

  @override
  createState() => _ConnectionCheckerState();
}

class _ConnectionCheckerState extends State<ConnectionChecker> {
  Timer? _waitNetworkTimer;

  Future<void> _checkConnection() async {
    final ready = widget.checker != null
        ? widget.checker!()
        : widget.plugin.sdk.api.connectedNode != null;
    if (ready) {
      widget.onConnected();
    } else {
      /// we need to re-fetch data with timer before wss connected
      _waitNetworkTimer = Timer(const Duration(seconds: 3), _checkConnection);
    }
  }

  @override
  void initState() {
    super.initState();

    _checkConnection();
  }

  @override
  void dispose() {
    _waitNetworkTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
