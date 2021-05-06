class CsvSourceFileTypeItemData {
  final String id;
  final String name;

  CsvSourceFileTypeItemData(this.id, this.name);

  static final supportedItems = [
    CsvSourceFileTypeItemData("nobitex", "Nobitex Transactions"),
    CsvSourceFileTypeItemData("bitpay", "Bitpay Transactions"),
  ];
}
