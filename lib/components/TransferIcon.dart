import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

enum TransferIconType {
  rollIn,
  rollOut,
  fine,
  earn,
  failure,
  redeem,
  mint,
  deposit,
  payback,
  withdraw,
  swap,
  add_liquidity,
  remove_liquidity,
  add_provision,
  stake,
  unstake,
  claim_rewards
}

class TransferIcon extends StatelessWidget {
  TransferIcon(
      {Key? key,
      this.size = 32,
      this.type = TransferIconType.rollIn,
      this.bgColor = const Color(0xFFE9E9E9),
      this.iconColor})
      : super(key: key);
  final double size;
  final TransferIconType type;
  final Color bgColor;
  final Color? iconColor;

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
              color: bgColor,
              borderRadius: BorderRadius.all(Radius.circular(8.r))),
          child: SvgPicture.asset(
            getIconImage(type),
            color: iconColor ?? getIconColor(type, context),
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
      case TransferIconType.failure:
        return Color(0xFF979797);
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
      case TransferIconType.redeem:
        return "packages/polkawallet_ui/assets/images/redeem.svg";
      case TransferIconType.mint:
        return "packages/polkawallet_ui/assets/images/mint.svg";
      case TransferIconType.withdraw:
        return "packages/polkawallet_ui/assets/images/withdraw.svg";
      case TransferIconType.deposit:
        return "packages/polkawallet_ui/assets/images/deposit.svg";
      case TransferIconType.payback:
        return "packages/polkawallet_ui/assets/images/payback.svg";
      case TransferIconType.swap:
        return "packages/polkawallet_ui/assets/images/swap.svg";
      case TransferIconType.add_liquidity:
        return "packages/polkawallet_ui/assets/images/add_liquidity.svg";
      case TransferIconType.remove_liquidity:
        return "packages/polkawallet_ui/assets/images/remove_liquidity.svg";
      case TransferIconType.add_provision:
        return "packages/polkawallet_ui/assets/images/add_provision.svg";
      case TransferIconType.stake:
        return "packages/polkawallet_ui/assets/images/stake.svg";
      case TransferIconType.unstake:
        return "packages/polkawallet_ui/assets/images/unstake.svg";
      case TransferIconType.claim_rewards:
        return "packages/polkawallet_ui/assets/images/reward.svg";
    }
  }
}
