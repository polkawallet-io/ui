import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginLoadingWidget.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

class ListTail extends StatelessWidget {
  ListTail(
      {Key? key,
      this.isEmpty,
      this.isLoading,
      this.isShowLoadText = false,
      this.color})
      : super(key: key);
  final bool? isLoading;
  final bool? isEmpty;
  late bool isShowLoadText;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: isLoading!
              ? isShowLoadText
                  ? Text(
                      dic!['list.loading']!,
                      style: TextStyle(
                          fontSize: UI.getTextSize(16, context),
                          color: color ?? Theme.of(context).disabledColor),
                    )
                  : PluginLoadingWidget()
              : Text(
                  isEmpty! ? dic!['list.empty']! : dic!['list.end']!,
                  style: TextStyle(
                      fontSize: UI.getTextSize(16, context),
                      color: color ?? Theme.of(context).disabledColor),
                ),
        )
      ],
    );
  }
}
