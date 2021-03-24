import 'package:flutter/material.dart';
import 'package:iiportfo/data/portfo_item_data.dart';
import 'package:iiportfo/utils/format_utils.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PortfoItemData> _items = [];

  @override
  void initState() {
    getPortfolioItems().then((value) {
      setState(() {
        _items = value;
      });
    });
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showImportBottomSheet,
        tooltip: 'Import',
        icon: Icon(Icons.add),
        label: Text("IMPORT"),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 36,
            padding: EdgeInsets.only(right: 8),
            alignment: Alignment.centerRight,
            child: Text(
              _item.rank.toRankFormatted(),
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Image.network(
            _item.imageUrl.toString(),
            width: 32,
            height: 32,
          ),
          SizedBox(
            width: 256,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(_item.name),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 128,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_item.priceUSD.toUSDFormatted()),
                Text(_item.priceIRR.toIRRFormatted()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
