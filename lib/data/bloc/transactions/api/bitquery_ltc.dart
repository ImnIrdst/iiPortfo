import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:iiportfo/data/api/secret_loader.dart';
import 'package:iiportfo/data/bloc/import_sources/model/wallet/wallet_source_item_data.dart';
import 'package:iiportfo/data/bloc/price/PriceHelper.dart';
import 'package:iiportfo/data/bloc/transactions/model/state.dart';
import 'package:iiportfo/data/bloc/transactions/model/transaction_item.dart';
import 'package:iiportfo/data/bloc/transactions/transaction_helper.dart';

class BitQueryLtcTransactionsApi extends TransactionHelper {
  final WalletImportSourceItemData params;
  final String idPrefix;

  GraphQLClient _client;

  String get symbol => params.walletType.symbol;

  final _priceHelper = PriceHelper();

  BitQueryLtcTransactionsApi(this.params)
      : idPrefix = "bitquery-api-${params.walletType.id}";

  @override
  Future<List<TransactionItemData>> getItems(Set<String> prevIds) async {
    await initiateBitqueryApiClient();
    progressSubject.add(ProgressState(0, "processing inflow transactions..."));
    List<TransactionItemData> transactions = [];
    transactions.addAll(await _getInflowTransactions(prevIds));

    return transactions;
  }

  Future<void> initiateBitqueryApiClient() async {
    if (_client == null) {
      final HttpLink _httpLink = HttpLink(
        'https://graphql.bitquery.io',
        defaultHeaders: {
          "X-API-KEY": (await SecretLoader().load()).bitqueryApiKey,
        },
      );

      final _link = _httpLink;

      _client = GraphQLClient(
        cache: GraphQLCache(),
        link: _link,
      );
    }
  }

  Future<List<TransactionItemData>> _getInflowTransactions(
    Set<String> prevIds,
  ) async {
    final _options = WatchQueryOptions(
      document: gql(inflowQuery),
      variables: inflowParams,
    );

    final result = await _client.query(_options);

    if (result.hasException) {
      final org = result.exception.linkException.originalException;
      if (org is FormatException) {
        print(org.source);
      }
      return [];
    }
    final transfers = result.data["bitcoin"]["outputs"] as List<dynamic>;

    final List<TransactionItemData> transactions = [];
    for (var i = 0; i < transfers.length; i++) {
      final item = transfers[i];

      final date = DateTime.parse(item["block"]["timestamp"]["time"]);
      final amount = item["value"];
      final transactionHash = item["transaction"]["hash"];
      final id = "$idPrefix-$amount-$date";

      if (progressSubject.isClosed) {
        return [];
      }

      progressSubject.add(
        ProgressState(
          i.toDouble() / transfers.length,
          "Processing inflow item $i from ${transfers.length}",
        ),
      );

      if (prevIds.contains(id)) {
        continue;
      }

      final transaction = TransactionItemData(
        id: id,
        date: date,
        symbol: symbol,
        amount: amount,
        description: transactionHash,
        account: params.accountName,
        buyPrice: await _priceHelper.getCoinPriceInUSD(date, symbol),
      );
      print(transaction.toCsvRow());
      transactions.add(transaction);
    }

    progressSubject.add(
      ProgressState(
        1,
        "Processing inflow transactions Completed!",
      ),
    );

    return transactions;
  }

  get inflowParams => {
        "limit": 100,
        "offset": 0,
        "address": params.address,
        "network": "litecoin",
        "from": null,
        "till": null,
        "dateFormat": "%Y-%m"
      };

  get inflowQuery => """
    query (\$network: BitcoinNetwork!,
        \$address:String!
        \$limit: Int!,
        \$offset: Int!
        \$from: ISO8601DateTime,
        \$till: ISO8601DateTime){
        bitcoin(network: \$network ){
            outputs(
                date: {
                    since: \$from
                    till: \$till}
                outputAddress: {is: \$address}
                options:{desc: "value"  asc: "block.height" limit: \$limit, offset: \$offset}
            ){
                block {
                    height
                    timestamp{
                        time (format: "%Y-%m-%d %H:%M:%S")
                    }
                }
                transaction {
                    hash
                }
                outputIndex
                outputDirection
    
                value
            }
        }
    }
  """;
}
