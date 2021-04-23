import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:iiportfo/data/api/crypto_watch_api.dart';
import 'package:intl/intl.dart';

import '../transaction_helper.dart';

class BitQueryTransactions {
  static Future<List<TransactionItem>> getItems(
    String filePath,
    Set<String> prevIds,
    bool isInflow,
  ) {
    if (isInflow) {
      return _getInflowItems(filePath, prevIds);
    } else {
      return _getOutflowItems(filePath, prevIds);
    }
  }

  static Future<List<TransactionItem>> _getInflowItems(
    String filePath,
    Set<String> prevIds,
  ) async {
    final input = File(filePath).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter(eol: "\n"))
        .toList();

    final List<TransactionItem> transactions = [];
    for (var i = 1; i < fields.length; i++) {
      final columns = fields[i];
      print("columns ${columns[2]} $columns");
      final dateTime = _getDate(columns[0]);
      final symbol = _getSymbol(columns[3]);
      final amount = _getAmount(columns[2]);
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
        description: _getDescription(columns[8]),
      );
      print(transactionItem.toCsvRow());
      transactions.add(transactionItem);
    }

    return transactions;
  }

  static Future<List<TransactionItem>> _getOutflowItems(
    String filePath,
    Set<String> prevIds,
  ) async {
    final input = File(filePath).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter(eol: "\n"))
        .toList();

    final List<TransactionItem> transactions = [];
    for (var i = 1; i < fields.length; i++) {
      final columns = fields[i];
      print("columns ${columns[2]} $columns");
      final dateTime = _getDate(columns[0]);
      final symbol = _getSymbol(columns[5]);
      final amount = _getAmount(columns[4]) * -1;
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
        description: _getDescription(columns[8]),
      );
      print(transactionItem.toCsvRow());
      transactions.add(transactionItem);
    }

    return transactions;
  }

  static _getId(DateTime dataTime, String symbol, double amount) =>
      "BitQuery-${dataTime.millisecondsSinceEpoch}-$symbol-$amount";

  static DateTime _getDate(String cell) =>
      DateFormat("y-M-d HH:mm:ss").parseUtc(cell);

  static double _getAmount(String cell) => double.parse(cell);

  static String _getSymbol(String cell) => cell;

  static String _getDescription(String transaction) => "BitQuery; $transaction";

  static Future<double> _getUSDBuyPrice(
    String symbol,
    DateTime dateTime,
  ) async {
    return await CryptoWatchAPI.getPairPrice(dateTime, "${symbol}USDT");
  }
}
