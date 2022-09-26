import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:rive/rive.dart';

class PluginPopLoadingContainer extends StatelessWidget {
  const PluginPopLoadingContainer(
      {Key? key,
      this.child,
      this.loading = false,
      this.canTap = false,
      this.isDarkTheme = true,
      this.tips})
      : super(key: key);
  final bool loading;
  final Widget? child;
  final String? tips;
  final bool canTap;
  final bool isDarkTheme;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child ?? Container(),
        loading
            ? Container(
                color: canTap ? null : Colors.transparent,
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      flex: 45,
                      child: Container(),
                    ),
                    Align(
                      child: isDarkTheme
                          ? PluginPopLoadingWidget(
                              tips: tips ?? 'Loading...',
                            )
                          : const CupertinoActivityIndicator(
                              color: Color(0xFF3C3C44)),
                    ),
                    Expanded(
                      flex: 55,
                      child: Container(),
                    ),
                  ],
                ),
              )
            : Container()
      ],
    );
  }
}

class PluginPopLoadingWidget extends StatelessWidget {
  const PluginPopLoadingWidget({Key? key, this.tips = 'Loading...'})
      : super(key: key);
  final String tips;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.08)),
        width: 170,
        height: 105,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              height: 58,
              width: 58,
              child: const RiveAnimation.asset(
                'packages/polkawallet_ui/assets/images/connecting.riv',
                fit: BoxFit.none,
              ),
            ),
            Expanded(
              child: Align(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.5),
                  child: Text(
                    tips,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: UI.getTextSize(12, context)),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
