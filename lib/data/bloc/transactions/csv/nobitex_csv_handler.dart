
import 'package:iiportfo/data/bloc/transactions/csv/csv_transaction_handler.dart';

class NobitexTransactions extends CsvTransactionHelper {
  NobitexTransactions()
      : super(
          idPrefix: "",
          filePath: "",
          account: "",
          delimiterChar: "",
          endOfLineChar: "",
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
