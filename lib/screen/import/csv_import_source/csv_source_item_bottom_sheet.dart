import 'package:flutter/material.dart';
import 'package:iiportfo/screen/import/csv_import_source/model/csv_source_file_type_item_data.dart';

class AddCSVSourceItemBottomSheet extends StatefulWidget {
  const AddCSVSourceItemBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  _AddCsvSourceItemBottomSheetState createState() =>
      _AddCsvSourceItemBottomSheetState();
}

class _AddCsvSourceItemBottomSheetState
    extends State<AddCSVSourceItemBottomSheet> {
  CsvSourceFileTypeItemData selectedSourceItem =
      CsvSourceFileTypeItemData.supportedItems.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      // color: Colors.grey[900],
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
          _renderAccountNameRow(context),
          _renderPathNameRow(context),
          _renderSupportedCsvSourcesSelector(context),
          _renderButtonRow(context),
        ],
      ),
    );
  }

  Widget _renderHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        "Add CSV source item",
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

  _renderSupportedCsvSourcesSelector(BuildContext context) {
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
                border: Border.all(color: Colors.grey[600]),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CsvSourceFileTypeItemData>(
                  value: selectedSourceItem,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  underline: Container(
                    height: 2,
                    color: Colors.grey[400],
                  ),
                  onChanged: (CsvSourceFileTypeItemData newValue) {
                    setState(() {
                      selectedSourceItem = newValue;
                    });
                  },
                  items: CsvSourceFileTypeItemData.supportedItems
                      .map(
                        (e) => DropdownMenuItem<CsvSourceFileTypeItemData>(
                          child: Container(
                              padding: EdgeInsets.only(right: 16),
                              child: Text(e.name)),
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
          Container(
            width: MediaQuery.of(context).size.width - 114,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'The csv file path',
              ),
            ),
          ),
          Container(
            height: 52,
            padding: EdgeInsets.only(left: 16),
            child: ElevatedButton(
              child: Icon(Icons.folder_open),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }

  _renderButtonRow(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Container(
            height: 86,
            padding: EdgeInsets.all(16),
            child: ElevatedButton(child: Text("Add"), onPressed: () {}),
          ),
        ),
      ],
    );
  }
}