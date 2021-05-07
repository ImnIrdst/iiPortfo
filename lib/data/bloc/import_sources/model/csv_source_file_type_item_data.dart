class CsvSourceFileTypeItemData {
  final String id;
  final String name;

  CsvSourceFileTypeItemData(this.id, this.name);

  CsvSourceFileTypeItemData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  static final supportedItems = [
    CsvSourceFileTypeItemData("nobitex", "Nobitex Transactions"),
    CsvSourceFileTypeItemData("bitpay", "Bitpay Transactions"),
  ];
}
