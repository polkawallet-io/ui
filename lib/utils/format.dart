import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polkawallet_sdk/api/types/balanceData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/utils/i18n.dart';

class Fmt {
  static String dateTime(DateTime? time) {
    if (time == null) {
      return 'date-time';
    }
    return DateFormat.yMd().add_Hm().format(time.toLocal());
  }

  static String blockToTime(int? blocks, int blockDuration,
      {String locale = 'en'}) {
    if (blocks == null) return '~';
    print(locale);

    final blocksOfMin = 60000 ~/ blockDuration;
    final blocksOfHour = 3600000 ~/ blockDuration;
    final blocksOfDay = 24 * 3600000 ~/ blockDuration;

    final day = (blocks / blocksOfDay).floor();
    final hour = (blocks % blocksOfDay / blocksOfHour).floor();
    final min = (blocks % blocksOfHour / blocksOfMin).floor();

    String res = '$min ${locale.contains('zh') ? "分钟" : "mins"}';

    if (day > 0) {
      res =
          '$day ${locale.contains('zh') ? "天" : "days"} $hour ${locale.contains('zh') ? "小时" : "hrs"}';
    } else if (hour > 0) {
      res = '$hour ${locale.contains('zh') ? "小时" : "hrs"} $res';
    }
    return res;
  }

  static String? address(String? addr, {int pad = 6}) {
    if (addr == null || addr.length == 0) {
      return addr;
    }
    return addr.substring(0, pad) + '...' + addr.substring(addr.length - pad);
  }

  static bool isAddress(String txt) {
    var reg = RegExp(r'^[A-z\d]{47,48}$');
    return reg.hasMatch(txt);
  }

  static bool isHexString(String hex) {
    var reg = RegExp(r'^[a-f0-9]+$');
    return reg.hasMatch(hex);
  }

  static BigInt balanceTotal(BalanceData? balance) {
    return balanceInt((balance?.freeBalance ?? 0).toString()) +
        balanceInt((balance?.reservedBalance ?? 0).toString());
  }

  /// number transform 1:
  /// from raw <String> of Api data to <BigInt>
  static BigInt balanceInt(String? raw) {
    if (raw == null || raw.length == 0) {
      return BigInt.zero;
    }
    if (raw.contains(',') || raw.contains('.')) {
      return BigInt.from(NumberFormat(",##0.000").parse(raw));
    } else {
      return BigInt.parse(raw);
    }
  }

  /// number transform 2:
  /// from <BigInt> to <double>
  static double bigIntToDouble(BigInt? value, int decimals) {
    if (value == null) {
      return 0;
    }
    return value / BigInt.from(pow(10, decimals));
  }

  /// number transform 3:
  /// from <double> to <String> in token format of ",##0.000"
  static String doubleFormat(
    double? value, {
    int length = 4,
    int round = 0,
  }) {
    if (value == null) {
      return '~';
    }
    NumberFormat f =
        NumberFormat(",##0${length > 0 ? '.' : ''}${'#' * length}", "en_US");
    return f.format(value);
  }

  /// combined number transform 1-3:
  /// from raw <String> to <String> in token format of ",##0.000"
  static String balance(
    String? raw,
    int decimals, {
    int length = 4,
  }) {
    if (raw == null || raw.length == 0) {
      return '~';
    }
    return doubleFormat(bigIntToDouble(balanceInt(raw), decimals),
        length: length);
  }

  /// combined number transform 1-2:
  /// from raw <String> to <double>
  static double balanceDouble(String raw, int decimals) {
    return bigIntToDouble(balanceInt(raw), decimals);
  }

  /// combined number transform 2-3:
  /// from <BigInt> to <String> in token format of ",##0.000"
  static String token(
    BigInt? value,
    int decimals, {
    int length = 4,
  }) {
    if (value == null) {
      return '~';
    }
    return doubleFormat(bigIntToDouble(value, decimals), length: length);
  }

  /// number transform 4:
  /// from <String of double> to <BigInt>
  static BigInt tokenInt(String? value, int decimals) {
    if (value == null) {
      return BigInt.zero;
    }
    double v = 0;
    try {
      if (value.contains(',') || value.contains('.')) {
        v = NumberFormat(",##0.${"0" * decimals}").parse(value) as double;
      } else {
        v = double.parse(value);
      }
    } catch (err) {
      print('Fmt.tokenInt() error: ${err.toString()}');
    }
    return BigInt.from(v * pow(10, decimals));
  }

