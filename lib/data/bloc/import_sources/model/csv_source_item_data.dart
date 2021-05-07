import 'package:iiportfo/data/bloc/import_sources/model/csv_source_file_type_item_data.dart';
import 'package:iiportfo/data/bloc/import_sources/model/import_source_item_data.dart';

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

  CsvImportSourceItemData.fromJson(Map<String, dynamic> json)
      : filePath = json['file_path'],
        sourceFileType =
            CsvSourceFileTypeItemData.fromJson(json['source_file_type']),
        super(json['account_name']);

  Map<String, dynamic> toJson() => {
        'account_name': accountName,
        'file_path': filePath,
        'source_file_type': sourceFileType,
      };

  @override
  String toString() {
    return 'CsvSourceItemData{accountName: $accountName, filePath: $filePath, sourceFileType: $sourceFileType}';
  }

  @override
  String getId() => filePath;
}