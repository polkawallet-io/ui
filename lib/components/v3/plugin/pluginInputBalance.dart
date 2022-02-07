import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkawallet_sdk/plugin/store/balances.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/currencyWithIcon.dart';
import 'package:polkawallet_ui/components/tokenIcon.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginCurrencyWithIcon.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTextTag.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTokenIcon.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

class PluginInputBalance extends StatefulWidget {
  PluginInputBalance(
      {this.titleTag,
      Key? key,
      this.inputCtrl,
      this.balance,
      this.tokenIconsMap,
      this.onTokenChange,
      this.margin,
      this.padding,
      this.onClear,
      this.onInputChange,
      this.onSetMax,
      this.enabled = true,
      this.tokenBgColor = const Color(0xFFFC8156),
      this.marketPrices,
      this.tokenSelectTitle,
      this.tokenOptions,
      this.text})
      : super(key: key);
  final String? titleTag;
  final TextEditingController? inputCtrl;
  final TokenBalanceData? balance;
  final Map<String, Widget>? tokenIconsMap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Function(TokenBalanceData)? onTokenChange;
  final Function? onClear;
  final Function(String)? onInputChange;
  final Function(BigInt)? onSetMax;
  final Color tokenBgColor;
  final Map<String?, double>? marketPrices;
  final String? tokenSelectTitle;
  final List<TokenBalanceData?>? tokenOptions;
  final bool enabled;
  final String? text; //enabled is false  To be valid

  @override
  _PluginInputBalanceState createState() => _PluginInputBalanceState();
}

class _PluginInputBalanceState extends State<PluginInputBalance> {
  bool _hasFocus = false;

  _tokenChangeAction() async {
    final selected = await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              kToolbarHeight -
              200,
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24)),
                    color: Color(0xFFD8D8D8),
                  ),
                  height: 48,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(widget.tokenSelectTitle ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF26282D),
                                    fontSize: 18)),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 15,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                        color: Color(0xFFBDBEBE),
                        padding: EdgeInsets.only(top: 35, left: 16, right: 16),
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: widget.tokenOptions?.length,
                            itemBuilder: (context, index) {
                              final symbol =
                                  widget.tokenOptions![index]!.symbol!;
                              return Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                      color: Color(0x33555555),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    title: CurrencyWithIcon(
                                      symbol,
                                      PluginTokenIcon(
                                        symbol,
                                        widget.tokenIconsMap!,
                                        size: 23,
                                      ),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          Fmt.priceFloorBigInt(
                                              BigInt.parse(widget
                                                  .tokenOptions![index]!
                                                  .amount!),
                                              widget.tokenOptions![index]!
                                                  .decimals!,
                                              lengthMax: 4),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '≈\$ ${Fmt.priceFloor((widget.marketPrices![widget.tokenOptions![index]!.symbol] ?? 0) * Fmt.balanceDouble(widget.tokenOptions![index]!.amount!, widget.tokenOptions![index]!.decimals!), lengthMax: 4)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.of(context)
                                          .pop(widget.tokenOptions![index]!);
                                    },
                                  ));
                            })))
              ],
            ),
          ),
        );
      },
      context: context,
    );
    if (selected != null) {
      widget.onTokenChange!(selected as TokenBalanceData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;

    final max = Fmt.balanceInt(widget.balance?.amount);
    final colorGray = Theme.of(context).unselectedWidgetColor;

    bool priceVisible =
        widget.marketPrices != null && widget.inputCtrl!.text.isNotEmpty;
    double inputAmount = 0;
    try {
      inputAmount = double.parse(widget.inputCtrl!.text.trim());
    } catch (e) {
      priceVisible = false;
    }
    final price = priceVisible
        ? widget.marketPrices![widget.balance!.symbol]! * inputAmount
        : null;

    return Container(
      margin: widget.margin,
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.titleTag != null
                  ? PluginTextTag(
                      padding: EdgeInsets.zero,
                      title: widget.titleTag!,
                      backgroundColor: widget.enabled
                          ? Color(0xCCFFFFFF)
                          : Color(0x33FFFFFF),
                    )
                  : Container(),
              widget.onSetMax != null && widget.enabled
                  ? GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Text(
                          "Max",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                        ),
                      ),
                      onTap: () => widget.onSetMax!(max),
                    )
                  : Container()
            ],
          ),
          Container(
            // height: 48,
            padding: EdgeInsets.only(left: 8, right: 6, top: 5, bottom: 5),
            decoration: BoxDecoration(
                color: Color(0x24FFFFFF),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(widget.titleTag != null ? 0 : 4),
                    bottomLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4))),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Focus(
                        onFocusChange: (v) {
                          setState(() {
                            _hasFocus = v;
                          });
                        },
                        child: TextFormField(
                          cursorColor: Colors.blue,
                          enabled: widget.enabled,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText:
                                '${dic['balance']}: ${widget.enabled ? Fmt.priceFloorBigInt(max, widget.balance?.decimals ?? 12, lengthMax: 4) : widget.text}',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(
                                    color: Color(0xFFBCBCBC),
                                    fontWeight: FontWeight.w300),
                            errorStyle: TextStyle(height: 0.3),
                            border: InputBorder.none,
                            suffix: _hasFocus &&
                                    widget.inputCtrl!.text.isNotEmpty
                                ? IconButton(
                                    padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                    icon: Icon(Icons.cancel,
                                        size: 16, color: colorGray),
                                    onPressed:
                                        widget.onClear as void Function()?,
                                  )
                                : null,
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                          inputFormatters: [
                            UI.decimalInputFormatter(widget.balance!.decimals!)!
                          ],
                          controller: widget.inputCtrl,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) {
                            try {
                              double.parse(value);
                              widget.onInputChange!(value);
                            } catch (e) {
                              widget.inputCtrl!.text = "";
                              widget.onInputChange!("");
                            }
                            setState(() {});
                          },
                        ),
                      ),
                      Visibility(
                          visible: priceVisible,
                          child: Text(
                            '≈ \$ ${Fmt.priceFloor(price)}',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color: Colors.white,
                                    height: 0.8,
                                    fontWeight: FontWeight.w300),
                          ))
                    ])),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: widget.enabled
                            ? widget.tokenBgColor
                            : Color(0x4DFFFFFF),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3))),
                    child: PluginCurrencyWithIcon(
                      widget.balance!.symbol!,
                      PluginTokenIcon(
                        widget.balance!.symbol!,
                        widget.tokenIconsMap!,
                        isHighlighted: widget.enabled,
                        isFold: true,
                      ),
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(
                              color: Color(0xFF212123),
                              fontWeight: FontWeight.w600),
                      trailing: widget.onTokenChange != null
                          ? Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: SvgPicture.asset(
                                "packages/polkawallet_ui/assets/images/triangle_bottom.svg",
                                color: Color(0x8026282D),
                              ))
                          : null,
                    ),
                  ),
                  onTap: widget.onTokenChange != null &&
                          widget.enabled &&
                          (widget.tokenOptions?.length ?? 0) > 0
                      ? () async {
                          _tokenChangeAction();
                        }
                      : null,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
