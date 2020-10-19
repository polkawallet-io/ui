import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/regInputFormatter.dart';

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
    return '${acc.name ?? Fmt.address(acc.address)}${(acc.observation ?? false) ? ' (${I18n.of(context).getDic(i18n_full_dic_ui, 'account')['observe']})' : ''}';
  }

  static TextInputFormatter decimalInputFormatter(int decimals) {
    return RegExInputFormatter.withRegex(
        '^[0-9]{0,$decimals}(\\.[0-9]{0,$decimals})?\$');
  }
}
