class CsvSourceItemData {
  final String id;
  final String name;

  CsvSourceItemData(this.id, this.name);

  static final supportedItems = [
    CsvSourceItemData("nobitex", "Nobitex Transactions"),
    CsvSourceItemData("bitpay", "Bitpay Transactions"),
  ];
}
