import 'package:iiportfo/data/bloc/import_sources/model/csv/csv_source_item_data.dart';
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
  DateTime getDate(dynamic cell) {
    if (cell is String) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(cell));
    } else if (cell is int) {
      return DateTime.fromMillisecondsSinceEpoch(cell);
    }
    throw Exception("Unhandled date type");
  }
}