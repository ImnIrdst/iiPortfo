import 'dart:io';

import 'package:iiportfo/data/preferences/shared_preferences_helper.dart';

const IRR_SYMBOL = "IRR";

class NobitexTransactionItem {
  final String symbol;
  final double amount;
  final double buyPrice;

  NobitexTransactionItem({
    this.symbol,
    this.amount,
    this.buyPrice,
  });
}

class NobitexTransactions {
  static List<String> csv = [];

  static void addTransactionsFromFile(String filePath) async {
    SharedPreferencesHelper.saveNobitexFilePath(filePath);
  }

  static Future<List<NobitexTransactionItem>> getItems() async {
    String filePath = await SharedPreferencesHelper.getNobitexFilePath();
    print("getItems $filePath");
    if (filePath == null || filePath == "") {
      return [];
    }

    File file = File(filePath);
    String fileContent = await file.readAsString();

    csv = fileContent.split("\n");

    csv.reversed.forEach((element) {
      print(element);
    });

    return [];
  }
}
