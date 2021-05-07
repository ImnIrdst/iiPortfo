import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iiportfo/data/portfo_item_data.dart';
import 'package:iiportfo/screen/home/portfo_item.dart';
import 'package:iiportfo/screen/home/summary_header.dart';
import 'package:iiportfo/screen/import/import_screen.dart';

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
    getPortfolioItems(true).then((value) {
      setState(() {
        _items = value;
        _isLoading = false;
      });
    });
    super.initState();
  }

  void _showImportBottomSheet() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImportPage()),
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
          width: max(MediaQuery.of(context).size.width, 360),
          child: RefreshIndicator(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 64),
              itemCount: _items.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return SummaryHeader(_items);
                } else {
                  return PortfoItem(_items[i - 1]);
                }
              },
            ),
            onRefresh: _onRefresh,
          ),
        ),
      );
    }
  }

  Future<void> _onRefresh() async {
    final newItems = await getPortfolioItems(false);

    setState(() {
      this._items = newItems;
    });
  }
}
