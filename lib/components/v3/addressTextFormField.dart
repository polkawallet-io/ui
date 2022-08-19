import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/types/ethWalletData.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/addressFormItem.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginAddressFormItem.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTextFormField.dart';
import 'package:polkawallet_ui/components/v3/textFormField.dart' as v3;
import 'package:polkawallet_ui/pages/v3/accountListPage.dart';
import 'package:polkawallet_ui/pages/v3/plugin/pluginAccountListPage.dart';
import 'package:polkawallet_ui/utils/consts.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

class AddressTextFormField extends StatefulWidget {
  AddressTextFormField(this.api, this.localAccounts,
      {this.initialValue,
      this.onChanged,
      this.localEthAccounts,
      this.hintText,
      this.hintStyle,
      this.errorStyle,
      this.labelText,
      this.labelStyle,
      this.onFocusChange,
      this.isClean = false,
      this.isHubTheme = false,
      this.sdk,
      Key? key})
      : super(key: key);
  final PolkawalletApi api;
  final WalletSDK? sdk;
  final List<KeyPairData> localAccounts;
  final List<EthWalletData>? localEthAccounts;
  final KeyPairData? initialValue;
  final Function(KeyPairData)? onChanged;

  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final String? labelText;
  final TextStyle? labelStyle;

  final void Function(bool)? onFocusChange;
  final bool isClean;
  final bool isHubTheme;

  @override
  createState() => _AddressTextFormFieldState();
}

class _AddressTextFormFieldState extends State<AddressTextFormField> {
  final TextEditingController _controller = TextEditingController();
  final Map _addressIndexMap = {};
  final Map _addressIconsMap = {};
  String? validatorError;
  bool hasFocus = false;
  final FocusNode _commentFocus = FocusNode();

  Future<String?> _checkBlackList(WalletSDK sdk, String address) async {
    final addresses = await sdk.api.account.decodeAddress([address]);
    if (addresses != null) {
      final pubKey = addresses.keys.toList()[0];
      if (sdk.blackList.indexOf(pubKey) > -1) {
        return I18n.of(context)!
            .getDic(i18n_full_dic_ui, 'common')!['address.scam'];
      }
    }
    return null;
  }

  Future<KeyPairData?> _parseEthAccount(String input) async {
    try {
      // check if input address in local account list
      final int addressIndex = widget.localEthAccounts!
          .indexWhere((e) => e.address?.toLowerCase() == input.toLowerCase());
      if (addressIndex >= 0) {
        return widget.localEthAccounts![addressIndex].toKeyPairData();
      }

      final checked = await widget.api.eth.account.getAddress(input);
      final res = KeyPairData()
        ..address = checked
        ..pubKey = checked;

      // fetch address info if it's a new address
      final icon =
          await widget.api.service.eth.account.getAddressIcons([checked]);
      if (icon != null) {
        res.icon = icon[0][1];
      }
      return res;
    } catch (err) {
      return null;
    }
  }

  Future<KeyPairData?> _parseSubstrateAccount(String input) async {
    if (input.length < 47) {
      return null;
    }

    try {
      // check if user input is valid address or indices
      final checkAddress = await widget.api.account.decodeAddress([input]);
      if (checkAddress == null) {
        return null;
      }

      final acc = KeyPairData();
      acc.address = input;
      acc.pubKey = checkAddress.keys.toList()[0];

      // check if input address in local account list
      final int addressIndex =
          widget.localAccounts.indexWhere((e) => e.address == input);
      if (addressIndex >= 0) {
        return widget.localAccounts[addressIndex];
      }

      // fetch address info if it's a new address
      final res = await widget.api.account.getAddressIcons([acc.address]);
      if (res != null) {
        if (res.isNotEmpty) {
          acc.icon = res[0][1];
          setState(() {
            _addressIconsMap.addAll({acc.address: res[0][1]});
          });
        }

        // we use address as account name
        acc.name ??= Fmt.address(acc.address);
      }
      return acc;
    } catch (err) {
      return null;
    }
  }

  Future<KeyPairData?> _getAccountFromInput(String input) async {
    if (widget.localEthAccounts != null) {
      final ethAcc = await _parseEthAccount(input);
      return ethAcc;
    }

    return _parseSubstrateAccount(input);
  }

  String _itemAsString(KeyPairData item) {
    final Map? accInfo = _getAddressInfo(item);
    String? idx = '';
    if (accInfo != null && accInfo['accountIndex'] != null) {
      idx = accInfo['accountIndex'];
    }
    if (item.name != null) {
      return '${item.name} $idx ${item.address}';
    }
    return '${UI.accountDisplayNameString(item.address, accInfo)} $idx ${item.address}';
  }

