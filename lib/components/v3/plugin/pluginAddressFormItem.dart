import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginInputItem.dart';
import 'package:polkawallet_ui/utils/consts.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/index.dart';

class PluginAddressFormItem extends StatelessWidget {
  const PluginAddressFormItem(
      {Key? key,
      this.label,
      this.svg,
      this.onTap,
      required this.account,
      this.isDisable = true})
      : super(key: key);

  final String? label;
  final KeyPairData account;
  final String? svg;
  final Future<void> Function()? onTap;
  final bool isDisable;

  @override
  Widget build(BuildContext context) {
    final content = PluginInputItem(
      label: label,
      labelBgColor: isDisable ? PluginColorsDark.disableTagBg : null,
      bgColor: isDisable ? PluginColorsDark.disableBg : null,
      bgHeight: 54,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        height: 46,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: AddressIcon(
                account.address,
                svg: svg ?? account.icon,
                size: 30,
                tapToCopy: false,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    UI.accountName(context, account),
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: const Color(0xCCFFFFFF)),
                  ),
                  Text(
                    Fmt.address(account.address),
                    style: TextStyle(
                        fontSize: UI.getTextSize(12, context),
                        color: const Color(0xCCFFFFFF)),
                  )
                ],
              ),
            ),
            Visibility(
                visible: onTap != null,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
    if (onTap == null) {
      return content;
    }
    return GestureDetector(
      child: content,
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
    );
  }
}
