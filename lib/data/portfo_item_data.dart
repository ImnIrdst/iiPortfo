import 'package:iiportfo/data/coin_market_cap_api.dart';
import 'package:iiportfo/data/csv_data.dart';

class PortfoItemData {
  final int rank;
  final String name;
  final double priceUSD;

  PortfoItemData({this.rank, this.name, this.priceUSD});
}

Future<List<PortfoItemData>> getPortfolioItems() async {
  final symbols = getSymbols();
  final quotes = await CoinMarketCapAPI.getQuotes(symbols);

  return quotes
      .map(
        (q) => PortfoItemData(
          rank: q.rank,
          name: q.name,
          priceUSD: q.priceUSD,
        ),
      )
      .toList();
}
