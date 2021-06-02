import 'package:flutter/material.dart';
import 'package:iiportfo/data/bloc/transactions/transaction_bloc.dart';

class CoinDetailsPage extends StatefulWidget {
  static const ROUTE_NAME = "coin_detail";

  final String title;

  const CoinDetailsPage({Key key, this.title = "Coin Details"})
      : super(key: key);

  @override
  _CoinDetailsScreenState createState() => _CoinDetailsScreenState();
}

class _CoinDetailsScreenState extends State<CoinDetailsPage> {
  final transactionBloc = TransactionBloc();

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
      child: Text("Not Implemented"),
    );
  }
}
