import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginAddressFormItem.dart';
import 'package:polkawallet_ui/components/v3/plugin/pluginTextFormField.dart';
import 'package:polkawallet_ui/pages/v3/plugin/pluginAccountListPage.dart';
import 'package:polkawallet_ui/utils/consts.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

class PluginAddressTextFormField extends StatefulWidget {
  const PluginAddressTextFormField(this.api, this.localAccounts,
      {this.initialValue,
      this.onChanged,
      this.hintText,
      this.hintStyle,
      this.errorStyle,
      this.labelText,
      this.labelStyle,
      Key? key})
      : super(key: key);
  final PolkawalletApi api;
  final List<KeyPairData> localAccounts;
  final KeyPairData? initialValue;
  final Function(KeyPairData)? onChanged;

  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final String? labelText;
  final TextStyle? labelStyle;

  @override
  createState() => _PluginAddressTextFormFieldState();
}

class _PluginAddressTextFormFieldState
    extends State<PluginAddressTextFormField> {
  final TextEditingController _controller = TextEditingController();
  final Map _addressIndexMap = {};
  final Map _addressIconsMap = {};
  String? validatorError;
  bool hasFocus = false;
  final FocusNode _commentFocus = FocusNode();

  Future<KeyPairData?> _getAccountFromInput(String input) async {
    // return local account list if input empty
    if (input.isEmpty || input.trim().length < 3) {
      return null;
    }

    // check if user input is valid address or indices
    final checkAddress = await widget.api.account.decodeAddress([input]);
    if (checkAddress == null) {
      return null;
    }

    final acc = KeyPairData();
    acc.address = input;
    acc.pubKey = checkAddress.keys.toList()[0];
    if (input.length < 47) {
      // check if input indices in local account list
      final int indicesIndex = widget.localAccounts.indexWhere((e) {
        final Map? accInfo = e.indexInfo;
        return accInfo != null && accInfo['accountIndex'] == input;
      });
      if (indicesIndex >= 0) {
        return widget.localAccounts[indicesIndex];
      }
      // query account address with account indices
      final queryRes =
          await widget.api.account.queryAddressWithAccountIndex(input);
      if (queryRes != null) {
        acc.address = queryRes;
        acc.name = input;
      }
    } else {
      // check if input address in local account list
      final int addressIndex = widget.localAccounts
          .indexWhere((e) => _itemAsString(e).contains(input));
      if (addressIndex >= 0) {
        return widget.localAccounts[addressIndex];
      }
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

      // The indices query too slow, so we use address as account name
      acc.name ??= Fmt.address(acc.address);
    }
    return acc;
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
    return Focus(
      onFocusChange: (hasFocus) async {
        if (!hasFocus) {
          if (_controller.text.trim().isNotEmpty) {
            final data = await _getAccountFromInput(_controller.text);
            setState(() {
              validatorError = data == null ? dic!['address.error'] : null;
            });
            if (data != null && widget.onChanged != null) {
              widget.onChanged!(data);
            }
          }
          setState(() {
            this.hasFocus = hasFocus;
          });
        }
      },
      child: !hasFocus && widget.initialValue != null && validatorError == null
          ? GestureDetector(
              onTap: () {
                setState(() {
                  hasFocus = true;
                });
                Future.delayed(const Duration(milliseconds: 100), () {
                  FocusScope.of(context).requestFocus(_commentFocus);
                });
              },
              child: PluginAddressFormItem(
                label: widget.labelText,
                account: widget.initialValue!,
                isDisable: false,
              ),
            )
          : PluginTextFormField(
              controller: _controller,
              focusNode: _commentFocus,
              padding: const EdgeInsets.fromLTRB(8, 2, 4, 2),
              label: widget.labelText,
              suffix: GestureDetector(
                onTap: () async {
                  var res = await Navigator.of(context).pushNamed(
                    PluginAccountListPage.route,
                    arguments:
                        PluginAccountListPageParams(list: widget.localAccounts),
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
              onChanged: (value) {
                if (validatorError != null &&
                    _controller.text.trim().toString().isEmpty) {
                  setState(() {
                    validatorError = null;
                  });
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.trim().isNotEmpty) {
                  return validatorError;
                }
                return null;
              },
            ),
    );
  }
}
