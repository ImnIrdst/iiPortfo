import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iiportfo/data/csv/nobitex_csv_data.dart';

class ImportBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.symmetric(vertical: 16),
      // color: Colors.grey[900],
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(184, 0, 184, 32),
            height: 4,
            color: Colors.grey[700],
          ),
          ImportItem(title: "Custom CSV", clickListener: _onCustomCSVClicked),
          ImportItem(title: "Nobitex CSV", clickListener: _onNobitexCSVClicked),
        ],
      ),
    );
  }

  void _onCustomCSVClicked() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
      print(await file.readAsString());
    } else {
      // User canceled the picker
    }
  }

  void _onNobitexCSVClicked() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      NobitexTransactions.addTransactionsFromFile(result.files.single.path);
    } else {
      // User canceled the picker
    }
  }
}

class ImportItem extends StatelessWidget {
  final String title;
  final void Function() clickListener;

  const ImportItem({Key key, this.title, this.clickListener}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[900],
      child: InkWell(
        onTap: clickListener,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.table_chart_outlined),
                  ),
                  Text(title),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(Icons.info_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
