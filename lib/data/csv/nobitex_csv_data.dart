import 'dart:io';

import 'package:iiportfo/data/api/nobitex_api.dart';
import 'package:iiportfo/data/portfo_item_data.dart';

import '../transaction_helper.dart';

class NobitexTransactions {
  static Future<List<TransactionItem>> getItems(String filePath) async {
    File file = File(filePath);
    String fileContent = await file.readAsString();

    final csvRows = fileContent.split("\n").reversed.toList();

    final List<TransactionItem> transactions = [];
    for (var i = 1; i < csvRows.length - 1; i++) {
      final columns = csvRows[i].split(",");
      final dateTime = _getDate(columns[1]);
      final symbol = _getSymbol(columns[3]);
      final transactionItem = TransactionItem(
        id: dateTime.millisecondsSinceEpoch,
        date: dateTime,
        symbol: symbol,
        amount: _getAmount(columns[4], symbol),
        buyPrice: await _getBuyPrice(columns, dateTime),
        description: _getDescription(columns[6]),
      );
      print(transactionItem.toCsvRow());
      transactions.add(transactionItem);
    }

    return transactions;
  }

  static DateTime _getDate(String cell) => DateTime.parse(cell);

  static String _getSymbol(String cell) =>
      cell == "rls" ? IRR_SYMBOL : cell.toUpperCase();

  static double _getAmount(String cell, String symbol) =>
      symbol == IRR_SYMBOL ? double.parse(cell) / 10 : double.parse(cell);

  static String _getDescription(String cell) => cell;

  static Future<double> _getBuyPrice(
    List<String> columns,
    DateTime dateTime,
  ) async {
    final symbol = _getSymbol(columns[3]);
    if (symbol == IRR_SYMBOL) {
      return 1 / await NobitexAPI.getUSDTPriceInIRR(dateTime);
    }
    if (symbol == "USDT") {
      return 1;
    } else {
      return await NobitexAPI.getCoinPrice(dateTime, "${symbol}USDT");
    }
  }
}
