import 'package:flutter/material.dart';
import 'package:iiportfo/data/portfo_item_data.dart';
import 'package:iiportfo/data/secret_loader.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _items = mockData;

  @override
  void initState() {
    final secret = SecretLoader()
        .load()
        .then((secret) => {print(secret.coinMarketCapApiKey)});

    super.initState();
  }

  void _showImportBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.grey[900],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Modal BottomSheet'),
                ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, i) => PortfoItem(_items[i]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showImportBottomSheet,
        tooltip: 'Import',
        child: Icon(Icons.add),
      ),
    );
  }
}

class PortfoItem extends StatelessWidget {
  final PortfoItemData _item;

  PortfoItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(_item.name),
    );
  }
}
