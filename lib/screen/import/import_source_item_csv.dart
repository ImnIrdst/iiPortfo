import 'package:flutter/material.dart';
import 'package:iiportfo/data/bloc/import_sources/import_sources_bloc.dart';
import 'package:iiportfo/data/bloc/import_sources/model/csv_source_item_data.dart';
import 'package:iiportfo/data/bloc/transactions/model/state.dart';
import 'package:iiportfo/data/bloc/transactions/transaction_bloc.dart';
import 'package:iiportfo/main.dart';

class CsvImportSourceItem extends StatelessWidget {
  final CsvImportSourceItemData item;
  final ImportSourcesBloc importSourcesBloc;
  final TransactionBloc transactionBloc;

  const CsvImportSourceItem({
    Key key,
    this.item,
    this.importSourcesBloc,
    this.transactionBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Card(
        child: Dismissible(
          background: stackBehindDismiss(),
          onDismissed: (direction) {
            importSourcesBloc.deleteItem(item);
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
                      onPressed: () {
                        showLoaderDialog(context);
                        // transactionBloc.syncTransactions(item);
                      },
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

  showLoaderDialog(BuildContext context) async {
    transactionBloc.createTransactionHelper(item);
    AlertDialog alert = AlertDialog(
      content: StreamBuilder<ProgressState>(
        stream: transactionBloc.currentTransactionHelper.progressStream,
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            return Row(
              children: [
                Stack(
                  children: [
                    CircularProgressIndicator(
                      value: snapshot.data.progress,
                    ),
                    Text(
                      "${(snapshot.data.progressPercent)}%",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                  alignment: AlignmentDirectional.center,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(snapshot.data.info, maxLines: 1),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            Navigator.of(context).pop();
          }
          return Row();
        },
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((value) {
      transactionBloc.currentTransactionHelper?.close();
    });
    await transactionBloc.syncTransactions();
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
