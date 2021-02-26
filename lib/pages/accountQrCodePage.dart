import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_ui/components/addressIcon.dart';
import 'package:polkawallet_ui/components/roundedButton.dart';
import 'package:polkawallet_ui/components/roundedCard.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:polkawallet_sdk/utils/i18n.dart';

class AccountQrCodePage extends StatelessWidget {
  AccountQrCodePage(this.plugin, this.keyring);
  final PolkawalletPlugin plugin;
  final Keyring keyring;

  static final String route = '/assets/receive';

  @override
  Widget build(BuildContext context) {
    String codeAddress =
        'substrate:${keyring.current.address}:${keyring.current.pubKey}:${keyring.current.name}';
    Color themeColor = Theme.of(context).primaryColor;

    final accInfo = keyring.current.indexInfo;
    final qrWidth = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
            I18n.of(context).getDic(i18n_full_dic_ui, 'account')['receive']),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            RoundedCard(
              margin: EdgeInsets.fromLTRB(32, 16, 32, 16),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 24, bottom: 8),
                    child: AddressIcon(
                      keyring.current.address,
                      svg: keyring.current.icon,
                    ),
                  ),
                  Text(
                    UI.accountDisplayNameString(
                        keyring.current.address, keyring.current.indexInfo),
                    style: Theme.of(context).textTheme.headline4,
                  ),
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
                    child: Text(keyring.current.address),
                  ),
                  Container(
                    width: qrWidth,
                    padding: EdgeInsets.only(top: 16, bottom: 24),
                    child: RoundedButton(
                      text: I18n.of(context)
                          .getDic(i18n_full_dic_ui, 'common')['copy'],
                      onPressed: () =>
                          UI.copyAndNotify(context, keyring.current.address),
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
