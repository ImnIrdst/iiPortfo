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
    final url = Uri.https(baseUrl, quotesApiUrl, {
      "symbol": symbols.where((s) => s != IRR_SYMBOL).join(","),
    });
    print(url);
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
        "timestamp": "2021-04-23T07:22:46.148Z",
        "error_code": 0,
        "error_message": null,
        "elapsed": 27,
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
                "circulating_supply": 18716393.75,
                "total_supply": 18716393.75,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 11,
                "is_fiat": 0,
                "last_updated": "2021-04-23T07:21:13.000Z",
                "quote": {
                    "USD": {
                        "price": 770.6146950960897,
                        "volume_24h": 8306391140.536057,
                        "percent_change_1h": 2.8263719,
                        "percent_change_24h": -17.62674126,
                        "percent_change_7d": -15.01473403,
                        "percent_change_30d": 49.26782573,
                        "percent_change_60d": 12.52666739,
                        "percent_change_90d": 76.1098474,
                        "market_cap": 14423128062.954609,
                        "last_updated": "2021-04-23T07:21:13.000Z"
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
                "num_market_pairs": 579,
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
                "last_updated": "2021-04-23T07:21:17.000Z",
                "quote": {
                    "USD": {
                        "price": 483.70576684643953,
                        "volume_24h": 9510698328.80347,
                        "percent_change_1h": 0.57676189,
                        "percent_change_24h": -14.80988256,
                        "percent_change_7d": -4.97249228,
                        "percent_change_30d": 89.13944296,
                        "percent_change_60d": 75.02270745,
                        "percent_change_90d": 1069.71068172,
                        "market_cap": 74216377102.85577,
                        "last_updated": "2021-04-23T07:21:17.000Z"
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
                "num_market_pairs": 9643,
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
                "circulating_supply": 18689000,
                "total_supply": 18689000,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 1,
                "is_fiat": 0,
                "last_updated": "2021-04-23T07:22:02.000Z",
                "quote": {
                    "USD": {
                        "price": 49203.700056448506,
                        "volume_24h": 87618583249.10886,
                        "percent_change_1h": 0.40072894,
                        "percent_change_24h": -10.28018755,
                        "percent_change_7d": -19.88471014,
                        "percent_change_30d": -9.19086734,
                        "percent_change_60d": -12.57859528,
                        "percent_change_90d": 47.88819773,
                        "market_cap": 919567950354.9662,
                        "last_updated": "2021-04-23T07:22:02.000Z"
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
                "num_market_pairs": 6337,
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
                "circulating_supply": 115583148.249,
                "total_supply": 115583148.249,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 2,
                "is_fiat": 0,
                "last_updated": "2021-04-23T07:22:02.000Z",
                "quote": {
                    "USD": {
                        "price": 2221.2584385418522,
                        "volume_24h": 59097646148.01172,
                        "percent_change_1h": 2.11649251,
                        "percent_change_24h": -10.97980867,
                        "percent_change_7d": -7.2086347,
                        "percent_change_30d": 32.63720581,
                        "percent_change_60d": 18.1455164,
                        "percent_change_90d": 75.86637581,
                        "market_cap": 256740043401.32516,
                        "last_updated": "2021-04-23T07:22:02.000Z"
                    }
                }
            }
        ],
        "LTC": [
            {
                "id": 2,
                "name": "Litecoin",
                "symbol": "LTC",
                "slug": "litecoin",
                "num_market_pairs": 744,
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
                        "slug": "scrypt",
                        "name": "Scrypt",
                        "category": "CONSENSUS_ALGORITHM"
                    },
                    {
                        "slug": "medium-of-exchange",
                        "name": "Medium of Exchange",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "binance-chain",
                        "name": "Binance Chain",
                        "category": "PLATFORM"
                    }
                ],
                "max_supply": 84000000,
                "circulating_supply": 66752414.51538747,
                "total_supply": 66752414.51538747,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 10,
                "is_fiat": 0,
                "last_updated": "2021-04-23T07:22:02.000Z",
                "quote": {
                    "USD": {
                        "price": 228.50261132342325,
                        "volume_24h": 11797592756.750008,
                        "percent_change_1h": 1.59758484,
                        "percent_change_24h": -14.79151276,
                        "percent_change_7d": -19.76857095,
                        "percent_change_30d": 19.26530452,
                        "percent_change_60d": 3.19792,
                        "percent_change_90d": 62.41545624,
                        "market_cap": 15253101028.909618,
                        "last_updated": "2021-04-23T07:22:02.000Z"
                    }
                }
            }
        ],
        "USDC": [
            {
                "id": 3408,
                "name": "USD Coin",
                "symbol": "USDC",
                "slug": "usd-coin",
                "num_market_pairs": 904,
                "date_added": "2018-10-08T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "medium-of-exchange",
                        "name": "Medium of Exchange",
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
                    }
                ],
                "max_supply": null,
                "circulating_supply": 11243286480.251637,
                "total_supply": 11506590888.92955,
                "platform": {
                    "id": 1027,
                    "name": "Ethereum",
                    "symbol": "ETH",
                    "slug": "ethereum",
                    "token_address": "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
                },
                "is_active": 1,
                "cmc_rank": 13,
                "is_fiat": 0,
                "last_updated": "2021-04-23T07:22:05.000Z",
                "quote": {
                    "USD": {
                        "price": 0.99983883038686,
                        "volume_24h": 3736604892.1199985,
                        "percent_change_1h": -0.00067437,
                        "percent_change_24h": 0.00358253,
                        "percent_change_7d": -0.1040453,
                        "percent_change_30d": -0.13009169,
                        "percent_change_60d": -0.00618379,
                        "percent_change_90d": -0.026677,
                        "market_cap": 11241474404.119192,
                        "last_updated": "2021-04-23T07:22:05.000Z"
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
                "num_market_pairs": 12371,
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
                "circulating_supply": 49280887016.94168,
                "total_supply": 51866290994.32977,
                "platform": {
                    "id": 1027,
                    "name": "Ethereum",
                    "symbol": "ETH",
                    "slug": "ethereum",
                    "token_address": "0xdac17f958d2ee523a2206206994597c13d831ec7"
                },
                "is_active": 1,
                "cmc_rank": 4,
                "is_fiat": 0,
                "last_updated": "2021-04-23T07:21:17.000Z",
                "quote": {
                    "USD": {
                        "price": 0.99987758506437,
                        "volume_24h": 206767906340.66824,
                        "percent_change_1h": 0.00492785,
                        "percent_change_24h": -0.00228216,
                        "percent_change_7d": -0.21964332,
                        "percent_change_30d": -0.12660026,
                        "percent_change_60d": -0.02589995,
                        "percent_change_90d": -0.17848235,
                        "market_cap": 49274854300.32971,
                        "last_updated": "2021-04-23T07:21:17.000Z"
                    }
                }
            }
        ]
    }
}
""";