  Map? _getAddressInfo(KeyPairData acc) {
    return acc.indexInfo ?? _addressIndexMap[acc.address];
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common');
    final labelStyle =
        widget.labelStyle ?? Theme.of(context).textTheme.bodyText1;

    if (widget.isHubTheme) {
      return Focus(
          onFocusChange: (hasFocus) async {
            if (!hasFocus) {
              final input = _controller.text.trim();
              if (input.isNotEmpty) {
                final data = await _getAccountFromInput(input);
                if (data == null) {
                  setState(() {
                    validatorError = dic!['address.error'];
                  });
                } else if (widget.localEthAccounts == null) {
                  // check blacklist
                  final blackListCheck = widget.sdk == null
                      ? null
                      : await _checkBlackList(widget.sdk!, data.address!);
                  setState(() {
                    validatorError = blackListCheck;
                  });
                }
                if (data != null && widget.onChanged != null) {
                  widget.onChanged!(data);
                }
              }
              setState(() {
                this.hasFocus = hasFocus;
              });
              if (widget.onFocusChange != null) {
                widget.onFocusChange!(hasFocus);
              }
            }
          },
          child: !hasFocus &&
                  widget.initialValue != null &&
                  validatorError == null
              ? GestureDetector(
                  onTap: widget.isClean
                      ? null
                      : () {
                          setState(() {
                            hasFocus = true;
                          });
                          Future.delayed(const Duration(milliseconds: 100), () {
                            FocusScope.of(context).requestFocus(_commentFocus);
                          });
                          if (widget.onFocusChange != null) {
                            widget.onFocusChange!(hasFocus);
                          }
                        },
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      PluginAddressFormItem(
                          account: widget.initialValue!,
                          label: widget.labelText),
                      Visibility(
                          visible: widget.isClean,
                          child: GestureDetector(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, right: 12),
                                child: Icon(
                                  Icons.cancel,
                                  size: 18,
                                  color:
                                      Theme.of(context).unselectedWidgetColor,
                                )),
                            onTap: () {
                              setState(() {
                                hasFocus = true;
                              });
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                FocusScope.of(context)
                                    .requestFocus(_commentFocus);
                              });
                              if (widget.onFocusChange != null) {
                                widget.onFocusChange!(hasFocus);
                              }
                            },
                          ))
                    ],
                  ))
              : PluginTextFormField(
                  label: widget.labelText,
                  controller: _controller,
                  focusNode: _commentFocus,
                  onChanged: (value) {
                    if (validatorError != null &&
                        _controller.text.trim().toString().isEmpty) {
                      setState(() {
                        validatorError = null;
                      });
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  suffix: GestureDetector(
                    onTap: () async {
                      var res = await Navigator.of(context).pushNamed(
                        PluginAccountListPage.route,
                        arguments: PluginAccountListPageParams(
                            list: widget.localEthAccounts
                                    ?.map((e) => e.toKeyPairData())
                                    .toList() ??
                                widget.localAccounts),
                      );
                      if (res != null && widget.onChanged != null) {
                        widget.onChanged!(res as KeyPairData);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(4, 10, 0, 10),
                      child: SvgPicture.asset(
                        "packages/polkawallet_ui/assets/images/icon_user.svg",
                        color: PluginColorsDark.headline2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.trim().length < 47) {
                      return dic!['address.error'];
                    }
                    if (value!.trim().isNotEmpty) {
                      return validatorError;
                    }
                    return null;
                  },
                ));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      widget.labelText != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                widget.labelText ?? "",
                style: labelStyle,
              ),
            )
          : Container(),
      Focus(
          onFocusChange: (hasFocus) async {
            if (!hasFocus) {
              final input = _controller.text.trim();
              if (input.isNotEmpty) {
                final data = await _getAccountFromInput(input);
                if (data == null) {
                  setState(() {
                    validatorError = dic!['address.error'];
                  });
                } else if (widget.localEthAccounts == null) {
                  // check blacklist
                  final blackListCheck = widget.sdk == null
                      ? null
                      : await _checkBlackList(widget.sdk!, data.address!);
                  setState(() {
                    validatorError = blackListCheck;
                  });
                }
                if (data != null && widget.onChanged != null) {
                  widget.onChanged!(data);
                }
              }
              setState(() {
                this.hasFocus = hasFocus;
              });
              if (widget.onFocusChange != null) {
                widget.onFocusChange!(hasFocus);
              }
            }
          },
          child: !hasFocus &&
                  widget.initialValue != null &&
                  validatorError == null
              ? GestureDetector(
                  onTap: widget.isClean
                      ? null
                      : () {
                          setState(() {
                            hasFocus = true;
                          });
                          Future.delayed(const Duration(milliseconds: 100), () {
                            FocusScope.of(context).requestFocus(_commentFocus);
                          });
                          if (widget.onFocusChange != null) {
                            widget.onFocusChange!(hasFocus);
                          }
                        },
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      AddressFormItem(
                        widget.initialValue,
                        margin: EdgeInsets.zero,
                        isGreyBg: false,
                      ),
                      Visibility(
                          visible: widget.isClean,
                          child: GestureDetector(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.cancel,
                                  size: 18,
                                  color:
                                      Theme.of(context).unselectedWidgetColor,
                                )),
                            onTap: () {
                              setState(() {
                                hasFocus = true;
                              });
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                FocusScope.of(context)
                                    .requestFocus(_commentFocus);
                              });
                              if (widget.onFocusChange != null) {
                                widget.onFocusChange!(hasFocus);
                              }
                            },
                          ))
                    ],
                  ))
              : v3.TextInputWidget(
                  controller: _controller,
                  focusNode: _commentFocus,
                  onChanged: (value) {
                    if (validatorError != null &&
                        _controller.text.trim().toString().isEmpty) {
                      setState(() {
                        validatorError = null;
                      });
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: v3.InputDecorationV3(
                    hintText: widget.hintText,
                    hintStyle: widget.hintStyle,
                    errorStyle: widget.errorStyle,
                    suffix: GestureDetector(
                      onTap: () async {
                        var res = await Navigator.of(context).pushNamed(
                          AccountListPage.route,
                          arguments: AccountListPageParams(
                              list: widget.localEthAccounts
                                      ?.map((e) => e.toKeyPairData())
                                      .toList() ??
                                  widget.localAccounts),
                        );
                        if (res != null && widget.onChanged != null) {
                          widget.onChanged!(res as KeyPairData);
                        }
                      },
                      child: SvgPicture.asset(
                        "packages/polkawallet_ui/assets/images/icon_user.svg",
                        height: 24,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (!value.startsWith('0x') && value.length < 47) {
                      return dic!['address.error'];
                    }
                    if (value.isNotEmpty) {
                      return validatorError;
                    }
                    return null;
                  },
                )),
    ]);
  }
}
