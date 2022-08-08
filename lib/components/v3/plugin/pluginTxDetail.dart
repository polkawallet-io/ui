import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginButton.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginScaffold.dart';
import 'package:polkawallet_ui/components/v3/plugin/roundedPluginCard.dart';
import 'package:polkawallet_ui/utils/consts.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

class PluginTxDetail extends StatelessWidget {
  const PluginTxDetail({
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
    this.resolveLinks,
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
  final String? resolveLinks;

  List<Widget> _buildListView(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common');
    final labelStyle = TextStyle(
      color: Colors.white,
      fontSize: UI.getTextSize(16, context),
      fontFamily: UI.getFontFamily('TitilliumWeb', context),
      fontWeight: FontWeight.w600,
    );

    var list = <Widget>[
      Container(
        margin: const EdgeInsets.all(16),
        height: success != null ? 180 : 160,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
                margin: const EdgeInsets.only(top: 30),
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 68, 70, 73),
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            Image.asset(
                'packages/polkawallet_ui/assets/images/bg_detail_circle.png',
                width: 90,
                color: const Color.fromARGB(255, 68, 70, 73),
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
                        success != null
                            ? Text(
                                '$action ${success! ? dic!['success'] : dic!['fail']}',
                                style: TextStyle(
                                  color: success!
                                      ? const Color(0xFF81FEB9)
                                      : PluginColorsDark.primary,
                                  fontSize: UI.getTextSize(14, context),
                                  fontFamily:
                                      UI.getFontFamily('TitilliumWeb', context),
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            : Container()
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
    list.add(RoundedPluginCard(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      borderRadius: const BorderRadius.all(const Radius.circular(8)),
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
                      label: dic?['tx.fee'],
                      content: Text(
                        fee ?? "",
                        style: const TextStyle(color: Colors.white),
                      )),
                  labelStyle)),
          Visibility(
              visible: eventId != null,
              child: TxDetailItem(
                  TxDetailInfoItem(
                      label: 'Event',
                      content: Text(eventId ?? "",
                          style: const TextStyle(color: Colors.white))),
                  labelStyle)),
          Visibility(
              visible: blockNum != null,
              child: TxDetailItem(
                  TxDetailInfoItem(
                      label: 'Block',
                      content: Text('#$blockNum',
                          style: const TextStyle(color: Colors.white))),
                  labelStyle)),
          Visibility(
              visible: hash != null,
              child: TxDetailItem(
                  TxDetailInfoItem(
                      copyText: hash,
                      label: 'Hash',
                      content: Text(Fmt.address(hash),
                          style: const TextStyle(color: Colors.white))),
                  labelStyle)),
          Visibility(
              visible: blockTime != null,
              child: TxDetailItem(
                  TxDetailInfoItem(
                      label: 'Time',
                      content: Text(blockTime!,
                          style: const TextStyle(color: Colors.white))),
                  labelStyle)),
        ],
      ),
    ));
    if (hash == null) {
      if (resolveLinks == null) return list;
      Widget links = Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: PluginButton(
            title: 'Subscan',
            style: Theme.of(context)
                .textTheme
                .headline3
                ?.copyWith(color: Colors.black),
            backgroundColor: PluginColorsDark.primary,
            onPressed: () async {
              await UI.launchURL(resolveLinks!);
            },
            icon: SvgPicture.asset(
              "packages/polkawallet_ui/assets/images/icon_share.svg",
              width: 24,
              color: Colors.black,
            ),
          ));
      list.add(links);
      return list;
    }

    final pnLink = networkName == 'polkadot' || networkName == 'kusama'
        ? 'https://polkascan.io/${networkName!.toLowerCase()}/transaction/$hash'
        : null;
    final snLink =
        'https://${networkName!.toLowerCase()}.subscan.io/extrinsic/$hash';
    Widget links = Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: PluginButton(
          title: 'Subscan',
          style: Theme.of(context)
              .textTheme
              .headline3
              ?.copyWith(color: Colors.black),
          backgroundColor: PluginColorsDark.primary,
          onPressed: () async {
            await UI.launchURL(snLink);
          },
          icon: SvgPicture.asset(
            "packages/polkawallet_ui/assets/images/icon_share.svg",
            width: 24,
            color: Colors.black,
          ),
        ));
    if (pnLink != null) {
      links = Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                  child: PluginButton(
                title: 'Subscan',
                backgroundColor: PluginColorsDark.primary,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(color: Colors.black),
                onPressed: () async {
                  await UI.launchURL(snLink);
                },
                icon: Container(
                    margin: const EdgeInsets.only(left: 3),
                    child: SvgPicture.asset(
                      "packages/polkawallet_ui/assets/images/icon_share.svg",
                      width: 24,
                      color: Colors.black,
                    )),
              )),
              Container(width: 30),
              Expanded(
                  child: PluginButton(
                title: 'Polkascan',
                style: TextStyle(
                    fontSize: UI.getTextSize(20, context),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: UI.getFontFamily('TitilliumWeb', context)),
                backgroundColor: PluginColorsDark.headline1,
                onPressed: () async {
                  await UI.launchURL(pnLink);
                },
                icon: Container(
                    margin: const EdgeInsets.only(left: 3),
                    child: SvgPicture.asset(
                      "packages/polkawallet_ui/assets/images/icon_share.svg",
                      width: 24,
                      color: Colors.black,
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
    return PluginScaffold(
      appBar: PluginAppBar(title: Text(dic['detail']!), centerTitle: true),
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
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  color: const Color(0xFFFFFFFF).withOpacity(0.14),
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
                          'packages/polkawallet_ui/assets/images/copy.png',
                          width: 16,
                          color: Colors.white,
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
