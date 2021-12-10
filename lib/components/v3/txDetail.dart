import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/jumpToBrowserLink.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/button.dart';
import 'package:polkawallet_ui/components/v3/roundedCard.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    required this.current,
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
  final KeyPairData current;

  List<Widget> _buildListView(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common');
    final labelStyle = TextStyle(
      color: Theme.of(context).textSelectionTheme.selectionColor,
      fontSize: 16,
      fontFamily: 'TitilliumWeb',
      fontWeight: FontWeight.w600,
    );

    var list = <Widget>[
      Container(
        margin: EdgeInsets.all(16),
        height: 180.h,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 30),
                child: Image.asset(
                  'packages/polkawallet_ui/assets/images/bg_detail.png',
                  width: double.infinity,
                )),
            Image.asset(
                'packages/polkawallet_ui/assets/images/bg_detail_circle.png',
                width: 90,
                fit: BoxFit.contain),
            Padding(
                padding: EdgeInsets.only(top: 10),
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(55 / 2.0))),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Text(current.name!, style: labelStyle)),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        infoItems![0].content!,
                        Text(
                          '$action ${success! ? dic!['success'] : dic!['fail']}',
                          style: TextStyle(
                            color: Color(0xFF22BC5A),
                            fontSize: 14,
                            fontFamily: 'TitilliumWeb',
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
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
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
          TxDetailItem(
              TxDetailInfoItem(
                  label: 'Hash', content: Text(Fmt.address(hash)!)),
              labelStyle),
        ],
      ),
    ));

    final pnLink = networkName == 'polkadot' || networkName == 'kusama'
        ? 'https://polkascan.io/${networkName!.toLowerCase()}/transaction/$hash'
        : null;
    final snLink =
        'https://${networkName!.toLowerCase()}.subscan.io/extrinsic/$hash';
    Widget links = Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Button(
          title: 'Subscan',
          onPressed: () async {
            await UI.launchURL(snLink);
          },
          icon: SvgPicture.asset(
            "packages/polkawallet_ui/assets/images/icon_share.svg",
            width: 24.h,
            color: Colors.white,
          ),
        ));
    if (pnLink != null) {
      links = Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                  child: Button(
                title: 'Subscan',
                isBlueBg: false,
                style: Theme.of(context).textTheme.headline3,
                onPressed: () async {
                  await UI.launchURL(snLink);
                },
                icon: Container(
                    margin: EdgeInsets.only(left: 3),
                    child: SvgPicture.asset(
                      "packages/polkawallet_ui/assets/images/icon_share.svg",
                      width: 24.h,
                      color: Theme.of(context).disabledColor,
                    )),
              )),
              Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Button(
                        title: 'Polkascan',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: "TitilliumWeb"),
                        isBlueBg: true,
                        onPressed: () async {
                          await UI.launchURL(pnLink);
                        },
                        icon: Container(
                            margin: EdgeInsets.only(left: 3),
                            child: SvgPicture.asset(
                              "packages/polkawallet_ui/assets/images/icon_share.svg",
                              width: 24.h,
                              color: Colors.white,
                            )),
                      )))
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
        leading: BackBtn(
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 32),
          children: _buildListView(context),
        ),
      ),
    );
  }
}

class TxDetailItem extends StatelessWidget {
  TxDetailItem(this.i, this.labelStyle, {this.isShowDivider = true});
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
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Divider(
                  height: 1,
                ))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                          width: 16.w,
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
