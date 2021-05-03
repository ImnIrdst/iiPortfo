import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iiportfo/utils/datetime_utils.dart';

class CryptoWatchAPI {
  // https://api.cryptowat.ch/markets/binance/bnbusdt/ohlc?periods=3600
  static final _baseUrl = "api.cryptowat.ch";
  static final _binanceMarketHistory = "/markets/binance";

  static Future<double> getPairPrice(DateTime dateTime, String pair) async {
    final from = dateTime.subtract(Duration(hours: 1));
    final period = "3600";
    final url = Uri.https(_baseUrl, "$_binanceMarketHistory/$pair/ohlc", {
      "periods": period,
      "after": from.toPosix().toString(),
      "before": dateTime.toPosix().toString(),
    });
    print(url);
    final response = await http.get(url);
    print(response.body);

    final decoded = jsonDecode(response.body);
    try {
      final error = decoded["error"];
      if (error != null) {
        print("error $error");
        return 0;
      }
      final List<dynamic> json = decoded["result"][period][0];
      // final List<dynamic> json = jsonDecode(mockResponse)["result"]["3600"][0];
      final double o = double.parse(json[1].toString());
      final double c = double.parse(json[4].toString());

      return ((c + o) / 2);
    } catch (e) {
      return 0;
    }
  }
}

final mockResponse = """{
  "result": {
    "3600": [
      [
        1619074800,
        54457.73,
        54850,
        54252.38,
        54457.46,
        2858.805659,
        156066284.8694611
      ],
      [
        1619078400,
        54457.46,
        54597,
        54096.08,
        54144.99,
        2482.312911,
        134734229.7848373
      ]
    ]
  },
  "allowance": {
    "cost": 0.015,
    "remaining": 8.875,
    "upgrade": "For unlimited API access, create an account at https://cryptowat.ch"
  }
}
""";
