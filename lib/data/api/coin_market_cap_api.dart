import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iiportfo/data/api/nobitex_api.dart';
import 'package:iiportfo/data/api/secret_loader.dart';
import 'package:iiportfo/data/portfo_item_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quote {
  final int id;
  final int rank;
  final String name;
  final String symbol;
  final double priceUSD;
  final double percentChange24hUSD;

  Quote({
    this.id,
    this.rank,
    this.name,
    this.symbol,
    this.priceUSD,
    this.percentChange24hUSD,
  });

  get imageUrl {
    return Uri.https(
      "s2.coinmarketcap.com",
      "/static/img/coins/128x128/$id.png",
    );
  }
}

class CoinMarketCapAPI {
  static final _baseUrl = "pro-api.coinmarketcap.com";
  static final _quotesApiUrl = "/v2/cryptocurrency/quotes/latest";

  static Uri cachedUrl;
  static List<Quote> cachedQuotes;

  static final _cache = _CoinMarketCapAPICache();

  static Future<List<Quote>> getQuotes(
    List<String> symbols,
    loadFromCache,
  ) async {
    final url = Uri.https(_baseUrl, _quotesApiUrl, {
      "symbol": symbols.where((s) => s != IRR_SYMBOL).join(","),
    });
    print(url);

    if (loadFromCache && cachedUrl == url) {
      return cachedQuotes;
    }

    final secret = await SecretLoader().load();
    final apiKey = secret.coinMarketCapApiKey;
    if (!loadFromCache || (await _cache.getCachedResponse(url)) == null) {
      final response = await http.get(url, headers: {
        "Accepts": "application/json",
        "X-CMC_PRO_API_KEY": apiKey,
      });
      print(response.body);
      await _cache.cacheResponse(url, response.body);
    }

    final responseBody = await _cache.getCachedResponse(url);
    final data = jsonDecode(responseBody)["data"];
    final usdt = await NobitexAPI().getCurrentUSDTPriceInIRR(loadFromCache);
    final usdtPercentChange = await NobitexAPI().getDayChange();

    cachedQuotes = symbols.map((symbol) {
      if (symbol == IRR_SYMBOL) {
        return Quote(
          id: 0,
          rank: 0,
          name: "Iranian Rial",
          symbol: IRR_SYMBOL,
          priceUSD: 1 / usdt,
          percentChange24hUSD: usdtPercentChange,
        );
      } else {
        final coin = data[symbol][0];
        return Quote(
          id: coin["id"],
          rank: coin["cmc_rank"],
          name: coin["name"],
          symbol: coin["symbol"],
          priceUSD: coin["quote"]["USD"]["price"],
          percentChange24hUSD: coin["quote"]["USD"]["percent_change_24h"],
        );
      }
    }).toList();
    return cachedQuotes;
  }
}

class _CoinMarketCapAPICache {
  String _cachedResponse;
  String _cachedUrl;

  Future<void> cacheResponse(Uri url, String response) async {
    final sp = await SharedPreferences.getInstance();

    sp.setString(KEY_CMC_QUOTES_URL, url.toString());
    _cachedUrl = url.toString();

    sp.setString(KEY_CMC_QUOTES_RESPONSE, response);
    _cachedResponse = response;
  }

  Future<String> getCachedResponse(Uri url) async {
    if (_cachedUrl == null) {
      final sp = await SharedPreferences.getInstance();
      _cachedUrl = sp.getString(KEY_CMC_QUOTES_URL);
    }

    if (_cachedUrl != url.toString()) {
      return null;
    }

    if (_cachedResponse == null) {
      final sp = await SharedPreferences.getInstance();
      _cachedResponse = sp.getString(KEY_CMC_QUOTES_RESPONSE);
    }

    return _cachedResponse;
  }

  static const KEY_CMC_QUOTES_URL = "KEY_CMC_QUOTES";
  static const KEY_CMC_QUOTES_RESPONSE = "KEY_CMC_QUOTES_RESPONSE";
}