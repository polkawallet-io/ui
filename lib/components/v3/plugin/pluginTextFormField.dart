import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginInputItem.dart';

class PluginTextFormField extends StatelessWidget {
  PluginTextFormField(
      {this.label,
      this.hintText,
      this.inputFormatters,
      this.controller,
      this.padding,
      this.validator});
  final String? label;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? padding;
  final FormFieldValidator<String>? validator;
  @override
  Widget build(BuildContext context) {
    return PluginInputItem(
      label: label,
      child: Container(
        padding: padding,
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.headline5?.copyWith(
                color: Color(0xFFBCBCBC), fontWeight: FontWeight.w300),
          ),
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          inputFormatters: inputFormatters,
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          validator: validator,
        ),
      ),
    );
  }
}
