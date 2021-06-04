import 'dart:convert';

import 'package:iiportfo/data/bloc/import_sources/model/csv/csv_source_item_data.dart';
import 'package:iiportfo/data/bloc/import_sources/model/import_source_item_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImportSourcesBloc {
  static const _KEY_IMPORT_SOURCES_JSON = "_KEY_IMPORT_SOURCES_JSON";

  get importSourceItems => _importSourceItems.stream;

  final _importSourceItems = PublishSubject<List<ImportSourceItemData>>();

  ImportSourcesBloc() {
    republishImportSourceItems();
  }

  Future<void> addImportSourceItem(ImportSourceItemData item) async {
    final importSourceItems = await getImportSourceItems();
    importSourceItems.remove(item);
    importSourceItems.add(item);

    await saveImportSourceItems(importSourceItems);
  }

  Future<void> deleteItem(CsvImportSourceItemData item) async {
    final items = await getImportSourceItems();
    items.remove(item);

    await saveImportSourceItems(items);

    republishImportSourceItems();
  }

  Future<Set<ImportSourceItemData>> getImportSourceItems() async {
    final sp = await SharedPreferences.getInstance();
    final jsonString = sp.getString(_KEY_IMPORT_SOURCES_JSON);
    try {
      final json = jsonDecode(jsonString) as List<dynamic>;
      return json.toImportSourceItemDataSet();
    } catch (e) {
      print("error happened $e");
    }
    return {};
  }

  Future<void> saveImportSourceItems(Set<ImportSourceItemData> items) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(_KEY_IMPORT_SOURCES_JSON, jsonEncode(items.toJson()));
    republishImportSourceItems();
  }

  void republishImportSourceItems() {
    getImportSourceItems().then((value) {
      final items = value.toList();
      items.sort();
      _importSourceItems.add(items);
    });
  }

  void close() {
    _importSourceItems.close();
  }
}
