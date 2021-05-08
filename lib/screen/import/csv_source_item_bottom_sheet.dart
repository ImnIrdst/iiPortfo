import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iiportfo/data/bloc/import_sources/import_sources_bloc.dart';
import 'package:iiportfo/data/bloc/import_sources/model/csv_source_file_type_item_data.dart';
import 'package:iiportfo/data/bloc/import_sources/model/csv_source_item_data.dart';

class AddCSVSourceItemBottomSheet extends StatefulWidget {
  final CsvImportSourceItemData sourceItem;
  final ImportSourcesBloc bloc;

  const AddCSVSourceItemBottomSheet({
    Key key,
    this.bloc,
    this.sourceItem,
  }) : super(key: key);

  @override
  _AddCsvSourceItemBottomSheetState createState() =>
      _AddCsvSourceItemBottomSheetState(this.bloc, this.sourceItem);
}

class _AddCsvSourceItemBottomSheetState
    extends State<AddCSVSourceItemBottomSheet> {
  final isInEditMode;
  var curSourceItem = CsvImportSourceItemData(
    sourceFileType: CsvSourceFileTypeItemData.supportedItems.first,
  );

  var _errorMessage = "";

  final ImportSourcesBloc bloc;
  final _sourceNameTextController = TextEditingController();
  final _accountTextController = TextEditingController();
  final _filePathTextController = TextEditingController();

  _AddCsvSourceItemBottomSheetState(
    this.bloc,
    CsvImportSourceItemData sourceItem,
  ) : isInEditMode = (sourceItem != null) {
    _sourceNameTextController.text = sourceItem?.sourceName;
    _accountTextController.text = sourceItem?.accountName;
    _filePathTextController.text = sourceItem?.filePath;
    if (sourceItem != null) {
      curSourceItem = sourceItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
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
          _renderPathNameRow(context),
          _renderSupportedCsvSourcesSelector(context),
          _renderError(),
          _renderButtonRow(context),
        ],
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

  Widget _renderSupportedCsvSourcesSelector(BuildContext context) {
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
                child: DropdownButton<CsvSourceFileTypeItemData>(
                  value: curSourceItem.sourceFileType,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.grey[200], fontSize: 16),
                  underline: Container(
                    height: 2,
                    color: Colors.grey[400],
                  ),
                  onChanged: (CsvSourceFileTypeItemData newValue) {
                    setState(() {
                      curSourceItem.sourceFileType = newValue;
                    });
                  },
                  items: CsvSourceFileTypeItemData.supportedItems
                      .map(
                        (e) => DropdownMenuItem<CsvSourceFileTypeItemData>(
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

  Widget _renderPathNameRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            // width: MediaQuery.of(context).size.width - 114,
            child: TextField(
              controller: _filePathTextController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'The CSV File Path',
              ),
              // onChanged: (text) {
              //   _filePathTextController.text = text;
              // },
            ),
          ),
          Container(
            height: 52,
            padding: EdgeInsets.only(left: 16),
            child: ElevatedButton(
              child: Icon(Icons.folder_open),
              onPressed: () {
                _onChooseFileItemCLicked(context);
              },
            ),
          )
        ],
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

  void _onChooseFileItemCLicked(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _filePathTextController.text = result.files.single.path;
      });
    }
  }

  void _onAddClicked(BuildContext context) {
    curSourceItem.sourceName = _sourceNameTextController.text;
    curSourceItem.accountName = _accountTextController.text;
    curSourceItem.filePath = _filePathTextController.text;
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
    return "${isInEditMode ? "Edit" : "Add"} CSV Source Item";
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