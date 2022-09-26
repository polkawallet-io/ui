import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginInputItem.dart';
import 'package:polkawallet_ui/utils/consts.dart';

class PluginTextFormField extends StatelessWidget {
  const PluginTextFormField(
      {Key? key,
      this.label,
      this.hintText,
      this.inputFormatters,
      this.controller,
      this.padding,
      this.validator,
      this.focusNode,
      this.onChanged,
      this.suffix,
      this.keyboardType,
      this.autovalidateMode})
      : super(key: key);
  final String? label;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? padding;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  @override
  Widget build(BuildContext context) {
    return PluginInputItem(
      label: label,
      bgColor: (focusNode?.hasFocus ?? false)
          ? Color(0x3DFFFFFF)
          : Color(0x1AFFFFFF),
      child: Container(
        padding: padding,
        child: TextFormField(
          decoration: InputDecoration(
            isCollapsed: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 8, top: 16, right: 8),
            suffixIcon: suffix,
            hintText: hintText,
            hintStyle: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: Colors.white.withAlpha(120)),
            errorStyle: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: PluginColorsDark.primary, height: 0.8),
          ),
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
          inputFormatters: inputFormatters,
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          focusNode: focusNode,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
        ),
      ),
    );
  }
}
