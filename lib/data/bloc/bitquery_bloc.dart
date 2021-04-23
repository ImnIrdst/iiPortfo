import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:iiportfo/data/api/bitquery_api.dart';
import 'package:rxdart/subjects.dart';

class Repo {
  const Repo({this.id, this.name, this.viewerHasStarred});

  final String id;
  final String name;
  final bool viewerHasStarred;
}

class Bloc {
  static final HttpLink _httpLink = HttpLink(
    'https://graphql.bitquery.io',
    defaultHeaders: {
      "X-API-KEY": "BQYS4BunQihTqd2KOMVd9kYBpgdqlC9v",
    },
  );

  // static final AuthLink _authLink = AuthLink(
  //   // ignore: undefined_identifier
  //   getToken: () async => 'Bearer BQYS4BunQihTqd2KOMVd9kYBpgdqlC9v',
  // );

  static final Link _link = _httpLink; // _authLink.concat(_httpLink);

  final BehaviorSubject<List<Repo>> _repoSubject =
      BehaviorSubject<List<Repo>>();

  Stream<List<Repo>> get repoStream => _repoSubject.stream;

  static final GraphQLClient _client = GraphQLClient(
    cache: GraphQLCache(),
    link: _link,
  );

  Future<void> queryRepo() async {
    // null is loading
    _repoSubject.add(null);
    final _options = WatchQueryOptions(
      document: gql(BitQueryAPI.query),
      variables: BitQueryAPI.params,
    );

    final result = await _client.query(_options);

    if (result.hasException) {
      final org = result.exception.linkException.originalException;
      if (org is FormatException) {
        print(org.source);
      }
      _repoSubject.addError(result.exception);
      return;
    }

    // print(result);
    final transfers = result.data["binance"]["transfers"] as List<Object>;
    // final transfersList = transfers as List<Object>;
    transfers.forEach((element) {
      print(element);
    });
    // if (transfers != null && transfers is List<Object>) {
    //   print(transfers);
    // }
  }
}
