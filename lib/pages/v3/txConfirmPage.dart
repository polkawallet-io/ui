import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/offlineSignatureInvalidWarn.dart';
import 'package:polkawallet_ui/components/tapTooltip.dart';
import 'package:polkawallet_ui/components/txButton.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/components/v3/button.dart';
import 'package:polkawallet_ui/components/v3/collapsedContainer.dart';
import 'package:polkawallet_ui/components/v3/dialog.dart';
import 'package:polkawallet_ui/components/v3/innerShadow.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginButton.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginIconButton.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginScaffold.dart';
import 'package:polkawallet_ui/components/v3/plugin/roundedPluginCard.dart';
import 'package:polkawallet_ui/components/v3/plugin/slider/PluginSlider.dart';
import 'package:polkawallet_ui/components/v3/sliderThumbShape.dart';
import 'package:polkawallet_ui/utils/consts.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

class TxConfirmPage extends StatefulWidget {
  const TxConfirmPage(this.plugin, this.keyring, this.getPassword,
      {this.txDisabledCalls});
  final PolkawalletPlugin plugin;
  final Keyring keyring;
  final Future<Map<dynamic, dynamic>>? txDisabledCalls;
  final Future<String> Function(BuildContext, KeyPairData) getPassword;

  static const String route = '/tx/confirm';

  @override
  _TxConfirmPageState createState() => _TxConfirmPageState();
}

class _TxConfirmPageState extends State<TxConfirmPage> {
  bool _submitting = false;

