import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/store/balances.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
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
  final bool enabled;
  final String? text; //enabled is false  To be valid

  @override
  _PluginInputBalanceState createState() => _PluginInputBalanceState();
}

class _PluginInputBalanceState extends State<PluginInputBalance> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;

    final max = Fmt.balanceInt(widget.balance?.amount);
    final colorGray = Theme.of(context).unselectedWidgetColor;

    return Container(
      margin: widget.margin,
      padding: widget.padding,
      child: Column(
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
            padding: EdgeInsets.only(left: 8, right: 6),
            decoration: BoxDecoration(
                color: Color(0x24FFFFFF),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4))),
            child: Row(
              children: [
                Expanded(
                    child: Focus(
                  onFocusChange: (v) {
                    setState(() {
                      _hasFocus = v;
                    });
                  },
                  child: TextFormField(
                    enabled: widget.enabled,
                    decoration: InputDecoration(
                      hintText:
                          '${dic['balance']}: ${widget.enabled ? Fmt.priceFloorBigInt(max, widget.balance?.decimals ?? 12, lengthMax: 4) : widget.text}',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(
                              color: Color(0xFFBCBCBC),
                              fontWeight: FontWeight.w300),
                      errorStyle: TextStyle(height: 0.3),
                      contentPadding: EdgeInsets.all(0),
                      border: InputBorder.none,
                      suffix: _hasFocus && widget.inputCtrl!.text.isNotEmpty
                          ? IconButton(
                              padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                              icon: Icon(Icons.cancel,
                                  size: 16, color: colorGray),
                              onPressed: widget.onClear as void Function()?,
                            )
                          : null,
                    ),
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
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
                      }
                    },
                  ),
                )),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: widget.enabled
                          ? widget.tokenBgColor
                          : Color(0x4DFFFFFF),
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
                  child: PluginCurrencyWithIcon(
                    widget.balance!.symbol!,
                    PluginTokenIcon(
                      widget.balance!.symbol!,
                      widget.tokenIconsMap!,
                      isHighlighted: widget.enabled,
                    ),
                    textStyle: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Color(0xFF212123), fontWeight: FontWeight.w600),
                    trailing: widget.onTokenChange != null
                        ? Icon(Icons.keyboard_arrow_down)
                        : null,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
