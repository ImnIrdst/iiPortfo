import 'dart:io';

import 'package:iiportfo/data/api/nobitex_api.dart';
import 'package:iiportfo/data/portfo_item_data.dart';
import 'package:iiportfo/data/preferences/shared_preferences_helper.dart';

class NobitexTransactionItem {
  final int id;
  final DateTime date;
  final String symbol;
  final double amount;
  final double buyPrice;
  final String description;

  NobitexTransactionItem({
    this.id,
    this.date,
    this.symbol,
    this.amount,
    this.buyPrice,
    this.description,
  });

  String toCsvRow() => "$id,$date,$symbol,$amount,$buyPrice,$description";

  static String getCsvHeader() => "id,date,symbol,amount,buyPrice,description";
}

class NobitexTransactions {
  static void addTransactionsFromFile(String filePath) async {
    SharedPreferencesHelper.saveNobitexFilePath(filePath);
  }

  static Future<List<NobitexTransactionItem>> getItems() async {
    String filePath = await SharedPreferencesHelper.getNobitexFilePath();
    if (filePath == null || filePath == "") {
      return [];
    }

    File file = File(filePath);
    String fileContent = await file.readAsString();

    final csvRows = fileContent.split("\n").reversed.toList();

    final List<NobitexTransactionItem> transactions = [];
    for (var i = 1; i < csvRows.length - 1; i++) {
      final columns = csvRows[i].split(",");
      final date = _getDate(columns);
      final usdtPrice = await NobitexAPI.getUSDTPriceInIRR(date);
      final transactionItem = NobitexTransactionItem(
        id: date.millisecondsSinceEpoch,
        date: _getDate(columns),
        symbol: _getSymbol(columns),
        amount: _getAmount(columns),
        buyPrice: 1.0 / usdtPrice,
        description: _getDescription(columns),
      );
      print(transactionItem.toCsvRow());
      transactions.add(transactionItem);
    }

    return [];
  }

  static DateTime _getDate(List<String> columns) => DateTime.parse(columns[1]);

  static String _getSymbol(List<String> columns) =>
      columns[3] == "rls" ? IRR_SYMBOL : columns[3].toUpperCase();

  static double _getAmount(List<String> columns) => double.parse(columns[4]);

  static String _getDescription(List<String> columns) => columns[6];
}
