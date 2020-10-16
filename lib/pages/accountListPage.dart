import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_ui/components/accountSelectList.dart';

class AccountListPageParams {
  AccountListPageParams({this.list, this.title});

  final String title;
  final List<KeyPairData> list;
}

class AccountListPage extends StatelessWidget {
  AccountListPage(this.plugin, this.keyring);

  static final String route = '/profile/contacts/list';
  final PolkawalletPlugin plugin;
  final Keyring keyring;

  @override
  Widget build(BuildContext context) {
    final AccountListPageParams args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title ?? ''),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AccountSelectList(
          plugin,
          args.list,
        ),
      ),
    );
  }
}
