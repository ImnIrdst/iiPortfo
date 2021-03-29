import 'package:iiportfo/data/coin_market_cap_api.dart';
import 'package:iiportfo/data/csv_data.dart';
import 'package:iiportfo/data/nobitex_api.dart';
import 'package:iiportfo/utils/iterable_utils.dart';

class PortfoItemData {
  final int rank;
  final String name;
  final String symbol;
  final Uri imageUrl;
  final double priceUSD;
  final double buyPriceUSD;
  final double percentChange24hUSD;
  final double totalUSD;
  final double totalIRR;

  PortfoItemData({
    this.rank,
    this.imageUrl,
    this.name,
    this.symbol,
    this.priceUSD,
    this.buyPriceUSD,
    this.percentChange24hUSD,
    this.totalUSD,
    this.totalIRR,
  });

  double get profitLossPercent => (totalUSD - buyPriceUSD) / buyPriceUSD;

  double get profitLossUSD => totalUSD - buyPriceUSD;
}

Future<List<PortfoItemData>> getPortfolioItems() async {
  final cryptos = CryptoPortfolio.getCryptoPortfolioItems();
  final symbols = cryptos.map((e) => e.symbol).toList();
  final quotes = await CoinMarketCapAPI.getQuotes(symbols);
  final usdt = await NobitexAPI.getUSDTPriceInIRR();

  return quotes.mapIndexed(
    (q, i) {
      return PortfoItemData(
        rank: q.rank,
        name: q.name,
        symbol: q.symbol,
        imageUrl: q.imageUrl,
        priceUSD: q.priceUSD,
        buyPriceUSD: cryptos[i].buyPrice,
        percentChange24hUSD: q.percentChange24hUSD / 100,
        totalUSD: q.priceUSD * cryptos[i].amount,
        totalIRR: q.priceUSD * cryptos[i].amount * usdt,
      );
    },
  ).toList();
}
