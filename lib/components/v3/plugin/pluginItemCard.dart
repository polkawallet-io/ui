import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/plugin/roundedPluginCard.dart';
import 'package:simple_shadow/simple_shadow.dart';

class PluginItemCard extends StatelessWidget {
  const PluginItemCard(
      {required this.title,
      required this.describe,
      this.icon,
      this.margin,
      this.padding = const EdgeInsets.fromLTRB(9, 6, 6, 11),
      Key? key})
      : super(key: key);
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final String title;
  final String? icon;
  final String describe;

  @override
  Widget build(BuildContext context) {
    return RoundedPluginCard(
      padding: this.padding,
      margin: this.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SimpleShadow(
                child: Text(
                  this.title,
                  style: Theme.of(context)
                      .appBarTheme
                      .titleTextStyle
                      ?.copyWith(fontSize: 16, color: Colors.white),
                ),
                opacity: 0.7, // Default: 0.5
                color: Color(0x80FFFFFF), // Default: Black
                offset: Offset(1, 1), // Default: Offset(2, 2)
                sigma: 4, // Default: 2
              ),
              Visibility(
                  visible: this.icon != null,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Container(
                        width: 18,
                        height: 18,
                        padding: EdgeInsets.all(2),
                        child: this.icon != null
                            ? Image.asset(this.icon!)
                            : Container(),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(const Radius.circular(5)),
                          color: Color(0xFFFF8E66),
                        )),
                  ))
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: 3),
              child: Text(
                this.describe,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(fontSize: 11, color: Colors.white),
              )),
        ],
      ),
    );
  }
}
