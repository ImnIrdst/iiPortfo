import 'package:iiportfo/data/bloc/import_sources/model/csv_source_item_data.dart';
import 'package:iiportfo/data/bloc/transactions/csv/csv_transaction_handler.dart';

class BitqueryBCHLTCOutFlowTransactions extends CsvTransactionHelper {
  BitqueryBCHLTCOutFlowTransactions(
    CsvImportSourceItemData importSource,
  ) : super(
          idPrefix: importSource.sourceFileType.id,
          filePath: importSource.filePath,
          account: importSource.accountName,
          delimiterChar: ",",
          endOfLineChar: "\n",
          hasHeader: true,
          dateColumnIndex: 0,
          symbolColumnIndex: 3,
          amountColumnIndex: 2,
        );

  @override
  double getAmount(cell, String symbol) => -1 * super.getAmount(cell, symbol);

  @override
  String getDescription(List<dynamic> columns) => columns[9].toString();
}
