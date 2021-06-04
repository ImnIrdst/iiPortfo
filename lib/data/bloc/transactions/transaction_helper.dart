import 'package:iiportfo/data/bloc/transactions/model/transaction_item.dart';
import 'package:rxdart/rxdart.dart';

import 'model/state.dart';

abstract class TransactionHelper {
  PublishSubject<ProgressState> progressSubject = PublishSubject();

  Stream<ProgressState> get progressStream => progressSubject.stream;

  Future<List<TransactionItemData>> getItems(Set<String> prevIds);

  void close() {
    progressSubject.close();
  }
}
