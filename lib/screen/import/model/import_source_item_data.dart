import 'package:iiportfo/screen/import/csv_import_source/model/csv_source_item_data.dart';

abstract class ImportSourceItemData
    implements Comparable<ImportSourceItemData> {
  String accountName;

  String getId();

  ImportSourceItemData(this.accountName);

  static CsvImportSourceItemData fromJson(Map<String, dynamic> json) {
    return CsvImportSourceItemData.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    if (this is CsvImportSourceItemData) {
      return this.toJson();
    } else {
      throw Exception("Invalid ImportSourceItem");
    }
  }

  @override
  int get hashCode => getId().hashCode;

  @override
  bool operator ==(Object other) {
    if (other is ImportSourceItemData) {
      return this.getId() == other.getId();
    }
    return super == other;
  }

  @override
  int compareTo(ImportSourceItemData other) {
    return this.getId().compareTo(other.getId());
  }
}

extension ImportSourceItemDataListJsonConverter on Set<ImportSourceItemData> {
  List<Map<String, dynamic>> toJson() {
    return this.map((e) => e.toJson()).toList();
  }
}

extension JsonToImportSourceItemDataList on List<dynamic> {
  Set<ImportSourceItemData> toImportSourceItemDataSet() {
    if (this == null) {
      return {};
    }
    return this.map((e) => ImportSourceItemData.fromJson(e)).toSet();
  }
}
