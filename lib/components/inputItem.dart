import 'package:flutter/material.dart';

class InputItem extends StatefulWidget {
  Color? color;
  final double borderWidth;
  EdgeInsetsGeometry? padding;
  TextAlign textAlign;
  TextInputType textInputType;
  Function(String) onChanged;
  String hintText;
  TextStyle style;
  TextStyle hintStyle;
  TextEditingController? controller;
  InputItem(
      {required this.onChanged,
      required this.hintText,
      required this.style,
      required this.hintStyle,
      this.color,
      this.borderWidth = 0.5,
      this.padding,
      this.textAlign = TextAlign.start,
      this.textInputType = TextInputType.text,
      this.controller,
      Key? key})
      : super(key: key);

  @override
  createState() => _InputItemState();
}

class _InputItemState extends State<InputItem> {
  @override
  void initState() {
    super.initState();
    setState(() {
      widget.controller = widget.controller ?? TextEditingController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
            color: widget.color ?? Theme.of(context).disabledColor,
            width: widget.borderWidth),
      ),
      padding: widget.padding ?? const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                  controller: widget.controller,
                  textAlign: widget.textAlign,
                  keyboardType: widget.textInputType,
                  onChanged: widget.onChanged,
                  style: widget.style,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    hintStyle: widget.hintStyle,
                  ))),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(2),
              child: Icon(
                Icons.cancel,
                size: 20,
                color: widget.color ?? Theme.of(context).unselectedWidgetColor,
              ),
            ),
            onTap: () {
              setState(() {
                widget.controller!.text = "";
              });
            },
          )
        ],
      ),
    );
  }
}
