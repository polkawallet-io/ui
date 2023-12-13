import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginAddressFormItem.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginScaffold.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class PluginAccountListPageParams {
  PluginAccountListPageParams(
      {this.list, this.title, this.listEVM, this.current});

  final String? title;
  final List<KeyPairData>? list;
  final List<KeyPairData>? listEVM;
  final KeyPairData? current;
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: args.list?.isNotEmpty == true,
                child: const Text('Substrate',
                    style: TextStyle(color: Colors.white))),
            Column(
              children: args.list?.map((i) {
                    return GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 12),
                        foregroundDecoration: args.current?.pubKey == i.pubKey
                            ? BoxDecoration(
                                color:
                                    const Color(0xFFFF7849).withOpacity(0.09),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: const Color(0xFFFF7849),
                                ))
                            : null,
                        child: PluginAddressFormItem(account: i),
                      ),
                      onTap: () => Navigator.of(context).pop(i),
                    );
                  }).toList() ??
                  [],
            ),
            Visibility(
                visible: args.listEVM?.isNotEmpty == true,
                child:
                    const Text('EVM', style: TextStyle(color: Colors.white))),
            Column(
              children: args.listEVM?.map((i) {
                    return GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 12),
                        foregroundDecoration: args.current?.pubKey == i.pubKey
                            ? BoxDecoration(
                                color:
                                    const Color(0xFFFF7849).withOpacity(0.09),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: const Color(0xFFFF7849),
                                ))
                            : null,
                        child: PluginAddressFormItem(account: i),
                      ),
                      onTap: () => Navigator.of(context).pop(i),
                    );
                  }).toList() ??
                  [],
            )
          ],
        ),
      ),
    );
  }
}
