import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iiportfo/utils/datetime_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NobitexAPI {
  // url = "https://api.nobitex.ir/market/udf/history?symbol=%s&resolution=60&from=%.0f&to=%.0f" \
  // % (coin, start.timestamp(), end.timestamp())
  final _baseUrl = "api.nobitex.ir";
  final _marketHistory = "/market/udf/history";
  final _marketStatsApiUrl = "/market/stats";

  final _cache = _NobitexCache();

  final supportedCoins = {
    "BTC",
    "ETH",
    "BCH",
    "LTC",
    "XRP",
    "BNB",
    "EOS",
    "DOGE",
  };

  Future<double> getCurrentUSDTPriceInIRR(bool loadFromCache) async {
    if (!loadFromCache || (await _cache.getCurrentUsdtPrice()) == null) {
      await _cache.setCurrentUsdtPrice(
        await getPairPrice(DateTime.now(), "USDTIRT"),
      );
    }
    return _cache.getCurrentUsdtPrice();
  }

  Future<double> getUSDTPriceInIRR(DateTime dateTime) async {
    return await getPairPrice(dateTime, "USDTIRT");
  }

  Future<double> getPairPrice(DateTime dateTime, String pair) async {
    final from = dateTime.subtract(Duration(hours: 1));

    final url = Uri.https(_baseUrl, _marketHistory, {
      "symbol": pair,
      "resolution": 60.toString(),
      "from": from.toPosix().toString(),
      "to": dateTime.toPosix().toString(),
    });
    print(url);
    final response = await http.get(url);
    print(response.body);

    final json = jsonDecode(response.body);
    final double c = json['c'][0];
    final double o = json['o'][0];

    return ((c + o) / 2);
  }

  Future<double> getDayChange() async {
    final url = Uri.https(_baseUrl, _marketStatsApiUrl);

    final response = await http.post(
      url,
      body: {"srcCurrency": "usdt", "dstCurrency": "rls"},
    );

    final json = jsonDecode(response.body);
    final double percentChange =
        double.parse(json["stats"]["usdt-rls"]["dayChange"]);

    return percentChange / 100;
  }

  static final NobitexAPI _singleton = NobitexAPI._internal();

  factory NobitexAPI() {
    return _singleton;
  }

  NobitexAPI._internal();
}

class _NobitexCache {
  double _currentUsdtPrice;

  Future<void> setCurrentUsdtPrice(double value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setDouble(KEY_CURRENT_USDT_PRICE, value);

    _currentUsdtPrice = value;
  }

  Future<double> getCurrentUsdtPrice() async {
    if (_currentUsdtPrice == null) {
      final sp = await SharedPreferences.getInstance();
      _currentUsdtPrice = sp.getDouble(KEY_CURRENT_USDT_PRICE);
    }
    return _currentUsdtPrice;
  }

  static const KEY_CURRENT_USDT_PRICE = "KEY_CURRENT_USDT_PRICE";
}