import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/roundedButton.dart';
import 'package:polkawallet_ui/components/roundedCard.dart';
import 'package:polkawallet_ui/components/textTag.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:qr_flutter_fork/qr_flutter_fork.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_ui/components/v3/button.dart' as v3;

import 'package:polkawallet_sdk/utils/i18n.dart';

class AccountQrCodePage extends StatelessWidget {
  AccountQrCodePage(this.plugin, this.keyring);
  final PolkawalletPlugin plugin;
  final Keyring keyring;

  static final String route = '/assets/receive';

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'account')!;

    final codeAddress =
        'substrate:${keyring.current.address}:${keyring.current.pubKey}:${keyring.current.name}';

    final accInfo = keyring.current.indexInfo;
    final qrWidth = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text(dic['receive']!),
          centerTitle: true,
          leading: Container(
            margin: EdgeInsets.only(left: 16.w),
            child: BackBtn(
              onBack: () => Navigator.of(context).pop(),
            ),
          )),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            RoundedCard(
              color: Color(0xFFF8F5F2),
              margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: Column(
                children: <Widget>[
                  Visibility(
                      visible: keyring.current.observation ?? false,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: TextTag(dic['warn.external'],
                            color: Color(0xFFD8D8D8)),
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        top:
                            (keyring.current.observation ?? false) ? 8.h : 13.h,
                        bottom: 4.h),
                    child: AddressIcon(
                      keyring.current.address,
                      svg: keyring.current.icon,
                      size: 32.w,
                    ),
                  ),
                  UI.accountDisplayName(
                      keyring.current.address, keyring.current.indexInfo,
                      mainAxisAlignment: MainAxisAlignment.center,
                      expand: false,
                      textColor: Theme.of(context).textSelectionColor),
                  accInfo != null && accInfo['accountIndex'] != null
                      ? Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(accInfo['accountIndex']),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.all(8),
                    child: QrImage(
                      data: codeAddress,
                      size: qrWidth + 24,
                      embeddedImage: AssetImage(
                          'packages/polkawallet_ui/assets/images/app.png'),
                      embeddedImageStyle:
                          QrEmbeddedImageStyle(size: Size(48, 48)),
                    ),
                  ),
                  Container(
                    width: qrWidth,
                    child: Text(keyring.current.address!,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "SF_Pro",
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).textSelectionColor)),
                  ),
                  Container(
                    width: qrWidth,
                    padding: EdgeInsets.only(top: 16, bottom: 24),
                    child: v3.Button(
                      title: I18n.of(context)!
                              .getDic(i18n_full_dic_ui, 'common')?['copy'] ??
                          "",
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: "TitilliumWeb",
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
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
