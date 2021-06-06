import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:iiportfo/data/bloc/price/PriceHelper.dart';
import 'package:iiportfo/data/bloc/transactions/model/state.dart';
import 'package:iiportfo/data/bloc/transactions/model/transaction_item.dart';
import 'package:iiportfo/data/bloc/transactions/transaction_helper.dart';
import 'package:iiportfo/data/portfo_item_data.dart';

abstract class CsvTransactionHelper extends TransactionHelper {
  final String idPrefix;
  final String filePath;
  final String account;
  final String delimiterChar;
  final String endOfLineChar;
  final bool hasHeader;

  final int dateColumnIndex;
  final int symbolColumnIndex;
  final int amountColumnIndex;

  final _priceHelper = PriceHelper();


  CsvTransactionHelper({
    @required this.idPrefix,
    @required this.filePath,
    @required this.account,
    @required this.delimiterChar,
    @required this.endOfLineChar,
    @required this.hasHeader,
    @required this.dateColumnIndex,
    @required this.symbolColumnIndex,
    @required this.amountColumnIndex,
  });

  Future<List<dynamic>> getFields() async {
    final input = File(filePath).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(
          CsvToListConverter(
            eol: endOfLineChar,
            fieldDelimiter: delimiterChar,
          ),
        )
        .toList();
    return fields;
  }

  @override
  Future<List<TransactionItemData>> getItems(Set<String> prevIds) async {
    final csvRows = await getFields();
    final List<TransactionItemData> transactions = [];
    print(csvRows[0]);
    for (var i = hasHeader ? 1 : 0; i < csvRows.length; i++) {
      final columns = csvRows[i];

      if (columns.length == 0) {
        continue;
      }

      final dateTime = getDate(columns[dateColumnIndex]);
      final symbol = getSymbol(columns[symbolColumnIndex]);
      final amount = getAmount(columns[amountColumnIndex], symbol);
      final fee = getFeeAmount(columns);
      final id = getId(columns);

      if (progressSubject.isClosed) {
        return [];
      }

      progressSubject.add(
        ProgressState(
          i.toDouble() / csvRows.length,
          "Processing item $i from ${csvRows.length}",
        ),
      );

      if (prevIds.contains(id)) {
        continue;
      }

      final transactionItem = TransactionItemData(
        id: id,
        date: dateTime,
        symbol: symbol,
        amount: amount + fee,
        account: account,
        buyPrice: await _priceHelper.getCoinPriceInUSD(dateTime, symbol),
        description: getDescription(columns),
      );
      _priceHelper.cachePriceFromTransaction(transactionItem);
      transactions.add(transactionItem);
    }

    progressSubject.add(
      ProgressState(
        1,
        "Completed!",
      ),
    );
    return transactions;
  }

  String getId(List<dynamic> columns) =>
      "$idPrefix-${columns[dateColumnIndex]}-${columns[amountColumnIndex]}-${columns[symbolColumnIndex]}";

  DateTime getDate(dynamic cell) => DateTime.parse(cell);

  String getSymbol(String cell) =>
      cell == "rls" ? IRR_SYMBOL : cell.toUpperCase();

  double getAmount(dynamic cell, String symbol) {
    double result = 0;
    if (cell is String) {
      result = double.parse(cell.trim());
    } else if (cell is int) {
      result = cell.toDouble();
    } else if (cell is double) {
      result = cell;
    } else {
      throw Exception("Illegal cell value $cell ${cell.runtimeType}");
    }

    if (symbol == IRR_SYMBOL) {
      result /= 10;
    }

    return result;
  }

  double getFeeAmount(columns) => 0;

  String getDescription(List<dynamic> columns);
}
