
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImportBottomSheet extends StatelessWidget {
  final Future<void> Function(String) customCsvItemClickListener;
  final Future<void> Function(String) nobitexCsvItemClickListener;
  final Future<void> Function(String) bitPayCsvItemClickListener;
  final Future<void> Function(String) bitcoinComBchCsvItemClickListener;
  final Future<void> Function(String) cryptoIdLtcCsvItemClickListener;
  final Future<void> Function(String, bool) bitQueryCsvItemClickListener;
  final Future<void> Function(String, bool)
      binanceWithdrawalDepositItemClickListener;
  final Future<void> Function(String) binanceTradesItemClickListener;

  const ImportBottomSheet({
    Key key,
    this.customCsvItemClickListener,
    this.nobitexCsvItemClickListener,
    this.bitPayCsvItemClickListener,
    this.bitcoinComBchCsvItemClickListener,
    this.cryptoIdLtcCsvItemClickListener,
    this.bitQueryCsvItemClickListener,
    this.binanceWithdrawalDepositItemClickListener,
    this.binanceTradesItemClickListener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.symmetric(vertical: 16),
      // color: Colors.grey[900],
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(184, 0, 184, 32),
            height: 4,
            color: Colors.grey[700],
          ),
          ImportItem(title: "Custom CSV", clickListener: _onCustomCSVClicked),
          ImportItem(title: "Nobitex CSV", clickListener: _onNobitexCSVClicked),
          ImportItem(title: "Bitpay CSV", clickListener: _onBitPayCSVClicked),
          ImportItem(
            title: "Bitcoin.com CSV (Bitcoin Cash)",
            clickListener: _onBitcoinComBchCSVCLicked,
          ),
          ImportItem(
            title: "CryptoId CSV (Lite Coin)",
            clickListener: _onCryptoIdLtcCSVCLicked,
          ),
          ImportItem(
            title: "BitQuery Inflow CSV",
            clickListener: _onBitQueryInflowCSVClicked,
          ),
          ImportItem(
            title: "BitQuery outFlow CSV",
            clickListener: _onBitQueryOutflowCSVClicked,
          ),
          ImportItem(
            title: "Binance Deposit CSV",
            clickListener: _onBinanceDepositCSVClicked,
          ),
          ImportItem(
            title: "Binance Withdrawal CSV",
            clickListener: _onBinanceWithdrawalCSVClicked,
          ),
          ImportItem(
            title: "Binance Trades CSV",
            clickListener: _onBinanceTradeCSVClicked,
          ),
        ],
      ),
    );
  }

  void _onCustomCSVClicked(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      customCsvItemClickListener.call(result.files.single.path);
      Navigator.pop(context);
    } else {
      // User canceled the picker
    }
  }

  void _onNobitexCSVClicked(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      nobitexCsvItemClickListener.call(result.files.single.path);
      Navigator.pop(context);
    } else {
      // User canceled the picker
    }
  }

  void _onBitPayCSVClicked(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      bitPayCsvItemClickListener.call(result.files.single.path);
      Navigator.pop(context);
    } else {
      // User canceled the picker
    }
  }

  void _onBitcoinComBchCSVCLicked(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      bitcoinComBchCsvItemClickListener.call(result.files.single.path);
      Navigator.pop(context);
    } else {
      // User canceled the picker
    }
  }

  void _onCryptoIdLtcCSVCLicked(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      cryptoIdLtcCsvItemClickListener.call(result.files.single.path);
      Navigator.pop(context);
    } else {
      // User canceled the picker
    }
  }

  void _onBitQueryInflowCSVClicked(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      bitQueryCsvItemClickListener.call(result.files.single.path, true);
      Navigator.pop(context);
    } else {
      // User canceled the picker
    }
  }

  void _onBitQueryOutflowCSVClicked(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      bitQueryCsvItemClickListener.call(result.files.single.path, false);
      Navigator.pop(context);
    } else {
      // User canceled the picker
    }
  }

  void _onBinanceDepositCSVClicked(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      binanceWithdrawalDepositItemClickListener.call(
        result.files.single.path,
        true,
      );
      Navigator.pop(context);
    } else {
      // User canceled the picker
    }
  }

  void _onBinanceWithdrawalCSVClicked(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      binanceWithdrawalDepositItemClickListener.call(
        result.files.single.path,
        false,
      );
      Navigator.pop(context);
    } else {
      // User canceled the picker
    }
  }

  void _onBinanceTradeCSVClicked(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      binanceTradesItemClickListener.call(
        result.files.single.path,
      );
      Navigator.pop(context);
    } else {
      // User canceled the picker
    }
  }
}

class ImportItem extends StatelessWidget {
  final String title;
  final void Function(BuildContext) clickListener;

  const ImportItem({Key key, this.title, this.clickListener}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[900],
      child: InkWell(
        onTap: () {
          clickListener.call(context);
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.table_chart_outlined),
                  ),
                  Text(title),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(Icons.info_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
