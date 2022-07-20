import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/plugin/roundedPluginCard.dart';
import 'package:polkawallet_ui/components/v3/roundedCard.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SkaletionRow extends StatelessWidget {
  SkaletionRow(
      {Key? key,
      this.child,
      this.items = 1,
      this.period = const Duration(seconds: 2),
      this.highlightColor = const Color(0xFFC0C0C0),
      this.baseColor = const Color(0xFFE0E0E0),
      this.direction = SkeletonDirection.ltr,
      this.itemMargin,
      this.itemPadding})
      : super(key: key);
  Widget? child;
  final int items;
  final Duration period;
  final Color highlightColor;
  final SkeletonDirection direction;
  final Color baseColor;
  final EdgeInsetsGeometry? itemMargin;
  final EdgeInsetsGeometry? itemPadding;

  @override
  Widget build(BuildContext context) {
    final list = [];
    for (int i = 0; i < items; i++) {
      list.add(i);
    }
    return Row(
      children: [
        ...list
            .map((e) => Expanded(
                child: RoundedCard(
                    margin: itemMargin ?? EdgeInsets.symmetric(horizontal: 3.w),
                    padding: itemPadding ??
                        EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                    child: SkeletonLoader(
                      builder: child ??
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.only(right: 3),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10 / 2))),
                                  ),
                                  Container(
                                      width: 30,
                                      height: 17,
                                      color: Colors.white),
                                ],
                              ),
                              const SizedBox(height: 3.5),
                              Container(
                                  width: 50, height: 15, color: Colors.white),
                            ],
                          ),
                      items: 1,
                      period: period,
                      highlightColor: UI.isDarkTheme(context)
                          ? const Color(0xFF6D6D6D)
                          : highlightColor,
                      baseColor: UI.isDarkTheme(context)
                          ? const Color(0xFF3A3B3D)
                          : baseColor,
                      direction: direction,
                    ))))
            .toList()
      ],
    );
  }
}

class SkaletonList extends StatelessWidget {
  const SkaletonList(
      {Key? key,
      this.child,
      this.items = 1,
      this.period = const Duration(seconds: 2),
      this.highlightColor = const Color(0xFFC0C0C0),
      this.baseColor = const Color(0xFFE0E0E0),
      this.direction = SkeletonDirection.ltr,
      this.itemMargin,
      this.itemPadding,
      this.padding,
      this.physics,
      this.shrinkWrap = false,
      this.isPlugin = false})
      : super(key: key);

  final Widget? child;
  final int items;
  final Duration period;
  final Color highlightColor;
  final SkeletonDirection direction;
  final Color baseColor;
  final EdgeInsetsGeometry? itemMargin;
  final EdgeInsetsGeometry? itemPadding;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool isPlugin;

  @override
  Widget build(BuildContext context) {
    final childWidget = SkeletonLoader(
      builder: child ??
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: <Widget>[
                const CircleAvatar(
                  radius: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 10,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      items: 1,
      period: period,
      highlightColor: highlightColor,
      baseColor: baseColor,
      direction: direction,
    );

    final card = !isPlugin
        ? RoundedCard(
            margin: itemMargin ?? const EdgeInsets.only(bottom: 16),
            padding: itemPadding,
            child: childWidget)
        : RoundedPluginCard(
            margin: itemMargin ?? const EdgeInsets.only(bottom: 16),
            padding: itemPadding,
            child: childWidget);

    return ListView.builder(
        shrinkWrap: shrinkWrap,
        physics: physics,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemCount: items,
        itemBuilder: (BuildContext context, int index) {
          return card;
        });
  }
}
