import 'package:flutter/material.dart';

class AddCSVSourceItemBottomSheet extends StatelessWidget {
  const AddCSVSourceItemBottomSheet({
    Key key,
  }) : super(key: key);

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
        style: Theme.of(context).textTheme.headline6,
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