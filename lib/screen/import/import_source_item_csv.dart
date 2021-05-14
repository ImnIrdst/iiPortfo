import 'package:flutter/material.dart';
import 'package:iiportfo/data/bloc/import_sources/import_sources_bloc.dart';
import 'package:iiportfo/data/bloc/import_sources/model/csv_source_item_data.dart';
import 'package:iiportfo/data/bloc/transactions/transaction_bloc.dart';
import 'package:iiportfo/main.dart';
import 'package:iiportfo/screen/import/csv_source_item_bottom_sheet.dart';
import 'package:iiportfo/widget/progress_dialog.dart';

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
    return InkWell(
      onTap: () => _onItemCLicked(context),
      child: Container(
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
                          item.sourceName,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(color: primaryColor),
                        ),
                        Text(
                          "Account: ${item.accountName}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
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
      ),
    );
  }

  showLoaderDialog(BuildContext context) async {
    transactionBloc.createTransactionHelper(item);
    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      useSafeArea: true,
      context: context,
      builder: (context) => ProgressDialog(
        progressStream: transactionBloc.currentTransactionHelper.progressStream,
      ),
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

  void _onItemCLicked(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddCSVSourceItemBottomSheet(
        bloc: importSourcesBloc,
        sourceItem: item,
      ),
    );
  }
}
