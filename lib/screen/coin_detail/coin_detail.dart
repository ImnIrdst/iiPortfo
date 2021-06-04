import 'package:flutter/material.dart';
import 'package:iiportfo/data/bloc/transactions/model/transaction_item.dart';
import 'package:iiportfo/data/bloc/transactions/transaction_bloc.dart';
import 'package:iiportfo/screen/coin_detail/transaction_item.dart';

class CoinDetailsPage extends StatefulWidget {
  static const ROUTE_NAME = "/coin_detail";

  final String symbol;
  final String title;

  const CoinDetailsPage({Key key, this.symbol})
      : title = "$symbol Details",
        super(key: key);

  @override
  _CoinDetailsScreenState createState() => _CoinDetailsScreenState(symbol);
}

class _CoinDetailsScreenState extends State<CoinDetailsPage> {
  final transactionBloc = TransactionBloc();

  final String symbol;

  _CoinDetailsScreenState(this.symbol);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _renderBody(),
    );
  }

  Widget _renderBody() {
    return Container(
      child: FutureBuilder<List<TransactionItemData>>(
          future: transactionBloc.getTransactionsForCoin(this.symbol),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => TransactionItem(
                  item: snapshot.data[index],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
