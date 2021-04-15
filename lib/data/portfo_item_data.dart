import 'package:iiportfo/data/api/coin_market_cap_api.dart';
import 'package:iiportfo/data/api/nobitex_api.dart';
import 'package:iiportfo/data/csv/custom_csv_data.dart';
import 'package:iiportfo/data/csv/nobitex_csv_data.dart';
import 'package:iiportfo/utils/iterable_utils.dart';

class PortfoItemData {
  final int rank;
  final String name;
  final String symbol;
  final Uri imageUrl;
  final double currentPriceUSD;
  final double amount;
  final double buyPriceUSD;
  final double percentChange24hUSD;
  final double usdtPrice;

  PortfoItemData({
    this.rank,
    this.imageUrl,
    this.name,
    this.symbol,
    this.currentPriceUSD,
    this.amount,
    this.buyPriceUSD,
    this.percentChange24hUSD,
    this.usdtPrice,
  });

  double get totalUSD => amount * currentPriceUSD;

  double get totalIRR => totalUSD * usdtPrice;

  double get profitLossPercent => (currentPriceUSD - buyPriceUSD) / buyPriceUSD;

  double get profitLossUSD => (currentPriceUSD - buyPriceUSD) * amount;

  double get profitLossIRR => profitLossUSD * usdtPrice;
}

Future<List<PortfoItemData>> getPortfolioItems() async {
  final cryptos = CryptoPortfolio.getCryptoPortfolioItems();
  final symbols = cryptos.map((e) => e.symbol).toList();
  final quotes = await CoinMarketCapAPI.getQuotes(symbols);
  final usdt = await NobitexAPI.getUSDTPriceInIRR();
  final nobitexData = await NobitexTransactions.getItems();

  return quotes.mapIndexed(
    (q, i) {
      return PortfoItemData(
        rank: q.rank,
        name: q.name,
        symbol: q.symbol,
        imageUrl: q.imageUrl,
        currentPriceUSD: q.priceUSD,
        buyPriceUSD: cryptos[i].buyPrice,
        percentChange24hUSD: q.percentChange24hUSD / 100,
        amount: cryptos[i].amount,
        usdtPrice: usdt,
      );
    },
  ).toList();
}
