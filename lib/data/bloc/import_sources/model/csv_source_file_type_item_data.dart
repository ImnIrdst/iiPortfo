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
    customCsvSourceFileType,
    binanceDepositsSourceFileType,
    bqBCHInflowSourceFileType,
    bqBCHOutflowSourceFileType,
    bqLTCInflowSourceFileType,
    bqLTCOutflowSourceFileType,
    bqBNBInflowSourceFileType,
    bqBNBOutflowSourceFileType,
    bqBSCInflowSourceFileType,
    bqBSCOutflowSourceFileType,
  ];
}

final nobitexSourceFileType =
    CsvSourceFileTypeItemData("nobitex", "Nobitex Transactions");

final bitPaySourceFileType =
    CsvSourceFileTypeItemData("bitpay", "Bitpay Transactions");

final customCsvSourceFileType =
    CsvSourceFileTypeItemData("custom", "Custom Transactions");

final binanceDepositsSourceFileType = CsvSourceFileTypeItemData(
    "binance-deposits", "Binance Deposit Transactions");

final bqBCHInflowSourceFileType = CsvSourceFileTypeItemData(
    "bitquery-bch-inflow", "Bitquery BCH Inflow Transactions");

final bqBCHOutflowSourceFileType = CsvSourceFileTypeItemData(
    "bitquery-bch-outflow", "Bitquery BCH Outflow Transactions");

final bqLTCInflowSourceFileType = CsvSourceFileTypeItemData(
    "bitquery-ltc-inflow", "Bitquery LTC Inflow Transactions");

final bqLTCOutflowSourceFileType = CsvSourceFileTypeItemData(
    "bitquery-ltc-outflow", "Bitquery LTC Outflow Transactions");

final bqBNBInflowSourceFileType = CsvSourceFileTypeItemData(
    "bitquery-bnb-inflow", "Bitquery BNB Inflow Transactions");

final bqBNBOutflowSourceFileType = CsvSourceFileTypeItemData(
    "bitquery-bnb-outflow", "Bitquery BNB Outflow Transactions");

final bqBSCInflowSourceFileType = CsvSourceFileTypeItemData(
    "bitquery-bsc-inflow", "Bitquery BSC Inflow Transactions");

final bqBSCOutflowSourceFileType = CsvSourceFileTypeItemData(
    "bitquery-bsc-outflow", "Bitquery BSC Outflow Transactions");