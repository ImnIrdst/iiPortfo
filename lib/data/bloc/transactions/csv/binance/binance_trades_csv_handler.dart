import 'dart:collection';
import 'dart:math';

import 'package:iiportfo/data/bloc/import_sources/model/csv/csv_source_item_data.dart';
import 'package:iiportfo/data/bloc/price/PriceHelper.dart';
import 'package:iiportfo/data/bloc/transactions/csv/csv_transaction_handler.dart';
import 'package:iiportfo/data/bloc/transactions/model/state.dart';
import 'package:iiportfo/data/bloc/transactions/model/transaction_item.dart';

class BinanceTradeTransactions extends CsvTransactionHelper {
  BinanceTradeTransactions(
    CsvImportSourceItemData importSource,
  ) : super(
          idPrefix: importSource.sourceFileType.id,
          filePath: importSource.filePath,
          account: importSource.accountName,
          delimiterChar: ",",
          endOfLineChar: "\r\n",
          hasHeader: true,
          dateColumnIndex: 0,
          symbolColumnIndex: 1,
          amountColumnIndex: 2,
        );

  @override
  Future<List<TransactionItemData>> getItems(Set<String> prevIds) async {
    final localPrevIds = HashSet();
    final fields = await getFields();
    final List<TransactionItemData> transactions = [];
    for (var i = 1; i < fields.length; i++) {
      final columns = fields[i];
      print(columns);

      if (progressSubject.isClosed) {
        return [];
      }

      progressSubject.add(
        ProgressState(
          i.toDouble() / fields.length,
          "Processing item $i from ${fields.length}",
        ),
      );

      final date = DateTime.parse(columns[0]);
      final pair = _CoinPair.fromString(columns[1]);
      final type = columns[2];
      final price = getAmount(columns[3], "");
      final amount = getAmount(columns[4], "");
      final total = getAmount(columns[5], "");

      final feeAmount = getAmount(columns[6], "");
      final feeSymbol = columns[7];
      final feeCoin = _CoinAmount(feeSymbol, -feeAmount);

      final fromCoin = _getFromCoin(amount, total, type, pair);
      final toCoin = _getToCoin(amount, total, type, pair);

      for (_CoinAmount coinAmount in [fromCoin, toCoin, feeCoin]) {
        var id = _getId(date, coinAmount.symbol, coinAmount.amount);
        if (localPrevIds.contains(id)) {
          id += "${Random().nextInt(1024)}";
        }
        localPrevIds.add(id);
        final transactionItem = TransactionItemData(
          id: id,
          date: date,
          symbol: coinAmount.symbol,
          amount: coinAmount.amount,
          buyPrice: await _getUSDBuyPrice(date, coinAmount, pair, price),
          description: getDescription(columns),
        );

        if (prevIds.contains(transactionItem.id)) {
          continue;
        }
        print(transactionItem.toCsvRow());
        transactions.add(transactionItem);
      }
    }
    progressSubject.add(
      ProgressState(
        1,
        "Completed!",
      ),
    );
    return transactions;
  }

  _CoinAmount _getFromCoin(
    double amount,
    double total,
    String type,
    _CoinPair pair,
  ) {
    if (type == "BUY") {
      return _CoinAmount(pair.second, -total);
    } else {
      return _CoinAmount(pair.first, -amount);
    }
  }

  _CoinAmount _getToCoin(
    double amount,
    double total,
    String type,
    _CoinPair pair,
  ) {
    if (type == "BUY") {
      return _CoinAmount(pair.first, amount);
    } else {
      return _CoinAmount(pair.second, total);
    }
  }

  Future<double> _getUSDBuyPrice(
    DateTime date,
    _CoinAmount coinAmount,
    _CoinPair pair,
    double price,
  ) async {
    print(coinAmount.symbol);
    print(pair.first);
    if (coinAmount.symbol == pair.first &&
        PriceHelper.stableCoins.contains(pair.second)) {
      return price;
    } else if (PriceHelper.stableCoins.contains(coinAmount.symbol)) {
      return 1;
    } else {
      return await PriceHelper().getCoinPriceInUSD(date, coinAmount.symbol);
    }
  }

  _getId(DateTime dataTime, String symbol, double amount) =>
      "$idPrefix-${dataTime.millisecondsSinceEpoch}-$symbol-$amount";

  @override
  String getDescription(List<dynamic> columns) => "${columns[1]}-${columns[2]}";
}

class _CoinAmount {
  final String symbol;
  final double amount;

  _CoinAmount(this.symbol, this.amount);
}

class _CoinPair {
  final String first;
  final String second;

  _CoinPair(this.first, this.second);

  static _CoinPair fromString(String pair) {
    for (String coin in _binanceBaseCoins) {
      if (pair.startsWith(coin)) {
        final second = pair.replaceAll(coin, "");
        return _CoinPair(coin, second);
      }
      if (pair.endsWith(coin)) {
        final first = pair.replaceAll(coin, "");
        return _CoinPair(first, coin);
      }
    }
    throw Exception("Unhandled pair $pair");
  }

  static final _binanceBaseCoins = ["BNB", "BUSD", "USDT"];
}
