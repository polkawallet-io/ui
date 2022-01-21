import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PluginPageTitleTaps extends StatelessWidget {
  PluginPageTitleTaps({this.names, this.activeTab, this.onTap});

  final List<String>? names;
  final Function(int)? onTap;
  final int? activeTab;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: names!.map(
        (title) {
          int index = names!.indexOf(title);
          return GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
