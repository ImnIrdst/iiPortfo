import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iiportfo/utils/datetime_utils.dart';

class Quote {
  final int rank;
  final String name;
  final double priceUSD;

  Quote({this.rank, this.name, this.priceUSD});
}

class NobitexAPI {
  // url = "https://api.nobitex.ir/market/udf/history?symbol=%s&resolution=60&from=%.0f&to=%.0f" \
  // % (coin, start.timestamp(), end.timestamp())
  static final baseUrl = "api.nobitex.ir";
  static final quotesApiUrl = "/market/udf/history";
  static final marketStatsApiUrl = "/market/stats";

  static Future<double> getUSDTPriceInIRR(DateTime to) async {
    final from = to.subtract(Duration(hours: 1));

    final url = Uri.https(baseUrl, quotesApiUrl, {
      "symbol": "USDTIRT",
      "resolution": 60.toString(),
      "from": from.toPosix().toString(),
      "to": to.toPosix().toString(),
    });

    final response = await http.get(url);

    final json = jsonDecode(response.body);
    final double c = json['c'][0];
    final double o = json['o'][0];

    return ((c + o) / 2);
  }

  static Future<double> getDayChange() async {
    final url = Uri.https(baseUrl, marketStatsApiUrl);

    final response = await http.post(
      url,
      body: {"srcCurrency": "usdt", "dstCurrency": "rls"},
    );

    final json = jsonDecode(response.body);
    final double percentChange =
        double.parse(json["stats"]["usdt-rls"]["dayChange"]);

    return percentChange / 100;
  }
}

