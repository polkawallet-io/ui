import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/webviewWithExtension/types/signExtrinsicParam.dart';
import 'package:polkawallet_sdk/webviewWithExtension/webviewWithExtension.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/components/v3/iconButton.dart' as v3;
import 'package:polkawallet_ui/components/v3/plugin/pluginIconButton.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginLoadingWidget.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginScaffold.dart';
import 'package:polkawallet_ui/pages/walletExtensionConnectPage.dart';
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

  Widget _buildScaffold(
      {Function? onBack, Widget? body, Function()? actionOnPressed}) {
    if (ModalRoute.of(context)!.settings.arguments is Map &&
        (ModalRoute.of(context)!.settings.arguments as Map)["isPlugin"]) {
      final String url =
          (ModalRoute.of(context)!.settings.arguments as Map)["url"];
      return PluginScaffold(
        appBar: PluginAppBar(
          title: Text(url),
          leading: PluginIconButton(
            icon: SvgPicture.asset(
              "packages/polkawallet_ui/assets/images/icon_back_24.svg",
              color: Colors.black,
            ),
            onPressed: () {
              onBack!();
            },
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 14),
              child: PluginIconButton(
                onPressed: actionOnPressed,
                icon: Icon(
                  CupertinoIcons.clear,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            )
          ],
        ),
        body: body,
      );
    }
    final String url = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        appBar: AppBar(
            title: Text(
              url,
              style: TextStyle(fontSize: 16),
            ),
            leading: BackBtn(
              onBack: onBack,
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 14),
                child: v3.IconButton(
                  onPressed: actionOnPressed,
                  icon: Icon(
                    CupertinoIcons.clear,
                    color: Theme.of(context).unselectedWidgetColor,
                    size: 16,
                  ),
                ),
              )
            ],
            centerTitle: true),
        body: body);
  }

  @override
  Widget build(BuildContext context) {
    String url = "";
    if (ModalRoute.of(context)!.settings.arguments is Map) {
      url = (ModalRoute.of(context)!.settings.arguments as Map)["url"];
    } else {
      url = ModalRoute.of(context)!.settings.arguments as String;
    }
    return WillPopScope(
      child: _buildScaffold(
        onBack: () async {
          final canGoBack = await _controller?.canGoBack();
          if (canGoBack ?? false) {
            _controller?.goBack();
          } else {
            Navigator.of(context).pop();
          }
        },
        actionOnPressed: () {
          _isWillClose = true;
          Navigator.of(context).pop();
        },
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
                onConnectRequest: (req) async {
                  final approve = (await Navigator.of(context).pushNamed(
                      WalletExtensionConnectPage.route,
                      arguments: req) as bool?);
                  return approve;
                },
                onSignBytesRequest: (req) async {
                  final signed = (await Navigator.of(context).pushNamed(
                      WalletExtensionSignPage.route,
                      arguments: req) as ExtensionSignResult?);
                  return signed;
                },
                onSignExtrinsicRequest: (req) async {
                  final signed = (await Navigator.of(context).pushNamed(
                      WalletExtensionSignPage.route,
                      arguments: req) as ExtensionSignResult?);
                  return signed;
                },
              ),
              Visibility(
                  visible: _loading,
                  child: Center(child: PluginLoadingWidget()))
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
