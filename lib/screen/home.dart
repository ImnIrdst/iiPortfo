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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              _item.imageUrl.toString(),
              width: 32,
              height: 32,
            ),
          ),
          SizedBox(
            width: 156,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _item.symbol,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 2),
                        alignment: Alignment.centerRight,
                        child: Text(
                          _item.rank.toRankFormatted(),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(_item.priceUSD.toUSDFormatted()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: _item.percentChange24hUSD
                            .toPercentChangeWidget(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 92,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_item.totalUSD.toUSDFormatted()),
                _item.profitLossUSD.toPriceChangeWidget(context),
                _item.profitLossPercent.toPercentChangeWidget(context),
              ],
            ),
          ),
          SizedBox(
            width: 128,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_item.totalIRR.toIRRFormatted()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
