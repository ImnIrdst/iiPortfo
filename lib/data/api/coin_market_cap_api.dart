import 'dart:convert';

import 'package:iiportfo/data/api/nobitex_api.dart';
import 'package:iiportfo/data/portfo_item_data.dart';

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
  static final baseUrl = "pro-api.coinmarketcap.com";
  static final quotesApiUrl = "/v2/cryptocurrency/quotes/latest";

  static Future<List<Quote>> getQuotes(List<String> symbols) async {
    // final secret = await SecretLoader().load();
    // final apiKey = secret.coinMarketCapApiKey;
    //
    // final url = Uri.https(baseUrl, quotesApiUrl, {
    //   "symbol": symbols.where((s) => s != IRR_SYMBOL).join(","),
    // });
    // print(url);
    //
    // final response = await http.get(url, headers: {
    //   "Accepts": "application/json",
    //   "X-CMC_PRO_API_KEY": apiKey,
    // });
    // print(response.body);
    // final data = jsonDecode(response.body)["data"];
    final data = jsonDecode(mockResponseBody)["data"];
    final usdt = await NobitexAPI.getUSDTPriceInIRR(DateTime.now());
    final usdtPercentChange = await NobitexAPI.getDayChange();

    return symbols.map((symbol) {
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
  }
}

final mockResponseBody = """
{
    "status": {
        "timestamp": "2021-04-22T07:51:50.815Z",
        "error_code": 0,
        "error_message": null,
        "elapsed": 30,
        "credit_count": 1,
        "notice": null
    },
    "data": {
        "BCH": [
            {
                "id": 1831,
                "name": "Bitcoin Cash",
                "symbol": "BCH",
                "slug": "bitcoin-cash",
                "num_market_pairs": 589,
                "date_added": "2017-07-23T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "mineable",
                        "name": "Mineable",
                        "category": "OTHER"
                    },
                    {
                        "slug": "pow",
                        "name": "PoW",
                        "category": "CONSENSUS_ALGORITHM"
                    },
                    {
                        "slug": "sha-256",
                        "name": "SHA-256",
                        "category": "CONSENSUS_ALGORITHM"
                    },
                    {
                        "slug": "marketplace",
                        "name": "Marketplace",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "medium-of-exchange",
                        "name": "Medium of Exchange",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "store-of-value",
                        "name": "Store of Value",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "enterprise-solutions",
                        "name": "Enterprise solutions",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "payments",
                        "name": "Payments",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "binance-chain",
                        "name": "Binance Chain",
                        "category": "PLATFORM"
                    }
                ],
                "max_supply": 21000000,
                "circulating_supply": 18715325,
                "total_supply": 18715325,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 11,
                "is_fiat": 0,
                "last_updated": "2021-04-22T07:50:08.000Z",
                "quote": {
                    "USD": {
                        "price": 921.4094719806263,
                        "volume_24h": 6005659571.292891,
                        "percent_change_1h": -0.49633477,
                        "percent_change_24h": -4.30021603,
                        "percent_change_7d": 11.59666507,
                        "percent_change_30d": 78.00138744,
                        "percent_change_60d": 35.66671044,
                        "percent_change_90d": 119.08418752,
                        "market_cap": 17244477726.195816,
                        "last_updated": "2021-04-22T07:50:08.000Z"
                    }
                }
            }
        ],
        "BNB": [
            {
                "id": 1839,
                "name": "Binance Coin",
                "symbol": "BNB",
                "slug": "binance-coin",
                "num_market_pairs": 578,
                "date_added": "2017-07-25T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "marketplace",
                        "name": "Marketplace",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "centralized-exchange",
                        "name": "Centralized exchange",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "payments",
                        "name": "Payments",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "binance-smart-chain",
                        "name": "Binance Smart Chain",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "alameda-research-portfolio",
                        "name": "Alameda Research Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "multicoin-capital-portfolio",
                        "name": "Multicoin Capital Portfolio",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": 170532785,
                "circulating_supply": 153432897,
                "total_supply": 169432897,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 3,
                "is_fiat": 0,
                "last_updated": "2021-04-22T07:50:08.000Z",
                "quote": {
                    "USD": {
                        "price": 555.2606990746675,
                        "volume_24h": 7863696814.326052,
                        "percent_change_1h": -0.2612719,
                        "percent_change_24h": -8.99440363,
                        "percent_change_7d": 1.60481196,
                        "percent_change_30d": 118.79255999,
                        "percent_change_60d": 113.47928236,
                        "percent_change_90d": 1299.11940173,
                        "market_cap": 85195257649.27145,
                        "last_updated": "2021-04-22T07:50:08.000Z"
                    }
                }
            }
        ],
        "BTC": [
            {
                "id": 1,
                "name": "Bitcoin",
                "symbol": "BTC",
                "slug": "bitcoin",
                "num_market_pairs": 9627,
                "date_added": "2013-04-28T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "mineable",
                        "name": "Mineable",
                        "category": "OTHER"
                    },
                    {
                        "slug": "pow",
                        "name": "PoW",
                        "category": "CONSENSUS_ALGORITHM"
                    },
                    {
                        "slug": "sha-256",
                        "name": "SHA-256",
                        "category": "CONSENSUS_ALGORITHM"
                    },
                    {
                        "slug": "store-of-value",
                        "name": "Store of Value",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "state-channels",
                        "name": "State channels",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "coinbase-ventures-portfolio",
                        "name": "Coinbase Ventures Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "three-arrows-capital-portfolio",
                        "name": "Three Arrows Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "polychain-capital-portfolio",
                        "name": "Polychain Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "binance-labs-portfolio",
                        "name": "Binance Labs Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "arrington-xrp-capital",
                        "name": "Arrington XRP capital",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "blockchain-capital-portfolio",
                        "name": "Blockchain Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "boostvc-portfolio",
                        "name": "BoostVC Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "cms-holdings-portfolio",
                        "name": "CMS Holdings Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "dcg-portfolio",
                        "name": "DCG Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "dragonfly-capital-portfolio",
                        "name": "DragonFly Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "electric-capital-portfolio",
                        "name": "Electric Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "fabric-ventures-portfolio",
                        "name": "Fabric Ventures Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "framework-ventures",
                        "name": "Framework Ventures",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "galaxy-digital-portfolio",
                        "name": "Galaxy Digital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "huobi-capital",
                        "name": "Huobi Capital",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "alameda-research-portfolio",
                        "name": "Alameda Research Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "a16z-portfolio",
                        "name": "A16Z Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "1confirmation-portfolio",
                        "name": "1Confirmation Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "winklevoss-capital",
                        "name": "Winklevoss Capital",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "usv-portfolio",
                        "name": "USV Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "placeholder-ventures-portfolio",
                        "name": "Placeholder Ventures Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "pantera-capital-portfolio",
                        "name": "Pantera Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "multicoin-capital-portfolio",
                        "name": "Multicoin Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "paradigm-xzy-screener",
                        "name": "Paradigm XZY Screener",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": 21000000,
                "circulating_supply": 18688093,
                "total_supply": 18688093,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 1,
                "is_fiat": 0,
                "last_updated": "2021-04-22T07:51:02.000Z",
                "quote": {
                    "USD": {
                        "price": 54257.31098326682,
                        "volume_24h": 59803608820.589905,
                        "percent_change_1h": 0.00355424,
                        "percent_change_24h": -2.65085233,
                        "percent_change_7d": -13.79812173,
                        "percent_change_30d": 1.29693975,
                        "percent_change_60d": -3.90003624,
                        "percent_change_90d": 71.60507139,
                        "market_cap": 1013965673585.2118,
                        "last_updated": "2021-04-22T07:51:02.000Z"
                    }
                }
            }
        ],
        "ETH": [
            {
                "id": 1027,
                "name": "Ethereum",
                "symbol": "ETH",
                "slug": "ethereum",
                "num_market_pairs": 6316,
                "date_added": "2015-08-07T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "mineable",
                        "name": "Mineable",
                        "category": "OTHER"
                    },
                    {
                        "slug": "pow",
                        "name": "PoW",
                        "category": "CONSENSUS_ALGORITHM"
                    },
                    {
                        "slug": "smart-contracts",
                        "name": "Smart Contracts",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "ethereum",
                        "name": "Ethereum",
                        "category": "PLATFORM"
                    },
                    {
                        "slug": "coinbase-ventures-portfolio",
                        "name": "Coinbase Ventures Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "three-arrows-capital-portfolio",
                        "name": "Three Arrows Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "polychain-capital-portfolio",
                        "name": "Polychain Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "binance-labs-portfolio",
                        "name": "Binance Labs Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "arrington-xrp-capital",
                        "name": "Arrington XRP capital",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "blockchain-capital-portfolio",
                        "name": "Blockchain Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "boostvc-portfolio",
                        "name": "BoostVC Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "cms-holdings-portfolio",
                        "name": "CMS Holdings Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "dcg-portfolio",
                        "name": "DCG Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "dragonfly-capital-portfolio",
                        "name": "DragonFly Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "electric-capital-portfolio",
                        "name": "Electric Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "fabric-ventures-portfolio",
                        "name": "Fabric Ventures Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "framework-ventures",
                        "name": "Framework Ventures",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "hashkey-capital-portfolio",
                        "name": "Hashkey Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "kinetic-capital",
                        "name": "Kinetic Capital",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "huobi-capital",
                        "name": "Huobi Capital",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "alameda-research-portfolio",
                        "name": "Alameda Research Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "a16z-portfolio",
                        "name": "A16Z Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "1confirmation-portfolio",
                        "name": "1Confirmation Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "winklevoss-capital",
                        "name": "Winklevoss Capital",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "usv-portfolio",
                        "name": "USV Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "placeholder-ventures-portfolio",
                        "name": "Placeholder Ventures Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "pantera-capital-portfolio",
                        "name": "Pantera Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "multicoin-capital-portfolio",
                        "name": "Multicoin Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "paradigm-xzy-screener",
                        "name": "Paradigm XZY Screener",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": null,
                "circulating_supply": 115569684.249,
                "total_supply": 115569684.249,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 2,
                "is_fiat": 0,
                "last_updated": "2021-04-22T07:51:02.000Z",
                "quote": {
                    "USD": {
                        "price": 2469.398731984408,
                        "volume_24h": 43597399845.4034,
                        "percent_change_1h": 0.97233485,
                        "percent_change_24h": 6.20898231,
                        "percent_change_7d": 0.16207501,
                        "percent_change_30d": 48.09802328,
                        "percent_change_60d": 27.55145387,
                        "percent_change_90d": 111.94438578,
                        "market_cap": 285387631740.31903,
                        "last_updated": "2021-04-22T07:51:02.000Z"
                    }
                }
            }
        ],
        "USDT": [
            {
                "id": 825,
                "name": "Tether",
                "symbol": "USDT",
                "slug": "tether",
                "num_market_pairs": 12275,
                "date_added": "2015-02-25T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "store-of-value",
                        "name": "Store of Value",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "payments",
                        "name": "Payments",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "stablecoin",
                        "name": "Stablecoin",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "stablecoin-asset-backed",
                        "name": "Stablecoin - Asset-Backed",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "solana-ecosystem",
                        "name": "Solana Ecosystem",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": null,
                "circulating_supply": 49320928120.83168,
                "total_supply": 51866290994.32977,
                "platform": {
                    "id": 1027,
                    "name": "Ethereum",
                    "symbol": "ETH",
                    "slug": "ethereum",
                    "token_address": "0xdac17f958d2ee523a2206206994597c13d831ec7"
                },
                "is_active": 1,
                "cmc_rank": 5,
                "is_fiat": 0,
                "last_updated": "2021-04-22T07:50:09.000Z",
                "quote": {
                    "USD": {
                        "price": 1.00008595494517,
                        "volume_24h": 137076694073.23434,
                        "percent_change_1h": -0.0000452,
                        "percent_change_24h": -0.0052331,
                        "percent_change_7d": -0.21179623,
                        "percent_change_30d": -0.09311726,
                        "percent_change_60d": -0.00068546,
                        "percent_change_90d": 0.03388247,
                        "market_cap": 49325167498.504036,
                        "last_updated": "2021-04-22T07:50:09.000Z"
                    }
                }
            }
        ]
    }
}
""";