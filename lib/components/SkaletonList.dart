import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/roundedCard.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class SkaletonList extends StatelessWidget {
  SkaletonList(
      {Key? key,
      this.child,
      this.items = 1,
      this.period = const Duration(seconds: 2),
      this.highlightColor = const Color(0xFFC0C0C0),
      this.baseColor = const Color(0xFFE0E0E0),
      this.direction = SkeletonDirection.ltr,
      this.showDecoration = true})
      : super(key: key);

  Widget? child;
  final int items;
  final Duration period;
  final Color highlightColor;
  final SkeletonDirection direction;
  final Color baseColor;
  final bool showDecoration;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemCount: items,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              margin: EdgeInsets.only(bottom: 16),
              child: RoundedCard(
                  child: SkeletonLoader(
                builder: child ??
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: 10,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
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
              )));
        });
    // return Container(
    //     margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //     decoration: !showDecoration
    //         ? null
    //         : BoxDecoration(
    //             borderRadius: const BorderRadius.all(const Radius.circular(16)),
    //             color: Theme.of(context).cardColor,
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.black12,
    //                 blurRadius: 16.0, // has the effect of softening the shadow
    //                 spreadRadius: 4.0, // has the effect of extending the shadow
    //                 offset: Offset(
    //                   2.0, // horizontal, move right 10
    //                   2.0, // vertical, move down 10
    //                 ),
    //               )
    //             ],
    //           ),
    //     child: SkeletonLoader(
    //       builder: child ??
    //           Container(
    //             // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),

    //             child: Row(
    //               children: <Widget>[
    //                 CircleAvatar(
    //                   radius: 30,
    //                 ),
    //                 SizedBox(width: 10),
    //                 Expanded(
    //                   child: Column(
    //                     children: <Widget>[
    //                       Container(
    //                         width: double.infinity,
    //                         height: 10,
    //                         color: Colors.white,
    //                       ),
    //                       SizedBox(height: 10),
    //                       Container(
    //                         width: double.infinity,
    //                         height: 12,
    //                         color: Colors.white,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //       items: items,
    //       period: period,
    //       highlightColor: highlightColor,
    //       baseColor: baseColor,
    //       direction: direction,
    //     ));
  }
}
