import 'package:iiportfo/data/bloc/import_sources/model/csv_source_item_data.dart';
import 'package:iiportfo/data/bloc/transactions/csv/csv_transaction_handler.dart';

class CustomCSVTransactions extends CsvTransactionHelper {
  CustomCSVTransactions(
    CsvImportSourceItemData importSource,
  ) : super(
          idPrefix: importSource.sourceFileType.id,
          filePath: importSource.filePath,
          account: importSource.accountName,
          delimiterChar: ",",
          endOfLineChar: "\n",
          hasHeader: true,
          dateColumnIndex: 0,
          symbolColumnIndex: 1,
          amountColumnIndex: 2,
        );

  @override
  String getDescription(List<dynamic> columns) => columns[3].toString();

  @override
  DateTime getDate(String cell) =>
      DateTime.fromMillisecondsSinceEpoch(int.parse(cell));
}

// import 'dart:collection';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:csv/csv.dart';
// import 'package:iiportfo/data/api/crypto_watch_api.dart';
//
// import '../transaction_helper.dart';
//
// class CustomCsv {
//   Future<List<TransactionItem>> getItems(
//     String filePath,
//     Set<String> prevIds,
//   ) async {
//     final input = File(filePath).openRead();
//     final fields = await input
//         .transform(utf8.decoder)
//         .transform(new CsvToListConverter(eol: "\n"))
//         .toList();
//
//     final List<TransactionItem> transactions = [];
//     for (var i = 1; i < fields.length; i++) {
//       final columns = fields[i];
//       print(columns);
//       final date = DateTime.fromMillisecondsSinceEpoch(columns[0]);
//       final symbol = columns[1];
//       final amount = _getAmount(columns[2]);
//       final transactionItem = TransactionItem(
//         id: _getId(date, symbol, amount),
//         date: date,
//         symbol: symbol,
//         amount: amount,
//         buyPrice: await _getUSDBuyPrice(date, symbol),
//         description: "",
//       );
//       print(transactionItem.toCsvRow());
//       transactions.add(transactionItem);
//     }
//     return transactions;
//   }
//
//   final _prefix = "Custom-Csv";
//
//   _getId(DateTime dataTime, String symbol, double amount) =>
//       "$_prefix-${dataTime.millisecondsSinceEpoch}-$symbol-$amount";
//
//   Future<double> _getUSDBuyPrice(
//     DateTime date,
//     String symbol,
//   ) async {
//     if (_usdCoinsSet.contains(symbol)) {
//       return 1;
//     } else {
//       return await CryptoWatchAPI.getPairPrice(date, "${symbol}USDT");
//     }
//   }
//
//   CustomCsv._internal();
//
//   factory CustomCsv() => _singleton;
//
//   static final CustomCsv _singleton = CustomCsv._internal();
// }
//
// double _getAmount(dynamic cell) {
//   if (cell is String) {
//     return double.parse(cell.trim());
//   } else if (cell is int) {
//     return cell.toDouble();
//   } else if (cell is double) {
//     return cell;
//   } else {
//     throw Exception("Illegal cell value $cell");
//   }
// }
//
// final _usdCoinsSet = HashSet.from(["USDT", "USDC", "BUSD"]);
