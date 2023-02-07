import 'package:flutter/material.dart';
import 'package:polkawallet_ui/utils/index.dart';

class GovExternalLinks extends StatelessWidget {
  const GovExternalLinks(this.links, {Key? key}) : super(key: key);

  final List? links;

  Widget buildItem(dynamic data, BuildContext context) {
    final name = (data['name'] as String).contains('Polkassembly')
        ? 'Polkassembly'
        : data['name'];
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          UI.launchURL(data['link']);
        },
        child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Color.fromARGB(255, 84, 85, 86),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                      "packages/polkawallet_ui/assets/images/external/$name.png",
                      height: 28),
                ),
                Text(
                  name,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.white,
                      fontSize: UI.getTextSize(10, context),
                      fontWeight: FontWeight.w300),
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    final list = (links ?? []).toList();
    if (list.indexWhere((e) => e['name'] == 'PolkassemblyNetwork') > -1) {
      list.removeWhere((e) => e['name'] == 'Polkassembly');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: (links ?? []).map((e) => buildItem(e, context)).toList(),
    );
  }
}
