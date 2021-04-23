import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:iiportfo/data/api/nobitex_api.dart';
import 'package:iiportfo/data/portfo_item_data.dart';
import 'package:intl/intl.dart';

import '../transaction_helper.dart';

class BitcoinComTransactions {
  static Future<List<TransactionItem>> getBCHItems(
    String filePath,
    Set<String> prevIds,
  ) async {
    final input = File(filePath).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();

    final List<TransactionItem> transactions = [];
    for (var i = 1; i < fields.length - 1; i++) {
      final columns = fields[i];
      final dateTime = _getDate(columns[0]);
      final symbol = "BCH";
      final amount = _getAmount(columns[6], symbol);
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
        description: _getDescription(columns[1], columns[2]),
      );
      print(transactionItem.toCsvRow());
      transactions.add(transactionItem);
    }

    return transactions;
  }

  static _getId(DateTime dataTime, String symbol, double amount) =>
      "Bitcoin.com (BCH)-${dataTime.millisecondsSinceEpoch}-$symbol-$amount";

  static DateTime _getDate(String cell) =>
      DateFormat(r'''MMM d, y HH:mm:ss Z''')
          .parse(cell); // DateTime.parse(cell); Mar 31, 2021 13:04:02 UTC+04:30

  static double _getAmount(String cell, String symbol) =>
      symbol == IRR_SYMBOL ? double.parse(cell) / 10 : double.parse(cell);

  static String _getDescription(String destination, String description) =>
      "Bitcoin.com (BCH); $destination; $description";

  static Future<double> _getUSDBuyPrice(
    String symbol,
    DateTime dateTime,
  ) async {
    if (HashSet.from(["USDT", "USDC", "BUSD"]).contains(symbol)) {
      return 1;
    } else {
      return await NobitexAPI.getPairPrice(dateTime, "${symbol}USDT");
    }
  }
}
