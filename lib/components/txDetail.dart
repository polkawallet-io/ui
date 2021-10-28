import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/jumpToBrowserLink.dart';
import 'package:polkawallet_ui/components/roundedCard.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

class TxDetail extends StatelessWidget {
  TxDetail({
    this.success,
    this.networkName,
    this.action,
    this.fee,
    this.eventId,
    this.hash,
    this.blockTime,
    this.blockNum,
    this.infoItems,
  });

  final bool? success;
  final String? networkName;
  final String? action;
  final String? fee;
  final String? eventId;
  final String? hash;
  final String? blockTime;
  final int? blockNum;
  final List<TxDetailInfoItem>? infoItems;

  List<Widget> _buildListView(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common');
    final labelStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).unselectedWidgetColor,
    );

    var list = <Widget>[
      RoundedCard(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.only(top: 8, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 120,
              padding: EdgeInsets.all(16),
              child: success!
                  ? Icon(Icons.check_circle, color: Colors.lightGreen, size: 80)
                  : Icon(Icons.error, color: Colors.red, size: 80),
            ),
            Text(
              '$action ${success! ? dic!['success'] : dic!['fail']}',
              style: Theme.of(context).textTheme.headline4,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text(blockTime!),
            ),
          ],
        ),
      ),
    ];
    list.add(RoundedCard(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        children: infoItems!.map((i) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: Text(i.label!, style: labelStyle)),
                i.content!,
                i.copyText != null
                    ? GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Image.asset(
                            'packages/polkawallet_ui/assets/images/copy.png',
                            width: 16,
                          ),
                        ),
                        onTap: () => UI.copyAndNotify(context, i.copyText),
                      )
                    : Container(width: 0)
              ],
            ),
          );
        }).toList(),
      ),
    ));

    final pnLink = networkName == 'polkadot' || networkName == 'kusama'
        ? 'https://polkascan.io/${networkName!.toLowerCase()}/transaction/$hash'
        : null;
    final snLink =
        'https://${networkName!.toLowerCase()}.subscan.io/extrinsic/$hash';
    final links = [
      JumpToBrowserLink(
        snLink,
        text: 'Subscan',
      )
    ];
    if (pnLink != null) {
      links.add(JumpToBrowserLink(
        pnLink,
        text: 'Polkascan',
      ));
    }
    list.add(RoundedCard(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        children: [
          Visibility(
              visible: fee != null,
              child: TxDetailItem(TxDetailInfoItem(
                  label: dic['tx.fee'], content: Text(fee ?? "")))),
          Visibility(
              visible: eventId != null,
              child: TxDetailItem(TxDetailInfoItem(
                  label: 'Event', content: Text(eventId ?? "")))),
          Visibility(
              visible: blockNum != null,
              child: TxDetailItem(TxDetailInfoItem(
                  label: 'Block', content: Text('#$blockNum')))),
          TxDetailItem(TxDetailInfoItem(
              label: 'Hash', content: Text(Fmt.address(hash)!))),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: links,
            ),
          )
        ],
      ),
    ));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    return Scaffold(
      appBar: AppBar(
        title: Text(dic['detail']!),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(bottom: 32),
          children: _buildListView(context),
        ),
      ),
    );
  }
}

class TxDetailItem extends StatelessWidget {
  TxDetailItem(this.i);
  final TxDetailInfoItem i;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
              child: Text(
            i.label!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).unselectedWidgetColor,
            ),
          )),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [i.content!]),
              flex: 0),
          i.copyText != null
              ? GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Image.asset(
                      'packages/polkawallet_ui/assets/images/copy.png',
                      width: 16,
                    ),
                  ),
                  onTap: () => UI.copyAndNotify(context, i.copyText),
                )
              : Container(width: 0)
        ],
      ),
    );
  }
}

class TxDetailInfoItem {
  TxDetailInfoItem({this.label, this.content, this.copyText});
  final String? label;
  final Widget? content;
  final String? copyText;
}
