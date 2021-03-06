import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:iiportfo/data/bloc/import_sources/import_sources_bloc.dart';
import 'package:iiportfo/data/bloc/import_sources/model/csv/csv_source_item_data.dart';
import 'package:iiportfo/data/bloc/import_sources/model/import_source_item_data.dart';
import 'package:iiportfo/data/bloc/import_sources/model/wallet/wallet_source_item_data.dart';
import 'package:iiportfo/data/bloc/transactions/transaction_bloc.dart';
import 'package:iiportfo/main.dart';
import 'package:iiportfo/screen/import/csv/csv_source_item_bottom_sheet.dart';
import 'package:iiportfo/screen/import/csv/import_source_item_csv.dart';
import 'package:iiportfo/screen/import/wallet/import_source_item_wallet.dart';
import 'package:iiportfo/screen/import/wallet/wallet_source_item_bottom_sheet.dart';

class ImportPage extends StatefulWidget {
  static const ROUTE_NAME = "/import_page";

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
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        buttonSize: 56.0,
        visible: true,
        closeManually: false,
        renderOverlay: false,
        overlayOpacity: 0,
        tooltip: 'Import sources',
        heroTag: 'import-sources-hero-tag',
        foregroundColor: Colors.black,
        backgroundColor: primaryColor,
        activeBackgroundColor: Colors.grey,
        children: [
          SpeedDialChild(
            child: Icon(Icons.account_balance_wallet),
            backgroundColor: primaryColor,
            foregroundColor: Colors.black,
            label: 'Wallet address',
            onTap: () => _showAddWalletSourcesBottomSheet(),
          ),
          SpeedDialChild(
            child: Icon(Icons.table_chart_outlined),
            backgroundColor: primaryColor,
            foregroundColor: Colors.black,
            label: 'CSV file',
            onTap: () => _showAddCsvSourcesBottomSheet(),
          ),
        ],
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
            padding: EdgeInsets.symmetric(vertical: 64),
            itemBuilder: (BuildContext context, int index) {
              final item = snapshot.data[index];
              if (item is CsvImportSourceItemData) {
                return CsvImportSourceItem(
                  item: item,
                  importSourcesBloc: importSourcesBloc,
                  transactionBloc: transactionBloc,
                );
              } else if (item is WalletImportSourceItemData) {
                return WalletImportSourceItem(
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

  void _showAddCsvSourcesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          AddCSVSourceItemBottomSheet(bloc: importSourcesBloc),
    );
  }

  void _showAddWalletSourcesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          AddWalletSourceItemBottomSheet(bloc: importSourcesBloc),
    );
  }
}