  /// number transform 5:
  /// from <BigInt> to <String> in price format of ",##0.00"
  /// ceil number of last decimal
  static String priceCeil(
    double? value, {
    int lengthFixed = 2,
    int? lengthMax,
  }) {
    if (value == null) {
      return '~';
    }
    final int x = pow(10, lengthMax ?? lengthFixed) as int;
    final double price = (value * x).ceilToDouble() / x;
    final String tailDecimals =
        lengthMax == null ? '' : "#" * (lengthMax - lengthFixed);
    return "${NumberFormat(",##0${lengthFixed > 0 ? '.' : ''}${"0" * lengthFixed}$tailDecimals", "en_US").format(price)}";
  }

  /// number transform 6:
  /// from <BigInt> to <String> in price format of ",##0.00"
  /// floor number of last decimal
  static String priceFloor(
    double? value, {
    int lengthFixed = 2,
    int? lengthMax,
  }) {
    if (value == null) {
      return '~';
    }
    final int x = pow(10, lengthMax ?? lengthFixed) as int;
    final double price = (value * x).floorToDouble() / x;
    final String tailDecimals =
        lengthMax == null ? '' : "#" * (lengthMax - lengthFixed);
    return "${NumberFormat(",##0${lengthFixed > 0 ? '.' : ''}${"0" * lengthFixed}$tailDecimals", "en_US").format(price)}";
  }

  /// number transform 7:
  /// from number to <String> in price format of ",##0.###%"
  static String ratio(dynamic number, {bool needSymbol = true}) {
    NumberFormat f = NumberFormat(",##0.###${needSymbol ? '%' : ''}");
    return f.format(number ?? 0);
  }

  static String priceCeilBigInt(
    BigInt? value,
    int decimals, {
    int lengthFixed = 2,
    int? lengthMax,
  }) {
    if (value == null) {
      return '~';
    }
    return priceCeil(Fmt.bigIntToDouble(value, decimals),
        lengthFixed: lengthFixed, lengthMax: lengthMax);
  }

  static String priceFloorBigInt(
    BigInt? value,
    int decimals, {
    int lengthFixed = 2,
    int? lengthMax,
  }) {
    if (value == null) {
      return '~';
    }
    return priceFloor(Fmt.bigIntToDouble(value, decimals),
        lengthFixed: lengthFixed, lengthMax: lengthMax);
  }

  static String? validatePrice(String value, BuildContext context) {
    final dic = I18n.of(context)!.getDic(i18n_full_dic_ui, 'common');

    final v = value.trim();
    try {
      if (v.isEmpty || double.parse(v.trim()) == 0) {
        return dic!['amount.error'];
      }
    } catch (e) {
      return dic!['amount.error'];
    }
    return null;
  }

  static String priceFloorFormatter(
    double? value, {
    int lengthFixed = 2,
    int? lengthMax,
  }) {
    if (value == null) {
      return '~';
    }
    final int x = pow(10, lengthMax ?? lengthFixed) as int;
    final PriceFormatter pf = PriceFormatter.init(value);
    final double price = (pf.price * x).floorToDouble() / x;
    final String tailDecimals =
        lengthMax == null ? '' : "#" * (lengthMax - lengthFixed);
    return "${NumberFormat(",##0${lengthFixed > 0 ? '.' : ''}${"0" * lengthFixed}$tailDecimals", "en_US").format(price)}${pf.unit}";
  }

  static String priceFloorBigIntFormatter(
    BigInt? value,
    int decimals, {
    int lengthFixed = 2,
    int? lengthMax,
  }) {
    if (value == null) {
      return '~';
    }
    return priceFloorFormatter(Fmt.bigIntToDouble(value, decimals),
        lengthFixed: lengthFixed, lengthMax: lengthMax);
  }
}

class PriceFormatter {
  PriceFormatter.init(double price) {
    var suffix = [' ', 'k', 'M', 'B', 'T', 'P', 'E'];
    if (price < 1000) {
      this.price = price;
      this.unit = '';
    } else {
      for (int i = 1; i < suffix.length && price > 1000; price /= 1000, i++) {
        this.price = price / 1000;
        this.unit = suffix[i];
      }
    }
  }
  double price = 0;
  String unit = '';
}
