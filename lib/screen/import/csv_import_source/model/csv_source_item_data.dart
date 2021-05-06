import 'package:iiportfo/screen/import/csv_import_source/model/csv_source_file_type_item_data.dart';
import 'package:iiportfo/screen/import/model/import_source_item_data.dart';

class CsvImportSourceItemData extends ImportSourceItemData {
  String filePath;
  CsvSourceFileTypeItemData sourceFileType;

  CsvImportSourceItemData({accountName, this.filePath, this.sourceFileType})
      : super(accountName);

  bool get isCompleted =>
      accountName != null &&
      accountName.isNotEmpty &&
      filePath != null &&
      filePath.isNotEmpty &&
      sourceFileType != null;

  @override
  String toString() {
    return 'CsvSourceItemData{accountName: $accountName, filePath: $filePath, sourceFileType: $sourceFileType}';
  }
}
