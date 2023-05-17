import 'package:flutter/material.dart';

class UniSwapTokenIcon extends StatelessWidget {
  const UniSwapTokenIcon({Key? key, required this.contractAddress})
      : super(key: key);
  final String contractAddress;
  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: const AssetImage(
          'packages/polkawallet_ui/assets/images/dapp_icon_failure.png'),
      image: NetworkImage(
          'https://raw.githubusercontent.com/Uniswap/assets/master/blockchains/ethereum/assets/$contractAddress/logo.png'),
      fit: BoxFit.cover,
    );
  }
}
