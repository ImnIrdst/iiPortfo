import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:iiportfo/data/api/nobitex_api.dart';

import '../transaction_helper.dart';

class CryptoIdTransactions {
  static Future<List<TransactionItem>> getLtcItems(
    String filePath,
    Set<String> prevIds,
  ) async {
    final input = File(filePath).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(
          new CsvToListConverter(
            fieldDelimiter: ";",
            eol: "\n",
          ),
        )
        .toList();

    fields.forEach((element) {
      print("fields " + element.toString());
    });
    final List<TransactionItem> transactions = [];
    for (var i = 2; i < fields.length; i++) {
      final columns = fields[i];
      final dateTime = _getDate(columns[2]);
      final symbol = "LTC";
      final amount = _getAmount(columns[4], symbol);
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
        description: _getDescription(columns[0]),
      );
      print(transactionItem.toCsvRow());
      transactions.add(transactionItem);
    }

    return transactions;
  }

  static _getId(DateTime dataTime, String symbol, double amount) =>
      "CryptoID (LTC)-${dataTime.millisecondsSinceEpoch}-$symbol-$amount";

  static DateTime _getDate(String cell) => DateTime.parse(cell);

  static double _getAmount(double cell, String symbol) => cell;

  static String _getDescription(String transaction) =>
      "CryptoID (LTC); $transaction";

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
