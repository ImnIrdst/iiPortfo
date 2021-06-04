import 'package:iiportfo/data/bloc/import_sources/model/csv/csv_source_file_type_item_data.dart';
import 'package:iiportfo/data/bloc/import_sources/model/import_source_item_data.dart';

class CsvImportSourceItemData extends ImportSourceItemData {
  String filePath;
  CsvSourceFileTypeItemData sourceFileType;

  CsvImportSourceItemData({this.sourceFileType}) : super();

  bool get isCompleted =>
      accountName != null &&
      accountName.isNotEmpty &&
      sourceName != null &&
      sourceName.isNotEmpty &&
      filePath != null &&
      filePath.isNotEmpty &&
      sourceFileType != null;

  CsvImportSourceItemData.fromJson(Map<String, dynamic> json)
      : filePath = json['file_path'],
        sourceFileType =
            CsvSourceFileTypeItemData.fromJson(json['source_file_type']),
        super.fromJson(json);

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result.addAll({
      'file_path': filePath,
      'source_file_type': sourceFileType.toJson(),
    });
    return result;
  }

  @override
  String toString() {
    return 'CsvSourceItemData{accountName: $accountName, filePath: $filePath, sourceFileType: $sourceFileType}';
  }
}