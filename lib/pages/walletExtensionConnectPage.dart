import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_sdk/webviewWithExtension/types/signExtrinsicParam.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class WalletExtensionConnectPage extends StatelessWidget {
  static const String route = '/extension/connect';

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    final args = ModalRoute.of(context)!.settings.arguments as DAppConnectParam;
    return Scaffold(
      appBar: AppBar(
        title: Text(dic['dApp.auth']!),
        centerTitle: true,
        leading: BackBtn(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      args.url ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dic['dApp.connect']!,
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: Theme.of(context).disabledColor)),
                      child: Text(
                        dic['dApp.connect.tip']!,
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.orange,
                    child: FlatButton(
                      padding: EdgeInsets.all(16),
                      child: Text(dic['dApp.connect.reject']!,
                          style: TextStyle(color: Colors.white)),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: FlatButton(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        dic['dApp.connect.allow']!,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
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
