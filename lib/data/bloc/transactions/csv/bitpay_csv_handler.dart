import 'package:iiportfo/data/bloc/import_sources/model/csv_source_item_data.dart';
import 'package:iiportfo/data/bloc/transactions/csv/csv_transaction_handler.dart';

class BitpayTransactions extends CsvTransactionHelper {
  BitpayTransactions(
    CsvImportSourceItemData importSource,
  ) : super(
          idPrefix: importSource.sourceFileType.id,
          filePath: importSource.filePath,
          account: importSource.accountName,
          delimiterChar: ",",
          endOfLineChar: "\r\n",
          hasHeader: true,
          dateColumnIndex: 0,
          symbolColumnIndex: 4,
          amountColumnIndex: 3,
        );

  @override
  String getDescription(List<dynamic> columns) =>
      "${columns[1]}-${columns[2]}-${columns[5]}";

  @override
  String getId(List<dynamic> columns) =>
      "$idPrefix-${columns[dateColumnIndex]}-${columns[amountColumnIndex]}-${columns[symbolColumnIndex]}";
}
