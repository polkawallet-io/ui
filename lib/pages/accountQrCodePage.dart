import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_ui/components/addressIcon.dart';
import 'package:polkawallet_ui/components/roundedButton.dart';
import 'package:polkawallet_ui/components/roundedCard.dart';
import 'package:polkawallet_ui/components/textTag.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:qr_flutter_fork/qr_flutter_fork.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';

import 'package:polkawallet_sdk/utils/i18n.dart';

class AccountQrCodePage extends StatelessWidget {
  AccountQrCodePage(this.plugin, this.keyring, {this.current});
  final PolkawalletPlugin plugin;
  /// Substrate or Etherem Recommend current
  final KeyPairData? current;
  /// Deprecated
  final Keyring keyring;

  static final String route = '/assets/receive';

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'account')!;

    final acc = this.current ?? keyring.current;
    final codeAddress =
        'substrate:${acc.address}:${acc.pubKey}:${acc.name}';

    final accInfo = acc.indexInfo;
    final qrWidth = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(dic['receive']!),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            RoundedCard(
              margin: EdgeInsets.fromLTRB(32, 16, 32, 16),
              child: Column(
                children: <Widget>[
                  acc.observation ?? false
                      ? Container(
                          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child:
                              TextTag(dic['warn.external'], color: Colors.red),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 24, bottom: 8),
                    child: AddressIcon(
                      acc.address,
                      svg: acc.icon,
                    ),
                  ),
                  UI.accountDisplayName(
                      acc.address, acc.indexInfo,
                      mainAxisAlignment: MainAxisAlignment.center,
                      expand: false),
                  accInfo != null && accInfo['accountIndex'] != null
                      ? Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(accInfo['accountIndex']),
                        )
                      : Container(width: 8, height: 8),
                  Container(
                    margin: EdgeInsets.all(8),
                    child: QrImage(
                      data: codeAddress,
                      size: qrWidth + 24,
                      embeddedImage: AssetImage(
                          'packages/polkawallet_ui/assets/images/app.png'),
                      embeddedImageStyle:
                          QrEmbeddedImageStyle(size: Size(40, 40)),
                    ),
                  ),
                  Container(
                    width: qrWidth,
                    child: Text(acc.address!),
                  ),
                  Container(
                    width: qrWidth,
                    padding: EdgeInsets.only(top: 16, bottom: 24),
                    child: RoundedButton(
                      text: I18n.of(context)!
                          .getDic(i18n_full_dic_ui, 'common')!['copy'],
                      onPressed: () =>
                          UI.copyAndNotify(context, acc.address),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
