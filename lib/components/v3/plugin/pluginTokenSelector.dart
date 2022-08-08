import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/plugin/store/balances.dart';
import 'package:polkawallet_ui/components/currencyWithIcon.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTokenIcon.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';

class PluginTokenSelector extends StatefulWidget {
  const PluginTokenSelector({
    Key? key,
    this.tokenViewFunction,
    required this.tokenBgColor,
    this.getMarketPrice,
    this.tokenSelectTitle,
    this.tokenOptions,
    this.quickTokenOptions,
    this.tokenIconsMap,
  }) : super(key: key);
  final String Function(String)? tokenViewFunction;
  final Color tokenBgColor;
  final double Function(String)? getMarketPrice;
  final String? tokenSelectTitle;
  final List<TokenBalanceData?>? tokenOptions;
  final List<TokenBalanceData?>? quickTokenOptions;
  final Map<String, Widget>? tokenIconsMap;
  @override
  State<PluginTokenSelector> createState() => _PluginTokenSelectorState();
}

class _PluginTokenSelectorState extends State<PluginTokenSelector> {
  var selecIndex = -1;
  final TextEditingController searchCtl = TextEditingController();
  final FocusNode focusNode = FocusNode();
  List<TokenBalanceData?>? searchList = [];

  @override
  void initState() {
    super.initState();
    searchList = widget.tokenOptions;
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      height: 550,
      width: double.infinity,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF313235),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14), topRight: Radius.circular(14)),
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
                        style: Theme.of(context).textTheme.headline5?.copyWith(
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
            Container(
                color: const Color(0xFF313235),
                padding: const EdgeInsets.only(
                    top: 16, left: 16, right: 16, bottom: 10),
                alignment: Alignment.center,
                height: 56,
                child: Stack(
                  children: [
                    Align(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color(0xFF424447)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: TextField(
                        focusNode: focusNode,
                        controller: searchCtl,
                        onChanged: (value) {
                          var list = widget.tokenOptions!
                              .where((element) => element!.symbol!
                                  .toUpperCase()
                                  .contains(searchCtl.text.toUpperCase()))
                              .toList();
                          if (searchCtl.text.isEmpty) {
                            list = widget.tokenOptions!;
                          }
                          setState(() {
                            searchList = list;
                          });
                        },
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.search,
                        maxLines: 1,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.only(
                              left: 8, right: 30, top: 10, bottom: 10),
                          hintText: dic['search.token'],
                          hintStyle: TextStyle(
                              fontFamily: 'Titillium Web Light',
                              fontWeight: FontWeight.w300,
                              fontSize: UI.getTextSize(14, context),
                              color: Colors.white.withOpacity(0.5)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.search,
                            size: 24,
                            color: Color(0xFF979797),
                          )),
                    )
                  ],
                )),
            widget.quickTokenOptions != null &&
                    widget.quickTokenOptions!.isNotEmpty
                ? Container(
                    color: const Color(0xFF313235),
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      spacing: 6,
                      runAlignment: WrapAlignment.start,
                      runSpacing: 6,
                      children: widget.quickTokenOptions!
                          .map((e) => GestureDetector(
                                onTap: () => Navigator.of(context).pop(e),
                                child: Container(
                                    height: 26,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                        border: const Border(),
                                        color: const Color(0xFF424447),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4),
                                          child: PluginTokenIcon(
                                            e?.name ?? e?.symbol ?? "",
                                            widget.tokenIconsMap!,
                                            size: 16,
                                          ),
                                        ),
                                        Text(
                                          e?.name ?? e?.symbol ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                        )
                                      ],
                                    )),
                              ))
                          .toList(),
                    ))
                : Container(),
            Expanded(
                child: Container(
                    color: const Color(0xFF313235),
                    padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: searchList?.length,
                        itemExtent: 56,
                        itemBuilder: (context, index) {
                          final symbol = searchList?[index]?.symbol ?? "";
                          return GestureDetector(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                  border: selecIndex == index
                                      ? Border.all(
                                          color: const Color(0xFFFF7849),
                                          width: 1)
                                      : const Border(),
                                  color: selecIndex == index
                                      ? const Color(0xFFFF7849)
                                          .withOpacity(0.09)
                                      : const Color(0xFF424447),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CurrencyWithIcon(
                                        widget.tokenViewFunction != null
                                            ? widget.tokenViewFunction!(symbol)
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
                                                fontWeight: FontWeight.w600),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            Fmt.priceFloorBigInt(
                                                BigInt.parse(searchList![index]!
                                                    .amount!),
                                                searchList![index]!.decimals!,
                                                lengthMax: 4),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(
                                                    color: Colors.white,
                                                    fontSize: UI.getTextSize(
                                                        14, context),
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                          widget.getMarketPrice != null
                                              ? Text(
                                                  '≈\$ ${Fmt.priceFloor(widget.getMarketPrice!(searchList![index]!.symbol ?? '') * Fmt.balanceDouble(searchList![index]!.amount!, searchList![index]!.decimals!), lengthMax: 4)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      ?.copyWith(
                                                          color: Colors.white,
                                                          fontSize:
                                                              UI.getTextSize(
                                                                  10, context),
                                                          fontWeight:
                                                              FontWeight.w300),
                                                )
                                              : const SizedBox(
                                                  height: 0, width: 0),
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                            onTap: () {
                              setState(() {
                                selecIndex = index;
                              });
                              Navigator.of(context).pop(searchList![index]!);
                            },
                          );
                        })))
          ],
        ),
      ),
    );
  }
}
