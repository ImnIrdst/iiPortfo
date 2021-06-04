class WalletType {
  final String id;
  final String name;

  WalletType(this.id, this.name);

  WalletType.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WalletType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'WalletType{id: $id, name: $name}';
  }

  static final supportedItems = [bch, ltc, bnb, bsc];
}

final bch = WalletType("bch", "Bitcoin cash");
final ltc = WalletType("ltc", "Lite Coin");
final bnb = WalletType("bnb", "Binance Chain");
final bsc = WalletType("bsc", "Binance Smart Chain");
