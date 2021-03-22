import 'package:intl/intl.dart';

final usdNumberFormat = NumberFormat(",##0.0#");
final irrNumberFormat = NumberFormat(",##0");

extension PriceUtils on double {
  String toIRRFormatted() => irrNumberFormat.format(this);

  String toUSDFormatted() => usdNumberFormat.format(this);
}
