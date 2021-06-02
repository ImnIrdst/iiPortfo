import 'package:flutter/material.dart';
import 'package:iiportfo/data/portfo_item_data.dart';
import 'package:iiportfo/screen/coin_detail/coin_detail.dart';
import 'package:iiportfo/utils/format_utils.dart';

class PortfoItem extends StatelessWidget {
  final PortfoItemData _item;

  PortfoItem(this._item);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _onItemClicked(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          direction: Axis.horizontal,
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: _getCoinLogo()),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                height: 48,
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
                    Text(_item.amount.toAmountFormatted()),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                padding: EdgeInsets.only(left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      _item.profitLossPercent.toPercentChangeIcon(),
                      size: 20,
                      color: _item.profitLossPercent.toPercentChangeColor(),
                    ),
                    _item.profitLossPercent.toPercentChangeWidget(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCoinLogo() {
    final dimens = 32.0;
    if (_item.symbol == IRR_SYMBOL) {
      return Image.asset(
        "lib/assets/img/irr-logo.png",
        width: dimens,
        height: dimens,
      );
    } else {
      return Image.network(
        _item.imageUrl.toString(),
        width: dimens,
        height: dimens,
      );
    }
  }

  void _onItemClicked(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoinDetailsPage(title: "${_item.symbol} Details"),
        settings: RouteSettings(name: CoinDetailsPage.ROUTE_NAME),
      ),
    );
  }
}
