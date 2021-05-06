import 'package:iiportfo/screen/import/csv_import_source/model/csv_source_file_type_item_data.dart';

class CsvSourceItemData {
  String accountName;
  String filePath;
  CsvSourceFileTypeItemData sourceFileType;

  CsvSourceItemData({this.accountName, this.filePath, this.sourceFileType});

  bool get isCompleted =>
      accountName != null && filePath != null && sourceFileType != null;

  @override
  String toString() {
    return 'CsvSourceItemData{accountName: $accountName, filePath: $filePath, sourceFileType: $sourceFileType}';
  }
}
