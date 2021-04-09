import 'package:flutter/material.dart';
import 'package:iiportfo/data/csv_data.dart';
import 'package:iiportfo/data/portfo_item_data.dart';
import 'package:iiportfo/utils/format_utils.dart';

class PortfoItem extends StatelessWidget {
  final PortfoItemData _item;

  PortfoItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: _getCoinLogo()),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              height: 36,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text(_item.currentPriceUSD.toUSDFormatted()),
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
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 36,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_item.totalUSD.toUSDFormatted()),
                  _item.profitLossUSD.toUSDPriceChangeWidget(context),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 36,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_item.totalIRR.toIRRFormatted()),
                  _item.profitLossIRR.toIRRPriceChangeWidget(context),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Icon(
                      _item.profitLossPercent.toPercentChangeIcon(),
                      size: 20,
                      color: _item.profitLossPercent.toPercentChangeColor(),
                    ),
                    _item.profitLossPercent.toPercentChangeWidget(context),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget _getCoinLogo() {
    print(_item.symbol);
    if (_item.symbol == IRR_SYMBOL) {
      return Image.asset(
        "lib/assets/img/irr-logo.png",
        width: 32,
        height: 32,
      );
    } else {
      return Image.network(
        _item.imageUrl.toString(),
        width: 32,
        height: 32,
      );
    }
  }
}
