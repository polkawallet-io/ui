import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/components/v3/button.dart';
import 'package:polkawallet_ui/components/v3/roundedCard.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

class TxDetail extends StatelessWidget {
  const TxDetail({
    Key? key,
    this.success,
    this.networkName,
    this.action,
    this.fee,
    this.eventId,
    this.hash,
    this.blockTime,
    this.blockNum,
    this.infoItems,
    required this.current,
  }) : super(key: key);

  final bool? success;
  final String? networkName;
  final String? action;
  final String? fee;
  final String? eventId;
  final String? hash;
  final String? blockTime;
  final int? blockNum;
  final List<TxDetailInfoItem>? infoItems;
  final KeyPairData current;

  List<Widget> _buildListView(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common');
    final labelStyle = TextStyle(
      color: Theme.of(context).textTheme.headline1?.color,
      fontSize: UI.getTextSize(16, context),
      fontFamily: UI.getFontFamily('TitilliumWeb', context),
      fontWeight: FontWeight.w600,
    );

    var list = <Widget>[
      Container(
        margin: const EdgeInsets.all(16),
        height: 180,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
                padding:
                    EdgeInsets.only(top: UI.isDarkTheme(context) ? 30.5 : 31),
                child: Image.asset(
                  'packages/polkawallet_ui/assets/images/bg_detail${UI.isDarkTheme(context) ? "_dark" : ""}.png',
                  width: double.infinity,
                  fit: BoxFit.fill,
                )),
            Image.asset(
                'packages/polkawallet_ui/assets/images/bg_detail_circle${UI.isDarkTheme(context) ? "_dark" : ""}.png',
                width: 90,
                fit: BoxFit.contain),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    AddressIcon(
                      current.address,
                      svg: current.icon,
                      size: 55,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Theme.of(context).toggleableActiveColor,
                              width: 3),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(55 / 2.0))),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(current.name!, style: labelStyle)),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        infoItems![0].content!,
                        Text(
                          '$action ${success! ? dic!['success'] : dic!['fail']}',
                          style: TextStyle(
                            color: success!
                                ? UI.isDarkTheme(context)
                                    ? const Color(0xFF82FF99)
                                    : const Color(0xFF22BC5A)
                                : Theme.of(context).disabledColor,
                            fontSize: UI.getTextSize(14, context),
                            fontFamily:
                                UI.getFontFamily('TitilliumWeb', context),
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ))
                  ],
                ))
          ],
        ),
      )
    ];

    int index = 0;
    bool isShowDivider = false;
    list.add(RoundedCard(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          ...infoItems!.map((i) {
            if (index == 0) {
              index = 1;
              return Container();
            }
            if (isShowDivider == false) {
              isShowDivider = true;
              return TxDetailItem(i, labelStyle, isShowDivider: false);
            }
            return TxDetailItem(i, labelStyle);
          }).toList(),
          Visibility(
              visible: fee != null,
              child: TxDetailItem(
                  TxDetailInfoItem(
                      label: dic['tx.fee'], content: Text(fee ?? "")),
                  labelStyle)),
          Visibility(
              visible: eventId != null,
              child: TxDetailItem(
                  TxDetailInfoItem(
                      label: 'Event', content: Text(eventId ?? "")),
                  labelStyle)),
          Visibility(
              visible: blockNum != null,
              child: TxDetailItem(
                  TxDetailInfoItem(label: 'Block', content: Text('#$blockNum')),
                  labelStyle)),
          Visibility(
              visible: hash != null,
              child: TxDetailItem(
                  TxDetailInfoItem(
                      copyText: Fmt.address(hash),
                      label: 'Hash',
                      content: Text(Fmt.address(hash))),
                  labelStyle)),
          Visibility(
              visible: blockTime != null,
              child: TxDetailItem(
                  TxDetailInfoItem(label: 'Time', content: Text(blockTime!)),
                  labelStyle)),
        ],
      ),
    ));
    if (hash == null) return list;

    final pnLink = networkName == 'polkadot' || networkName == 'kusama'
        ? 'https://polkascan.io/${networkName!.toLowerCase()}/transaction/$hash'
        : null;
    final snLink =
        'https://${networkName!.toLowerCase()}.subscan.io/extrinsic/$hash';
    Widget links = Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Button(
          title: 'Subscan',
          onPressed: () async {
            await UI.launchURL(snLink);
          },
          icon: SvgPicture.asset(
            "packages/polkawallet_ui/assets/images/icon_share.svg",
            width: 24,
            color: Theme.of(context).textTheme.button?.color,
          ),
        ));
    if (pnLink != null) {
      links = Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                  child: Button(
                title: 'Subscan',
                isBlueBg: false,
                style: Theme.of(context).textTheme.headline3?.copyWith(
                    color: Theme.of(context).textTheme.button?.color),
                onPressed: () async {
                  await UI.launchURL(snLink);
                },
                icon: Container(
                    margin: const EdgeInsets.only(left: 3),
                    child: SvgPicture.asset(
                      "packages/polkawallet_ui/assets/images/icon_share.svg",
                      width: 24,
                      color: Theme.of(context).textTheme.button?.color,
                    )),
              )),
              Container(width: 30),
              Expanded(
                  child: Button(
                title: 'Polkascan',
                style: TextStyle(
                    fontSize: UI.getTextSize(20, context),
                    fontWeight: FontWeight.w600,
                    color: UI.isDarkTheme(context)
                        ? Theme.of(context).textTheme.button?.color
                        : Colors.white,
                    fontFamily: UI.getFontFamily('TitilliumWeb', context)),
                isBlueBg: true,
                onPressed: () async {
                  await UI.launchURL(pnLink);
                },
                icon: Container(
                    margin: const EdgeInsets.only(left: 3),
                    child: SvgPicture.asset(
                      "packages/polkawallet_ui/assets/images/icon_share.svg",
                      width: 24,
                      color: UI.isDarkTheme(context)
                          ? Theme.of(context).textTheme.button?.color
                          : Colors.white,
                    )),
              ))
            ],
          ));
    }

    list.add(links);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    return Scaffold(
      appBar: AppBar(
        title: Text(dic['detail']!),
        centerTitle: true,
        leading: const BackBtn(),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32),
          children: _buildListView(context),
        ),
      ),
    );
  }
}

class TxDetailItem extends StatelessWidget {
  const TxDetailItem(this.i, this.labelStyle,
      {Key? key, this.isShowDivider = true})
      : super(key: key);
  final TxDetailInfoItem i;
  final TextStyle labelStyle;
  final bool isShowDivider;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
            visible: isShowDivider,
            child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  height: 1,
                ))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(flex: 0, child: Text(i.label!, style: labelStyle)),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(left: 16),
                alignment: Alignment.centerRight,
                child: i.content!,
              )),
              i.copyText != null
                  ? GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Image.asset(
                          'packages/polkawallet_ui/assets/images/copy${UI.isDarkTheme(context) ? "_dark" : ""}.png',
                          width: 16,
                        ),
                      ),
                      onTap: () => UI.copyAndNotify(context, i.copyText),
                    )
                  : Container(width: 0)
            ],
          ),
        )
      ],
    );
  }
}

class TxDetailInfoItem {
  TxDetailInfoItem({this.label, this.content, this.copyText});
  final String? label;
  final Widget? content;
  final String? copyText;
}
