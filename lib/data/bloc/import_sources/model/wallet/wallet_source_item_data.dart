import 'package:iiportfo/data/bloc/import_sources/model/import_source_item_data.dart';
import 'package:iiportfo/data/bloc/import_sources/model/wallet/wallet_type.dart';

class WalletImportSourceItemData extends ImportSourceItemData {
  String address;
  WalletType walletType;

  WalletImportSourceItemData({this.walletType}) : super();

  bool get isCompleted =>
      accountName != null &&
      accountName.isNotEmpty &&
      sourceName != null &&
      sourceName.isNotEmpty &&
      address != null &&
      address.isNotEmpty &&
      walletType != null;

  WalletImportSourceItemData.fromJson(Map<String, dynamic> json)
      : address = json['address'],
        walletType = WalletType.fromJson(json['wallet_type']),
        super.fromJson(json);

  Map<String, dynamic> toJson() {
    final result = super.toJson();
    result.addAll({
      'address': address,
      'wallet_type': walletType.toJson(),
    });
    return result;
  }

  @override
  String toString() {
    return 'WalletSourceItemData{accountName: $accountName, address: $address, walletType: $walletType}';
  }
}
