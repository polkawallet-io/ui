import 'package:flutter/material.dart';

class MainTabBar extends StatelessWidget {
  MainTabBar({
    this.tabs = const [],
    this.activeTab,
    this.onTap,
  });

  final List<String> tabs;
  final Function(int)? onTap;
  final int? activeTab;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: tabs.map((e) {
        final index = tabs.indexOf(e);
        return Expanded(
          child: GestureDetector(
            child: Container(
              alignment: Alignment.center,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                    image: AssetImage(
                        "packages/polkawallet_ui/assets/images/tab_bg_${index == 0 ? 'l' : 'r'}_${index == activeTab ? 'blue' : 'grey'}.png"),
                    fit: BoxFit.fill),
              ),
              child: Text(
                e,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'TitilliumWeb',
                  color: activeTab == index
                      ? Colors.white
                      : Theme.of(context).unselectedWidgetColor,
                ),
              ),
            ),
            onTap: () => onTap!(index),
          ),
        );
      }).toList(),
    );
  }
}
