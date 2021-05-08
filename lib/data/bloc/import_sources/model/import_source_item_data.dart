import 'package:iiportfo/data/bloc/import_sources/model/csv_source_item_data.dart';

abstract class ImportSourceItemData
    implements Comparable<ImportSourceItemData> {
  String sourceName;
  String accountName;
  DateTime createDate;

  ImportSourceItemData() : createDate = DateTime.now();

  ImportSourceItemData.fromJson(Map<String, dynamic> json)
      : sourceName = json["source_name"],
        accountName = json["account_name"],
        createDate = DateTime.fromMillisecondsSinceEpoch(json["create_date"]);

  Map<String, dynamic> toJson() => {
        "source_name": sourceName,
        "create_date": createDate.millisecondsSinceEpoch,
        "account_name": accountName,
      };

  @override
  int get hashCode => createDate.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is ImportSourceItemData) {
      return this.createDate == other.createDate;
    }
    return super == other;
  }

  @override
  int compareTo(ImportSourceItemData other) {
    return this.createDate.compareTo(other.createDate);
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
    return this.map((e) {
      try {
        return CsvImportSourceItemData.fromJson(e);
      } catch (ex) {}
      throw Exception("Unknown import source subclass $e");
    }).toSet();
  }
}
