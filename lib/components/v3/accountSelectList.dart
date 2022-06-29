import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/roundedCard.dart';
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
        return RoundedCard(
            margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
            child: ListTile(
              dense: true,
              leading: AddressIcon(i.address, svg: i.icon, size: 36.w),
              title: Text(
                UI.accountName(context, i),
                style: Theme.of(context).textTheme.headline5,
              ),
              subtitle: Text(
                Fmt.address(i.address),
                style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontSize: UI.getTextSize(10, context),
                    color: const Color(0xFF908E8C)),
              ),
              onTap: () => Navigator.of(context).pop(i),
            ));
      }).toList(),
    );
  }
}
