import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/tapTooltip.dart';
import 'package:polkawallet_ui/components/txButton.dart';
import 'package:polkawallet_ui/components/v3/addressIcon.dart';
import 'package:polkawallet_ui/components/v3/back.dart';
import 'package:polkawallet_ui/components/v3/button.dart';
import 'package:polkawallet_ui/components/v3/collapsedContainer.dart';
import 'package:polkawallet_ui/components/v3/innerShadow.dart';
import 'package:polkawallet_ui/components/v3/sliderThumbShape.dart';
import 'package:polkawallet_ui/pages/qrSenderPage.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class TxConfirmPage extends StatefulWidget {
  const TxConfirmPage(this.plugin, this.keyring, this.getPassword,
      {this.txDisabledCalls});
  final PolkawalletPlugin plugin;
  final Keyring keyring;
  final Future<Map<dynamic, dynamic>>? txDisabledCalls;
  final Future<String> Function(BuildContext, KeyPairData) getPassword;

  static final String route = '/tx/confirm';

  @override
  _TxConfirmPageState createState() => _TxConfirmPageState();
}

class _TxConfirmPageState extends State<TxConfirmPage> {
  bool _submitting = false;

  TxFeeEstimateResult? _fee;
  double _tip = 0;
  BigInt _tipValue = BigInt.zero;
  KeyPairData? _proxyAccount;
  // RecoveryInfo? _recoveryInfo = RecoveryInfo();

  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    load('packages/polkawallet_ui/assets/images/slider_thumb.png').then((i) {
      setState(() {
        _image = i;
      });
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
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

  Future<String> _getTxFee({bool reload = false}) async {
    // if (_fee?.partialFee != null && !reload) {
    //   return _fee!.partialFee.toString();
    // }
    // if (widget.plugin.basic.name == 'kusama' &&
    //     (widget.keyring.current.observation ?? false)) {
    //   final recoveryInfo = await widget.plugin.sdk.api.recovery
    //       .queryRecoverable(widget.keyring.current.address!);
    //   setState(() {
    //     _recoveryInfo = recoveryInfo;
    //   });
    // }

    final TxConfirmParams args =
        ModalRoute.of(context)!.settings.arguments as TxConfirmParams;
    final sender = TxSenderData(
        widget.keyring.current.address, widget.keyring.current.pubKey);
    final txInfo =
        TxInfoData(args.module, args.call, sender, txName: args.txName);
    // if (_proxyAccount != null) {
    //   txInfo['proxy'] = _proxyAccount.pubKey;
    // }
    final fee = await widget.plugin.sdk.api.tx
        .estimateFees(txInfo, args.params!, rawParam: args.rawParams);
    setState(() {
      _fee = fee;
    });
    return fee.partialFee.toString();
  }

  // Future<void> _onSwitch(bool value) async {
  //   if (value) {
  //     final accounts = widget.keyring.keyPairs.toList();
  //     accounts.addAll(widget.keyring.externals);
  //     final acc = await Navigator.of(context).pushNamed(
  //       AccountListPage.route,
  //       arguments: AccountListPageParams(list: accounts),
  //     );
  //     if (acc != null) {
  //       setState(() {
  //         _proxyAccount = acc as KeyPairData?;
  //       });
  //     }
  //   } else {
  //     setState(() {
  //       _proxyAccount = null;
  //     });
  //   }
  //   _getTxFee(reload: true);
  // }

  void _onTxFinish(BuildContext context, Map? res, String? errorMsg) async {
    if (res != null) {
      print('callback triggered, blockHash: ${res['hash']}');
    }
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (mounted) {
      await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: errorMsg != null
                ? Icon(Icons.cancel, color: Colors.red, size: 32)
                : Icon(Icons.check_circle, color: Colors.lightGreen, size: 32),
            content: Text(errorMsg ??
                I18n.of(context)!
                    .getDic(i18n_full_dic_ui, 'common')!['success']!),
            actions: <Widget>[
              CupertinoButton(
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

  // Future<bool> _validateProxy() async {
  //   List proxies = await (widget.plugin.sdk.api.recovery
  //           .queryRecoveryProxies([_proxyAccount!.address!])
  //       as FutureOr<List<dynamic>>);
  //   print(proxies);
  //   return proxies[0] == widget.keyring.current.address;
  // }

  Future<void> _showPasswordDialog(BuildContext context) async {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common');
    final TxConfirmParams args =
        ModalRoute.of(context)!.settings.arguments as TxConfirmParams;

    if ((await widget.txDisabledCalls) != null) {
      List moduleCalls = (await widget.txDisabledCalls)![args.module] ?? [];
      if (_checkCallDisabled(moduleCalls)) {
        return;
      }
    }

    // if (_proxyAccount != null && !(await _validateProxy())) {
    //   showCupertinoDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return CupertinoAlertDialog(
    //         title: Text(Fmt.address(widget.keyring.current.address)!),
    //         content: Text(dic!['tx.proxy.invalid']!),
    //         actions: <Widget>[
    //           CupertinoButton(
    //             child: Text(
    //               dic['cancel']!,
    //               style: TextStyle(
    //                 color: Theme.of(context).unselectedWidgetColor,
    //               ),
    //             ),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    //   return;
    // }

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
    );

    try {
      final res = viaQr
          ? await _sendTxViaQr(context, txInfo, args)
          : await _sendTx(context, txInfo, args, password!);
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
          return CupertinoAlertDialog(
            title: Text(dic['note']!),
            content: Text(
                "<${args.module}.${args.call}> ${dic['tx.disabledCall']!}"),
            actions: <Widget>[
              CupertinoButton(
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

  Future<Map?> _sendTxViaQr(
    BuildContext context,
    TxInfoData txInfo,
    TxConfirmParams args,
  ) async {
    final Map? dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common');
    print('show qr');
    final signed = await Navigator.of(context).pushNamed(
      QrSenderPage.route,
      arguments: QrSenderPageParams(
        txInfo,
        args.params,
        rawParams: args.rawParams,
      ),
    );
    if (signed == null) {
      throw Exception(dic!['tx.cancelled']);
    }
    final res = await widget.plugin.sdk.api.uos.addSignatureAndSend(
      widget.keyring.current.address!,
      signed.toString(),
      (status) {
        if (mounted) {
          _updateTxStatus(context, dic!['tx.$status'] ?? status);
        }
      },
    );
    return res;
  }

  void _updateTxStatus(BuildContext context, String status) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).cardColor,
        content: ListTile(
          leading: CupertinoActivityIndicator(),
          title: Text(
            status,
            style: TextStyle(color: Colors.black54),
          ),
        ),
        duration: Duration(minutes: 5),
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

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    final dicAcc = I18n.of(context)!.getDic(i18n_full_dic_ui, 'account')!;

    final isNetworkConnected = widget.plugin.sdk.api.connectedNode != null;
    // todo: update this check with sdk 0.1.7
    final isNetworkMatch = true;
    // final isNetworkMatch = widget.plugin.networkState.genesisHash ==
    //     widget.plugin.basic.genesisHash;

    final bool isKusama = widget.plugin.basic.name == 'kusama';
    final String symbol = (widget.plugin.networkState.tokenSymbol ?? [''])[0];
    final int decimals = (widget.plugin.networkState.tokenDecimals ?? [12])[0];

    final TxConfirmParams args =
        ModalRoute.of(context)!.settings.arguments as TxConfirmParams;

    final bool isObservation = widget.keyring.current.observation ?? false;
    final bool isProxyObservation =
        _proxyAccount != null ? _proxyAccount!.observation ?? false : false;

    bool isUnsigned = args.isUnsigned ?? false;

    final itemContentStyle = TextStyle(
        fontFamily: 'TitilliumWeb',
        color: Theme.of(context).unselectedWidgetColor);
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
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: <Widget>[
                    // todo: social-recovery supporting paused for now
                    // Visibility(
                    //     visible: isKusama &&
                    //         isObservation &&
                    //         _recoveryInfo?.address != null,
                    //     child: Padding(
                    //       padding: EdgeInsets.only(left: 16, right: 16),
                    //       child: Row(
                    //         children: [
                    //           TapTooltip(
                    //             message: dic['tx.proxy.brief']!,
                    //             child: Icon(Icons.info_outline, size: 16),
                    //           ),
                    //           Expanded(
                    //             child: Padding(
                    //               padding: EdgeInsets.only(left: 4),
                    //               child: Text(dic['tx.proxy']!),
                    //             ),
                    //           ),
                    //           CupertinoSwitch(
                    //             value: _proxyAccount != null,
                    //             onChanged: (res) => _onSwitch(res),
                    //           )
                    //         ],
                    //       ),
                    //     )),
                    // _proxyAccount != null
                    //     ? GestureDetector(
                    //         child: Padding(
                    //           padding: EdgeInsets.only(left: 16, right: 16),
                    //           child: AddressFormItem(
                    //             _proxyAccount,
                    //             label: dicAcc["proxy"],
                    //           ),
                    //         ),
                    //         onTap: () => _onSwitch(true),
                    //       )
                    //     : Container(),
                    Column(
                      children: [
                        InnerShadowBGCar(
                          padding: EdgeInsets.only(left: 16),
                          margin: EdgeInsets.only(bottom: 24),
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
                          padding: EdgeInsets.only(left: 16),
                          child: Column(
                            children: [
                              isUnsigned
                                  ? Container()
                                  : Row(
                                      children: [
                                        _ConfirmItemLabel(
                                            text: dic["tx.from"] ?? ''),
                                        AddressIcon(
                                          widget.keyring.current.address,
                                          svg: widget.keyring.current.icon,
                                        ),
                                        Expanded(
                                            child: Container(
                                          margin: EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Text(
                                            Fmt.address(
                                                    widget.keyring.current
                                                        .address,
                                                    pad: 8) ??
                                                '',
                                            style: itemContentStyle,
                                          ),
                                        ))
                                      ],
                                    ),
                              Row(
                                children: <Widget>[
                                  _ConfirmItemLabel(
                                      text: dic["tx.network"] ?? ''),
                                  Visibility(
                                      visible: isNetworkConnected,
                                      child: Container(
                                          height: 44,
                                          width: 32,
                                          margin: EdgeInsets.only(right: 8),
                                          child: widget.plugin.basic.icon)),
                                  Expanded(
                                      child: !isNetworkConnected
                                          ? Text(
                                              dic['tx.network.no']!,
                                              style: itemContentStyle,
                                            )
                                          : Text(
                                              widget.plugin.basic.name!,
                                              style: itemContentStyle,
                                            ))
                                ],
                              ),
                              Visibility(
                                visible: !isUnsigned && _fee != null,
                                child: Row(
                                  children: <Widget>[
                                    _ConfirmItemLabel(
                                        text: dic["tx.fee"] ?? ''),
                                    Text(
                                      '${Fmt.balance(
                                        (_fee?.partialFee ?? 0).toString(),
                                        decimals,
                                        length: 6,
                                      )} $symbol',
                                      style: TextStyle(
                                        fontFamily: 'TitilliumWeb',
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
                    Divider(height: 24),
                    CollapsedContainer(
                      title: dic['tx.params'] ?? '',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${args.module}.${args.call}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40),
                            child: Text(
                              args.rawParams != null
                                  ? args.rawParams!
                                  : JsonEncoder.withIndent('  ')
                                      .convert(args.params),
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: CollapsedContainer(
                        title: dicAcc['advanced'] ?? '',
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 64,
                                  child: Text(dic['tx.tip']!),
                                ),
                                TapTooltip(
                                  message: dic['tx.tip.brief']!,
                                  child: Row(
                                    children: [
                                      Text(
                                          '${Fmt.token(_tipValue, decimals)} $symbol'),
                                      Container(
                                        padding: EdgeInsets.only(left: 8),
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
                                Text('0'),
                                Expanded(
                                  child: SliderTheme(
                                      data: SliderThemeData(
                                          trackHeight: 16,
                                          activeTrackColor: Theme.of(context)
                                              .toggleableActiveColor,
                                          inactiveTrackColor: Color(0xFFE3DED8),
                                          overlayColor: Colors.transparent,
                                          thumbShape:
                                              SliderThumbShape(_image ?? null)),
                                      child: Slider(
                                        min: 0,
                                        max: 19,
                                        divisions: 19,
                                        value: _tip,
                                        onChanged:
                                            _submitting ? null : _onTipChanged,
                                      )),
                                ),
                                Text('1')
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
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Button(
                              submitting: _submitting,
                              style: Theme.of(context).textTheme.headline3,
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
                                      : (isObservation &&
                                                  _proxyAccount == null) ||
                                              isProxyObservation
                                          ? dic['tx.qr']!
                                          // dicAcc['observe.invalid']
                                          : dic['tx.submit']!,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontFamily: "TitilliumWeb"),
                                  onPressed: !isNetworkMatch
                                      ? null
                                      : isUnsigned
                                          ? () => _onSubmit(context)
                                          : (isObservation &&
                                                      _proxyAccount == null) ||
                                                  isProxyObservation
                                              ? () => _onSubmit(context,
                                                  viaQr: true)
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
  _ConfirmItemLabel({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      child: Text(text, style: TextStyle(fontFamily: 'TitilliumWeb')),
      alignment: AlignmentDirectional.centerStart,
    );
  }
}
