import 'package:flutter/material.dart';

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
          padding:
              EdgeInsets.symmetric(horizontal: getPaddingHorizontal(this.type)),
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage(getBgImage(this.type)),
            ),
          ),
          child: Image.asset(
            getIconImage(this.type),
            fit: BoxFit.contain,
          )),
    );
  }

  double getPaddingHorizontal(TransferIconType type) {
    switch (type) {
      case TransferIconType.rollOut:
        return 9;
      case TransferIconType.fine:
        return 7;
      case TransferIconType.earn:
        return 7;
      case TransferIconType.rollIn:
        return 7;
      case TransferIconType.failure:
        return 7;
    }
  }

  String getBgImage(TransferIconType type) {
    switch (type) {
      case TransferIconType.rollOut:
        return "packages/polkawallet_ui/assets/images/transfer_icon_blue_bg.png";
      case TransferIconType.fine:
        return "packages/polkawallet_ui/assets/images/transfer_icon_red_bg.png";
      case TransferIconType.earn:
        return "packages/polkawallet_ui/assets/images/transfer_icon_yellow_bg.png";
      case TransferIconType.rollIn:
        return "packages/polkawallet_ui/assets/images/transfer_icon_green_bg.png";
      case TransferIconType.failure:
        return "packages/polkawallet_ui/assets/images/transfer_icon_gray_bg.png";
    }
  }

  String getIconImage(TransferIconType type) {
    switch (type) {
      case TransferIconType.rollOut:
        return "packages/polkawallet_ui/assets/images/transfer_icon_out.png";
      case TransferIconType.fine:
        return "packages/polkawallet_ui/assets/images/transfer_icon_err.png";
      case TransferIconType.earn:
        return "packages/polkawallet_ui/assets/images/transfer_icon_earn.png";
      case TransferIconType.rollIn:
        return "packages/polkawallet_ui/assets/images/transfer_icon_in.png";
      case TransferIconType.failure:
        return "packages/polkawallet_ui/assets/images/transfer_icon_failure.png";
    }
  }
}
