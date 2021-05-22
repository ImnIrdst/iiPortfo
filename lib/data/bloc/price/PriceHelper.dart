import 'package:iiportfo/data/api/crypto_watch_api.dart';
import 'package:iiportfo/data/api/nobitex_api.dart';
import 'package:iiportfo/data/bloc/transactions/model/transaction_item.dart';
import 'package:iiportfo/data/portfo_item_data.dart';

class PriceHelper {
  static final stableCoins = {"USDT", "USDC", "BUSD"};

  final Map<String, double> priceCacheMap = {};

  NobitexAPI _nobitexAPI = NobitexAPI();
  CryptoWatchAPI _cryptoWatchAPI = CryptoWatchAPI();

  Future<double> getCoinPriceInUSD(DateTime dateTime, String symbol) async {
    if (stableCoins.contains(symbol)) {
      return 1;
    } else if (priceCacheMap.containsKey(_getPriceCacheKey(dateTime, symbol))) {
      return priceCacheMap[_getPriceCacheKey(dateTime, symbol)];
    } else if (symbol == IRR_SYMBOL) {
      return 1 / await _nobitexAPI.getUSDTPriceInIRR(dateTime);
    } else if (_nobitexAPI.supportedCoins.contains(symbol)) {
      return _nobitexAPI.getPairPrice(dateTime, "${symbol}USDT");
    } else {
      final result =
          await _cryptoWatchAPI.getPairPrice(dateTime, "${symbol}USDT");
      if (result == CryptoWatchAPI.ERROR_RESULT) {
        return _cryptoWatchAPI.getPairPrice(dateTime, "${symbol}BUSD");
      }
    }
    return 0;
  }

  Future<double> getUSDTIRRPrice(DateTime dateTime) async =>
      _nobitexAPI.getUSDTPriceInIRR(dateTime);

  void cachePriceFromTransaction(TransactionItem transaction) {
    final key = _getPriceCacheKey(transaction.date, transaction.symbol);
    priceCacheMap[key] = transaction.buyPrice;
  }

  String _getPriceCacheKey(DateTime date, String symbol) => "$date-$symbol";

  static final PriceHelper _singleton = PriceHelper._internal();

  factory PriceHelper() {
    return _singleton;
  }

  PriceHelper._internal();
}
