import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iiportfo/utils/datetime_utils.dart';

class CryptoWatchAPI {
  // https://api.cryptowat.ch/markets/binance/bnbusdt/ohlc?periods=3600
  final _baseUrl = "api.cryptowat.ch";
  final _binanceMarketHistory = "/markets/binance";
  static const double ERROR_RESULT = -1;

  Future<double> getPairPrice(DateTime dateTime, String pair) async {
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
        return ERROR_RESULT;
      }
      final List<dynamic> json = decoded["result"][period][0];
      final double o = double.parse(json[1].toString());
      final double c = double.parse(json[4].toString());

      return ((c + o) / 2);
    } catch (e) {
      return ERROR_RESULT;
    }
  }

  static final CryptoWatchAPI _singleton = CryptoWatchAPI._internal();

  factory CryptoWatchAPI() {
    return _singleton;
  }

  CryptoWatchAPI._internal();
}