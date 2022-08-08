import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginAddressFormItem.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginScaffold.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class PluginAccountListPageParams {
  PluginAccountListPageParams({this.list, this.title});

  final String? title;
  final List<KeyPairData>? list;
}

class PluginAccountListPage extends StatelessWidget {
  const PluginAccountListPage(this.plugin, this.keyring, {Key? key})
      : super(key: key);

  static const String route = '/account/list';
  final PolkawalletPlugin plugin;
  final Keyring keyring;

  @override
  Widget build(BuildContext context) {
    final PluginAccountListPageParams args = ModalRoute.of(context)!
        .settings
        .arguments as PluginAccountListPageParams;
    return PluginScaffold(
      appBar: PluginAppBar(
        title: Text(args.title ??
            I18n.of(context)!.getDic(i18n_full_dic_ui, 'account')!['select']!),
        centerTitle: true,
      ),
      body: ListView(
        children: args.list!.map((i) {
          return GestureDetector(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: PluginAddressFormItem(account: i),
            ),
            onTap: () => Navigator.of(context).pop(i),
          );
        }).toList(),
      ),
    );
  }
}
