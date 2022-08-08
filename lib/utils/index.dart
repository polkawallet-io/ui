import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/dialog.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/numberInputFormatter.dart';
import 'package:url_launcher/url_launcher.dart';

class UI {
  static void copyAndNotify(BuildContext context, String? text) {
    Clipboard.setData(ClipboardData(text: text ?? ''));

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        final Map<String, String> dic =
            I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
        return PolkawalletAlertDialog(
          title: Container(),
          content: Text('${dic['copy']} ${dic['success']}'),
        );
      },
    );

    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  static String accountName(BuildContext context, KeyPairData acc) {
    return '${accountDisplayNameString(acc.address, acc.indexInfo, acc.name)}${(acc.observation ?? false) ? ' (${I18n.of(context)!.getDic(i18n_full_dic_ui, 'account')!['observe']})' : ''}';
  }

  static Widget accountDisplayName(String? address, Map? accInfo,
      {bool expand = true,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
      Color textColor = const Color(0xFF565554),
      TextStyle? style}) {
    bool hasId = false;
    bool good = false;
    if (accInfo != null) {
      if (accInfo['identity']['display'] != null) {
        hasId = true;
      }
      if (accInfo['identity']['judgements'].length > 0) {
        final judgement = accInfo['identity']['judgements'][0][1];
        if (Map.of(judgement).keys.contains('knownGood') ||
            Map.of(judgement).keys.contains('reasonable')) {
          good = true;
        }
      }
    }
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: <Widget>[
        hasId
            ? Container(
                width: 14,
                margin: const EdgeInsets.only(right: 4),
                child: good
                    ? const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.lightGreen,
                      )
                    : const Icon(
                        Icons.remove_circle,
                        size: 16,
                        color: Colors.grey,
                      ),
              )
            : const SizedBox(width: 1, height: 2),
        expand
            ? Expanded(
                child: Text(accountDisplayNameString(address, accInfo),
                    overflow: TextOverflow.ellipsis,
                    style: style ??
                        TextStyle(
                            fontSize: 12,
                            fontFamily: "TitilliumWeb",
                            fontWeight: FontWeight.w400,
                            color: textColor)),
              )
            : Text(accountDisplayNameString(address, accInfo),
                overflow: TextOverflow.ellipsis,
                style: style ??
                    TextStyle(
                        fontSize: 12,
                        fontFamily: "TitilliumWeb",
                        fontWeight: FontWeight.w400,
                        color: textColor))
      ],
    );
  }

  static String accountDisplayNameString(String? address, Map? accInfo,
      [String? localName]) {
    String display = localName?.toUpperCase() ?? Fmt.address(address, pad: 6);
    if (accInfo != null) {
      if (accInfo['identity']['display'] != null) {
        display = accInfo['identity']['display'];
        if (accInfo['identity']['displayParent'] != null) {
          display = '${accInfo['identity']['displayParent']}/$display';
        }
      }
      display = display.toUpperCase();
    }
    return display;
  }

  static TextInputFormatter? decimalInputFormatter(int decimals) {
    return NumberInputFormatter.withRegex(
        '^[0-9]{0,$decimals}((\\.|,)[0-9]{0,$decimals})?\$');
  }

  static launchURL(String url) {
    throttle(() async {
      if (await canLaunch(url)) {
        try {
          await launch(url);
        } catch (err) {
          if (kDebugMode) {
            print(err);
          }
        }
      } else {
        debugPrint('Could not launch $url');
      }
    });
  }

  static const Duration _kDelay = Duration(milliseconds: 500);
  static var enable = true;

  static throttle(
    Function func, {
    Duration delay = _kDelay,
  }) {
    if (enable) {
      func();
      enable = false;
      Future.delayed(delay, () {
        enable = true;
      });
    }
  }

  static double getTextSize(double size, BuildContext context,
      {Locale? locale}) {
    final localeTextSize =
        ((locale ?? I18n.of(context)?.locale)?.toString().contains('zh') ??
                false)
            ? 1.5
            : 0.0;
    return size <= 12 ? size : (size - localeTextSize);
  }

  static String? getFontFamily(String fontFamilyEn, BuildContext context,
      {String? fontFamilyZh, Locale? locale}) {
    final fontFamilyLocale =
        ((locale ?? I18n.of(context)?.locale)?.toString().contains('zh') ??
                false)
            ? fontFamilyZh
            : fontFamilyEn;
    return fontFamilyLocale;
  }

  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor.value ==
        const Color(0xFF242528).value;
  }
}
