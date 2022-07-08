import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/store/balances.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginCurrencyWithIcon.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTextTag.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTokenIcon.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTokenSelector.dart';
import 'package:polkawallet_ui/utils/consts.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

enum InputBalanceType { defaultType, swapType }

class PluginInputBalance extends StatefulWidget {
  const PluginInputBalance({
    this.titleTag,
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
    this.text,
    this.quickTokenOptions,
    this.type = InputBalanceType.defaultType,
    this.bgBorderRadius,
  }) : super(key: key);

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
  final List<TokenBalanceData?>? quickTokenOptions;
  final bool enabled;
  final String? text; //enabled is false  To be valid
  final InputBalanceType type;
  final BorderRadiusGeometry? bgBorderRadius; //swapType

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
          return PluginTokenSelector(
            tokenBgColor: widget.tokenBgColor,
            tokenSelectTitle: widget.tokenSelectTitle,
            tokenIconsMap: widget.tokenIconsMap,
            tokenViewFunction: widget.tokenViewFunction,
            getMarketPrice: widget.getMarketPrice,
            tokenOptions: widget.tokenOptions,
            quickTokenOptions: widget.quickTokenOptions,
          );
        },
        context: context);
    if (selected != null) {
      widget.onTokenChange!(selected as TokenBalanceData);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == InputBalanceType.swapType) {
      return buildSwapType(context);
    }
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
                                    widget.inputCtrl!.text.isNotEmpty &&
                                    widget.onClear != null
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

  Widget buildSwapType(BuildContext context) {
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
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: Color(_hasFocus ? 0x3DFFFFFF : 0x1AFFFFFF),
          borderRadius: widget.bgBorderRadius ??
              const BorderRadius.only(
                  topLeft: Radius.circular(4), topRight: Radius.circular(4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.titleTag != null
                  ? Text(
                      widget.titleTag!,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.white.withAlpha(153),
                          fontWeight: FontWeight.w600),
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
            padding: const EdgeInsets.only(top: 12, bottom: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
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
                                    widget.inputCtrl!.text.isNotEmpty &&
                                    widget.onClear != null
                                ? GestureDetector(
                                    onTap: widget.onClear as void Function()?,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: Icon(Icons.cancel,
                                            size: 14, color: colorGray)),
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
                          visible: priceVisible,
                          child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                '≈ \$ ${Fmt.priceFloor(price)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        color: Colors.white.withAlpha(127),
                                        fontSize: 10,
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
