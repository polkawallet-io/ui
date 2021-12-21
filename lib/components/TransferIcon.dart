import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

enum TransferIconType { rollIn, rollOut, fine, earn, failure }

class TransferIcon extends StatelessWidget {
  TransferIcon({Key? key, this.size = 32, this.type = TransferIconType.rollIn})
      : super(key: key);
  final double size;
  final TransferIconType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.size,
      height: this.size,
      child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
              color: Color(0xFFE9E9E9),
              borderRadius: BorderRadius.all(Radius.circular(8.r))),
          child: SvgPicture.asset(
            getIconImage(type),
            color: getIconColor(type, context),
          )),
    );
  }

  Color getIconColor(TransferIconType type, BuildContext context) {
    switch (type) {
      case TransferIconType.rollOut:
        return Theme.of(context).toggleableActiveColor;
      case TransferIconType.fine:
        return Color(0xFFCE623C);
      case TransferIconType.earn:
        return Color(0xFFD7BC75);
      case TransferIconType.rollIn:
        return Color(0xFF7AC074);
      default:
        return Colors.white;
    }
  }

  String getIconImage(TransferIconType type) {
    switch (type) {
      case TransferIconType.rollOut:
        return "packages/polkawallet_ui/assets/images/transfer_icon_out.svg";
      case TransferIconType.fine:
        return "packages/polkawallet_ui/assets/images/transfer_icon_err.svg";
      case TransferIconType.earn:
        return "packages/polkawallet_ui/assets/images/transfer_icon_earn.svg";
      case TransferIconType.rollIn:
        return "packages/polkawallet_ui/assets/images/transfer_icon_in.svg";
      case TransferIconType.failure:
        return "packages/polkawallet_ui/assets/images/transfer_icon_failure.svg";
    }
  }
}
