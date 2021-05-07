class AggregatedData {
  final String symbol;

  double amount = 0;
  double totalPrice = 0;

  AggregatedData(this.symbol);

  double get averageBuyPrice => amount != 0 ? totalPrice / amount : 0;
}
