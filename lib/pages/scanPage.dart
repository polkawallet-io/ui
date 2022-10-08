import 'package:flutter/material.dart';
import 'package:flutter_qr_scan/qrcode_reader_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/utils/format.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class ScanPage extends StatelessWidget {
  ScanPage(this.plugin, this.keyring, {Key? key}) : super(key: key);
  final PolkawalletPlugin plugin;
  final Keyring keyring;

  static const String route = '/account/scan';

  final GlobalKey<QrcodeReaderViewState> _qrViewKey = GlobalKey();

  Future<bool> canOpenCamera() async {
    var status = await Permission.camera.request();
    return status.isGranted;
  }

  Future _onScan(BuildContext context, String? txt, String? rawData) async {
    String address = '';
    final String? data = txt?.trim();
    if ((data != null && data.isNotEmpty) ||
        (rawData != null && rawData.isNotEmpty)) {
      try {
        if (data!.contains("polkawallet.io")) {
          final paths = data.toString().split("polkawallet.io");
          Map<dynamic, dynamic> args = <dynamic, dynamic>{};
          if (paths.length > 1) {
            final pathDatas = paths[1].split("?");
            if (pathDatas.length > 1) {
              final datas = pathDatas[1].split("&");
              for (var element in datas) {
                args[element.split("=")[0]] =
                    Uri.decodeComponent(element.split("=")[1]);
              }
            }
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(pathDatas[0], arguments: args);
          }
          return;
        }
        List<String> ls = data.split(':');

        if (ls[0] == 'wc') {
          debugPrint('walletconnect pairing uri detected.');
          Navigator.of(context).pop(QRCodeResult(
            type: QRCodeResultType.rawData,
            rawData: data,
          ));
          return;
        }

        for (String item in ls) {
          if (Fmt.isAddress(item) || Fmt.isAddressETH(item)) {
            address = item;
            break;
          }
        }

        if (address.isNotEmpty) {
          debugPrint('address detected in Qr');
          Navigator.of(context).pop(QRCodeResult(
            type: QRCodeResultType.address,
            address: ls.length == 4
                ? QRCodeAddressResult(ls)
                : QRCodeAddressResult([
                    Fmt.isAddress(address)
                        ? 'substrate'
                        : Fmt.isAddressETH(address)
                            ? "evm"
                            : "",
                    address,
                    '',
                    ''
                  ]),
          ));
        } else if (Fmt.isHexString(data)) {
          debugPrint('hex detected in Qr');
          Navigator.of(context).pop(QRCodeResult(
            type: QRCodeResultType.hex,
            hex: data,
          ));
        } else if (rawData != null &&
            rawData.startsWith('4') &&
            (rawData.endsWith('ec') ||
                rawData.endsWith('ec11') ||
                rawData.endsWith('0'))) {
          debugPrint('rawBytes detected in Qr');
          Navigator.of(context).pop(QRCodeResult(
            type: QRCodeResultType.rawData,
            rawData: rawData,
          ));
        } else {
          _qrViewKey.currentState!.startScan();
        }
      } catch (err) {
        // ignore error and restart scan
        _qrViewKey.currentState!.startScan();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common')!;
    return Scaffold(
      body: FutureBuilder<bool>(
        future: canOpenCamera(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return QrcodeReaderView(
                key: _qrViewKey,
                headerWidget: SafeArea(
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).cardColor,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                helpWidget: Text(dic['scan.help']!),
                onScan: (String? txt, String? rawData) =>
                    _onScan(context, txt, rawData));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

enum QRCodeResultType { address, hex, rawData }

class QRCodeResult {
  QRCodeResult({this.type, this.address, this.hex, this.rawData});

  final QRCodeResultType? type;
  final QRCodeAddressResult? address;
  final String? hex;
  final String? rawData;
}

class QRCodeAddressResult {
  QRCodeAddressResult(this.rawData)
      : chainType = rawData[0],
        address = rawData[1],
        pubKey = rawData[2],
        name = rawData[3];

  final List<String> rawData;

  final String chainType; //'evm','substrate'
  final String address;
  final String pubKey;
  final String name;
}
