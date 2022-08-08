import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_ui/components/addressIcon.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/index.dart';

class AccountSelectList extends StatelessWidget {
  const AccountSelectList(this.plugin, this.list, {Key? key}) : super(key: key);

  final PolkawalletPlugin plugin;
  final List<KeyPairData>? list;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: list!.map((i) {
        return ListTile(
          leading: AddressIcon(i.address, svg: i.icon),
          title: Text(UI.accountName(context, i)),
          subtitle: Text(Fmt.address(i.address)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => Navigator.of(context).pop(i),
        );
      }).toList(),
    );
  }
}
