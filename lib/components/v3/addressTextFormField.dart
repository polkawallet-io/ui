import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/addressFormItem.dart';
import 'package:polkawallet_ui/components/v3/textFormField.dart' as v3;
import 'package:polkawallet_ui/pages/v3/accountListPage.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';
import 'package:polkawallet_ui/utils/index.dart';

class AddressTextFormField extends StatefulWidget {
  AddressTextFormField(this.api, this.localAccounts,
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
  final Function(KeyPairData?)? onChanged;

  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final String? labelText;
  final TextStyle? labelStyle;

  @override
  _AddressTextFormFieldState createState() => _AddressTextFormFieldState();
}

class _AddressTextFormFieldState extends State<AddressTextFormField> {
  final TextEditingController _controller = TextEditingController();
  Map _addressIndexMap = {};
  Map _addressIconsMap = {};
  String? validatorError;
  bool hasFocus = false;
  FocusNode _commentFocus = FocusNode();

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
      if (res.length > 0) {
        acc.icon = res[0][1];
        setState(() {
          _addressIconsMap.addAll({acc.address: res[0][1]});
        });
      }

      // The indices query too slow, so we use address as account name
      if (acc.name == null) {
        acc.name = Fmt.address(acc.address);
      }
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      widget.labelText != null
          ? Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Text(
                widget.labelText ?? "",
                style:
                    widget.labelStyle ?? Theme.of(context).textTheme.bodyText1,
              ),
            )
          : Container(),
      Focus(
          onFocusChange: (hasFocus) async {
            if (!hasFocus) {
              if (_controller.text.trim().isNotEmpty) {
                final data = await _getAccountFromInput(_controller.text);
                setState(() {
                  validatorError = data == null ? dic!['amount.error'] : null;
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
          child: !hasFocus &&
                  widget.initialValue != null &&
                  validatorError == null
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      hasFocus = true;
                    });
                    Future.delayed(const Duration(milliseconds: 100), () {
                      FocusScope.of(context).requestFocus(_commentFocus);
                    });
                  },
                  child: AddressFormItem(
                    widget.initialValue,
                    margin: EdgeInsets.zero,
                    isGreyBg: false,
                  ))
              : v3.TextFormField(
                  controller: _controller,
                  focusNode: _commentFocus,
                  onChanged: (value) {
                    if (validatorError != null &&
                        _controller.text.trim().toString().length == 0) {
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
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        var res = await Navigator.of(context).pushNamed(
                          AccountListPage.route,
                          arguments:
                              AccountListPageParams(list: widget.localAccounts),
                        );
                        if (res != null && widget.onChanged != null) {
                          widget.onChanged!(res as KeyPairData);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(12, 12, 0, 12),
                        child: SvgPicture.asset(
                          "packages/polkawallet_ui/assets/images/icon_user.svg",
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.trim().length > 0) {
                      return validatorError;
                    }
                    return null;
                  },
                )),
    ]);
  }
}
