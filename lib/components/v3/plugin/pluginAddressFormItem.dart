import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_ui/components/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginInputItem.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/index.dart';

class PluginAddressFormItem extends StatelessWidget {
  PluginAddressFormItem({this.label, required this.account});

  final String? label;
  final KeyPairData account;

  @override
  Widget build(BuildContext context) {
    return PluginInputItem(
      label: label,
      labelBgColor: Color(0xCCFFFFFF),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 8),
              child: AddressIcon(
                account.address,
                svg: account.icon,
                size: 32,
                tapToCopy: false,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      UI.accountName(context, account),
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                          color: Color(0xCCFFFFFF)),
                    ),
                    Text(
                      Fmt.address(account.address)!,
                      style: TextStyle(fontSize: 12, color: Color(0xCCFFFFFF)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
