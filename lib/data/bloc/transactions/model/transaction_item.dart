class TransactionItemData extends Comparable<TransactionItemData> {
  final String id;
  final DateTime date;
  final String symbol;
  final double amount;
  final double buyPrice;
  final String description;
  final String account;

  TransactionItemData({
    this.id,
    this.date,
    this.symbol,
    this.amount,
    this.buyPrice,
    this.description,
    this.account,
  });

  String toCsvRow() =>
      "$id,$date,$symbol,$amount,$buyPrice,$description,$account";

  static String getCsvHeader() =>
      "id,date,symbol,amount,buyPrice,description,account";

  @override
  int compareTo(TransactionItemData other) {
    final dateCompare = this.date.compareTo(other.date);
    if (dateCompare != 0) return dateCompare;
    return this.amount.compareTo(other.amount);
  }
}
