import 'package:flutter/material.dart';
import 'package:iiportfo/data/bloc/import_sources/import_sources_bloc.dart';
import 'package:iiportfo/data/bloc/import_sources/model/wallet/wallet_source_item_data.dart';
import 'package:iiportfo/data/bloc/import_sources/model/wallet/wallet_type.dart';

class AddWalletSourceItemBottomSheet extends StatefulWidget {
  final WalletImportSourceItemData sourceItem;
  final ImportSourcesBloc bloc;

  const AddWalletSourceItemBottomSheet({
    Key key,
    this.bloc,
    this.sourceItem,
  }) : super(key: key);

  @override
  _AddWalletSourceItemBottomSheetState createState() =>
      _AddWalletSourceItemBottomSheetState(this.bloc, this.sourceItem);
}

class _AddWalletSourceItemBottomSheetState
    extends State<AddWalletSourceItemBottomSheet> {
  final isInEditMode;
  var curSourceItem = WalletImportSourceItemData(
    walletType: WalletType.supportedItems.first,
  );

  var _errorMessage = "";

  final ImportSourcesBloc bloc;
  final _sourceNameTextController = TextEditingController();
  final _accountTextController = TextEditingController();
  final _addressTextController = TextEditingController();

  _AddWalletSourceItemBottomSheetState(
    this.bloc,
    WalletImportSourceItemData sourceItem,
  ) : isInEditMode = (sourceItem != null) {
    _sourceNameTextController.text = sourceItem?.sourceName;
    _accountTextController.text = sourceItem?.accountName;
    _addressTextController.text = sourceItem?.address;
    if (sourceItem != null) {
      curSourceItem = sourceItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: MediaQuery.of(context).viewInsets +
            EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          border: Border.all(),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _renderHeader(context),
            _renderSourceName(context),
            _renderAccountNameRow(context),
            _renderAddressRow(context),
            _renderSupportedWalletSourcesSelector(context),
            _renderError(),
            _renderButtonRow(context),
          ],
        ),
      ),
    );
  }

  Widget _renderHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        _getHeaderText(),
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }

  Widget _renderAccountNameRow(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: TextField(
            controller: _accountTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter the account name",
              labelText: "Account",
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderSupportedWalletSourcesSelector(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey[400]),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<WalletType>(
                  value: curSourceItem.walletType,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.grey[200], fontSize: 16),
                  underline: Container(
                    height: 2,
                    color: Colors.grey[400],
                  ),
                  onChanged: (WalletType newValue) {
                    setState(() {
                      curSourceItem.walletType = newValue;
                    });
                  },
                  items: WalletType.supportedItems
                      .map(
                        (e) => DropdownMenuItem<WalletType>(
                          child: Container(
                            padding: EdgeInsets.only(right: 16),
                            child: Text(e.name),
                          ),
                          value: e,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderAddressRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: _addressTextController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'The Wallet Address',
        ),
      ),
    );
  }

  Widget _renderButtonRow(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Container(
            height: 86,
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              child: Text("Add"),
              onPressed: () {
                _onAddClicked(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  void _onAddClicked(BuildContext context) {
    curSourceItem.sourceName = _sourceNameTextController.text;
    curSourceItem.accountName = _accountTextController.text;
    curSourceItem.address = _addressTextController.text;
    if (curSourceItem.isCompleted) {
      bloc.addImportSourceItem(curSourceItem);
      Navigator.pop(context);
    } else {
      setState(() {
        _errorMessage = "Please fill all the fields.";
      });
    }
  }

  Widget _renderError() {
    if (_errorMessage != "") {
      Future.delayed(Duration(seconds: 3)).then((value) {
        setState(() {
          _errorMessage = "";
        });
      });
      return Container(
        alignment: AlignmentDirectional.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          _errorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red, fontSize: 15),
        ),
      );
    } else {
      return Container();
    }
  }

  String _getHeaderText() {
    return "${isInEditMode ? "Edit" : "Add"} Wallet Source Item";
  }

  Widget _renderSourceName(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: TextField(
            controller: _sourceNameTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter the source name",
              labelText: "Source Name",
            ),
          ),
        ),
      ],
    );
  }
}