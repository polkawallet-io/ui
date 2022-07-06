import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/store/balances.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/currencyWithIcon.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginCurrencyWithIcon.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTextTag.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTokenIcon.dart';
import 'package:polkawallet_ui/utils/consts.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

class PluginInputBalance extends StatefulWidget {
  const PluginInputBalance(
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
      this.tokenBgColor = const Color(0xFFFF7849),
      this.getMarketPrice,
      this.tokenSelectTitle,
      this.tokenOptions,
      this.tokenViewFunction,
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
  final String Function(String)? tokenViewFunction;
  final Color tokenBgColor;
  final double Function(String)? getMarketPrice;
  final String? tokenSelectTitle;
  final List<TokenBalanceData?>? tokenOptions;
  final bool enabled;
  final String? text; //enabled is false  To be valid

  @override
  createState() => _PluginInputBalanceState();
}

class _PluginInputBalanceState extends State<PluginInputBalance> {
  bool _hasFocus = false;

  _tokenChangeAction() async {
    final selected = await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x24FFFFFF),
      builder: (BuildContext context) {
        var selecIndex = -1;
        return StatefulBuilder(
          builder: (BuildContext context, setBottomSheet) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              height: 350,
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14)),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(14),
                            topRight: Radius.circular(14)),
                        color: Color(0xFF000000),
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
                                        color: const Color(0xFFFFFFFF),
                                        fontSize: UI.getTextSize(18, context))),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                            color: const Color(0xFF313235),
                            padding: const EdgeInsets.only(
                                top: 18, left: 16, right: 16),
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: widget.tokenOptions?.length,
                                itemBuilder: (context, index) {
                                  final symbol =
                                      widget.tokenOptions![index]!.symbol!;
                                  return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                          border: selecIndex == index
                                              ? Border.all(
                                                  color:
                                                      const Color(0xFFFF7849),
                                                  width: 1)
                                              : const Border(),
                                          color: selecIndex == index
                                              ? const Color(0xFFFF7849)
                                                  .withOpacity(0.09)
                                              : const Color(0xFF424447),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: GestureDetector(
                                        child: ListTile(
                                          title: CurrencyWithIcon(
                                            widget.tokenViewFunction != null
                                                ? widget
                                                    .tokenViewFunction!(symbol)
                                                : symbol,
                                            PluginTokenIcon(
                                              symbol,
                                              widget.tokenIconsMap!,
                                              size: 24,
                                            ),
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                                        fontSize:
                                                            UI.getTextSize(
                                                                14, context),
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                              widget.getMarketPrice != null
                                                  ? Text(
                                                      '≈\$ ${Fmt.priceFloor(widget.getMarketPrice!(widget.tokenOptions![index]!.symbol ?? '') * Fmt.balanceDouble(widget.tokenOptions![index]!.amount!, widget.tokenOptions![index]!.decimals!), lengthMax: 4)}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: UI
                                                                  .getTextSize(
                                                                      10,
                                                                      context),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                    )
                                                  : const SizedBox(
                                                      height: 0, width: 0),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pop(
                                                widget.tokenOptions![index]!);
                                          },
                                        ),
                                        onTapDown: (details) {
                                          debugPrint("onTapDown");
                                          setBottomSheet(() {
                                            selecIndex = index;
                                          });
                                        },
                                        onTapUp: (details) {
                                          debugPrint("onTapUp");
                                          setBottomSheet(() {
                                            selecIndex = -1;
                                          });
                                        },
                                        onTapCancel: () {
                                          debugPrint("onTapCancel");
                                          setBottomSheet(() {
                                            selecIndex = -1;
                                          });
                                        },
                                      ));
                                })))
                  ],
                ),
              ),
            );
          },
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
        widget.getMarketPrice != null && widget.inputCtrl!.text.isNotEmpty;
    double inputAmount = 0;
    try {
      inputAmount =
          double.parse(widget.inputCtrl!.text.trim().replaceAll(",", ""));
    } catch (e) {
      priceVisible = false;
    }
    final price = priceVisible
        ? widget.getMarketPrice!(widget.balance!.symbol ?? '') * inputAmount
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
                      title: widget.titleTag!,
                      backgroundColor: widget.enabled
                          ? PluginColorsDark.headline1
                          : PluginColorsDark.headline3,
                    )
                  : Container(),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(bottom: 8),
                child: Visibility(
                  visible: widget.enabled,
                  child: Text(
                      '${dic['balance']}: ${widget.enabled ? Fmt.priceFloorBigInt(max, widget.balance?.decimals ?? 12, lengthMax: 4) : widget.text}',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.w300, color: Colors.white)),
                ),
              )),
            ],
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 16, right: 12, top: 12, bottom: 12),
            decoration: BoxDecoration(
                color: Color(_hasFocus ? 0x3DFFFFFF : 0x1AFFFFFF),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(widget.titleTag != null ? 0 : 4),
                    bottomLeft: const Radius.circular(4),
                    topRight: const Radius.circular(4),
                    bottomRight: const Radius.circular(4))),
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
                          scrollPadding: EdgeInsets.zero,
                          cursorColor: Colors.blue,
                          enabled: widget.enabled,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            hintText: widget.enabled ? "" : widget.text,
                            hintStyle: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(color: const Color(0xFFBCBCBC)),
                            errorStyle: const TextStyle(height: 0.3),
                            border: InputBorder.none,
                            suffix: _hasFocus &&
                                    widget.inputCtrl!.text.isNotEmpty
                                ? GestureDetector(
                                    onTap: widget.onClear as void Function()?,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: Icon(Icons.cancel,
                                            size: 16, color: colorGray)),
                                  )
                                : null,
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                  color: _hasFocus
                                      ? Colors.white
                                      : const Color(0xFFBCBCBC)),
                          inputFormatters: [
                            UI.decimalInputFormatter(widget.balance!.decimals!)!
                          ],
                          controller: widget.inputCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
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
                          visible: priceVisible && _hasFocus,
                          child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                '≈ \$ ${Fmt.priceFloor(price)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        color: Colors.white,
                                        height: 0.8,
                                        fontWeight: FontWeight.w300),
                              )))
                    ])),
                GestureDetector(
                  onTap: widget.onTokenChange != null &&
                          widget.enabled &&
                          (widget.tokenOptions?.length ?? 0) > 0
                      ? () async {
                          _tokenChangeAction();
                        }
                      : null,
                  child: PluginCurrencyWithIcon(
                    widget.tokenViewFunction != null
                        ? widget.tokenViewFunction!(widget.balance!.symbol!)
                        : widget.balance!.symbol!,
                    PluginTokenIcon(
                      widget.balance!.symbol!,
                      widget.tokenIconsMap!,
                      isHighlighted: widget.enabled,
                      isFold: true,
                    ),
                    textStyle: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.white.withAlpha(
                            widget.onTokenChange != null &&
                                    widget.enabled &&
                                    (widget.tokenOptions?.length ?? 0) > 0
                                ? 255
                                : 127)),
                    trailing: widget.onTokenChange != null &&
                            widget.enabled &&
                            (widget.tokenOptions?.length ?? 0) > 0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: Image.asset(
                              "packages/polkawallet_ui/assets/images/token_select.png",
                              width: 10,
                            ))
                        : null,
                  ),
                ),
                widget.onSetMax != null && widget.enabled
                    ? Row(
                        children: [
                          Container(
                            height: 20,
                            width: 1,
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            color: const Color(0xFF979797),
                          ),
                          GestureDetector(
                            child: Text(
                              "All",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                      color: const Color(0xFFFF7849),
                                      fontWeight: FontWeight.w400),
                            ),
                            onTap: () => widget.onSetMax!(max),
                          )
                        ],
                      )
                    : Container()
              ],
            ),
          )
        ],
      ),
    );
  }
}
