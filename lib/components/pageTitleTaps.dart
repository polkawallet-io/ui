import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/index.dart';

class PageTitleTabs extends StatelessWidget {
  const PageTitleTabs({Key? key, this.names, this.activeTab, this.onTab})
      : super(key: key);

  final List<String>? names;
  final Function(int)? onTab;
  final int? activeTab;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: names!.map(
        (title) {
          int index = names!.indexOf(title);
          return GestureDetector(
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontSize: UI.getTextSize(20, context),
                      color: activeTab == index
                          ? Theme.of(context).cardColor
                          : Colors.white70,
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  height: 12,
                  width: 32,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: activeTab == index ? 3 : 0,
                            color: Colors.white)),
                  ),
                )
              ],
            ),
            onTap: () => onTab!(index),
          );
        },
      ).toList(),
    );
  }
}
