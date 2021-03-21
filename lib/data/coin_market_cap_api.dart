import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iiportfo/data/csv_data.dart';
import 'package:iiportfo/data/portfo_item_data.dart';
import 'package:iiportfo/data/secret_loader.dart';

class Quote {
  final int rank;
  final String name;
  final double priceUSD;

  Quote({this.rank, this.name, this.priceUSD});
}

class CoinMarketCapAPI {
  static final baseUrl = "pro-api.coinmarketcap.com";
  static final quotesApiUrl = "/v2/cryptocurrency/quotes/latest";

  static Future<List<PortfoItemData>> getQuotes(List<String> symbols) async {
    final secret = await SecretLoader().load();
    final apiKey = secret.coinMarketCapApiKey;

    final url = Uri.https(baseUrl, quotesApiUrl, {
      "symbol": getSymbols().join(","),
    });

    final response = await http.get(url, headers: {
      "Accepts": "application/json",
      "X-CMC_PRO_API_KEY": apiKey,
    });
    final data = jsonDecode(response.body)["data"];

    final coin = data["ADA"][0];
    print(coin["cmc_rank"]);
    print(coin["name"]);
    print(coin["quote"]["USD"]["price"]);

    return getSymbols().map((it) {
      final coin = data[it][0];
      return PortfoItemData(
          rank: coin["cmc_rank"],
          name: coin["name"],
          priceUSD: coin["quote"]["USD"]["price"]);
    }).toList();
  }
}
