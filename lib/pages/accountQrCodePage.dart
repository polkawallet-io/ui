import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/keyringEVM.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/roundedCard.dart';
import 'package:polkawallet_ui/components/textTag.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:qr_flutter_fork/qr_flutter_fork.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_ui/components/v3/index.dart' as v3;

import 'package:polkawallet_sdk/utils/i18n.dart';

class AccountQrCodePage extends StatelessWidget {
  const AccountQrCodePage(this.plugin, this.keyring,
      {Key? key, this.keyringEVM})
      : super(key: key);
  final PolkawalletPlugin plugin;
  final Keyring keyring;
  final KeyringEVM? keyringEVM;

  static const String route = '/assets/receive';

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'account')!;

    final current = keyringEVM != null
        ? keyringEVM!.current.toKeyPairData()
        : keyring.current;

    final codeAddress =
        '${keyringEVM != null ? 'evm' : 'substrate'}:${current.address}:${current.pubKey}:${current.name}';

    final accInfo = keyringEVM != null ? null : keyring.current.indexInfo;
    final qrWidth = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text(dic['receive']!),
          centerTitle: true,
          leading: BackBtn()),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            RoundedCard(
              margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: Column(
                children: <Widget>[
                  Visibility(
                      visible: current.observation ?? false,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Text(dic['warn.external']!,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(
                                    fontSize: UI.getTextSize(10, context),
                                    color: Theme.of(context).errorColor)),
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        top: (current.observation ?? false) ? 8.h : 13.h,
                        bottom: 4.h),
                    child: AddressIcon(
                      current.address,
                      svg: current.icon,
                      size: 32.w,
                    ),
                  ),
                  UI.accountDisplayName(current.address, current.indexInfo,
                      mainAxisAlignment: MainAxisAlignment.center,
                      expand: false,
                      textColor: Theme.of(context).textTheme.headline1!.color!),
                  accInfo != null && accInfo['accountIndex'] != null
                      ? Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(accInfo['accountIndex']),
                        )
                      : Container(),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: QrImage(
                      data: codeAddress,
                      size: qrWidth + 24,
                      padding: const EdgeInsets.all(2),
                      backgroundColor: Colors.white,
                      embeddedImage: const AssetImage(
                          'packages/polkawallet_ui/assets/images/app.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                          size: Size(qrWidth / 3.875, qrWidth / 3.875)),
                    ),
                  ),
                  SizedBox(
                    width: qrWidth,
                    child: Text(current.address!,
                        style: TextStyle(
                            fontSize: UI.getTextSize(12, context),
                            fontFamily: UI.getFontFamily('SF_Pro', context),
                            fontWeight: FontWeight.w400,
                            color:
                                Theme.of(context).textTheme.headline1?.color)),
                  ),
                  Container(
                    width: qrWidth,
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    child: v3.Button(
                      title: I18n.of(context)!
                              .getDic(i18n_full_dic_ui, 'common')?['copy'] ??
                          "",
                      style: TextStyle(
                          fontSize: UI.getTextSize(22, context),
                          fontFamily: UI.getFontFamily('TitilliumWeb', context),
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.button?.color),
                      onPressed: () =>
                          UI.copyAndNotify(context, current.address),
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
