import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/roundedCard.dart';

class EntryPageCard extends StatelessWidget {
  EntryPageCard(this.title, this.brief, this.icon, {this.color});

  final Widget icon;
  final String title;
  final String brief;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: color ?? Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(8),
                  bottomLeft: const Radius.circular(8)),
            ),
            child: Center(child: icon),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 8),
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  brief,
                  style: Theme.of(context).textTheme.headline6,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
