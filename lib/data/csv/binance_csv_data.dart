import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:iiportfo/data/api/crypto_watch_api.dart';
import 'package:iiportfo/data/transaction_helper.dart';

class BinanceDeposits {
  Future<List<TransactionItem>> getItemsFromWithdrawalAndDeposit(
    String filePath,
    Set<String> prevIds,
    bool isDeposit,
  ) async {
    final input = File(filePath).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();

    final List<TransactionItem> transactions = [];
    for (var i = 1; i < fields.length; i++) {
      final columns = fields[i];
      print(columns);
      final dateTime = _getDate(columns[0]);
      final symbol = columns[1];
      final fee = columns[3];
      final sign = isDeposit ? 1 : -1;
      final amount = sign * (_getAmount(columns[2]) + fee);
      final id = _getId(dateTime, symbol, amount);
      if (prevIds.contains(id)) {
        continue;
      }

      final transactionItem = TransactionItem(
        id: id,
        date: dateTime,
        symbol: symbol,
        amount: amount,
        buyPrice: await _getUSDBuyPrice(symbol, dateTime),
        description: _getDescription(columns[4], columns[5]),
      );
      print(transactionItem.toCsvRow());
      transactions.add(transactionItem);
    }

    return transactions;
  }

  final _prefix = "Binance-Wallet";

  _getId(DateTime dataTime, String symbol, double amount) =>
      "$_prefix-${dataTime.millisecondsSinceEpoch}-$symbol-$amount";

  String _getDescription(String destination, String description) =>
      "$_prefix; $destination; $description";

  Future<double> _getUSDBuyPrice(
    String symbol,
    DateTime dateTime,
  ) async {
    if (_usdCoinsSet.contains(symbol)) {
      return 1;
    } else {
      return await CryptoWatchAPI.getPairPrice(dateTime, "${symbol}USDT");
    }
  }

  BinanceDeposits._internal();

  factory BinanceDeposits() => _singleton;
  static final BinanceDeposits _singleton = BinanceDeposits._internal();
}

class BinanceTrades {
  Future<List<TransactionItem>> getItems(
    String filePath,
    Set<String> prevIds,
  ) async {
    final input = File(filePath).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();

    final List<TransactionItem> transactions = [];
    for (var i = 1; i < fields.length; i++) {
      final columns = fields[i];
      print(columns);
      final date = DateTime.parse(columns[0]);
      final pair = _CoinPair.fromString(columns[1]);
      final type = columns[2];
      final price = _getAmount(columns[3]);
      final amount = _getAmount(columns[4]);
      final total = _getAmount(columns[5]);
      final feeAmount = _getAmount(columns[6]);
      final feeSymbol = columns[7];
      final feeCoin = _CoinAmount(feeSymbol, -feeAmount);
      final fromCoin = _getFromCoin(amount, total, type, pair);
      final toCoin = _getToCoin(amount, total, type, pair);
      for (_CoinAmount coinAmount in [fromCoin, toCoin, feeCoin]) {
        final transactionItem = TransactionItem(
          id: _getId(i, date, coinAmount.symbol, coinAmount.amount),
          date: date,
          symbol: coinAmount.symbol,
          amount: coinAmount.amount,
          buyPrice: await _getUSDBuyPrice(date, coinAmount, pair, price),
          description: _getDescription(columns[1], columns[2]),
        );
        if (prevIds.contains(transactionItem.id)) {
          continue;
        }
        print(transactionItem.toCsvRow());
        transactions.add(transactionItem);
      }
    }
    return transactions;
  }

  final _prefix = "Binance-Trade";

  _getId(int i, DateTime dataTime, String symbol, double amount) =>
      "$i-$_prefix-${dataTime.millisecondsSinceEpoch}-$symbol-$amount";

  String _getDescription(String destination, String description) =>
      "$_prefix; $destination; $description";

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
    if (coinAmount.symbol == pair.first && _usdCoinsSet.contains(pair.second)) {
      return price;
    } else if (_usdCoinsSet.contains(coinAmount.symbol)) {
      return 1;
    } else {
      return await CryptoWatchAPI.getPairPrice(
          date, "${coinAmount.symbol}USDT");
    }
  }

  BinanceTrades._internal();

  factory BinanceTrades() => _singleton;

  static final BinanceTrades _singleton = BinanceTrades._internal();
}

DateTime _getDate(String cell) => DateTime.parse(cell);

double _getAmount(dynamic cell) {
  if (cell is String) {
    return double.parse(cell);
  } else if (cell is int) {
    return cell.toDouble();
  } else if (cell is double) {
    return cell;
  } else {
    throw Exception("Illegal cell value $cell");
  }
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

final _usdCoinsSet = HashSet.from(["USDT", "USDC", "BUSD"]);