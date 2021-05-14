import 'package:flutter/material.dart';
import 'package:iiportfo/data/bloc/import_sources/import_sources_bloc.dart';
import 'package:iiportfo/data/bloc/import_sources/model/csv_source_item_data.dart';
import 'package:iiportfo/data/bloc/import_sources/model/import_source_item_data.dart';
import 'package:iiportfo/data/bloc/transactions/transaction_bloc.dart';
import 'package:iiportfo/screen/import/csv_source_item_bottom_sheet.dart';
import 'package:iiportfo/screen/import/import_source_item_csv.dart';

class ImportPage extends StatefulWidget {
  static const ROUTE_NAME = "import_page";

  ImportPage({Key key, this.title = "Import Sources"}) : super(key: key);

  final String title;

  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  final importSourcesBloc = ImportSourcesBloc();
  final transactionBloc = TransactionBloc();

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
    return StreamBuilder<List<ImportSourceItemData>>(
      initialData: [],
      stream: importSourcesBloc.importSourceItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(child: Text("No Imported sources created"));
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              final item = snapshot.data[index];
              if (item is CsvImportSourceItemData) {
                return CsvImportSourceItem(
                  item: item,
                  importSourcesBloc: importSourcesBloc,
                  transactionBloc: transactionBloc,
                );
              }
              throw Exception("Invalid Import source Item!");
            },
            itemCount: snapshot.data.length,
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  void _showAddSourcesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          AddCSVSourceItemBottomSheet(bloc: importSourcesBloc),
    );
  }
}