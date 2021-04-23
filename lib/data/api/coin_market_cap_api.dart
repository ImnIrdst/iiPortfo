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
        "timestamp": "2021-04-23T14:37:18.729Z",
        "error_code": 0,
        "error_message": null,
        "elapsed": 29,
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
                "last_updated": "2021-04-23T14:36:12.000Z",
                "quote": {
                    "USD": {
                        "price": 1.09738438301091,
                        "volume_24h": 7736173109.196338,
                        "percent_change_1h": -0.1247199,
                        "percent_change_24h": -10.68144577,
                        "percent_change_7d": -20.83325781,
                        "percent_change_30d": -5.52158389,
                        "percent_change_60d": 12.88974802,
                        "percent_change_90d": 218.16048536,
                        "market_cap": 35059575843.876656,
                        "last_updated": "2021-04-23T14:36:12.000Z"
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
                "last_updated": "2021-04-23T14:36:09.000Z",
                "quote": {
                    "USD": {
                        "price": 796.7049655461763,
                        "volume_24h": 8371872023.1741705,
                        "percent_change_1h": 0.86420461,
                        "percent_change_24h": -16.1794882,
                        "percent_change_7d": -9.98364525,
                        "percent_change_30d": 50.57397189,
                        "percent_change_60d": 24.00372016,
                        "percent_change_90d": 86.14017782,
                        "market_cap": 14911558364.081215,
                        "last_updated": "2021-04-23T14:36:09.000Z"
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
                "last_updated": "2021-04-23T14:36:10.000Z",
                "quote": {
                    "USD": {
                        "price": 509.08217366090355,
                        "volume_24h": 10429874459.553057,
                        "percent_change_1h": 0.45737821,
                        "percent_change_24h": -11.33322197,
                        "percent_change_7d": -0.5873887,
                        "percent_change_30d": 89.58607451,
                        "percent_change_60d": 103.32162512,
                        "percent_change_90d": 1166.74324349,
                        "market_cap": 78109952715.84953,
                        "last_updated": "2021-04-23T14:36:10.000Z"
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
                "num_market_pairs": 9644,
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
                "circulating_supply": 18689250,
                "total_supply": 18689250,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 1,
                "is_fiat": 0,
                "last_updated": "2021-04-23T14:37:02.000Z",
                "quote": {
                    "USD": {
                        "price": 49782.33890315447,
                        "volume_24h": 95849627835.0886,
                        "percent_change_1h": 0.09061261,
                        "percent_change_24h": -9.81862829,
                        "percent_change_7d": -18.74700669,
                        "percent_change_30d": -13.06275367,
                        "percent_change_60d": -6.19769893,
                        "percent_change_90d": 55.7768518,
                        "market_cap": 930394577345.7797,
                        "last_updated": "2021-04-23T14:37:02.000Z"
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
                "last_updated": "2021-04-23T14:37:07.000Z",
                "quote": {
                    "USD": {
                        "price": 0.99981553725343,
                        "volume_24h": 12376098521.438763,
                        "percent_change_1h": 0.00024598,
                        "percent_change_24h": -0.03763824,
                        "percent_change_7d": -0.15187629,
                        "percent_change_30d": -0.05153371,
                        "percent_change_60d": 0.00155404,
                        "percent_change_90d": -0.00844712,
                        "market_cap": 5386023575.7767515,
                        "last_updated": "2021-04-23T14:37:07.000Z"
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
                "num_market_pairs": 6339,
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
                "circulating_supply": 115587572.1865,
                "total_supply": 115587572.1865,
                "is_active": 1,
                "platform": null,
                "cmc_rank": 2,
                "is_fiat": 0,
                "last_updated": "2021-04-23T14:37:02.000Z",
                "quote": {
                    "USD": {
                        "price": 2292.5750370378664,
                        "volume_24h": 62249756178.313774,
                        "percent_change_1h": 0.94328099,
                        "percent_change_24h": -11.18490653,
                        "percent_change_7d": -4.90297336,
                        "percent_change_30d": 31.84545728,
                        "percent_change_60d": 29.88144832,
                        "percent_change_90d": 85.8936085,
                        "market_cap": 264993182586.5823,
                        "last_updated": "2021-04-23T14:37:02.000Z"
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
                "last_updated": "2021-04-23T14:37:05.000Z",
                "quote": {
                    "USD": {
                        "price": 0.30174726302602,
                        "volume_24h": 127661187.41362618,
                        "percent_change_1h": 0.45856035,
                        "percent_change_24h": -21.57629448,
                        "percent_change_7d": -27.98547719,
                        "percent_change_30d": -24.85255547,
                        "percent_change_60d": -17.39742402,
                        "percent_change_90d": 816.2735074,
                        "market_cap": 767948677.2618018,
                        "last_updated": "2021-04-23T14:37:05.000Z"
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
                "last_updated": "2021-04-23T14:37:02.000Z",
                "quote": {
                    "USD": {
                        "price": 235.39449171495457,
                        "volume_24h": 11420969014.392878,
                        "percent_change_1h": 0.81802005,
                        "percent_change_24h": -16.18212763,
                        "percent_change_7d": -15.74019184,
                        "percent_change_30d": 19.42930937,
                        "percent_change_60d": 14.69625052,
                        "percent_change_90d": 69.84597948,
                        "market_cap": 15713150685.595589,
                        "last_updated": "2021-04-23T14:37:02.000Z"
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
                "cmc_rank": 89,
                "is_fiat": 0,
                "last_updated": "2021-04-23T14:36:09.000Z",
                "quote": {
                    "USD": {
                        "price": 0.09752868393058,
                        "volume_24h": 205375016.91340813,
                        "percent_change_1h": 1.13119853,
                        "percent_change_24h": -18.64944273,
                        "percent_change_7d": -30.71721528,
                        "percent_change_30d": -54.60777966,
                        "percent_change_60d": 282.46047468,
                        "percent_change_90d": 1244.72104387,
                        "market_cap": 917708099.6149205,
                        "last_updated": "2021-04-23T14:36:09.000Z"
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
                "cmc_rank": 667,
                "is_fiat": 0,
                "last_updated": "2021-04-23T14:37:05.000Z",
                "quote": {
                    "USD": {
                        "price": 0.00315966049391,
                        "volume_24h": 193457.24846325,
                        "percent_change_1h": -0.2514119,
                        "percent_change_24h": -14.1707846,
                        "percent_change_7d": -23.31689919,
                        "percent_change_30d": -16.78432952,
                        "percent_change_60d": -28.10875999,
                        "percent_change_90d": 99.14175141,
                        "market_cap": 29855888.046884052,
                        "last_updated": "2021-04-23T14:37:05.000Z"
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
                "cmc_rank": 14,
                "is_fiat": 0,
                "last_updated": "2021-04-23T14:37:05.000Z",
                "quote": {
                    "USD": {
                        "price": 1.00007961598327,
                        "volume_24h": 4175131429.6941133,
                        "percent_change_1h": -0.01140183,
                        "percent_change_24h": 0.02391654,
                        "percent_change_7d": -0.12338523,
                        "percent_change_30d": -0.00423134,
                        "percent_change_60d": 0.01634631,
                        "percent_change_90d": 0.0007107,
                        "market_cap": 11244181625.55995,
                        "last_updated": "2021-04-23T14:37:05.000Z"
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
                "num_market_pairs": 12374,
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
                "cmc_rank": 5,
                "is_fiat": 0,
                "last_updated": "2021-04-23T14:36:10.000Z",
                "quote": {
                    "USD": {
                        "price": 0.99986808474258,
                        "volume_24h": 225360659018.98477,
                        "percent_change_1h": -0.02507985,
                        "percent_change_24h": -0.01724004,
                        "percent_change_7d": -0.29227928,
                        "percent_change_30d": -0.0309122,
                        "percent_change_60d": 0.07651287,
                        "percent_change_90d": -0.14005436,
                        "market_cap": 49274386116.04496,
                        "last_updated": "2021-04-23T14:36:10.000Z"
                    }
                }
            }
        ]
    }
}
""";