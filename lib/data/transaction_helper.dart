import 'dart:io';

import 'package:iiportfo/data/csv/bitcoin_com_csv_data.dart';
import 'package:iiportfo/data/csv/bitpay_csv_data.dart';
import 'package:path_provider/path_provider.dart';

import 'csv/nobitex_csv_data.dart';

class TransactionItem extends Comparable<TransactionItem> {
  final String id;
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

  @override
  int compareTo(TransactionItem other) {
    final dateCompare = this.date.compareTo(other.date);
    if (dateCompare != 0) return dateCompare;
    return this.amount.compareTo(other.amount);
  }
}

class AggregatedData {
  final String symbol;

  double amount = 0;
  double totalPrice = 0;

  AggregatedData(this.symbol);

  double get averageBuyPrice => amount != 0 ? totalPrice / amount : 0;
}

class TransactionHelper {
  static Future<void> addTransactionsFromNobitexCSV(String filePath) async {
    final nobitexTransactions =
        await NobitexTransactions.getItems(filePath, await _getCurrentIds());

    final transactionFile = await _getTransactionFile();

    _writeTransactionsToFile(transactionFile, nobitexTransactions);
  }

  static addTransactionsFromBitPayCSV(String filePath) async {
    final bitPayTransactions =
        await BitPayTransactions.getItems(filePath, await _getCurrentIds());

    final transactionFile = await _getTransactionFile();

    _writeTransactionsToFile(transactionFile, bitPayTransactions);
  }

  static addTransactionsFromBitcoinComBCHCSV(String filePath) async {
    final bchTransactions = await BitcoinComTransactions.getBCHItems(
      filePath,
      await _getCurrentIds(),
    );

    final transactionFile = await _getTransactionFile();

    _writeTransactionsToFile(transactionFile, bchTransactions);
  }

  static Future<File> _getTransactionFile() async {
    final transactionFile = await _getIIPortfoTransactionFile();
    if (!await transactionFile.exists()) {
      await transactionFile.create();
    }
    return transactionFile;
  }

  static Future<List<AggregatedData>> getAggregatedData() async {
    final aggregatedData = <String, AggregatedData>{};
    final transactions = await _getTransactions();

    transactions.forEach((t) {
      if (!aggregatedData.containsKey(t.symbol)) {
        aggregatedData[t.symbol] = AggregatedData(t.symbol);
      }
      aggregatedData[t.symbol].totalPrice += t.amount * t.buyPrice;
      aggregatedData[t.symbol].amount += t.amount;
    });

    return aggregatedData.values.toList();
  }

  static Future<List<TransactionItem>> _getTransactions() async {
    final transactionFile = await _getIIPortfoTransactionFile();
    if (await transactionFile.exists()) {
      String fileContent = await transactionFile.readAsString();

      final csvRows = fileContent.split("\n");
      final transactions = <TransactionItem>[];
      for (var i = 1; i < csvRows.length - 1; i++) {
        final columns = csvRows[i].split(",");

        final transactionItem = TransactionItem(
          id: _getId(columns[0]),
          date: _getDate(columns[1]),
          symbol: _getSymbol(columns[2]),
          amount: _getAmount(columns[3]),
          buyPrice: _getBuyPrice(columns[4]),
          description: _getDescription(columns[5]),
        );
        transactions.add(transactionItem);
      }
      return transactions;
    }
    return [];
  }

  static Future<Set<String>> _getCurrentIds() async =>
      (await _getTransactions()).map((e) => e.id).toSet();

  static Future<File> _getIIPortfoTransactionFile() async {
    final localPath = await getApplicationDocumentsDirectory();
    return File("${localPath.path}/iiPortfo_transactions.csv");
  }

  static String _getId(String cell) => cell;

  static DateTime _getDate(String cell) => DateTime.parse(cell);

  static String _getSymbol(String cell) => cell;

  static double _getAmount(String cell) => double.parse(cell);

  static double _getBuyPrice(String cell) => double.parse(cell);

  static String _getDescription(String cell) => cell;

  static void _writeTransactionsToFile(
    File transactionFile,
    List<TransactionItem> newTransactions,
  ) async {
    final prevTransactions = await _getTransactions();
    final uniqueTransactionsMap = <String, TransactionItem>{};

    prevTransactions.forEach((e) {
      uniqueTransactionsMap[e.id] = e;
    });

    newTransactions.forEach((e) {
      uniqueTransactionsMap[e.id] = e;
    });

    var fileContent = "${TransactionItem.getCsvHeader()}\n";

    final uniqueTransactions = uniqueTransactionsMap.values.toList();
    uniqueTransactions.sort();
    uniqueTransactions.forEach((transaction) {
      fileContent += "${transaction.toCsvRow()}\n";
    });

    await transactionFile.writeAsString(fileContent);
  }
}
