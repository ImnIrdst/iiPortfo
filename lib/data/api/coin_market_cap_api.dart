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
        "timestamp": "2021-04-23T15:06:49.201Z",
        "error_code": 0,
        "error_message": null,
        "elapsed": 34,
        "credit_count": 1,
        "notice": null
    },
    "data": {
        "ADA": [
            {
                "id": 2010,
                "name": "Cardano",
                "symbol": "ADA",
                "slug": "cardano",
                "num_market_pairs": 262,
                "date_added": "2017-10-01T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "mineable",
                        "name": "Mineable",
                        "category": "OTHER"
                    },
                    {
                        "slug": "dpos",
                        "name": "DPoS",
                        "category": "CONSENSUS_ALGORITHM"
                    },
                    {
                        "slug": "pos",
                        "name": "PoS",
                        "category": "CONSENSUS_ALGORITHM"
                    },
                    {
                        "slug": "platform",
                        "name": "Platform",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "research",
                        "name": "Research",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "smart-contracts",
                        "name": "Smart Contracts",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "staking",
                        "name": "Staking",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "binance-chain",
                        "name": "Binance Chain",
                        "category": "PLATFORM"
                    }
                ],
                "max_supply": 45000000000,
                "circulating_supply": 31948309440.7478,
                "total_supply": 45000000000,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 6,
                "is_fiat": 0,
                "last_updated": "2021-04-23T15:05:10.000Z",
                "quote": {
                    "USD": {
                        "price": 1.08561394911033,
                        "volume_24h": 7751361571.316628,
                        "percent_change_1h": 2.11988602,
                        "percent_change_24h": -11.307287,
                        "percent_change_7d": -21.03410885,
                        "percent_change_30d": -5.75888769,
                        "percent_change_60d": 12.72427531,
                        "percent_change_90d": 217.11664978,
                        "market_cap": 34683530379.36906,
                        "last_updated": "2021-04-23T15:05:10.000Z"
                    }
                }
            }
        ],
        "ARGON": [
            {
                "id": 8421,
                "name": "Argon",
                "symbol": "ARGON",
                "slug": "argon",
                "num_market_pairs": 4,
                "date_added": "2021-02-10T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "binance-smart-chain",
                        "name": "Binance Smart Chain",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": 100000000,
                "circulating_supply": 52509542.39676329,
                "total_supply": 99999999,
                "platform": {
                    "id": 1839,
                    "name": "Binance Smart Chain",
                    "symbol": "BNB",
                    "slug": "binance-coin",
                    "token_address": "0x851f7a700c5d67db59612b871338a85526752c25"
                },
                "is_active": 1,
                "cmc_rank": 1044,
                "is_fiat": 0,
                "last_updated": "2021-04-23T15:06:04.000Z",
                "quote": {
                    "USD": {
                        "price": 0.16737793444542,
                        "volume_24h": 3055583.78456372,
                        "percent_change_1h": 4.94739513,
                        "percent_change_24h": -36.62230572,
                        "percent_change_7d": 10.17689894,
                        "percent_change_30d": 36.73507418,
                        "percent_change_60d": 0,
                        "percent_change_90d": 0,
                        "market_cap": 8788938.745044447,
                        "last_updated": "2021-04-23T15:06:04.000Z"
                    }
                }
            }
        ],
        "ATOM": [
            {
                "id": 3794,
                "name": "Cosmos",
                "symbol": "ATOM",
                "slug": "cosmos",
                "num_market_pairs": 173,
                "date_added": "2019-03-14T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "platform",
                        "name": "Platform",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "cosmos-ecosystem",
                        "name": "Cosmos Ecosystem",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "content-creation",
                        "name": "Content Creation",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "interoperability",
                        "name": "Interoperability",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "binance-chain",
                        "name": "Binance Chain",
                        "category": "PLATFORM"
                    },
                    {
                        "slug": "polychain-capital-portfolio",
                        "name": "Polychain Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "dragonfly-capital-portfolio",
                        "name": "DragonFly Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "hashkey-capital-portfolio",
                        "name": "Hashkey Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "1confirmation-portfolio",
                        "name": "1Confirmation Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "paradigm-xzy-screener",
                        "name": "Paradigm XZY Screener",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "exnetwork-capital-portfolio",
                        "name": "Exnetwork Capital Portfolio",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": null,
                "circulating_supply": 210722437.316501,
                "total_supply": 268507040.316501,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 34,
                "is_fiat": 0,
                "last_updated": "2021-04-23T15:05:08.000Z",
                "quote": {
                    "USD": {
                        "price": 18.6821115313511,
                        "volume_24h": 1106355966.88014,
                        "percent_change_1h": 1.96194949,
                        "percent_change_24h": -9.87991379,
                        "percent_change_7d": -24.64797581,
                        "percent_change_30d": -4.17394769,
                        "percent_change_60d": -0.81989512,
                        "percent_change_90d": 128.77600965,
                        "market_cap": 3936740076.105013,
                        "last_updated": "2021-04-23T15:05:08.000Z"
                    }
                }
            },
            {
                "id": 1420,
                "name": "Atomic Coin",
                "symbol": "ATOM",
                "slug": "atomic-coin",
                "num_market_pairs": 0,
                "date_added": "2016-10-09T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "mineable",
                        "name": "Mineable",
                        "category": "OTHER"
                    },
                    {
                        "slug": "hybrid-pow-pos",
                        "name": "Hybrid - PoW & PoS",
                        "category": "CONSENSUS_ALGORITHM"
                    },
                    {
                        "slug": "scrypt",
                        "name": "Scrypt",
                        "category": "CONSENSUS_ALGORITHM"
                    }
                ],
                "max_supply": 252000000,
                "circulating_supply": 18554847.3005747,
                "total_supply": 18554847.3005747,
                "is_active": 0,
                "platform": null,
                "cmc_rank": null,
                "is_fiat": 0,
                "last_updated": "2020-09-17T05:43:16.000Z",
                "quote": {
                    "USD": {
                        "price": 0.00014288,
                        "volume_24h": 0,
                        "percent_change_1h": 0,
                        "percent_change_24h": 0,
                        "percent_change_7d": 0,
                        "percent_change_30d": 0,
                        "percent_change_60d": 0,
                        "percent_change_90d": 0,
                        "market_cap": 2651.1165823061133,
                        "last_updated": "2020-09-17T05:43:16.000Z"
                    }
                }
            }
        ],
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
                "circulating_supply": 18716537.5,
                "total_supply": 18716537.5,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 11,
                "is_fiat": 0,
                "last_updated": "2021-04-23T15:05:08.000Z",
                "quote": {
                    "USD": {
                        "price": 788.0364216167478,
                        "volume_24h": 8365394258.39019,
                        "percent_change_1h": 1.38587315,
                        "percent_change_24h": -15.9211604,
                        "percent_change_7d": -7.95923664,
                        "percent_change_30d": 49.82896949,
                        "percent_change_60d": 25.72771024,
                        "percent_change_90d": 84.72853175,
                        "market_cap": 14749313236.555672,
                        "last_updated": "2021-04-23T15:05:08.000Z"
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
                "last_updated": "2021-04-23T15:05:10.000Z",
                "quote": {
                    "USD": {
                        "price": 500.2621187928505,
                        "volume_24h": 10291775523.616676,
                        "percent_change_1h": 1.3578781,
                        "percent_change_24h": -12.11312002,
                        "percent_change_7d": -1.07969707,
                        "percent_change_30d": 88.46457331,
                        "percent_change_60d": 103.96194947,
                        "percent_change_90d": 1148.99435958,
                        "market_cap": 76756666145.7452,
                        "last_updated": "2021-04-23T15:05:10.000Z"
                    }
                }
            }
        ],
        "BUSD": [
            {
                "id": 4687,
                "name": "Binance USD",
                "symbol": "BUSD",
                "slug": "binance-usd",
                "num_market_pairs": 591,
                "date_added": "2019-09-20T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "store-of-value",
                        "name": "Store of Value",
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
                        "slug": "binance-chain",
                        "name": "Binance Chain",
                        "category": "PLATFORM"
                    },
                    {
                        "slug": "binance-smart-chain",
                        "name": "Binance Smart Chain",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": null,
                "circulating_supply": 5387017279.78,
                "total_supply": 5387017279.78,
                "platform": {
                    "id": 1839,
                    "name": "Binance Chain",
                    "symbol": "BNB",
                    "slug": "binance-coin",
                    "token_address": "BUSD-BD1"
                },
                "is_active": 1,
                "cmc_rank": 23,
                "is_fiat": 0,
                "last_updated": "2021-04-23T15:05:08.000Z",
                "quote": {
                    "USD": {
                        "price": 1.00002776766171,
                        "volume_24h": 12318962062.453201,
                        "percent_change_1h": -0.00636639,
                        "percent_change_24h": -0.01306774,
                        "percent_change_7d": -0.04197871,
                        "percent_change_30d": -0.10004977,
                        "percent_change_60d": 0.06281445,
                        "percent_change_90d": 0.01277804,
                        "market_cap": 5387166864.65345,
                        "last_updated": "2021-04-23T15:05:08.000Z"
                    }
                }
            }
        ],
        "DOT": [
            {
                "id": 6636,
                "name": "Polkadot",
                "symbol": "DOT",
                "slug": "polkadot-new",
                "num_market_pairs": 189,
                "date_added": "2020-08-19T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "substrate",
                        "name": "Substrate",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "polkadot",
                        "name": "Polkadot",
                        "category": "PLATFORM"
                    },
                    {
                        "slug": "binance-chain",
                        "name": "Binance Chain",
                        "category": "PLATFORM"
                    },
                    {
                        "slug": "polkadot-ecosystem",
                        "name": "Polkadot Ecosystem",
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
                        "slug": "coinfund-portfolio",
                        "name": "Coinfund Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "fabric-ventures-portfolio",
                        "name": "Fabric Ventures Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "fenbushi-capital-portfolio",
                        "name": "Fenbushi Capital Portfolio",
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
                        "slug": "1confirmation-portfolio",
                        "name": "1Confirmation Portfolio",
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
                        "slug": "exnetwork-capital-portfolio",
                        "name": "Exnetwork Capital Portfolio",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": null,
                "circulating_supply": 932032928.0378042,
                "total_supply": 1067557042.8919921,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 8,
                "is_fiat": 0,
                "last_updated": "2021-04-23T15:06:07.000Z",
                "quote": {
                    "USD": {
                        "price": 31.17985776272499,
                        "volume_24h": 4941393326.073615,
                        "percent_change_1h": 2.80516628,
                        "percent_change_24h": -11.06713059,
                        "percent_change_7d": -24.04167913,
                        "percent_change_30d": -13.04994925,
                        "percent_change_60d": -10.00338408,
                        "percent_change_90d": 78.61708112,
                        "market_cap": 29060654126.394833,
                        "last_updated": "2021-04-23T15:06:07.000Z"
                    }
                }
            }
        ],
        "EGLD": [
            {
                "id": 6892,
                "name": "Elrond",
                "symbol": "EGLD",
                "slug": "elrond-egld",
                "num_market_pairs": 37,
                "date_added": "2020-09-04T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "binance-launchpad",
                        "name": "Binance Launchpad",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "binance-labs-portfolio",
                        "name": "Binance Labs Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "electric-capital-portfolio",
                        "name": "Electric Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "exnetwork-capital-portfolio",
                        "name": "Exnetwork Capital Portfolio",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": 31415926,
                "circulating_supply": 17336942.0245636,
                "total_supply": 21574126,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 44,
                "is_fiat": 0,
                "last_updated": "2021-04-23T15:05:08.000Z",
                "quote": {
                    "USD": {
                        "price": 158.4798483869328,
                        "volume_24h": 263223326.20145124,
                        "percent_change_1h": 0.46622696,
                        "percent_change_24h": -13.13503279,
                        "percent_change_7d": -23.2576261,
                        "percent_change_30d": 18.91430026,
                        "percent_change_60d": 27.78972902,
                        "percent_change_90d": 328.89993564,
                        "market_cap": 2747555943.5458827,
                        "last_updated": "2021-04-23T15:05:08.000Z"
                    }
                }
            }
        ],
        "FTM": [
            {
                "id": 3513,
                "name": "Fantom",
                "symbol": "FTM",
                "slug": "fantom",
                "num_market_pairs": 52,
                "date_added": "2018-10-29T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "platform",
                        "name": "Platform",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "enterprise-solutions",
                        "name": "Enterprise solutions",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "defi",
                        "name": "DeFi",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "research",
                        "name": "Research",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "scaling",
                        "name": "Scaling",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "smart-contracts",
                        "name": "Smart Contracts",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": 3175000000,
                "circulating_supply": 2545006273,
                "total_supply": 2545006273,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 95,
                "is_fiat": 0,
                "last_updated": "2021-04-23T15:06:05.000Z",
                "quote": {
                    "USD": {
                        "price": 0.30002420958486,
                        "volume_24h": 128331637.02298363,
                        "percent_change_1h": 3.56824194,
                        "percent_change_24h": -20.93681904,
                        "percent_change_7d": -27.36830338,
                        "percent_change_30d": -24.85217547,
                        "percent_change_60d": -15.9956039,
                        "percent_change_90d": 838.60562465,
                        "market_cap": 763563495.4453354,
                        "last_updated": "2021-04-23T15:06:05.000Z"
                    }
                }
            }
        ],
        "LINK": [
            {
                "id": 1975,
                "name": "Chainlink",
                "symbol": "LINK",
                "slug": "chainlink",
                "num_market_pairs": 498,
                "date_added": "2017-09-20T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "platform",
                        "name": "Platform",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "defi",
                        "name": "DeFi",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "oracles",
                        "name": "Oracles",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "smart-contracts",
                        "name": "Smart Contracts",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "substrate",
                        "name": "Substrate",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "polkadot",
                        "name": "Polkadot",
                        "category": "PLATFORM"
                    },
                    {
                        "slug": "polkadot-ecosystem",
                        "name": "Polkadot Ecosystem",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "solana-ecosystem",
                        "name": "Solana Ecosystem",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "framework-ventures",
                        "name": "Framework Ventures",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": 1000000000,
                "circulating_supply": 419009556.43444455,
                "total_supply": 1000000000,
                "platform": {
                    "id": 1027,
                    "name": "Ethereum",
                    "symbol": "ETH",
                    "slug": "ethereum",
                    "token_address": "0x514910771af9ca656af840dff83e8264ecf986ca"
                },
                "is_active": 1,
                "cmc_rank": 12,
                "is_fiat": 0,
                "last_updated": "2021-04-23T15:05:10.000Z",
                "quote": {
                    "USD": {
                        "price": 32.98300189093667,
                        "volume_24h": 4248054335.2414207,
                        "percent_change_1h": 2.82876739,
                        "percent_change_24h": -15.58410218,
                        "percent_change_7d": -16.66745604,
                        "percent_change_30d": 19.38029074,
                        "percent_change_60d": 10.89660286,
                        "percent_change_90d": 38.21773112,
                        "market_cap": 13820192992.19782,
                        "last_updated": "2021-04-23T15:05:10.000Z"
                    }
                }
            }
        ],
        "ONE": [
            {
                "id": 3945,
                "name": "Harmony",
                "symbol": "ONE",
                "slug": "harmony",
                "num_market_pairs": 34,
                "date_added": "2019-06-01T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "platform",
                        "name": "Platform",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "enterprise-solutions",
                        "name": "Enterprise solutions",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "scaling",
                        "name": "Scaling",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "binance-launchpad",
                        "name": "Binance Launchpad",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "binance-labs-portfolio",
                        "name": "Binance Labs Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "hashkey-capital-portfolio",
                        "name": "Hashkey Capital Portfolio",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": 12600000000,
                "circulating_supply": 9409622509.293127,
                "total_supply": 13002578509.293139,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 91,
                "is_fiat": 0,
                "last_updated": "2021-04-23T15:05:09.000Z",
                "quote": {
                    "USD": {
                        "price": 0.09472799968071,
                        "volume_24h": 203128413.66627452,
                        "percent_change_1h": 2.97729161,
                        "percent_change_24h": -19.98696189,
                        "percent_change_7d": -32.22675869,
                        "percent_change_30d": -55.1972553,
                        "percent_change_60d": 282.56207895,
                        "percent_change_90d": 1208.53293469,
                        "market_cap": 891354718.055921,
                        "last_updated": "2021-04-23T15:05:09.000Z"
                    }
                }
            },
            {
                "id": 2324,
                "name": "BigONE Token",
                "symbol": "ONE",
                "slug": "bigone-token",
                "num_market_pairs": 5,
                "date_added": "2017-12-30T00:00:00.000Z",
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
                    }
                ],
                "max_supply": 13508522147.21,
                "circulating_supply": 9449081034,
                "total_supply": 6689417418.392,
                "platform": {
                    "id": 1027,
                    "name": "Ethereum",
                    "symbol": "ETH",
                    "slug": "ethereum",
                    "token_address": "0x946551dd05c5abd7cc808927480225ce36d8c475"
                },
                "is_active": 1,
                "cmc_rank": 660,
                "is_fiat": 0,
                "last_updated": "2021-04-23T15:06:05.000Z",
                "quote": {
                    "USD": {
                        "price": 0.00320474762915,
                        "volume_24h": 196279.62833332,
                        "percent_change_1h": 3.28058732,
                        "percent_change_24h": -13.72041496,
                        "percent_change_7d": -20.73676972,
                        "percent_change_30d": -15.56379849,
                        "percent_change_60d": -25.96071069,
                        "percent_change_90d": 97.50324582,
                        "market_cap": 30281920.04135773,
                        "last_updated": "2021-04-23T15:06:05.000Z"
                    }
                }
            },
            {
                "id": 710,
                "name": "1Coin",
                "symbol": "ONE",
                "slug": "1coin",
                "num_market_pairs": 0,
                "date_added": "2014-11-01T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "mineable",
                        "name": "Mineable",
                        "category": "OTHER"
                    }
                ],
                "max_supply": null,
                "circulating_supply": 1383619.2,
                "total_supply": 1383619.2,
                "is_active": 0,
                "platform": null,
                "cmc_rank": null,
                "is_fiat": 0,
                "last_updated": "2016-03-22T19:54:18.000Z",
                "quote": {
                    "USD": {
                        "price": 0.00086611,
                        "volume_24h": 0,
                        "percent_change_1h": 0,
                        "percent_change_24h": 0,
                        "percent_change_7d": 0,
                        "percent_change_30d": 0,
                        "percent_change_60d": 0,
                        "percent_change_90d": 0,
                        "market_cap": 1198.366425312,
                        "last_updated": "2016-03-22T19:54:18.000Z"
                    }
                }
            },
            {
                "id": 3603,
                "name": "Menlo One",
                "symbol": "ONE",
                "slug": "menlo-one",
                "num_market_pairs": 1,
                "date_added": "2018-11-09T00:00:00.000Z",
                "tags": [],
                "max_supply": null,
                "circulating_supply": 300404657.917,
                "total_supply": 1000000000,
                "platform": {
                    "id": 1027,
                    "name": "Ethereum",
                    "symbol": "ETH",
                    "slug": "ethereum",
                    "token_address": "0x4d807509aece24c0fa5a102b6a3b059ec6e14392"
                },
                "is_active": 0,
                "cmc_rank": null,
                "is_fiat": 0,
                "last_updated": "2020-10-23T03:17:47.000Z",
                "quote": {
                    "USD": {
                        "price": 0.00186852815193,
                        "volume_24h": 0,
                        "percent_change_1h": 0.75613908,
                        "percent_change_24h": 5.17398928,
                        "percent_change_7d": 9.44229977,
                        "percent_change_30d": 0,
                        "percent_change_60d": 0,
                        "percent_change_90d": 0,
                        "market_cap": 561314.5602888159,
                        "last_updated": "2020-10-23T03:17:47.000Z"
                    }
                }
            }
        ],
        "XTZ": [
            {
                "id": 2011,
                "name": "Tezos",
                "symbol": "XTZ",
                "slug": "tezos",
                "num_market_pairs": 164,
                "date_added": "2017-10-06T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "platform",
                        "name": "Platform",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "enterprise-solutions",
                        "name": "Enterprise solutions",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "smart-contracts",
                        "name": "Smart Contracts",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "binance-chain",
                        "name": "Binance Chain",
                        "category": "PLATFORM"
                    },
                    {
                        "slug": "polychain-capital-portfolio",
                        "name": "Polychain Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "boostvc-portfolio",
                        "name": "BoostVC Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "winklevoss-capital",
                        "name": "Winklevoss Capital",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": null,
                "circulating_supply": 767414739.048991,
                "total_supply": 767414739.048991,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 38,
                "is_fiat": 0,
                "last_updated": "2021-04-23T15:05:10.000Z",
                "quote": {
                    "USD": {
                        "price": 4.56714746817816,
                        "volume_24h": 806592127.3683522,
                        "percent_change_1h": 2.44534994,
                        "percent_change_24h": -17.50177857,
                        "percent_change_7d": -32.50663151,
                        "percent_change_30d": 3.25293091,
                        "percent_change_60d": 12.14896276,
                        "percent_change_90d": 43.42191897,
                        "market_cap": 3504896282.490202,
                        "last_updated": "2021-04-23T15:05:10.000Z"
                    }
                }
            }
        ],
        "YFI": [
            {
                "id": 5864,
                "name": "yearn.finance",
                "symbol": "YFI",
                "slug": "yearn-finance",
                "num_market_pairs": 239,
                "date_added": "2020-07-18T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "defi",
                        "name": "DeFi",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "yield-farming",
                        "name": "Yield farming",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "yield-aggregator",
                        "name": "Yield Aggregator",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "yearn-partnerships",
                        "name": "Yearn Partnerships",
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
                        "slug": "governance",
                        "name": "Governance",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "blockchain-capital-portfolio",
                        "name": "Blockchain Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "framework-ventures",
                        "name": "Framework Ventures",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "alameda-research-portfolio",
                        "name": "Alameda Research Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "parafi-capital",
                        "name": "ParaFi capital",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": 36666,
                "circulating_supply": 36634.94063504,
                "total_supply": 36666,
                "platform": {
                    "id": 1027,
                    "name": "Ethereum",
                    "symbol": "ETH",
                    "slug": "ethereum",
                    "token_address": "0x0bc529c00c6401aef6d220be8c6ea1667f6ad93e"
                },
                "is_active": 1,
                "cmc_rank": 68,
                "is_fiat": 0,
                "last_updated": "2021-04-23T15:05:08.000Z",
                "quote": {
                    "USD": {
                        "price": 41981.547492225334,
                        "volume_24h": 814386038.5558213,
                        "percent_change_1h": 1.70353269,
                        "percent_change_24h": -16.49925322,
                        "percent_change_7d": -10.05978026,
                        "percent_change_30d": 22.34309765,
                        "percent_change_60d": 13.38720642,
                        "percent_change_90d": 39.32234337,
                        "market_cap": 1537991500.1447875,
                        "last_updated": "2021-04-23T15:05:08.000Z"
                    }
                }
            }
        ]
    }
}
""";