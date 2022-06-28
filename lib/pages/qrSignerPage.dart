import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_ui/components/addressFormItem.dart';
import 'package:polkawallet_ui/components/textTag.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:qr_flutter_fork/qr_flutter_fork.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';

class QrSignerPage extends StatelessWidget {
  const QrSignerPage(this.plugin, this.keyring, {Key? key}) : super(key: key);

  static const String route = 'tx/uos/signer';

  final PolkawalletPlugin plugin;
  final Keyring keyring;

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'account')!;
    final text = ModalRoute.of(context)!.settings.arguments!;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(dic['uos.title']!),
          centerTitle: true,
          leading: BackBtn()),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AddressFormItem(
                  keyring.current,
                  label: dic['uos.signer'],
                  svg: keyring.current.icon,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextTag(
                    dic['uos.warn'],
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    color: Colors.red,
                    fontSize: UI.getTextSize(16, context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(dic['uos.push']!),
                ),
                QrImage(data: text as String, size: screenWidth - 24),
              ],
            )
          ],
        ),
      ),
    );
  }
}