  TxFeeEstimateResult? _fee;
  double _tip = 0;
  BigInt _tipValue = BigInt.zero;
  KeyPairData? _proxyAccount;

  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    load('packages/polkawallet_ui/assets/images/slider_thumb.png').then((i) {
      setState(() {
        _image = i;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTxFee();
    });
  }

  Future<ui.Image> load(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.ImmutableBuffer.fromUint8List(data.buffer.asUint8List());
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 39, targetHeight: 24);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  Future<String> _getTxFee() async {
    final TxConfirmParams args =
        ModalRoute.of(context)!.settings.arguments as TxConfirmParams;
    final sender = TxSenderData(
        widget.keyring.current.address, widget.keyring.current.pubKey);
    final txInfo = TxInfoData(args.module, args.call, sender,
        txName: args.txName, txHex: args.txHex);

    final fee = await widget.plugin.sdk.api.tx
        .estimateFees(txInfo, args.params!, rawParam: args.rawParams);
    if (mounted) {
      setState(() {
        _fee = fee;
      });
    }
    return fee.partialFee.toString();
  }

  void _onTxFinish(BuildContext context, Map? res, String? errorMsg) async {
    if (res != null) {
      print('callback triggered, blockHash: ${res['hash']}');
    }
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (mounted) {
      await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return PolkawalletAlertDialog(
            type: errorMsg != null ? DialogType.warn : DialogType.ok,
            title: Text(errorMsg ??
                I18n.of(context)!
                    .getDic(i18n_full_dic_ui, 'common')!['success']!),
            actions: <Widget>[
              PolkawalletActionSheetAction(
                child: Text(I18n.of(context)!
                    .getDic(i18n_full_dic_ui, 'common')!['ok']!),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      Navigator.of(context).pop(res);
    }
  }

  Future<void> _showPasswordDialog(BuildContext context) async {
    final TxConfirmParams args =
        ModalRoute.of(context)!.settings.arguments as TxConfirmParams;

    if ((await widget.txDisabledCalls) != null) {
      List moduleCalls = (await widget.txDisabledCalls)![args.module] ?? [];
      if (_checkCallDisabled(moduleCalls)) {
        return;
      }
    }

    final password = await widget.getPassword(
        context, _proxyAccount ?? widget.keyring.current);
    if (password != null) {
      _onSubmit(context, password: password);
    }
  }

  Future<void> _onSubmit(
    BuildContext context, {
    String? password,
    bool viaQr = false,
  }) async {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    final TxConfirmParams args =
        ModalRoute.of(context)!.settings.arguments as TxConfirmParams;

    if (viaQr && (await widget.txDisabledCalls) != null) {
      List moduleCalls = (await widget.txDisabledCalls)![args.module] ?? [];
      if (_checkCallDisabled(moduleCalls)) {
        return;
      }
    }

    setState(() {
      _submitting = true;
    });
    _updateTxStatus(context, dic['tx.wait']!);

    final TxSenderData sender = TxSenderData(
      widget.keyring.current.address,
      widget.keyring.current.pubKey,
    );
    final TxInfoData txInfo = TxInfoData(
      args.module,
      args.call,
      sender,
      proxy: _proxyAccount != null
          ? TxSenderData(_proxyAccount!.address, _proxyAccount!.pubKey)
          : null,
      tip: _tipValue.toString(),
      txName: args.txName,
      txHex: args.txHex,
    );

    try {
      final res = await _sendTx(context, txInfo, args, password!);
      _onTxFinish(context, res, null);
    } catch (err) {
      _onTxFinish(context, null, err.toString());
    }
    if (mounted) {
      setState(() {
        _submitting = false;
      });
    }
  }

  bool _checkCallDisabled(List disabledCalls) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    final TxConfirmParams args =
        ModalRoute.of(context)!.settings.arguments as TxConfirmParams;
    if (disabledCalls.contains(args.call)) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return PolkawalletAlertDialog(
            title: Text(dic['note']!),
            content: Text(
                "<${args.module}.${args.call}> ${dic['tx.disabledCall']!}"),
            actions: <Widget>[
              PolkawalletActionSheetAction(
                child: Text(
                  dic['cancel']!,
                  style: TextStyle(
                    color: Theme.of(context).unselectedWidgetColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return true;
    }
    return false;
  }

  Future<Map> _sendTx(
    BuildContext context,
    TxInfoData txInfo,
    TxConfirmParams args,
    String password,
  ) async {
    return widget.plugin.sdk.api.tx.signAndSend(txInfo, args.params!, password,
        rawParam: args.rawParams, onStatusChange: (status) {
      if (mounted) {
        final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
        _updateTxStatus(context, dic['tx.$status'] ?? status);
      }
    });
  }

  void _updateTxStatus(BuildContext context, String status) {
    final TxConfirmParams args =
        ModalRoute.of(context)!.settings.arguments as TxConfirmParams;
    if (args.onStatusChange != null) {
      args.onStatusChange!(status);
    }
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: args.isPlugin
            ? const Color(0xFF202020)
            : Theme.of(context).cardColor,
        content: ListTile(
          leading: const CupertinoActivityIndicator(),
          title: Text(
            status,
            style: TextStyle(
                color: args.isPlugin
                    ? PluginColorsDark.headline1
                    : Theme.of(context).textTheme.headline1?.color),
          ),
        ),
        duration: const Duration(minutes: 5),
      ));
    }
  }

  void _onTipChanged(double tip) {
    final decimals = (widget.plugin.networkState.tokenDecimals ?? [12])[0];

    /// tip division from 0 to 19:
    /// 0-10 for 0-0.1
    /// 10-19 for 0.1-1
    BigInt value = Fmt.tokenInt('0.01', decimals) * BigInt.from(tip.toInt());
    if (tip > 10) {
      value = Fmt.tokenInt('0.1', decimals) * BigInt.from((tip - 9).toInt());
    }
    setState(() {
      _tip = tip;
      _tipValue = value;
    });
  }

  dynamic _updateKUSD(String value) {
    value = value.replaceAll("KUSD", "AUSD");
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    final dicAcc = I18n.of(context)!.getDic(i18n_full_dic_ui, 'account')!;

    final isNetworkConnected = widget.plugin.sdk.api.connectedNode != null;
    // const isNetworkMatch = true;
    final isNetworkMatch = widget.plugin.networkState.genesisHash ==
        widget.plugin.basic.genesisHash;

    final String symbol = (widget.plugin.networkState.tokenSymbol ?? [''])[0];
    final int decimals = (widget.plugin.networkState.tokenDecimals ?? [12])[0];

    final TxConfirmParams args =
        ModalRoute.of(context)!.settings.arguments as TxConfirmParams;

    final bool isObservation = widget.keyring.current.observation ?? false;
    final bool isProxyObservation =
        _proxyAccount != null ? _proxyAccount!.observation ?? false : false;

    bool isUnsigned = args.isUnsigned ?? false;

    final itemContentStyle = TextStyle(
        fontFamily: UI.getFontFamily('TitilliumWeb', context),
        color: args.isPlugin
            ? Colors.white
            : Theme.of(context).unselectedWidgetColor);
    if (args.isPlugin) {
      return WillPopScope(
        child: PluginScaffold(
          appBar: PluginAppBar(
            title: Text(args.txTitle!),
            centerTitle: true,
            leading: PluginIconButton(
                icon: Image.asset(
                  "packages/polkawallet_ui/assets/images/icon_back_plugin.png",
                  width: 9,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  Navigator.of(context).pop();
                }),
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    children: <Widget>[
                      Column(
                        children: [
                          RoundedPluginCard(
                            color: const Color(0x24FFFFFF),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 24),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...args.txDisplayBold.keys.map((key) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _ConfirmItemLabel(
                                          text: key, isPlugin: true),
                                      args.txDisplayBold[key] ?? Container(),
                                    ],
                                  );
                                }).toList(),
                                ...args.txDisplay.keys.map((key) {
                                  final content =
                                      args.txDisplay[key].runtimeType == String
                                          ? args.txDisplay[key]
                                          : jsonEncode(args.txDisplay[key]);
                                  return Row(
                                    children: [
                                      _ConfirmItemLabel(
                                          text: key, isPlugin: true),
                                      Expanded(
                                          child: Text(
                                        _updateKUSD(content),
                                        style: itemContentStyle,
                                      )),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                          RoundedPluginCard(
                            color: const Color(0x24FFFFFF),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                isUnsigned
                                    ? Container()
                                    : Row(
                                        children: [
                                          Expanded(
                                              child: _ConfirmItemLabel(
                                            text: dic["tx.from"] ?? '',
                                            isPlugin: true,
                                          )),
                                          AddressIcon(
                                            widget.keyring.current.address,
                                            svg: widget.keyring.current.icon,
                                            size: 24,
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                              Fmt.address(
                                                  widget
                                                      .keyring.current.address,
                                                  pad: 8),
                                              style: itemContentStyle,
                                            ),
                                          )
                                        ],
                                      ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: _ConfirmItemLabel(
                                      text: dic["tx.network"] ?? '',
                                      isPlugin: true,
                                    )),
                                    Visibility(
                                        visible: isNetworkConnected,
                                        child: Container(
                                            height: 44,
                                            width: 24,
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            child: widget.plugin.basic.icon)),
                                    !isNetworkConnected
                                        ? Text(
                                            dic['tx.network.no']!,
                                            style: itemContentStyle,
                                          )
                                        : Text(
                                            widget.plugin.basic.name!,
                                            style: itemContentStyle,
                                          )
                                  ],
                                ),
                                Visibility(
                                  visible: !isUnsigned && _fee != null,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: _ConfirmItemLabel(
                                        text: dic["tx.fee"] ?? '',
                                        isPlugin: true,
                                      )),
                                      Text(
                                        '${Fmt.balance(
                                          (_fee?.partialFee ?? 0).toString(),
                                          decimals,
                                          length: 6,
                                        )} $symbol',
                                        style: TextStyle(
                                          fontFamily: UI.getFontFamily(
                                              'TitilliumWeb', context),
                                          color: Theme.of(context).errorColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Image.asset(
                              "packages/polkawallet_ui/assets/images/divider.png")),
                      CollapsedContainer(
                        title: dic['tx.params'] ?? '',
                        isPlugin: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${args.module}.${args.call}',
                              style: TextStyle(
                                  fontSize: UI.getTextSize(14, context),
                                  color: Colors.white),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 40),
                              child: Text(
                                _updateKUSD(args.rawParams != null
                                    ? args.rawParams!
                                    : const JsonEncoder.withIndent('  ')
                                        .convert(args.params)),
                                style: TextStyle(
                                    fontSize: UI.getTextSize(14, context),
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: CollapsedContainer(
                          title: dicAcc['advanced'] ?? '',
                          isPlugin: true,
                          child: Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 64,
                                    child: Text(dic['tx.tip']!,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                  TapTooltip(
                                    message: dic['tx.tip.brief']!,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${Fmt.token(_tipValue, decimals)} $symbol',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: const Icon(
                                            Icons.info,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  const Text('0',
                                      style: TextStyle(color: Colors.white)),
                                  Expanded(
                                    child: PluginSlider(
                                      max: 19,
                                      divisions: 19,
                                      value: _tip,
                                      onChanged:
                                          _submitting ? null : _onTipChanged,
                                    ),
                                  ),
                                  const Text('1',
                                      style: TextStyle(color: Colors.white))
                                ],
                              )
                            ],
                          ),
                          onCollapse: (collapsed) {
                            if (!collapsed) {
                              setState(() {
                                _tip = 0;
                                _tipValue = BigInt.zero;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: isNetworkConnected,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: isObservation
                            ? const OfflineSignatureInvalidWarn()
                            : Row(
                                children: <Widget>[
                                  Expanded(
                                    child: PluginButton(
                                      submitting: _submitting,
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          ?.copyWith(
                                              color: UI.isDarkTheme(context)
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .button
                                                      ?.color
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .headline1
                                                      ?.color),
                                      title: dic['cancel']!,
                                      backgroundColor: Colors.white,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Builder(
                                      builder: (BuildContext context) {
                                        return PluginButton(
                                          submitting: _submitting,
                                          title: isUnsigned
                                              ? dic['tx.no.sign']!
                                              : dic['tx.submit']!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              ?.copyWith(color: Colors.black),
                                          onPressed: !isNetworkMatch
                                              ? null
                                              : isUnsigned
                                                  ? () => _onSubmit(context)
                                                  : _submitting
                                                      ? null
                                                      : () =>
                                                          _showPasswordDialog(
                                                              context),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )))
              ],
            ),
          ),
        ),
        onWillPop: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          return Future.value(true);
        },
      );
    }
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(args.txTitle!),
          centerTitle: true,
          leading: BackBtn(
            onBack: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: <Widget>[
                    Column(
                      children: [
                        InnerShadowBGCar(
                          padding: const EdgeInsets.only(left: 16),
                          margin: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...args.txDisplayBold.keys.map((key) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _ConfirmItemLabel(text: key),
                                    args.txDisplayBold[key] ?? Container(),
                                  ],
                                );
                              }).toList(),
                              ...args.txDisplay.keys.map((key) {
                                final content =
                                    args.txDisplay[key].runtimeType == String
                                        ? args.txDisplay[key]
                                        : jsonEncode(args.txDisplay[key]);
                                return Row(
                                  children: [
                                    _ConfirmItemLabel(text: key),
                                    Expanded(
                                        child: Text(
                                      content,
                                      style: itemContentStyle,
                                    )),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        InnerShadowBGCar(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            children: [
                              isUnsigned
                                  ? Container()
                                  : Row(
                                      children: [
                                        Expanded(
                                            child: _ConfirmItemLabel(
                                                text: dic["tx.from"] ?? '')),
                                        AddressIcon(
                                          widget.keyring.current.address,
                                          svg: widget.keyring.current.icon,
                                          size: 24,
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                            Fmt.address(
                                                widget.keyring.current.address,
                                                pad: 8),
                                            style: itemContentStyle,
                                          ),
                                        )
                                      ],
                                    ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: _ConfirmItemLabel(
                                          text: dic["tx.network"] ?? '')),
                                  Visibility(
                                      visible: isNetworkConnected,
                                      child: Container(
                                          height: 44,
                                          width: 24,
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          child: widget.plugin.basic.icon)),
                                  !isNetworkConnected
                                      ? Text(
                                          dic['tx.network.no']!,
                                          style: itemContentStyle,
                                        )
                                      : Text(
                                          widget.plugin.basic.name!,
                                          style: itemContentStyle,
                                        )
                                ],
                              ),
                              Visibility(
                                visible: !isUnsigned && _fee != null,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: _ConfirmItemLabel(
                                            text: dic["tx.fee"] ?? '')),
                                    Text(
                                      '${Fmt.balance(
                                        (_fee?.partialFee ?? 0).toString(),
                                        decimals,
                                        length: 6,
                                      )} $symbol',
                                      style: TextStyle(
                                        fontFamily: UI.getFontFamily(
                                            'TitilliumWeb', context),
                                        color: Theme.of(context).errorColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    CollapsedContainer(
                      title: dic['tx.params'] ?? '',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${args.module}.${args.call}',
                            style: TextStyle(
                                fontSize: UI.getTextSize(14, context)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 40),
                            child: Text(
                              _updateKUSD(args.rawParams != null
                                  ? args.rawParams!
                                  : const JsonEncoder.withIndent('  ')
                                      .convert(args.params)),
                              style: TextStyle(
                                  fontSize: UI.getTextSize(14, context)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: CollapsedContainer(
                        title: dicAcc['advanced'] ?? '',
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 64,
                                  child: Text(dic['tx.tip']!),
                                ),
                                TapTooltip(
                                  message: dic['tx.tip.brief']!,
                                  child: Row(
                                    children: [
                                      Text(
                                        '${Fmt.token(_tipValue, decimals)} $symbol',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .toggleableActiveColor),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Icon(
                                          Icons.info,
                                          color: Theme.of(context)
                                              .unselectedWidgetColor,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                const Text('0'),
                                Expanded(
                                  child: SliderTheme(
                                      data: SliderThemeData(
                                          trackHeight: 16,
                                          activeTrackColor: Theme.of(context)
                                              .toggleableActiveColor,
                                          inactiveTrackColor:
                                              const Color(0xFFE4E4E3),
                                          overlayColor: Colors.transparent,
                                          thumbShape: SliderThumbShape(_image)),
                                      child: Slider(
                                        min: 0,
                                        max: 19,
                                        divisions: 19,
                                        value: _tip,
                                        onChanged:
                                            _submitting ? null : _onTipChanged,
                                      )),
                                ),
                                const Text('1')
                              ],
                            )
                          ],
                        ),
                        onCollapse: (collapsed) {
                          if (!collapsed) {
                            setState(() {
                              _tip = 0;
                              _tipValue = BigInt.zero;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                  visible: isNetworkConnected,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: isObservation
                          ? const OfflineSignatureInvalidWarn()
                          : Row(
                              children: <Widget>[
                                Expanded(
                                  child: Button(
                                    submitting: _submitting,
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        ?.copyWith(
                                            color: UI.isDarkTheme(context)
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .button
                                                    ?.color
                                                : Theme.of(context)
                                                    .textTheme
                                                    .headline1
                                                    ?.color),
                                    title: dic['cancel']!,
                                    isBlueBg: false,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Container(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Builder(
                                    builder: (BuildContext context) {
                                      return Button(
                                        submitting: _submitting,
                                        title: isUnsigned
                                            ? dic['tx.no.sign']!
                                            : dic['tx.submit']!,
                                        style:
                                            Theme.of(context).textTheme.button,
                                        onPressed: !isNetworkMatch
                                            ? null
                                            : isUnsigned
                                                ? () => _onSubmit(context)
                                                : _submitting
                                                    ? null
                                                    : () => _showPasswordDialog(
                                                        context),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )))
            ],
          ),
        ),
      ),
      onWillPop: () {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        return Future.value(true);
      },
    );
  }
}

class _ConfirmItemLabel extends StatelessWidget {
  const _ConfirmItemLabel({required this.text, this.isPlugin = false});
  final String text;
  final bool isPlugin;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 88),
      child: Text(text,
          style: TextStyle(
              fontFamily: UI.getFontFamily('TitilliumWeb', context),
              color: this.isPlugin ? Colors.white : null)),
      alignment: AlignmentDirectional.centerStart,
    );
  }
}
