import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/api/types/walletConnect/pairingData.dart';
import 'package:polkawallet_sdk/api/types/walletConnect/payloadData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/roundedCard.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class EthSignRequestInfo extends StatelessWidget {
  const EthSignRequestInfo(this.callRequest,
      {Key? key, this.peer, required this.originUri})
      : super(key: key);
  final WCCallRequestData callRequest;
  final WCProposerMeta? peer;
  final Uri originUri;
  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    List<WCCallRequestParamItem> params = callRequest.params!;
    if (callRequest.params![0].value == 'eth_sendTransaction') {
      params = [
        ...callRequest.params!.sublist(0, 3),
        ...callRequest.params!.sublist(5)
      ];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            dic['dApp.src']!,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        peer != null
            ? WCPairingSourceInfo(peer!)
            : RoundedCard(
                child: ListTile(
                  title: Text(originUri.host),
                  subtitle: Text(originUri.toString()),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 16),
          child: Text(
            dic['dApp.data']!,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Column(
            children: params.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: SignInfoItemRow(e.label!, e.value.toString()),
          );
        }).toList())
      ],
    );
  }
}

class WCPairingSourceInfo extends StatelessWidget {
  const WCPairingSourceInfo(this.metadata, {this.trailing, Key? key})
      : super(key: key);
  final WCProposerMeta metadata;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      child: ListTile(
        dense: true,
        leading: Image.network(metadata.icons![0], width: 40),
        title: Text(metadata.name ?? ''),
        subtitle: Text(metadata.url ?? ''),
        trailing: trailing,
      ),
    );
  }
}

class SignInfoItemRow extends StatelessWidget {
  const SignInfoItemRow(this.label, this.content, {Key? key}) : super(key: key);
  final String label;
  final String content;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(bottom: 6),
          child: Text(
            content,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w300),
          ),
        ))
      ],
    );
  }
}
