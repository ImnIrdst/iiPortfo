import 'package:flutter/material.dart';
import 'package:iiportfo/screen/import/csv_import_source/csv_source_item_bottom_sheet.dart';
import 'package:iiportfo/screen/import/csv_import_source/model/csv_source_item_data.dart';
import 'package:iiportfo/screen/import/import_source_item_csv.dart';
import 'package:iiportfo/screen/import/model/import_source_item_data.dart';

class ImportPage extends StatefulWidget {
  ImportPage({Key key, this.title = "Import Sources"}) : super(key: key);

  final String title;

  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  List<ImportSourceItemData> _importSourceItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _renderBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSourcesBottomSheet,
        tooltip: 'Add Sources',
        icon: Icon(Icons.add),
        label: Text("ADD SOURCES"),
      ),
    );
  }

  Widget _renderBody() {
    if (_importSourceItems.isEmpty) {
      return Center(
        child: Text("No Import sources created."),
      );
    } else {
      return ListView.builder(
        itemBuilder: itemBuilder,
        itemCount: _importSourceItems.length,
      );
    }
  }

  Widget itemBuilder(BuildContext context, int index) {
    final item = _importSourceItems[index];
    if (item is CsvImportSourceItemData) {
      return CsvImportSourceItem(item: item);
    }
    throw Exception("Invalid Import source Item!");
  }

  void _showAddSourcesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddCSVSourceItemBottomSheet(
        onCsvSourceItemAdded: _onCsvSourceItemAdded,
      ),
    );
  }

  Future<void> _onCsvSourceItemAdded(CsvImportSourceItemData itemData) async {
    setState(() {
      print("itemData $itemData");
      _importSourceItems.add(itemData);
    });
  }
}