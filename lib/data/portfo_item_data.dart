import 'package:iiportfo/data/api/coin_market_cap_api.dart';
import 'package:iiportfo/data/api/nobitex_api.dart';
import 'package:iiportfo/data/transaction_helper.dart';
import 'package:iiportfo/utils/iterable_utils.dart';

const IRR_SYMBOL = "IRR";

class PortfoItemData extends Comparable<PortfoItemData> {
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

  @override
  int compareTo(PortfoItemData other) {
    return other.totalUSD.compareTo(totalUSD);
  }
}

Future<List<PortfoItemData>> getPortfolioItems(bool loadFromCache) async {
  final aggregatedData = await TransactionHelper.getAggregatedData();
  final symbols = aggregatedData.map((e) => e.symbol).toList();
  final quotes = await CoinMarketCapAPI.getQuotes(symbols, loadFromCache);
  final usdt = await NobitexAPI.getCurrentUSDTPriceInIRR(loadFromCache);

  final portfoItems = quotes.mapIndexed(
    (q, i) {
      return PortfoItemData(
        rank: q.rank,
        name: q.name,
        symbol: q.symbol,
        imageUrl: q.imageUrl,
        currentPriceUSD: q.priceUSD,
        buyPriceUSD: aggregatedData[i].averageBuyPrice,
        percentChange24hUSD: q.percentChange24hUSD / 100,
        amount: aggregatedData[i].amount,
        usdtPrice: usdt,
      );
    },
  ).toList();

  portfoItems.sort();
  return portfoItems;
}
