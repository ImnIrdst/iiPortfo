import 'package:flutter/material.dart';
import 'package:iiportfo/data/portfo_item_data.dart';
import 'package:iiportfo/utils/format_utils.dart';

class SummaryHeader extends StatelessWidget {
  final List<PortfoItemData> _items;

  SummaryHeader(this._items);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getItem(
            context,
            "Total IRR: ",
            _getTotalIRR(),
          ),
          _getItem(
            context,
            "Total USD: ",
            _getTotalUSD(),
          ),
          _getItem(
            context,
            "24h Profit: ",
            _get24HProfitUSD(),
          ),
          _getItem(
            context,
            "All Time Profit: ",
            _getAllTimeProfitUSD(),
          ),
        ],
      ),
    );
  }

  Widget _getItem(BuildContext context, String key, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }

  String _getTotalIRR() {
    var total = 0.0;
    _items.forEach((it) {
      total += it.totalIRR;
    });

    return total.toIRRFormatted();
  }

  String _getTotalUSD() {
    var total = 0.0;
    _items.forEach((it) {
      total += it.totalUSD;
    });

    return total.toUSDFormatted();
  }

  String _getAllTimeProfitUSD() {
    var total = 0.0;
    _items.forEach((it) {
      total += it.profitLossUSD;
    });

    return total.toUSDFormatted();
  }

  String _get24HProfitUSD() {
    var total = 0.0;
    _items.forEach((it) {
      total += it.percentChange24hUSD * it.totalUSD;
    });

    return total.toUSDFormatted();
  }
}
