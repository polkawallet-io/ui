import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_sdk/webviewWithExtension/types/signExtrinsicParam.dart';
import 'package:polkawallet_sdk/webviewWithExtension/webviewWithExtension.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/components/v3/iconButton.dart' as v3;
import 'package:polkawallet_ui/components/v3/plugin/pluginBottomSheetContainer.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginIconButton.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginLoadingWidget.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginOutlinedButtonSmall.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginScaffold.dart';
import 'package:polkawallet_ui/pages/walletExtensionSignPage.dart';
import 'package:polkawallet_ui/utils/consts.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DAppWrapperPage extends StatefulWidget {
  DAppWrapperPage(this.plugin, this.keyring,
      {this.getPassword, this.checkAuth, this.updateAuth});
  final PolkawalletPlugin plugin;
  final Keyring keyring;
  final Future<String?> Function(BuildContext, KeyPairData)? getPassword;
  final bool Function(String)? checkAuth;
  final Function(String)? updateAuth;

  static const String route = '/extension/app';

  @override
  _DAppWrapperPageState createState() => _DAppWrapperPageState();
}

class _DAppWrapperPageState extends State<DAppWrapperPage> {
  WebViewController? _controller;
  bool _loading = true;
  bool _signing = false;

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

  Future<bool> _onConnectRequest(DAppConnectParam params) async {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    final uri = Uri.parse(params.url ?? '');

    if (widget.checkAuth != null && widget.checkAuth!(uri.host)) {
      return true;
    }

    final res = await showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PluginBottomSheetContainer(
          height: MediaQuery.of(context).size.height / 2,
          title: Text(
            dic['dApp.auth']!,
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: Colors.white, fontSize: 16),
          ),
          content: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 24, bottom: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          '${uri.scheme}://${uri.host}/favicon.ico',
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      uri.host,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Text(
                        dic['dApp.connect.tip']!,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )),
              Container(
                margin: EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Row(
                  children: [
                    Expanded(
                      child: PluginOutlinedButtonSmall(
                        margin: EdgeInsets.only(right: 12),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        content: dic['dApp.connect.reject']!,
                        fontSize: 16,
                        color: Color(0xFFD8D8D8),
                        active: true,
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                    ),
                    Expanded(
                      child: PluginOutlinedButtonSmall(
                        margin: EdgeInsets.only(left: 12),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        content: dic['dApp.connect.allow']!,
                        fontSize: 16,
                        color: PluginColorsDark.primary,
                        active: true,
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
      context: context,
    );
    if (res == true && widget.updateAuth != null) {
      widget.updateAuth!(uri.host);
    }
    return res ?? false;
  }

  Future<ExtensionSignResult> _onSignRequest(
      SignAsExtensionParam params) async {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    final address = params.msgType == WalletExtensionSignPage.signTypeBytes
        ? SignBytesRequest.fromJson(
                Map<String, dynamic>.from(params.request ?? {}))
            .address
        : SignExtrinsicRequest.fromJson(
                Map<String, dynamic>.from(params.request ?? {}))
            .address;
    final acc = widget.keyring.keyPairs.firstWhere((acc) {
      bool matched = false;
      widget.keyring.store.pubKeyAddressMap.values.forEach((e) {
        e.forEach((k, v) {
          if (acc.pubKey == k && address == v) {
            matched = true;
          }
        });
      });
      return matched;
    });
    final res = await showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PluginBottomSheetContainer(
          height: MediaQuery.of(context).size.height / 2,
          title: Text(
            dic[params.msgType == WalletExtensionSignPage.signTypeExtrinsic
                ? 'submit.sign.tx'
                : 'submit.sign.msg']!,
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: Colors.white, fontSize: 16),
          ),
          content: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Text(
                                dic['submit.signer']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 4),
                              child:
                                  AddressIcon(address, svg: acc.icon, size: 18),
                            ),
                            Expanded(
                                child: Text(
                              Fmt.address(address, pad: 8),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                            ))
                          ],
                        ),
                      ),
                      params.msgType ==
                              WalletExtensionSignPage.signTypeExtrinsic
                          ? SignExtrinsicInfo(params)
                          : SignBytesInfo(params),
                    ],
                  ),
                ),
              )),
              Container(
                margin: EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Row(
                  children: [
                    Expanded(
                      child: PluginOutlinedButtonSmall(
                        margin: EdgeInsets.only(right: 12),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        content: dic['dApp.connect.reject']!,
                        fontSize: 16,
                        color: Color(0xFFD8D8D8),
                        active: true,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Expanded(
                      child: PluginOutlinedButtonSmall(
                        margin: EdgeInsets.only(left: 12),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        content: dic['dApp.confirm']!,
                        fontSize: 16,
                        color: PluginColorsDark.primary,
                        active: !_signing,
                        onPressed: _signing
                            ? null
                            : () async {
                                final res = await _doSign(acc, params);
                                if (res != null) {
                                  Navigator.of(context).pop(res);
                                }
                              },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
      context: context,
    );
    return res;
  }

  Future<ExtensionSignResult?> _doSign(
      KeyPairData acc, SignAsExtensionParam params) async {
    setState(() {
      _signing = true;
    });
    final password = await widget.getPassword!(context, acc);
    if (password == null) return null;

    final res =
        await widget.plugin.sdk.api.keyring.signAsExtension(password, params);
    if (mounted) {
      setState(() {
        _signing = false;
      });
    }
    return ExtensionSignResult.fromJson({
      'id': params.id,
      'signature': res?.signature,
    });
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
                onConnectRequest: _onConnectRequest,
                onSignBytesRequest: _onSignRequest,
                onSignExtrinsicRequest: _onSignRequest,
                checkAuth: widget.checkAuth,
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

class SignExtrinsicInfo extends StatelessWidget {
  SignExtrinsicInfo(this.msg);
  final SignAsExtensionParam msg;
  @override
  Widget build(BuildContext context) {
    final req = SignExtrinsicRequest.fromJson(
        Map<String?, dynamic>.of(msg.request as Map<String?, dynamic>)
            as Map<String, dynamic>);
    return Column(
      children: [
        SignInfoItemRow('From', msg.url ?? ''),
        SignInfoItemRow('Genesis', Fmt.address(req.genesisHash, pad: 10)),
        SignInfoItemRow('Version', int.parse(req.specVersion!).toString()),
        SignInfoItemRow('Nonce', int.parse(req.nonce!).toString()),
        SignInfoItemRow('Method Data', Fmt.address(req.method, pad: 10)),
      ],
    );
  }
}

class SignBytesInfo extends StatelessWidget {
  SignBytesInfo(this.msg);
  final SignAsExtensionParam msg;
  @override
  Widget build(BuildContext context) {
    final req = SignBytesRequest.fromJson(
        Map<String?, dynamic>.of(msg.request as Map<String?, dynamic>)
            as Map<String, dynamic>);
    return Column(
      children: [
        SignInfoItemRow('From', msg.url ?? ''),
        SignInfoItemRow('Bytes', Fmt.address(req.data, pad: 10)),
      ],
    );
  }
}

class SignInfoItemRow extends StatelessWidget {
  SignInfoItemRow(this.label, this.content);
  final String label;
  final String content;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 4,
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(bottom: 6),
          child: Text(
            content,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w300),
          ),
        ))
      ],
    );
  }
}
