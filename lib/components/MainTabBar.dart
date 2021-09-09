import 'package:flutter/material.dart';

class MainTabBar extends StatelessWidget {
  MainTabBar({
    this.tabs,
    this.activeTab,
    this.onTap,
    this.fontSize = 24,
    this.lineWidth = 8,
  });

  final List<String>? tabs;
  final Function(int)? onTap;
  final int? activeTab;
  final double fontSize;
  final double lineWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: tabs!.map((e) {
        final isActive = tabs![activeTab!] == e;
        return GestureDetector(
          child: isActive
              ? Padding(
                  padding: EdgeInsets.only(right: 24),
                  child: Column(
                    children: [
                      Text(e,
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.bold)),
                      Container(
                        width: 24,
                        height: lineWidth,
                        margin: EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(right: 24),
                  child: Column(children: [
                    Text(e, style: TextStyle(fontSize: fontSize - 4)),
                    Container(width: 24, height: 8)
                  ]),
                ),
          onTap: () => onTap!(tabs!.indexOf(e)),
        );
      }).toList(),
    );
  }
}
