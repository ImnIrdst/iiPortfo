import 'package:iiportfo/data/coin_market_cap_api.dart';
import 'package:iiportfo/data/csv_data.dart';
import 'package:iiportfo/data/nobitex_api.dart';
import 'package:iiportfo/utils/iterable_utils.dart';

class PortfoItemData {
  final int rank;
  final String name;
  final Uri imageUrl;
  final double priceUSD;
  final double priceIRR;

  PortfoItemData({
    this.rank,
    this.imageUrl,
    this.name,
    this.priceUSD,
    this.priceIRR,
  });
}

Future<List<PortfoItemData>> getPortfolioItems() async {
  final cryptos = CryptoPortfolio.getCryptoPortfolioItems();
  final symbols = cryptos.map((e) => e.symbol).toList();
  final quotes = await CoinMarketCapAPI.getQuotes(symbols);
  final usdt = await NobitexAPI.getUSDTPriceInIRR();

  return quotes.mapIndexed(
    (q, i) {
      print("q.imageUrl");
      return PortfoItemData(
        rank: q.rank,
        name: q.name,
        imageUrl: q.imageUrl,
        priceUSD: q.priceUSD * cryptos[i].amount,
        priceIRR: q.priceUSD * cryptos[i].amount * usdt,
      );
    },
  ).toList();
}
