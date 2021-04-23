import 'dart:collection';
import 'dart:io';

import 'package:iiportfo/data/api/nobitex_api.dart';
import 'package:iiportfo/data/portfo_item_data.dart';

import '../transaction_helper.dart';

class BitPayTransactions {
  static Future<List<TransactionItem>> getItems(
    String filePath,
    Set<String> prevIds,
  ) async {
    File file = File(filePath);
    String fileContent = await file.readAsString();

    final csvRows = fileContent.split("\n").reversed.toList();

    final List<TransactionItem> transactions = [];
    for (var i = 0; i < csvRows.length - 1; i++) {
      final columns = csvRows[i].split(",");
      print(columns);
      final dateTime = _getDate(columns[0]);
      final symbol = _getSymbol(columns[4]);
      final amount = _getAmount(columns[3], symbol);
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
      "BitPay-${dataTime.millisecondsSinceEpoch}-$symbol-$amount";

  static DateTime _getDate(String cell) => DateTime.parse(cell);

  static String _getSymbol(String cell) => cell.toUpperCase();

  static double _getAmount(String cell, String symbol) =>
      symbol == IRR_SYMBOL ? double.parse(cell) / 10 : double.parse(cell);

  static String _getDescription(String destination, String description) =>
      "Bitpay; $destination; $description";

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
