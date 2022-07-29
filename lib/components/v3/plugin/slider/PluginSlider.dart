import 'package:flutter/material.dart';
import 'package:polkawallet_ui/components/v3/plugin/slider/PluginSliderOverlayShape.dart';
import 'package:polkawallet_ui/components/v3/plugin/slider/PluginSliderThumbShape.dart';
import 'package:polkawallet_ui/components/v3/plugin/slider/PluginSliderTickMarkShape.dart';
import 'package:polkawallet_ui/components/v3/plugin/slider/PluginSliderTrackShape.dart';
import 'package:polkawallet_ui/utils/consts.dart';
import 'package:polkawallet_ui/utils/index.dart';

class PluginSlider extends StatefulWidget {
  PluginSlider(
      {Key? key,
      required this.value,
      this.label,
      this.divisions,
      this.max = 1.0,
      this.min = 0.0,
      this.enabled = true,
      this.onChanged})
      : super(key: key);

  final bool enabled;
  Function(double)? onChanged;
  String? label;
  double value;
  int? divisions;
  double max;
  double min;

  @override
  State<PluginSlider> createState() => _PluginSliderState();
}

class _PluginSliderState extends State<PluginSlider> {
  @override
  Widget build(BuildContext context) {
    return SliderTheme(
        data: SliderThemeData(
            trackHeight: 11,
            activeTrackColor: PluginColorsDark.green,
            disabledActiveTrackColor: PluginColorsDark.primary,
            inactiveTrackColor: const Color(0x4DFFFFFF),
            disabledInactiveTrackColor: const Color(0x4DFFFFFF),
            overlayColor: Colors.transparent,
            trackShape: const PluginSliderTrackShape(),
            thumbShape: PluginSliderThumbShape(isShow: widget.enabled),
            tickMarkShape: const PluginSliderTickMarkShape(),
            overlayShape: const PluginSliderOverlayShape(),
            valueIndicatorColor: const Color(0xFF7D7D7D),
            valueIndicatorTextStyle: Theme.of(context)
                .textTheme
                .headline3
                ?.copyWith(
                    color: PluginColorsDark.headline1,
                    fontSize: UI.getTextSize(14, context))),
        child: Slider(
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          value: widget.value,
          label: widget.label,
          activeColor: widget.enabled ? null : PluginColorsDark.headline2,
          inactiveColor: widget.enabled ? null : PluginColorsDark.headline2,
          onChanged: widget.enabled ? widget.onChanged : null,
        ));
  }
}
