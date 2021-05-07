import 'package:flutter/material.dart';
import 'package:iiportfo/data/bloc/import_sources/import_sources_bloc.dart';
import 'package:iiportfo/data/bloc/import_sources/model/csv_source_item_data.dart';
import 'package:iiportfo/main.dart';

class CsvImportSourceItem extends StatelessWidget {
  final CsvImportSourceItemData item;
  final ImportSourcesBloc bloc;

  const CsvImportSourceItem({Key key, this.item, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Card(
        child: Dismissible(
          background: stackBehindDismiss(),
          onDismissed: (direction) {
            bloc.deleteItem(item);
          },
          key: ObjectKey(item.filePath),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.accountName,
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: primaryColor),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          item.filePath,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.sync),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget stackBehindDismiss() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