// https://api.nobitex.ir/market/udf/history?symbol=USDTIRR&resolution=60&from=1616325535&to=1616329135
// https://api.nobitex.ir/market/udf/history?symbol=USDTIRT&resolution=60&from=1616328600&to=1616332200
final mockResponseBody = """
{
    "status": {
        "timestamp": "2021-03-21T12:52:32.470Z",
        "error_code": 0,
        "error_message": null,
        "elapsed": 41,
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
                "num_market_pairs": 260,
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
                "circulating_supply": 31948309440.747814,
                "total_supply": 45000000000,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 5,
                "is_fiat": 0,
                "last_updated": "2021-03-21T12:51:09.000Z",
                "quote": {
                    "USD": {
                        "price": 1.17924797479276,
                        "volume_24h": 4578737893.830224,
                        "percent_change_1h": -1.60431699,
                        "percent_change_24h": -7.24736805,
                        "percent_change_7d": 9.51512941,
                        "percent_change_30d": 25.56473347,
                        "percent_change_60d": 247.85532493,
                        "percent_change_90d": 675.81580374,
                        "market_cap": 37674979206.054276,
                        "last_updated": "2021-03-21T12:51:09.000Z"
                    }
                }
            }
        ],
        "AVAX": [
            {
                "id": 5805,
                "name": "Avalanche",
                "symbol": "AVAX",
                "slug": "avalanche",
                "num_market_pairs": 55,
                "date_added": "2020-07-13T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "defi",
                        "name": "DeFi",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "polychain-capital-portfolio",
                        "name": "Polychain Capital Portfolio",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "avalanche-ecosystem",
                        "name": "Avalanche Ecosystem",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": 720000000,
                "circulating_supply": 127747425.63305873,
                "total_supply": 381913460.6330587,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 24,
                "is_fiat": 0,
                "last_updated": "2021-03-21T12:51:07.000Z",
                "quote": {
                    "USD": {
                        "price": 32.60366319520278,
                        "volume_24h": 338946154.33710414,
                        "percent_change_1h": -1.12255178,
                        "percent_change_24h": -10.94683117,
                        "percent_change_7d": 5.73686888,
                        "percent_change_30d": -17.90959296,
                        "percent_change_60d": 187.15245865,
                        "percent_change_90d": 952.00336259,
                        "market_cap": 4165034039.3944607,
                        "last_updated": "2021-03-21T12:51:07.000Z"
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
                "num_market_pairs": 595,
                "date_added": "2017-07-23T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "mineable",
                        "name": "Mineable",
                        "category": "OTHER"
                    },
                    {
                        "slug": "marketplace",
                        "name": "Marketplace",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "enterprise-solutions",
                        "name": "Enterprise solutions",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "binance-chain",
                        "name": "Binance Chain",
                        "category": "PLATFORM"
                    }
                ],
                "max_supply": 21000000,
                "circulating_supply": 18685668.75,
                "total_supply": 18685668.75,
                "platform": {
                    "id": 2502,
                    "name": "Heco",
                    "symbol": "HT",
                    "slug": "huobi-token",
                    "token_address": "0xef3cebd77e0c52cb6f60875d9306397b5caca375"
                },
                "is_active": 1,
                "cmc_rank": 12,
                "is_fiat": 0,
                "last_updated": "2021-03-21T12:51:09.000Z",
                "quote": {
                    "USD": {
                        "price": 521.3079363631248,
                        "volume_24h": 2289016400.557901,
                        "percent_change_1h": -0.32516877,
                        "percent_change_24h": -5.42547058,
                        "percent_change_7d": -9.17253878,
                        "percent_change_30d": -27.69539593,
                        "percent_change_60d": 8.77085722,
                        "percent_change_90d": 62.0912232,
                        "market_cap": 9740987415.62743,
                        "last_updated": "2021-03-21T12:51:09.000Z"
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
                "num_market_pairs": 604,
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
                    }
                ],
                "max_supply": 170532785,
                "circulating_supply": 154532785,
                "total_supply": 170532785,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 3,
                "is_fiat": 0,
                "last_updated": "2021-03-21T12:51:09.000Z",
                "quote": {
                    "USD": {
                        "price": 260.2144186398784,
                        "volume_24h": 1890596308.9152966,
                        "percent_change_1h": -0.60875857,
                        "percent_change_24h": -3.80181708,
                        "percent_change_7d": -3.48125242,
                        "percent_change_30d": -1.22822602,
                        "percent_change_60d": 537.82908275,
                        "percent_change_90d": 699.45757212,
                        "market_cap": 40211658809.57632,
                        "last_updated": "2021-03-21T12:51:09.000Z"
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
                "num_market_pairs": 9894,
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
                    }
                ],
                "max_supply": 21000000,
                "circulating_supply": 18660062,
                "total_supply": 18660062,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 1,
                "is_fiat": 0,
                "last_updated": "2021-03-21T12:52:02.000Z",
                "quote": {
                    "USD": {
                        "price": 56315.90502765266,
                        "volume_24h": 56441004127.135666,
                        "percent_change_1h": -0.12838752,
                        "percent_change_24h": -5.23269963,
                        "percent_change_7d": -6.25636405,
                        "percent_change_30d": 6.84202008,
                        "percent_change_60d": 63.62914826,
                        "percent_change_90d": 147.71939669,
                        "market_cap": 1050858279402.1104,
                        "last_updated": "2021-03-21T12:52:02.000Z"
                    }
                }
            }
        ],
        "HBAR": [
            {
                "id": 4642,
                "name": "Hedera Hashgraph",
                "symbol": "HBAR",
                "slug": "hedera-hashgraph",
                "num_market_pairs": 47,
                "date_added": "2019-09-17T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "dag",
                        "name": "DAG",
                        "category": "CONSENSUS_ALGORITHM"
                    },
                    {
                        "slug": "marketplace",
                        "name": "Marketplace",
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
                    }
                ],
                "max_supply": null,
                "circulating_supply": 7547263258,
                "total_supply": 50000000000,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 41,
                "is_fiat": 0,
                "last_updated": "2021-03-21T12:52:06.000Z",
                "quote": {
                    "USD": {
                        "price": 0.31632964978906,
                        "volume_24h": 231609592.49299467,
                        "percent_change_1h": -1.63817319,
                        "percent_change_24h": -8.78483763,
                        "percent_change_7d": -10.20638964,
                        "percent_change_30d": 112.96836513,
                        "percent_change_60d": 251.00646966,
                        "percent_change_90d": 807.59016341,
                        "market_cap": 2387423143.26898,
                        "last_updated": "2021-03-21T12:52:06.000Z"
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
                "num_market_pairs": 769,
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
                "circulating_supply": 66700964.51538747,
                "total_supply": 66700964.51538747,
                "platform": {
                    "id": 2502,
                    "name": "Heco",
                    "symbol": "HT",
                    "slug": "huobi-token",
                    "token_address": "0xecb56cf772b5c9a6907fb7d32387da2fcbfb63b4"
                },
                "is_active": 1,
                "cmc_rank": 9,
                "is_fiat": 0,
                "last_updated": "2021-03-21T12:52:02.000Z",
                "quote": {
                    "USD": {
                        "price": 194.7484440539725,
                        "volume_24h": 2779590856.664118,
                        "percent_change_1h": -0.17961432,
                        "percent_change_24h": -5.37687966,
                        "percent_change_7d": -11.0792149,
                        "percent_change_30d": -16.14541032,
                        "percent_change_60d": 36.8791298,
                        "percent_change_90d": 84.24786499,
                        "market_cap": 12989909056.27094,
                        "last_updated": "2021-03-21T12:52:02.000Z"
                    }
                }
            }
        ],
        "MATIC": [
            {
                "id": 3890,
                "name": "Polygon",
                "symbol": "MATIC",
                "slug": "polygon",
                "num_market_pairs": 103,
                "date_added": "2019-04-28T00:00:00.000Z",
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
                        "slug": "binance-launchpad",
                        "name": "Binance Launchpad",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": 10000000000,
                "circulating_supply": 5011255458,
                "total_supply": 10000000000,
                "platform": {
                    "id": 1027,
                    "name": "Ethereum",
                    "symbol": "ETH",
                    "slug": "ethereum",
                    "token_address": "0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0"
                },
                "is_active": 1,
                "cmc_rank": 53,
                "is_fiat": 0,
                "last_updated": "2021-03-21T12:51:08.000Z",
                "quote": {
                    "USD": {
                        "price": 0.37324469225386,
                        "volume_24h": 228972065.42559874,
                        "percent_change_1h": -1.51340471,
                        "percent_change_24h": -9.97434599,
                        "percent_change_7d": -3.69099684,
                        "percent_change_30d": 199.33818773,
                        "percent_change_60d": 1109.89033871,
                        "percent_change_90d": 1908.86443934,
                        "market_cap": 1870424501.2266862,
                        "last_updated": "2021-03-21T12:51:08.000Z"
                    }
                }
            }
        ],
        "STMX": [
            {
                "id": 2297,
                "name": "StormX",
                "symbol": "STMX",
                "slug": "stormx",
                "num_market_pairs": 15,
                "date_added": "2017-12-20T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "media",
                        "name": "Media",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "loyalty",
                        "name": "Loyalty",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": 10000000000,
                "circulating_supply": 8315901031.789724,
                "total_supply": 10000000000,
                "platform": {
                    "id": 1027,
                    "name": "Ethereum",
                    "symbol": "ETH",
                    "slug": "ethereum",
                    "token_address": "0xbE9375C6a420D2eEB258962efB95551A5b722803"
                },
                "is_active": 1,
                "cmc_rank": 113,
                "is_fiat": 0,
                "last_updated": "2021-03-21T12:52:04.000Z",
                "quote": {
                    "USD": {
                        "price": 0.06020372265613,
                        "volume_24h": 767035161.2039828,
                        "percent_change_1h": -4.64969607,
                        "percent_change_24h": -20.35256426,
                        "percent_change_7d": 164.22314034,
                        "percent_change_30d": 461.91775165,
                        "percent_change_60d": 2007.19454792,
                        "percent_change_90d": 2268.60124869,
                        "market_cap": 500648199.35369384,
                        "last_updated": "2021-03-21T12:52:04.000Z"
                    }
                }
            }
        ],
        "VET": [
            {
                "id": 3077,
                "name": "VeChain",
                "symbol": "VET",
                "slug": "vechain",
                "num_market_pairs": 124,
                "date_added": "2017-08-22T00:00:00.000Z",
                "tags": [
                    {
                        "slug": "logistics",
                        "name": "Logistics",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "data-provenance",
                        "name": "Data Provenance",
                        "category": "PROPERTY"
                    },
                    {
                        "slug": "smart-contracts",
                        "name": "Smart Contracts",
                        "category": "PROPERTY"
                    }
                ],
                "max_supply": 86712634466,
                "circulating_supply": 64315576989,
                "total_supply": 86712634466,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 18,
                "is_fiat": 0,
                "last_updated": "2021-03-21T12:52:02.000Z",
                "quote": {
                    "USD": {
                        "price": 0.09228880956702,
                        "volume_24h": 1544663548.30168,
                        "percent_change_1h": 0.5158004,
                        "percent_change_24h": 8.4263092,
                        "percent_change_7d": 40.36025649,
                        "percent_change_30d": 68.3059239,
                        "percent_change_60d": 196.7796864,
                        "percent_change_90d": 494.69942961,
                        "market_cap": 5935608036.930835,
                        "last_updated": "2021-03-21T12:52:02.000Z"
                    }
                }
            }
        ]
    }
}
""";
