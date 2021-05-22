import 'package:iiportfo/data/bloc/import_sources/model/csv_source_item_data.dart';
import 'package:iiportfo/data/bloc/transactions/csv/csv_transaction_handler.dart';

class NobitexTransactions extends CsvTransactionHelper {
  NobitexTransactions(
    CsvImportSourceItemData importSource,
  ) : super(
          idPrefix: importSource.sourceFileType.id,
          filePath: importSource.filePath,
          account: importSource.accountName,
          delimiterChar: ",",
          endOfLineChar: "\r\n",
          hasHeader: true,
          dateColumnIndex: 1,
          symbolColumnIndex: 3,
          amountColumnIndex: 4,
        );

  @override
  String getDescription(List<dynamic> columns) => columns[6].toString();

  @override
  String getId(List<dynamic> columns) => "$idPrefix-${columns[0]}";
}
