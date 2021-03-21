class CryptoPortfoItem {
  final String symbol;
  final double amount;

  CryptoPortfoItem({this.symbol, this.amount});
}

class CryptoPortfolio {
  static final csv = [
    "01,Bitcoin,BTC,1.02",
    "12,Bitcoin Cash,BCH,2.2",
    "09,Litecoin,LTC,2.04",
    "05,Cardano,ADA,212.9",
    "03,Binance Coin,BNB,2.7",
    "43,Hedera Hashgraph,HBAR,1",
    "24,Avalanche,AVAX,2.5",
    "18,VeChain,VET,21",
    "117,StormX,STMX,14",
    "52,Polygon,MATIC,100.86",
  ];

  static List<CryptoPortfoItem> getCryptoPortfolioItems() => csv
      .map(
        (row) => CryptoPortfoItem(
          symbol: row.split(",")[2],
          amount: double.parse(row.split(",")[3]),
        ),
      )
      .toList();
}
