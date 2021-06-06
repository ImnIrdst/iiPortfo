import 'package:flutter/cupertino.dart';

class TransactionItemData extends Comparable<TransactionItemData> {
  final String id;
  final DateTime date;
  final String symbol;
  final double amount;
  final double buyPrice;
  final String description;
  final String account;

  TransactionItemData({
    @required this.id,
    @required this.date,
    @required this.symbol,
    @required this.amount,
    @required this.buyPrice,
    @required this.description,
    @required this.account,
  });

  String toCsvRow() =>
      "$id,$date,$symbol,$amount,$buyPrice,$description,$account";

  static String getCsvHeader() =>
      "id,date,symbol,amount,buyPrice,description,account";

  @override
  String toString() => toCsvRow();

  @override
  int compareTo(TransactionItemData other) {
    final dateCompare = this.date.compareTo(other.date);
    if (dateCompare != 0) return dateCompare;
    return this.amount.compareTo(other.amount);
  }
}
