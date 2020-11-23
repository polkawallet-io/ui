import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/regInputFormatter.dart';
import 'package:url_launcher/url_launcher.dart';

class UI {
  static void copyAndNotify(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text ?? ''));

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        final Map<String, String> dic =
            I18n.of(context).getDic(i18n_full_dic_ui, 'common');
        return CupertinoAlertDialog(
          title: Container(),
          content: Text('${dic['copy']} ${dic['success']}'),
        );
      },
    );

    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  static String accountName(BuildContext context, KeyPairData acc) {
    return '${acc.name ?? accountDisplayNameString(acc.address, acc.indexInfo)}${(acc.observation ?? false) ? ' (${I18n.of(context).getDic(i18n_full_dic_ui, 'account')['observe']})' : ''}';
  }

  static Widget accountDisplayName(
    String address,
    Map accInfo, {
    bool expand = true,
  }) {
    return Row(
      children: <Widget>[
        accInfo != null && accInfo['identity']['judgements'].length > 0
            ? Container(
                width: 14,
                margin: EdgeInsets.only(right: 4),
                child: Image.asset(
                    'packages/polkawallet_ui/assets/images/success.png'),
              )
            : Container(height: 16),
        expand
            ? Expanded(
                child: Text(accountDisplayNameString(address, accInfo)),
              )
            : Text(accountDisplayNameString(address, accInfo))
      ],
    );
  }

  static String accountDisplayNameString(String address, Map accInfo) {
    String display = Fmt.address(address, pad: 6);
    if (accInfo != null) {
      if (accInfo['identity']['display'] != null) {
        display = accInfo['identity']['display'];
        if (accInfo['identity']['displayParent'] != null) {
          display = '${accInfo['identity']['displayParent']}/$display';
        }
      } else if (accInfo['accountIndex'] != null) {
        display = accInfo['accountIndex'];
      }
      display = display.toUpperCase();
    }
    return display;
  }

  static TextInputFormatter decimalInputFormatter(int decimals) {
    return RegExInputFormatter.withRegex(
        '^[0-9]{0,$decimals}(\\.[0-9]{0,$decimals})?\$');
  }

  static Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      try {
        await launch(url);
      } catch (err) {
        print(err);
      }
    } else {
      print('Could not launch $url');
    }
  }
}
