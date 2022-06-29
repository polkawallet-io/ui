import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TabBarPlugin extends StatefulWidget {
  const TabBarPlugin(
      {required this.datas,
      this.unSelectTextStyle,
      this.selectTextStyle,
      this.backgroundColor = const Color(0xFF242424),
      this.selectTextColor = const Color(0xFFFF8E66),
      this.unSelectTextColor = const Color(0x80FFFFFF),
      this.selectTextBackgroundColor = const Color(0x2EFF8E66),
      this.itemPaddingHorizontal = 12,
      this.onChange,
      this.controller,
      Key? key})
      : super(key: key);
  final List<String> datas;
  final TabBarPluginController? controller;
  final TextStyle? unSelectTextStyle;
  final TextStyle? selectTextStyle;
  final Color? backgroundColor;
  final Color? selectTextColor;
  final Color? unSelectTextColor;
  final double? itemPaddingHorizontal;
  final Color? selectTextBackgroundColor;
  final Function(int)? onChange;

  @override
  createState() => _TabBarPluginState();
}

class _TabBarPluginState extends State<TabBarPlugin> {
  int _index = 0;
  int _min = 0, _max = 0;
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    widget.controller?._bind((index) => onChange(index));
    super.initState();
  }

  void onChange(int index) {
    if (index >= widget.datas.length) {
      index = 0;
    }
    setState(() {
      _index = index;
      if (widget.onChange != null) {
        widget.onChange!(_index);
      }
      if (_index < _min || _index > _max) {
        _scrollController.jumpTo(index: _index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          ValueListenableBuilder<Iterable<ItemPosition>>(
            valueListenable: _itemPositionsListener.itemPositions,
            builder: (context, positions, child) {
              int? min;
              int? max;
              if (positions.isNotEmpty) {
                // Determine the first visible item by finding the item with the
                // smallest trailing edge that is greater than 0.  i.e. the first
                // item whose trailing edge in visible in the viewport.
                min = positions
                    .where((ItemPosition position) =>
                        position.itemLeadingEdge >= 0)
                    .reduce((ItemPosition min, ItemPosition position) =>
                        position.itemTrailingEdge < min.itemTrailingEdge
                            ? position
                            : min)
                    .index;
                // Determine the last visible item by finding the item with the
                // greatest leading edge that is less than 1.  i.e. the last
                // item whose leading edge in visible in the viewport.
                max = positions
                    .where((ItemPosition position) =>
                        double.parse(
                            position.itemTrailingEdge.toStringAsFixed(2)) <=
                        1)
                    .reduce((ItemPosition max, ItemPosition position) =>
                        position.itemTrailingEdge > max.itemTrailingEdge
                            ? position
                            : max)
                    .index;
                _min = min;
                _max = max;
              }
              return Container();
            },
          ),
          GestureDetector(
            onTap: () {
              onChange(_index + 1);
            },
            child: Image.asset(
              "packages/polkawallet_ui/assets/images/tab_bar_plugin.png",
              height: double.infinity,
            ),
          ),
          Container(
              margin: const EdgeInsets.only(right: 22, bottom: 5.5, top: 2.5),
              padding: const EdgeInsets.all(4),
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5)),
                color: Color(0xFFD5D2CD),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x80000000),
                    blurRadius: 4.0, // has the effect of softening the shadow
                    spreadRadius: 0.0, // has the effect of extending the shadow
                    offset: Offset(
                      0.0, // horizontal, move right 10
                      2.0, // vertical, move down 10
                    ),
                  )
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(3),
                      bottomLeft: Radius.circular(3)),
                  color: widget.backgroundColor,
                ),
                child: ScrollablePositionedList.builder(
                    scrollDirection: Axis.horizontal,
                    itemScrollController: _scrollController,
                    itemPositionsListener: _itemPositionsListener,
                    itemCount: widget.datas.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            onChange(index);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: widget.itemPaddingHorizontal!),
                            alignment: Alignment.center,
                            color: _index == index
                                ? widget.selectTextBackgroundColor
                                : Colors.transparent,
                            child: Text(
                              widget.datas[index],
                              style: _index == index
                                  ? (widget.selectTextStyle == null
                                      ? Theme.of(context)
                                          .appBarTheme
                                          .titleTextStyle!
                                          .copyWith(
                                              color: widget.selectTextColor)
                                      : widget.selectTextStyle!.copyWith(
                                          color: widget.selectTextColor))
                                  : (widget.unSelectTextStyle == null
                                      ? Theme.of(context)
                                          .appBarTheme
                                          .titleTextStyle!
                                          .copyWith(
                                              color: widget.unSelectTextColor)
                                      : widget.unSelectTextStyle!.copyWith(
                                          color: widget.unSelectTextColor)),
                            ),
                          ));
                    }),
              ))
        ],
      ),
    );
  }
}

class TabBarPluginController {
  late Function(int) move;

  void _bind(Function(int) onChange) {
    move = onChange;
  }
}
