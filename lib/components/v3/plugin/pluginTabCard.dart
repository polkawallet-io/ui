import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTextTag.dart';

class PluginTabCard extends StatefulWidget {
  PluginTabCard(this.datas, this.onChange, this.initIndex,
      {Key? key, this.margin})
      : super(key: key);
  List<String> datas;
  int initIndex = 0;
  Function(int) onChange;
  EdgeInsetsGeometry? margin;

  @override
  State<PluginTabCard> createState() => _PluginTabCardState();
}

class _PluginTabCardState extends State<PluginTabCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 28,
        margin: widget.margin,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (widget.initIndex != index) {
                  widget.onChange(index);
                }
              },
              child: PluginTextTag(
                margin: EdgeInsets.only(right: 3),
                padding: EdgeInsets.zero,
                title: widget.datas[index],
                style: Theme.of(context).textTheme.headline4?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212123),
                    fontSize: widget.initIndex == index ? 16 : 14),
                height: widget.initIndex == index ? 28 : 25,
                backgroundColor: widget.initIndex == index
                    ? Color(0xCCFFFFFF)
                    : Color(0x80FFFFFF),
              ),
            );
          },
          itemCount: widget.datas.length,
        ));
  }
}
