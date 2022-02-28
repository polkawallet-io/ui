import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/webviewWithExtension/types/signExtrinsicParam.dart';
import 'package:polkawallet_sdk/webviewWithExtension/webviewWithExtension.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/components/v3/iconButton.dart' as v3;
import 'package:polkawallet_ui/pages/walletExtensionSignPage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DAppWrapperPage extends StatefulWidget {
  DAppWrapperPage(this.plugin, this.keyring);
  final PolkawalletPlugin plugin;
  final Keyring keyring;

  static const String route = '/extension/app';

  @override
  _DAppWrapperPageState createState() => _DAppWrapperPageState();
}

class _DAppWrapperPageState extends State<DAppWrapperPage> {
  WebViewController? _controller;
  bool _loading = true;

  bool _isWillClose = false;

  @override
  Widget build(BuildContext context) {
    final String url = ModalRoute.of(context)!.settings.arguments as String;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              url,
              style: TextStyle(fontSize: 16),
            ),
            leading: BackBtn(
              onBack: () async {
                final canGoBack = await _controller?.canGoBack();
                if (canGoBack ?? false) {
                  _controller?.goBack();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 14),
                child: v3.IconButton(
                  onPressed: () {
                    _isWillClose = true;
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    CupertinoIcons.clear,
                    color: Theme.of(context).unselectedWidgetColor,
                    size: 16,
                  ),
                ),
              )
            ],
            centerTitle: true),
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWithExtension(
                widget.plugin.sdk.api,
                url,
                widget.keyring,
                onPageFinished: (url) {
                  setState(() {
                    _loading = false;
                  });
                },
                onWebViewCreated: (controller) {
                  setState(() {
                    _controller = controller;
                  });
                },
                onSignBytesRequest: (req) async {
                  final signed = (await Navigator.of(context).pushNamed(
                      WalletExtensionSignPage.route,
                      arguments: req) as ExtensionSignResult);
                  return signed;
                },
                onSignExtrinsicRequest: (req) async {
                  final signed = (await Navigator.of(context).pushNamed(
                      WalletExtensionSignPage.route,
                      arguments: req) as ExtensionSignResult);
                  return signed;
                },
              ),
              Visibility(
                  visible: _loading,
                  child: Center(child: CupertinoActivityIndicator()))
            ],
          ),
        ),
      ),
      onWillPop: () async {
        if (_isWillClose) {
          return true;
        } else {
          final canGoBack = await _controller?.canGoBack();
          if (canGoBack ?? false) {
            _controller?.goBack();
            return false;
          } else {
            return true;
          }
        }
      },
    );
  }
}
