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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CsvSourceFileTypeItemData && id == other.id;

  @override
  int get hashCode => id.hashCode;

  static final supportedItems = [
    nobitexSourceFileType,
    bitPaySourceFileType,
  ];
}

final nobitexSourceFileType =
    CsvSourceFileTypeItemData("nobitex", "Nobitex Transactions");

final bitPaySourceFileType =
    CsvSourceFileTypeItemData("bitpay", "Bitpay Transactions");