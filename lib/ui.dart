library ui;

import 'package:flutter/material.dart';

class PageWrapperWithBackground extends StatelessWidget {
  PageWrapperWithBackground(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 180,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).canvasColor
            ],
            stops: [0.4, 0.9],
          )),
        ),
        child,
      ],
    );
  }
}
