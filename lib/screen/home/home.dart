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
    _loadPortfolioItems();
    super.initState();
  }

  void _navigateToImportPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImportPage(),
        settings: RouteSettings(name: ImportPage.ROUTE_NAME),
      ),
    ).then((value) {
      _loadPortfolioItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _renderBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _navigateToImportPage(context);
        },
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
              itemCount: _items.length + 2,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return SummaryHeader(_items);
                } else if (i == _items.length + 1) {
                  if (_items.length == 0) {
                    return Container();
                  }
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: OutlinedButton(
                      child: Text("Clear All Transactions"),
                      onPressed: () async {
                        await clearAllTransactions();
                        await _onRefresh();
                      },
                    ),
                  );
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

  void _loadPortfolioItems() {
    getPortfolioItems(true).then((value) {
      setState(() {
        _items = value;
        _isLoading = false;
      });
    });
  }
}
