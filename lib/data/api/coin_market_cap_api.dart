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
        "timestamp": "2021-04-23T14:24:29.969Z",
        "error_code": 0,
        "error_message": null,
        "elapsed": 23,
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
                "last_updated": "2021-04-23T14:23:10.000Z",
                "quote": {
                    "USD": {
                        "price": 1.08246491412043,
                        "volume_24h": 7687222849.923452,
                        "percent_change_1h": -2.38540647,
                        "percent_change_24h": -11.93907044,
                        "percent_change_7d": -21.88914918,
                        "percent_change_30d": -6.20238023,
                        "percent_change_60d": 11.44262999,
                        "percent_change_90d": 215.20542343,
                        "market_cap": 34582924035.07199,
                        "last_updated": "2021-04-23T14:23:10.000Z"
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
                "last_updated": "2021-04-23T14:23:08.000Z",
                "quote": {
                    "USD": {
                        "price": 785.3669097627898,
                        "volume_24h": 8334256278.136966,
                        "percent_change_1h": -0.92764981,
                        "percent_change_24h": -17.33132443,
                        "percent_change_7d": -10.71253765,
                        "percent_change_30d": 48.76755779,
                        "percent_change_60d": 23.23275569,
                        "percent_change_90d": 83.84168728,
                        "market_cap": 14699349217.834372,
                        "last_updated": "2021-04-23T14:23:08.000Z"
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
                "last_updated": "2021-04-23T14:23:09.000Z",
                "quote": {
                    "USD": {
                        "price": 501.90213012027954,
                        "volume_24h": 10289624229.646194,
                        "percent_change_1h": -2.09202781,
                        "percent_change_24h": -12.3764636,
                        "percent_change_7d": -1.55665882,
                        "percent_change_30d": 87.48219854,
                        "percent_change_60d": 101.60534975,
                        "percent_change_90d": 1150.45080243,
                        "market_cap": 77008297834.82545,
                        "last_updated": "2021-04-23T14:23:09.000Z"
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
                "last_updated": "2021-04-23T14:24:02.000Z",
                "quote": {
                    "USD": {
                        "price": 49397.66306329058,
                        "volume_24h": 95102654163.04279,
                        "percent_change_1h": -1.00421746,
                        "percent_change_24h": -10.41965968,
                        "percent_change_7d": -19.18170032,
                        "percent_change_30d": -13.47138256,
                        "percent_change_60d": -6.57703395,
                        "percent_change_90d": 54.69794896,
                        "market_cap": 923205274405.6035,
                        "last_updated": "2021-04-23T14:24:02.000Z"
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
                "last_updated": "2021-04-23T14:24:02.000Z",
                "quote": {
                    "USD": {
                        "price": 2265.8188149467037,
                        "volume_24h": 61665777962.50535,
                        "percent_change_1h": -0.5276569,
                        "percent_change_24h": -12.06549435,
                        "percent_change_7d": -5.46518561,
                        "percent_change_30d": 30.57081653,
                        "percent_change_60d": 28.31465603,
                        "percent_change_90d": 84.73131924,
                        "market_cap": 261900495834.182,
                        "last_updated": "2021-04-23T14:24:02.000Z"
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
                "last_updated": "2021-04-23T14:24:02.000Z",
                "quote": {
                    "USD": {
                        "price": 232.98831206585226,
                        "volume_24h": 11386621189.114895,
                        "percent_change_1h": -0.83516231,
                        "percent_change_24h": -16.80508326,
                        "percent_change_7d": -15.54830136,
                        "percent_change_30d": 18.30263386,
                        "percent_change_60d": 13.7680845,
                        "percent_change_90d": 69.15634199,
                        "market_cap": 15552532384.260221,
                        "last_updated": "2021-04-23T14:24:02.000Z"
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
                "last_updated": "2021-04-23T14:24:05.000Z",
                "quote": {
                    "USD": {
                        "price": 1.00002272912771,
                        "volume_24h": 4139852449.1902504,
                        "percent_change_1h": -0.00739892,
                        "percent_change_24h": 0.00806089,
                        "percent_change_7d": -0.12393409,
                        "percent_change_30d": 0.01615821,
                        "percent_change_60d": 0.00883927,
                        "percent_change_90d": -0.00080483,
                        "market_cap": 11243542030.345926,
                        "last_updated": "2021-04-23T14:24:05.000Z"
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
                "last_updated": "2021-04-23T14:23:10.000Z",
                "quote": {
                    "USD": {
                        "price": 1.00011646674296,
                        "volume_24h": 224207223843.8881,
                        "percent_change_1h": 0.00152221,
                        "percent_change_24h": 0.02857544,
                        "percent_change_7d": -0.22371615,
                        "percent_change_30d": 0.01975034,
                        "percent_change_60d": 0.08862748,
                        "percent_change_90d": -0.10478478,
                        "market_cap": 49286626601.34273,
                        "last_updated": "2021-04-23T14:23:10.000Z"
                    }
                }
            }
        ]
    }
}
""";