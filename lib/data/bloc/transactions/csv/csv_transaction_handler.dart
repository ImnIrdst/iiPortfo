import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:iiportfo/data/api/nobitex_api.dart';
import 'package:iiportfo/data/bloc/transactions/model/transaction_item.dart';
import 'package:iiportfo/data/portfo_item_data.dart';

abstract class CsvTransactionHelper {
  final String idPrefix;
  final String filePath;
  final String account;
  final String delimiterChar;
  final String endOfLineChar;
  final bool hasHeader;

  final int dateColumnIndex;
  final int symbolColumnIndex;
  final int amountColumnIndex;

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

  Future<List<TransactionItem>> getItems(Set<String> prevIds) async {
    final csvRows = await getFields();
    final List<TransactionItem> transactions = [];
    for (var i = hasHeader ? 1 : 0; i < csvRows.length; i++) {
      final columns = csvRows[i];
      if (columns.length == 0) {
        continue;
      }

      final dateTime = getDate(columns[dateColumnIndex]);
      final symbol = getSymbol(columns[symbolColumnIndex]);
      final amount = getAmount(columns[amountColumnIndex], symbol);
      final id = getId(columns);

      if (prevIds.contains(id)) {
        continue;
      }

      final transactionItem = TransactionItem(
        id: id,
        date: dateTime,
        symbol: symbol,
        amount: amount,
        buyPrice: await _getUSDBuyPrice(symbol, dateTime),
        description: getDescription(columns),
      );
      print("transactionItem ${transactionItem.toCsvRow()}");
      transactions.add(transactionItem);
    }

    return transactions;
  }

  String getId(List<dynamic> columns);

  DateTime getDate(String cell) => DateTime.parse(cell);

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

  String getDescription(List<dynamic> columns);

  // TODO write this better
  Future<double> _getUSDBuyPrice(
    String symbol,
    DateTime dateTime,
  ) async {
    if (symbol == IRR_SYMBOL) {
      return 1 / await NobitexAPI.getUSDTPriceInIRR(dateTime);
    }
    if (symbol == "USDT") {
      return 1;
    } else {
      return await NobitexAPI.getPairPrice(dateTime, "${symbol}USDT");
    }
  }
}
