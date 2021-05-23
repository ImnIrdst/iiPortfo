import 'package:iiportfo/data/bloc/import_sources/model/csv_source_item_data.dart';
import 'package:iiportfo/data/bloc/transactions/csv/csv_transaction_handler.dart';

class BitqueryBNBBCHInflowTransactions extends CsvTransactionHelper {
  BitqueryBNBBCHInflowTransactions(
    CsvImportSourceItemData importSource,
  ) : super(
          idPrefix: importSource.sourceFileType.id,
          filePath: importSource.filePath,
          account: importSource.accountName,
          delimiterChar: ",",
          endOfLineChar: "\n",
          hasHeader: true,
          dateColumnIndex: 0,
          symbolColumnIndex: 5,
          amountColumnIndex: 4,
        );

  @override
  String getDescription(List<dynamic> columns) => columns[6].toString();
}