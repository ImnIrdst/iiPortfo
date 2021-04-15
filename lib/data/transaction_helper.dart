import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'csv/nobitex_csv_data.dart';

class TransactionItem {
  final int id;
  final DateTime date;
  final String symbol;
  final double amount;
  final double buyPrice;
  final String description;

  TransactionItem({
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

class TransactionHelper {
  static const String _TRANSACTION_FILE_NAME = "iiPortfo_transactions.csv";

  static Future<List<TransactionItem>> getTransactions() async {
    final transactionFile = File(_TRANSACTION_FILE_NAME);
    if (await transactionFile.exists()) {
      String fileContent = await transactionFile.readAsString();

      final csvRows = fileContent.split("\n");
      final transactions = <TransactionItem>[];
      for (var i = 1; i < csvRows.length - 1; i++) {
        final columns = csvRows[i].split(",");

        final transactionItem = TransactionItem(
          id: _getId(columns),
          date: _getDate(columns),
          symbol: _getSymbol(columns),
          amount: _getAmount(columns),
          buyPrice: _getBuyPrice(columns),
          description: _getDescription(columns),
        );
        transactions.add(transactionItem);
      }
      return transactions;
    }
    return [];
  }

  static Future<void> addTransactionsFromNobitexCSV(String filePath) async {
    final localPath = await getApplicationDocumentsDirectory();
    final transactionFile = File("${localPath.path}/$_TRANSACTION_FILE_NAME");
    if (!await transactionFile.exists()) {
      await transactionFile.create();
    }
    final transactions = await NobitexTransactions.getItems(filePath);

    var fileContent = "${TransactionItem.getCsvHeader()}\n";
    transactions.forEach((transaction) {
      fileContent += "${transaction.toCsvRow()}\n";
    });

    print(fileContent);

    await transactionFile.writeAsString(fileContent);
  }

  static int _getId(List<String> columns) => int.parse(columns[0]);

  static DateTime _getDate(List<String> columns) => DateTime.parse(columns[1]);

  static String _getSymbol(List<String> columns) => columns[2];

  static double _getAmount(List<String> columns) => double.parse(columns[3]);

  static double _getBuyPrice(List<String> columns) => double.parse(columns[4]);

  static String _getDescription(List<String> columns) => columns[5];
}
