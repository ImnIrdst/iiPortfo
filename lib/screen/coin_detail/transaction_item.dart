import 'package:flutter/material.dart';
import 'package:iiportfo/data/bloc/transactions/model/transaction_item.dart';
import 'package:iiportfo/utils/format_utils.dart';

class TransactionItem extends StatelessWidget {
  final TransactionItemData item;

  const TransactionItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _renderAccount(context),
                _renderDate(context),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _renderAmount(context),
                _renderSellPrice(context),
                _renderTransactionType(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderAccount(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          this.item.account.toString(),
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }

  Widget _renderDate(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: AlignmentDirectional.centerEnd,
        child: Text(
          this.item.date.toString(),
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }

  Widget _renderAmount(BuildContext context) {
    return Expanded(
      child: Text(
        this.item.amount.abs().toAmountFormatted(),
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Widget _renderSellPrice(BuildContext context) {
    return Expanded(
      child: Text(
        this.item.buyPrice.abs().toAmountFormatted(),
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Widget _renderTransactionType(BuildContext context) {
    final label = item.amount >= 0 ? "Buy" : "Sell";
    final color = item.amount >= 0 ? Colors.green : Colors.red;
    return Expanded(
      child: Container(
        alignment: AlignmentDirectional.centerEnd,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyText1.copyWith(color: color),
        ),
      ),
    );
  }
}
