import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/plugin/roundedPluginCard.dart';
// import 'package:simple_shadow/simple_shadow.dart';

class PluginItemCard extends StatelessWidget {
  const PluginItemCard(
      {required this.title,
      this.describe,
      this.icon,
      this.margin,
      this.padding = const EdgeInsets.fromLTRB(9, 6, 6, 11),
      Key? key})
      : super(key: key);
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final String title;
  final Widget? icon;
  final String? describe;

  @override
  Widget build(BuildContext context) {
    return RoundedPluginCard(
      padding: this.padding,
      margin: this.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // SimpleShadow(
              //   child:
              Text(
                this.title,
                style: Theme.of(context)
                    .appBarTheme
                    .titleTextStyle
                    ?.copyWith(fontSize: 16, color: Colors.white),
              ),
              //   opacity: 0.7, // Default: 0.5
              //   color: Color(0x80FFFFFF), // Default: Black
              //   offset: Offset(1, 1), // Default: Offset(2, 2)
              //   sigma: 4, // Default: 2
              // ),
              Visibility(
                  visible: this.icon != null,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: this.icon != null ? this.icon : Container(),
                  ))
            ],
          ),
          this.describe != null
              ? Padding(
                  padding: EdgeInsets.only(top: 3, right: 43),
                  child: Text(
                    this.describe!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: 11, color: Colors.white),
                  ))
              : Container(),
        ],
      ),
    );
  }
}
