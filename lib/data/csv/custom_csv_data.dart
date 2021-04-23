import 'package:iiportfo/data/portfo_item_data.dart';

class CryptoPortfoItem {
  final String symbol;
  final double amount;
  final double buyPrice;

  CryptoPortfoItem({
    this.symbol,
    this.amount,
    this.buyPrice,
  });
}

class CryptoPortfolio {
  static final csv = [
    "00,IRR,$IRR_SYMBOL,100000,0.00004",
    "01,Bitcoin,BTC,1.02,6777.14",
    "12,Bitcoin Cash,Bch,2.2,912.53",
    "09,Litecoin,Ltc,2.04,130.45",
    "05,Cardano,ADA,212.9,194.13",
    "03,Binance Coin,BNB,2.7,518.85",
    "43,Hedera Hashgraph,HBAR,1,0.15",
    "24,Avalanche,AVAX,2.5,100.53",
    "18,VeChain,VET,21,0.65",
    "117,StormX,STMX,14,0.75",
    "52,Polygon,MATIC,100.86,14.14",
  ];

  static List<CryptoPortfoItem> getCryptoPortfolioItems() => csv
      .map(
        (row) => CryptoPortfoItem(
          symbol: row.split(",")[2],
          amount: double.parse(row.split(",")[3]),
          buyPrice: double.parse(row.split(",")[4]),
        ),
      )
      .toList();
}
