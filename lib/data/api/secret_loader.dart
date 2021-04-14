import 'dart:async' show Future;
import 'dart:convert' show json;

import 'package:flutter/services.dart' show rootBundle;

class Secret {
  final String coinMarketCapApiKey;

  Secret({this.coinMarketCapApiKey = ""});

  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(coinMarketCapApiKey: jsonMap["coin_market_cap_api_key"]);
  }
}

class SecretLoader {
  final String secretPath = "lib/assets/secrets.json";

  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(this.secretPath, (
      jsonStr,
    ) async {
      return Secret.fromJson(json.decode(jsonStr));
    });
  }
}
