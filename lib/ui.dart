library polkawallet_ui;

import 'package:flutter/material.dart';

class PageWrapperWithBackground extends StatelessWidget {
  PageWrapperWithBackground(this.child, {this.height, this.backgroundImage});

  final double height;
  final AssetImage backgroundImage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      // fit: StackFit.expand,
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        // Container(
        //   width: double.infinity,
        //   height: double.infinity,
        //   color: Theme.of(context).canvasColor,
        // ),
        Container(
          width: width,
          height: height ?? 180,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColorDark
            ],
            stops: [0.6, 0.9],
          )),
        ),
        Container(
          width: width,
          height: height ?? 180,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
