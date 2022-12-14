import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class OfflineSignatureInvalidWarn extends StatelessWidget {
  const OfflineSignatureInvalidWarn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dicAcc = I18n.of(context)!.getDic(i18n_full_dic_ui, 'account')!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Row(
        children: [Text(dicAcc['uos.invalid']!)],
      ),
    );
  }
}
