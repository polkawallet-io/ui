import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class PluginFilterWidget extends StatefulWidget {
  static const String pluginAllFilter = 'All';
  const PluginFilterWidget(
      {Key? key, required this.options, required this.filter})
      : super(key: key);
  final List<String> options;
  final Function(String) filter;
  @override
  State<PluginFilterWidget> createState() => _PluginFilterWidgetState();
}

class _PluginFilterWidgetState extends State<PluginFilterWidget> {
  bool showOptions = false;
  String currentString = PluginFilterWidget.pluginAllFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        currentString = widget.options.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common');
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    showOptions = !showOptions;
                  });
                },
                child: Container(
                  width: 72,
                  height: 26,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: showOptions
                          ? const Color(0xFFFF7849)
                          : const Color(0xFFFFFFFF).withOpacity(0.14)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        dic!['filter']!,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: showOptions
                                ? FontWeight.w600
                                : FontWeight.normal,
                            fontFamily: 'Titillium Web Regular',
                            color: showOptions
                                ? const Color(0xFF212224)
                                : const Color(0xFFFFFFFF)),
                      ),
                      Icon(
                        showOptions
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 16,
                        color: showOptions
                            ? const Color(0xFF212224)
                            : const Color(0xFFFFFFFF),
                      )
                    ],
                  ),
                )),
          ),
          Visibility(
              visible: showOptions,
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 16),
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    runAlignment: WrapAlignment.start,
                    runSpacing: 10,
                    children: widget.options
                        .map((e) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentString = e;
                                  widget.filter(e);
                                });
                              },
                              child: Container(
                                  height: 22,
                                  constraints:
                                      const BoxConstraints(minWidth: 64),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: currentString == e
                                          ? const Color(0xFFFF7849)
                                          : const Color(0xFFFFFFFF)
                                              .withOpacity(0.14),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        e,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily:
                                                'Titillium Web SemiBold',
                                            fontWeight: FontWeight.w600,
                                            color: currentString == e
                                                ? const Color(0xFF212224)
                                                : const Color(0xFFFFFFFF)),
                                      )
                                    ],
                                  )),
                            ))
                        .toList(),
                  )))
        ],
      ),
    );
  }
}
