import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final usdNumberFormat = NumberFormat("\$,##0.0#");
final irrNumberFormat = NumberFormat(",##0");
final percentNumberFormat = NumberFormat("#,##0.#%");

extension PriceUtils on double {
  String toIRRFormatted() => irrNumberFormat.format(this);

  String toUSDFormatted() => usdNumberFormat.format(this);

  Widget toPriceChangeWidget(BuildContext context) {
    final color = this < 0 ? Colors.red : Colors.green;
    return Text(
      this.toUSDFormatted(),
      style: Theme.of(context).textTheme.caption.copyWith(color: color),
    );
  }
}

extension PercentUtils on double {
  String toPercentFormatted() => percentNumberFormat.format(this);

  Widget toPercentChangeWidget(BuildContext context) {
    final color = this < 0 ? Colors.red : Colors.green;
    return Text(
      this.toPercentFormatted(),
      style: Theme.of(context).textTheme.caption.copyWith(color: color),
    );
  }
}

extension RankUtils on int {
  String toRankFormatted() => "#$this";
}
