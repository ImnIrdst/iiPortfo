import 'package:flutter/material.dart';

class ImportBottomSheet extends StatelessWidget {
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
          ImportItem(title: "Custom CSV"),
          ImportItem(title: "Nobitex"),
        ],
      ),
    );
  }
}

class ImportItem extends StatelessWidget {
  final String title;

  const ImportItem({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
