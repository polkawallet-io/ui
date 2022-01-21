import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class ListTail extends StatelessWidget {
  ListTail(
      {this.isEmpty, this.isLoading, this.isShowLoadText = false, this.color});
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
          padding: EdgeInsets.all(16),
          child: isLoading!
              ? this.isShowLoadText
                  ? Text(
                      dic!['list.loading']!,
                      style: TextStyle(
                          fontSize: 16,
                          color: color ?? Theme.of(context).disabledColor),
                    )
                  : CupertinoActivityIndicator()
              : Text(
                  isEmpty! ? dic!['list.empty']! : dic!['list.end']!,
                  style: TextStyle(
                      fontSize: 16,
                      color: color ?? Theme.of(context).disabledColor),
                ),
        )
      ],
    );
  }
}
