import 'dart:io';

import 'package:iiportfo/data/bloc/import_sources/model/csv_source_file_type_item_data.dart';
import 'package:iiportfo/data/bloc/import_sources/model/csv_source_item_data.dart';
import 'package:iiportfo/data/bloc/transactions/csv/csv_transaction_handler.dart';
import 'package:iiportfo/data/bloc/transactions/csv/nobitex_csv_handler.dart';
import 'package:iiportfo/data/bloc/transactions/model/aggregated_data.dart';
import 'package:iiportfo/data/bloc/transactions/model/transaction_item.dart';
import 'package:path_provider/path_provider.dart';

class TransactionBloc {
  CsvTransactionHelper currentTransactionHelper;

  CsvTransactionHelper createTransactionHelper(
    CsvImportSourceItemData importSource,
  ) {
    return currentTransactionHelper = _getTransactionHelper(importSource);
  }

  Future<void> syncTransactions() async {
    final newTransactions = await currentTransactionHelper
        .getItems(await _getCurrentTransactionIds());
    await _writeTransactionsToFile(newTransactions);
    currentTransactionHelper.close();
  }

  Future<List<AggregatedData>> getAggregatedData() async {
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

  CsvTransactionHelper _getTransactionHelper(
    CsvImportSourceItemData importSource,
  ) {
    if (importSource.sourceFileType == nobitexSourceFileType) {
      return NobitexTransactions(importSource);
    } else {
      throw Exception("Unknown import source type");
    }
  }

  Future<Set<String>> _getCurrentTransactionIds() async =>
      (await _getTransactions()).map((e) => e.id).toSet();

  Future<File> _getIIPortfoTransactionFile() async {
    final localPath = await getApplicationDocumentsDirectory();

    final transactionFile = File("${localPath.path}/iiPortfo_transactions.csv");
    if (!await transactionFile.exists()) {
      await transactionFile.create();
    }
    // else {
    //   await transactionFile.delete();
    //   await transactionFile.create();
    // }
    return transactionFile;
  }

  Future<List<TransactionItem>> _getTransactions() async {
    final transactionFile = await _getIIPortfoTransactionFile();
    if (!await transactionFile.exists()) {}
    String fileContent = await transactionFile.readAsString();

    final csvRows = fileContent.split("\r\n");
    final transactions = <TransactionItem>[];
    for (var i = 1; i < csvRows.length - 1; i++) {
      final columns = csvRows[i].split(",");

      final transactionItem = TransactionItem(
        id: columns[0],
        date: DateTime.parse(columns[1]),
        symbol: columns[2],
        amount: double.parse(columns[3]),
        buyPrice: double.parse(columns[4]),
        description: columns[5],
        account: columns[6],
      );
      transactions.add(transactionItem);
    }
    return transactions;
  }

  Future<void> _writeTransactionsToFile(
      List<TransactionItem> newTransactions) async {
    final transactionFile = await _getIIPortfoTransactionFile();
    final prevTransactions = await _getTransactions();
    final uniqueTransactionsMap = <String, TransactionItem>{};

    prevTransactions.forEach((e) {
      uniqueTransactionsMap[e.id] = e;
    });

    newTransactions.forEach((e) {
      uniqueTransactionsMap[e.id] = e;
    });

    var fileContent = "${TransactionItem.getCsvHeader()}\r\n";

    final uniqueTransactions = uniqueTransactionsMap.values.toList();
    uniqueTransactions.sort();
    uniqueTransactions.forEach((transaction) {
      fileContent += "${transaction.toCsvRow()}\r\n";
    });

    await transactionFile.writeAsString(fileContent);
  }
}
