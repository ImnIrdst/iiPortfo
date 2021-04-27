import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:iiportfo/data/api/crypto_watch_api.dart';
import 'package:iiportfo/data/transaction_helper.dart';

class BinanceDeposits {
  Future<List<TransactionItem>> getItemsFromWithdrawalAndDeposit(
    String filePath,
    Set<String> prevIds,
    bool isDeposit,
  ) async {
    final input = File(filePath).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();

    final List<TransactionItem> transactions = [];
    for (var i = 1; i < fields.length; i++) {
      final columns = fields[i];
      print(columns);
      final dateTime = _getDate(columns[0]);
      final symbol = columns[1];
      final fee = columns[3];
      final sign = isDeposit ? 1 : -1;
      final amount = sign * (_getAmount(columns[2]) + fee);
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
        description: _getDescription(columns[4], columns[5]),
      );
      print(transactionItem.toCsvRow());
      transactions.add(transactionItem);
    }

    return transactions;
  }

  BinanceDeposits._internal();

  factory BinanceDeposits() => _singleton;
  static final BinanceDeposits _singleton = BinanceDeposits._internal();
}

final _prefix = "Binance";

_getId(DateTime dataTime, String symbol, double amount) =>
    "$_prefix-${dataTime.millisecondsSinceEpoch}-$symbol-$amount";

DateTime _getDate(String cell) => DateTime.parse(cell);

double _getAmount(dynamic cell) {
  if (cell is String) {
    return double.parse(cell);
  } else if (cell is int) {
    return cell.toDouble();
  } else if (cell is double) {
    return cell;
  } else {
    throw Exception("Illegal cell value $cell");
  }
}

String _getDescription(String destination, String description) =>
    "$_prefix; $destination; $description";

Future<double> _getUSDBuyPrice(
  String symbol,
  DateTime dateTime,
) async {
  if (HashSet.from(["USDT", "USDC", "BUSD"]).contains(symbol)) {
    return 1;
  } else {
    return await CryptoWatchAPI.getPairPrice(dateTime, "${symbol}USDT");
  }
}
