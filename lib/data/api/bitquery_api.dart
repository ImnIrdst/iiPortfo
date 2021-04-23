import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class BitQueryAPI {
  static final _baseUrl = "pro-api.coinmarketcap.com";
  static final _quotesApiUrl = "/v2/cryptocurrency/quotes/latest";

  static ValueNotifier<GraphQLClient> getGraphQLClient() {
    final httpLink = HttpLink(
      'https://graphql.bitquery.io',
    );

    // final authLink = AuthLink(
    //   // ignore: undefined_identifier
    //   getToken: () async => 'Bearer ', //$YOUR_PERSONAL_ACCESS_TOKEN',
    // );
    //
    // var link = authLink.concat(httpLink);

    final client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      ),
    );

    return client;
  }

  static get params => {
        "limit": 10,
        "offset": 0,
        "address": "bnb1nkvu3gfxx2475k5zehsz3mdpfy8t022acxyzu0",
        "from": null,
        "till": null,
        "dateFormat": "%Y-%m"
      };

  static get query => """
query (
      \$address: String!,
      \$limit: Int!,
      \$offset: Int!
      \$from: ISO8601DateTime,
      \$till: ISO8601DateTime){
  binance {
    transfers(options:{desc: "block.timestamp.time" asc: "currency.symbol" limit: \$limit, offset: \$offset},
      date: {since: \$from till: \$till },
      receiver: {is: \$address}) {

      block {
        timestamp {
          time (format: "%Y-%m-%d %H:%M:%S")
        }
        height
      }
      address: sender {
        address
        annotation
      }
      currency {
        address
        symbol
        tokenId
      }
      amount
      transaction {
        hash
      }
      tradeId
      transferType

    }
  }
}
  """;
}
