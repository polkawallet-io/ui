import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/api/types/recoveryInfo.dart';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/addressFormItem.dart';
import 'package:polkawallet_ui/components/tapTooltip.dart';
import 'package:polkawallet_ui/components/txButton.dart';
import 'package:polkawallet_ui/pages/accountListPage.dart';
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
  bool _tipExpanded = false;
  bool _paramsExpanded = false;
  double _tip = 0;
  BigInt _tipValue = BigInt.zero;
  KeyPairData? _proxyAccount;
  RecoveryInfo? _recoveryInfo = RecoveryInfo();

  Future<String> _getTxFee({bool reload = false}) async {
    if (_fee?.partialFee != null && !reload) {
      return _fee!.partialFee.toString();
    }
    if (widget.plugin.basic.name == 'kusama' &&
        (widget.keyring.current.observation ?? false)) {
      final recoveryInfo = await widget.plugin.sdk.api.recovery
          .queryRecoverable(widget.keyring.current.address!);
      setState(() {
        _recoveryInfo = recoveryInfo;
      });
    }

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

  Future<void> _onSwitch(bool value) async {
    if (value) {
      final accounts = widget.keyring.keyPairs.toList();
      accounts.addAll(widget.keyring.externals);
      final acc = await Navigator.of(context).pushNamed(
        AccountListPage.route,
        arguments: AccountListPageParams(list: accounts),
      );
      if (acc != null) {
        setState(() {
          _proxyAccount = acc as KeyPairData?;
        });
      }
    } else {
      setState(() {
        _proxyAccount = null;
      });
    }
    _getTxFee(reload: true);
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

  Future<bool> _validateProxy() async {
    List proxies = await (widget.plugin.sdk.api.recovery
            .queryRecoveryProxies([_proxyAccount!.address!])
        as FutureOr<List<dynamic>>);
    print(proxies);
    return proxies[0] == widget.keyring.current.address;
  }

  Future<void> _showPasswordDialog(BuildContext context) async {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common');
    if (_proxyAccount != null && !(await _validateProxy())) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(Fmt.address(widget.keyring.current.address)!),
            content: Text(dic!['tx.proxy.invalid']!),
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
      return;
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

    if ((await widget.txDisabledCalls) != null) {
      List moduleCalls = (await widget.txDisabledCalls)![args.module] ?? [];
      if (moduleCalls.contains(args.call)) {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(dic['tx.hint']!),
              content: Text(
                  "${args.module}.${args.call} ${dic['tx.disabledCall']!}"),
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
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(args.txTitle!),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(bottom: 24),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        dic['tx.submit']!,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    isUnsigned
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: AddressFormItem(
                              widget.keyring.current,
                              label: dic["tx.from"],
                            ),
                          ),
                    isKusama && isObservation && _recoveryInfo?.address != null
                        ? Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              children: [
                                TapTooltip(
                                  message: dic['tx.proxy.brief']!,
                                  child: Icon(Icons.info_outline, size: 16),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Text(dic['tx.proxy']!),
                                  ),
                                ),
                                CupertinoSwitch(
                                  value: _proxyAccount != null,
                                  onChanged: (res) => _onSwitch(res),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    _proxyAccount != null
                        ? GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: AddressFormItem(
                                _proxyAccount,
                                label: dicAcc["proxy"],
                              ),
                            ),
                            onTap: () => _onSwitch(true),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Row(
                        children: <Widget>[
                          Container(width: 64, child: Text(dic["tx.network"]!)),
                          !isNetworkConnected
                              ? Container()
                              : Container(
                                  width: 28,
                                  height: 28,
                                  margin: EdgeInsets.only(right: 8),
                                  child: widget.plugin.basic.icon),
                          Expanded(
                              child: !isNetworkConnected
                                  ? Text(dic['tx.network.no']!)
                                  : Text(widget.plugin.basic.name!))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          Container(width: 64, child: Text(dic["tx.call"]!)),
                          Text('${args.module}.${args.call}'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        children: <Widget>[
                          Container(width: 64, child: Text(dic["detail"]!)),
                          Container(
                            width:
                                MediaQuery.of(context).copyWith().size.width -
                                    120,
                            child: Text(
                              JsonEncoder.withIndent('  ')
                                  .convert(args.txDisplay),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Row(
                            children: <Widget>[
                              Text('Params'),
                              Icon(
                                _paramsExpanded
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                size: 30,
                                color: Theme.of(context).unselectedWidgetColor,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _paramsExpanded = !_paramsExpanded;
                          });
                        },
                      ),
                    ),
                    _paramsExpanded
                        ? Container(
                            margin: EdgeInsets.only(left: 80),
                            child: Text(
                              args.rawParams != null
                                  ? args.rawParams!
                                  : JsonEncoder.withIndent('  ')
                                      .convert(args.params),
                            ),
                          )
                        : Container(),
                    Container(
                      margin: EdgeInsets.only(left: 16, top: 8, right: 16),
                      child: Divider(),
                    ),
                    isUnsigned
                        ? Container()
                        : FutureBuilder<String>(
                            future: _getTxFee(),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.hasData) {
                                String fee = Fmt.balance(
                                  _fee!.partialFee.toString(),
                                  decimals,
                                  length: 6,
                                );
                                return Padding(
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 8),
                                        width: 64,
                                        child: Text(dic["tx.fee"]!),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 8),
                                        width: MediaQuery.of(context)
                                                .copyWith()
                                                .size
                                                .width -
                                            120,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '$fee $symbol',
                                            ),
                                            Text(
                                              '${_fee!.weight} Weight',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Theme.of(context)
                                                    .unselectedWidgetColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8, top: 8),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                _tipExpanded
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                size: 30,
                                color: Theme.of(context).unselectedWidgetColor,
                              ),
                              Text(dicAcc['advanced']!)
                            ],
                          ),
                        ),
                        onTap: () {
                          // clear state while advanced options closed
                          if (_tipExpanded) {
                            setState(() {
                              _tip = 0;
                              _tipValue = BigInt.zero;
                            });
                          }
                          setState(() {
                            _tipExpanded = !_tipExpanded;
                          });
                        },
                      ),
                    ),
                    _tipExpanded
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 64,
                                  child: Text(dic['tx.tip']!),
                                ),
                                Text(
                                    '${Fmt.token(_tipValue, decimals)} $symbol'),
                                TapTooltip(
                                  message: dic['tx.tip.brief']!,
                                  child: Icon(
                                    Icons.info,
                                    color:
                                        Theme.of(context).unselectedWidgetColor,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    _tipExpanded
                        ? Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              children: <Widget>[
                                Text('0'),
                                Expanded(
                                  child: Slider(
                                    min: 0,
                                    max: 19,
                                    divisions: 19,
                                    value: _tip,
                                    onChanged:
                                        _submitting ? null : _onTipChanged,
                                  ),
                                ),
                                Text('1')
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              !isNetworkConnected
                  ? Container()
                  : Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            color: _submitting ? Colors.black12 : Colors.orange,
                            child: FlatButton(
                              padding: EdgeInsets.all(16),
                              child: Text(dic['cancel']!,
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: _submitting || !isNetworkMatch
                                ? Theme.of(context).disabledColor
                                : Theme.of(context).primaryColor,
                            child: Builder(
                              builder: (BuildContext context) {
                                return FlatButton(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    isUnsigned
                                        ? dic['tx.no.sign']!
                                        : (isObservation &&
                                                    _proxyAccount == null) ||
                                                isProxyObservation
                                            ? dic['tx.qr']!
                                            // dicAcc['observe.invalid']
                                            : dic['tx.submit']!,
                                    style: TextStyle(color: Colors.white),
                                  ),
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
                        ),
                      ],
                    )
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
