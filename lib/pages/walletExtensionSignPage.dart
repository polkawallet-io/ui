import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_sdk/webviewWithExtension/types/signExtrinsicParam.dart';
import 'package:polkawallet_ui/components/addressFormItem.dart';
import 'package:polkawallet_ui/components/infoItemRow.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class WalletExtensionSignPage extends StatefulWidget {
  const WalletExtensionSignPage(this.plugin, this.keyring, this.getPassword,
      {Key? key})
      : super(key: key);
  final PolkawalletPlugin plugin;
  final Keyring keyring;
  final Future<String> Function(BuildContext, KeyPairData) getPassword;

  static const String route = '/extension/sign';

  static const String signTypeBytes = 'pub(bytes.sign)';
  static const String signTypeExtrinsic = 'pub(extrinsic.sign)';

  @override
  createState() => _WalletExtensionSignPageState();
}

class _WalletExtensionSignPageState extends State<WalletExtensionSignPage> {
  bool _submitting = false;

  Future<void> _showPasswordDialog(KeyPairData acc) async {
    final password = await widget.getPassword(context, acc);
    _sign(password);
  }

  Future<void> _sign(String password) async {
    setState(() {
      _submitting = true;
    });
    final SignAsExtensionParam args =
        ModalRoute.of(context)!.settings.arguments as SignAsExtensionParam;
    final res = await (widget.plugin.sdk.api.keyring
        .signAsExtension(password, args) as FutureOr<ExtensionSignResult>);
    if (mounted) {
      setState(() {
        _submitting = false;
      });
    }
    if (!mounted) return;
    Navigator.of(context).pop(ExtensionSignResult.fromJson({
      'id': args.id,
      'signature': res.signature,
    }));
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    final SignAsExtensionParam args =
        ModalRoute.of(context)!.settings.arguments as SignAsExtensionParam;
    final address = args.msgType == WalletExtensionSignPage.signTypeBytes
        ? SignBytesRequest.fromJson(
                Map<String?, dynamic>.of(args.request as Map<String?, dynamic>)
                    as Map<String, dynamic>)
            .address
        : SignBytesRequest.fromJson(
                Map<String?, dynamic>.of(args.request as Map<String?, dynamic>)
                    as Map<String, dynamic>)
            .address;
    final KeyPairData acc = widget.keyring.keyPairs.firstWhere((acc) {
      bool matched = false;
      for (var e in widget.keyring.store.pubKeyAddressMap.values) {
        e.forEach((k, v) {
          if (acc.pubKey == k && address == v) {
            matched = true;
          }
        });
      }
      return matched;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(dic[
            args.msgType == WalletExtensionSignPage.signTypeExtrinsic
                ? 'submit.sign.tx'
                : 'submit.sign.msg']!),
        centerTitle: true,
        leading: BackBtn(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AddressFormItem(acc,
                        svg: acc.icon, label: dic['submit.signer']),
                  ),
                  args.msgType == WalletExtensionSignPage.signTypeExtrinsic
                      ? SignExtrinsicInfo(args)
                      : SignBytesInfo(args),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: _submitting ? Colors.black12 : Colors.orange,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16)),
                      child: Text(dic['cancel']!,
                          style: const TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: _submitting
                        ? Theme.of(context).disabledColor
                        : Theme.of(context).primaryColor,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed:
                          _submitting ? null : () => _showPasswordDialog(acc),
                      child: Text(
                        dic['submit.sign']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SignExtrinsicInfo extends StatelessWidget {
  const SignExtrinsicInfo(this.msg, {Key? key}) : super(key: key);
  final SignAsExtensionParam msg;
  @override
  Widget build(BuildContext context) {
    final req = SignExtrinsicRequest.fromJson(
        Map<String?, dynamic>.of(msg.request as Map<String?, dynamic>)
            as Map<String, dynamic>);
    return Column(
      children: [
        InfoItemRow('from', msg.url),
        InfoItemRow('genesis', Fmt.address(req.genesisHash, pad: 10)),
        InfoItemRow('version', int.parse(req.specVersion!).toString()),
        InfoItemRow('nonce', int.parse(req.nonce!).toString()),
        InfoItemRow('method data', Fmt.address(req.method, pad: 10)),
      ],
    );
  }
}

class SignBytesInfo extends StatelessWidget {
  const SignBytesInfo(this.msg, {Key? key}) : super(key: key);
  final SignAsExtensionParam msg;
  @override
  Widget build(BuildContext context) {
    final req = SignBytesRequest.fromJson(
        Map<String?, dynamic>.of(msg.request as Map<String?, dynamic>)
            as Map<String, dynamic>);
    return Column(
      children: [
        InfoItemRow('from', msg.url),
        InfoItemRow('bytes', Fmt.address(req.data, pad: 10)),
      ],
    );
  }
}
