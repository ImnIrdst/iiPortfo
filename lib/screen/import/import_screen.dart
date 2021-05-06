import 'package:flutter/material.dart';
import 'package:iiportfo/screen/import/csv_import_source/csv_source_item_bottom_sheet.dart';

class ImportPage extends StatefulWidget {
  ImportPage({Key key, this.title = "Import Sources"}) : super(key: key);

  final String title;

  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  List<ImportItemData> _importItems = [];

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
    if (_importItems.isEmpty) {
      return Center(
        child: Text("No Import sources created."),
      );
    } else {
      return ListView.builder(
        itemBuilder: itemBuilder,
        itemCount: _importItems.length,
      );
    }
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Text("Item $index");
  }

  void _showAddSourcesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddCSVSourceItemBottomSheet(),
    );
  }
}

class ImportItemData {
  final String accountName;

  ImportItemData(this.accountName);
}

class CSVImportItemData extends ImportItemData {
  final String path;

  CSVImportItemData(String accountName, this.path) : super(accountName);
}
