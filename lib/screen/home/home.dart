import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iiportfo/data/portfo_item_data.dart';
import 'package:iiportfo/data/transaction_helper.dart';
import 'package:iiportfo/screen/home/import_bottom_sheet.dart';
import 'package:iiportfo/screen/home/portfo_item.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PortfoItemData> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    getPortfolioItems().then((value) {
      setState(() {
        _items = value;
        _isLoading = false;
      });
    });
    super.initState();
  }

  void _showImportBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => ImportBottomSheet(
        nobitexCsvItemClickListener: _nobitexItemClickListener,
        bitPayCsvItemClickListener: _bitPayItemClickListener,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _renderBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showImportBottomSheet,
        tooltip: 'Import',
        icon: Icon(Icons.add),
        label: Text("IMPORT"),
      ),
    );
  }

  Widget _renderBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: max(MediaQuery.of(context).size.width, 480),
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, i) => PortfoItem(_items[i]),
          ),
        ),
      );
    }
  }

  Future<void> _nobitexItemClickListener(String filePath) async {
    setState(() {
      _isLoading = true;
    });
    await TransactionHelper.addTransactionsFromNobitexCSV(filePath);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _bitPayItemClickListener(String filePath) async {
    setState(() {
      _isLoading = true;
    });
    await TransactionHelper.addTransactionsFromNobitexCSV(filePath);
    setState(() {
      _isLoading = false;
    });
  }
}
