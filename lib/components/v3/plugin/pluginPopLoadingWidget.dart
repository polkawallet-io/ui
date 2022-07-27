import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/index.dart';
import 'package:rive/rive.dart';

class PluginPopLoadingContainer extends StatelessWidget {
  const PluginPopLoadingContainer(
      {Key? key, required this.child, this.loading = false, this.tips})
      : super(key: key);
  final bool loading;
  final Widget child;
  final String? tips;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        loading
            ? Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
                child: Align(
                  child: PluginPopLoadingWidget(
                    tips: tips ?? 'Connecting...',
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}

class PluginPopLoadingWidget extends StatelessWidget {
  const PluginPopLoadingWidget({Key? key, this.tips = 'Connecting...'})
      : super(key: key);
  final String tips;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.08)),
        height: 104,
        width: 168,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 6),
              height: 58,
              width: 58,
              child: const RiveAnimation.asset(
                'packages/polkawallet_ui/assets/images/connecting.riv',
                fit: BoxFit.none,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: SizedBox(
                height: 19,
                child: Align(
                  child: Text(
                    tips,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: UI.getTextSize(12, context)),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
