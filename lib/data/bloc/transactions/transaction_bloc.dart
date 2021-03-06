import 'dart:io';

import 'package:iiportfo/data/bloc/import_sources/model/csv/csv_source_file_type_item_data.dart';
import 'package:iiportfo/data/bloc/import_sources/model/csv/csv_source_item_data.dart';
import 'package:iiportfo/data/bloc/import_sources/model/import_source_item_data.dart';
import 'package:iiportfo/data/bloc/import_sources/model/wallet/wallet_source_item_data.dart';
import 'package:iiportfo/data/bloc/import_sources/model/wallet/wallet_type.dart';
import 'package:iiportfo/data/bloc/price/PriceHelper.dart';
import 'package:iiportfo/data/bloc/transactions/api/bitquery_ltc.dart';
import 'package:iiportfo/data/bloc/transactions/csv/binance/binance_deposit_csv_handler.dart';
import 'package:iiportfo/data/bloc/transactions/csv/binance/binance_trades_csv_handler.dart';
import 'package:iiportfo/data/bloc/transactions/csv/binance/binance_withdrawal_csv_handler.dart';
import 'package:iiportfo/data/bloc/transactions/csv/bitpay/bitpay_csv_handler.dart';
import 'package:iiportfo/data/bloc/transactions/csv/bitquery/bitquery_bch_ltc_inflow_csv_handler.dart';
import 'package:iiportfo/data/bloc/transactions/csv/bitquery/bitquery_bch_ltc_outflow_csv_handler.dart';
import 'package:iiportfo/data/bloc/transactions/csv/bitquery/bitquery_bnb_bch_inflow_csv_handler.dart';
import 'package:iiportfo/data/bloc/transactions/csv/bitquery/bitquery_bnb_bch_outflow_csv_handler.dart';
import 'package:iiportfo/data/bloc/transactions/csv/custom/custom_csv_data.dart';
import 'package:iiportfo/data/bloc/transactions/csv/nobitex/nobitex_csv_handler.dart';
import 'package:iiportfo/data/bloc/transactions/model/aggregated_data.dart';
import 'package:iiportfo/data/bloc/transactions/model/transaction_item.dart';
import 'package:iiportfo/data/bloc/transactions/transaction_helper.dart';
import 'package:path_provider/path_provider.dart';

class TransactionBloc {
  TransactionHelper currentTransactionHelper;

  TransactionHelper createTransactionHelper(
    ImportSourceItemData importSource,
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

  Future<List<TransactionItemData>> getTransactionsForCoin(
      String symbol) async {
    final transactions = await _getTransactions();
    final result =
        transactions.where((element) => element.symbol == symbol).toList();
    result.sort();

    return result.reversed.toList();
  }

  TransactionHelper _getTransactionHelper(
    ImportSourceItemData importSource,
  ) {
    if (importSource is WalletImportSourceItemData) {
      if (importSource.walletType == ltcWalletType) {
        return BitQueryLtcTransactionsApi(importSource);
      }
    } else if (importSource is CsvImportSourceItemData) {
      if (importSource.sourceFileType == nobitexSourceFileType) {
        return NobitexTransactions(importSource);
      } else if (importSource.sourceFileType == bitPaySourceFileType) {
        return BitpayTransactions(importSource);
      } else if (importSource.sourceFileType == customCsvSourceFileType) {
        return CustomCSVTransactions(importSource);
      } else if (importSource.sourceFileType == binanceDepositsSourceFileType) {
        return BinanceDepositTransactions(importSource);
      } else if (importSource.sourceFileType ==
          binanceWithdrawalsSourceFileType) {
        return BinanceWithdrawalTransactions(importSource);
      } else if (importSource.sourceFileType == binanceTradesSourceFileType) {
        return BinanceTradeTransactions(importSource);
      } else if (importSource.sourceFileType == bqBCHInflowSourceFileType ||
          importSource.sourceFileType == bqLTCInflowSourceFileType) {
        return BitqueryBCHLTCInflowTransactions(importSource);
      } else if (importSource.sourceFileType == bqBCHOutflowSourceFileType ||
          importSource.sourceFileType == bqLTCOutflowSourceFileType) {
        return BitqueryBCHLTCOutFlowTransactions(importSource);
      } else if (importSource.sourceFileType == bqBNBInflowSourceFileType ||
          importSource.sourceFileType == bqBSCInflowSourceFileType) {
        return BitqueryBNBBCHInflowTransactions(importSource);
      } else if (importSource.sourceFileType == bqBNBOutflowSourceFileType ||
          importSource.sourceFileType == bqBSCOutflowSourceFileType) {
        return BitqueryBNBBCHOutFlowTransactions(importSource);
      }
    }
    throw Exception("Unknown import source type");
  }

  Future<Set<String>> _getCurrentTransactionIds() async =>
      (await _getTransactions()).map((e) => e.id).toSet();

  Future<File> _getIIPortfoTransactionFile() async {
    final localPath = await getApplicationDocumentsDirectory();

    final transactionFile = File("${localPath.path}/iiPortfo_transactions.csv");
    if (!await transactionFile.exists()) {
      await transactionFile.create();
    }
    return transactionFile;
  }

  Future<List<TransactionItemData>> _getTransactions() async {
    final transactionFile = await _getIIPortfoTransactionFile();
    if (!await transactionFile.exists()) {}
    String fileContent = await transactionFile.readAsString();

    final csvRows = fileContent.split("\r\n");
    final transactions = <TransactionItemData>[];
    for (var i = 1; i < csvRows.length - 1; i++) {
      final columns = csvRows[i].split(",");

      final transactionItem = TransactionItemData(
        id: columns[0],
        date: DateTime.parse(columns[1]),
        symbol: columns[2],
        amount: double.parse(columns[3]),
        buyPrice: double.parse(columns[4]),
        description: columns[5],
        account: columns[6],
      );
      // TODO performance can be improved
      PriceHelper().cachePriceFromTransaction(transactionItem);
      transactions.add(transactionItem);
      print(transactionItem.toCsvRow());
    }

    return transactions;
  }

  Future<void> _writeTransactionsToFile(
      List<TransactionItemData> newTransactions) async {
    final transactionFile = await _getIIPortfoTransactionFile();
    final prevTransactions = await _getTransactions();
    final uniqueTransactionsMap = <String, TransactionItemData>{};

    prevTransactions.forEach((e) {
      uniqueTransactionsMap[e.id] = e;
    });

    newTransactions.forEach((e) {
      uniqueTransactionsMap[e.id] = e;
    });

    var fileContent = "${TransactionItemData.getCsvHeader()}\r\n";

    final uniqueTransactions = uniqueTransactionsMap.values.toList();
    uniqueTransactions.sort();
    uniqueTransactions.forEach((transaction) {
      fileContent += "${transaction.toCsvRow()}\r\n";
    });

    await transactionFile.writeAsString(fileContent);
  }

  Future<void> clearAllTransactions() async {
    (await _getIIPortfoTransactionFile()).delete();
  }
}
