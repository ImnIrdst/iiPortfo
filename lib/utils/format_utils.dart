import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final usdNumberFormat = NumberFormat("\$,##0.0#");
final irrNumberFormat = NumberFormat.compact();
final percentNumberFormat = NumberFormat("#,##0.#%");
final amountFormat = NumberFormat("##0.00####");

extension PriceUtils on double {
  String toIRRFormatted() => irrNumberFormat.format(this);

  String toUSDFormatted() => usdNumberFormat.format(this);

  Widget toIRRPriceChangeWidget(BuildContext context) {
    final color = this < 0 ? Colors.red : Colors.green;
    final sign = this < 0 ? "" : "+";
    return Text(
      sign + this.toIRRFormatted(),
      style: Theme.of(context).textTheme.caption.copyWith(color: color),
    );
  }

  Widget toUSDPriceChangeWidget(BuildContext context) {
    final color = this < 0 ? Colors.red : Colors.green;
    final sign = this < 0 ? "" : "+";
    return Text(
      sign + this.toUSDFormatted(),
      style: Theme.of(context).textTheme.caption.copyWith(color: color),
    );
  }
}

extension PercentUtils on double {
  String toPercentFormatted() => percentNumberFormat.format(this);

  Widget toPercentChangeWidget(BuildContext context) {
    final sign = this < 0 ? "" : "+";
    return Text(
      sign + this.toPercentFormatted(),
      style: Theme.of(context)
          .textTheme
          .caption
          .copyWith(color: this.toPercentChangeColor()),
    );
  }

  IconData toPercentChangeIcon() {
    if (this >= 0) {
      return Icons.arrow_drop_up;
    } else {
      return Icons.arrow_drop_down;
    }
  }

  Color toPercentChangeColor() {
    if (this >= 0) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}

extension RankUtils on int {
  String toRankFormatted() => "#$this";
}

extension AmountUtils on double {
  String toAmountFormatted() => amountFormat.format(this);
}
