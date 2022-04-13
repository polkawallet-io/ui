import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PluginPageTitleTaps extends StatelessWidget {
  PluginPageTitleTaps(
      {this.names,
      this.activeTab,
      this.onTap,
      this.isSpaceBetween = false,
      this.itemPadding});

  final List<String>? names;
  final Function(int)? onTap;
  final int? activeTab;
  final bool isSpaceBetween;
  final EdgeInsetsGeometry? itemPadding;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isSpaceBetween
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      children: names!.map(
        (title) {
          int index = names!.indexOf(title);
          return GestureDetector(
            child: Container(
              padding: itemPadding ??
                  EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              margin: EdgeInsets.only(right: isSpaceBetween ? 0 : 26),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(const Radius.circular(6)),
                color:
                    activeTab == index ? Color(0x24FFFFFF) : Colors.transparent,
              ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline3?.copyWith(
                    fontSize: 18,
                    color:
                        activeTab == index ? Colors.white : Color(0x88FFFFFF)),
              ),
            ),
            onTap: () => onTap!(index),
          );
        },
      ).toList(),
    );
  }
}
