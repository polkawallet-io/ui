import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/api/api.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/components/v3/dialog.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class PasswordInputDialog extends StatefulWidget {
  const PasswordInputDialog(this.api,
      {Key? key, this.account, this.userPass, this.title, this.content})
      : super(key: key);

  final PolkawalletApi api;
  final KeyPairData? account;
  final String? userPass;
  final Widget? title;
  final Widget? content;

  @override
  createState() => _PasswordInputDialog();
}

class _PasswordInputDialog extends State<PasswordInputDialog> {
  final TextEditingController _passCtrl = TextEditingController();

  bool _submitting = false;

  Future<void> _submit(String password) async {
    setState(() {
      _submitting = true;
    });
    var passed =
        await widget.api.keyring.checkPassword(widget.account!, password);
    if (mounted) {
      setState(() {
        _submitting = false;
      });
    }
    if (!mounted) return;
    if (!passed) {
      final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common');
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return PolkawalletAlertDialog(
            type: DialogType.warn,
            title: Text(dic!['pass.error']!),
            content: Text(dic['pass.error.text']!),
            actions: <Widget>[
              PolkawalletActionSheetAction(
                child: Text(dic['ok']!),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.of(context).pop(password);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.userPass != null) {
        _submit(widget.userPass!);
      }
    });
  }

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;

    return PolkawalletAlertDialog(
      title: widget.title ?? Container(),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: widget.content ?? Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _submitting
                ? Text(dic['pass.checking']!)
                : CupertinoTextField(
                    placeholder: dic['pass.old'],
                    controller: _passCtrl,
                    obscureText: true,
                    clearButtonMode: OverlayVisibilityMode.editing,
                  ),
          ),
        ],
      ),
      actions: <Widget>[
        PolkawalletActionSheetAction(
          child: Text(dic['cancel']!),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        PolkawalletActionSheetAction(
          isDefaultAction: true,
          onPressed: _submitting ? null : () => _submit(_passCtrl.text.trim()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                  visible: _submitting,
                  child: const CupertinoActivityIndicator()),
              Text(dic['ok']!)
            ],
          ),
        ),
      ],
    );
  }
}
