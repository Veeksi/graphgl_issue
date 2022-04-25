import 'package:gql/language.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class ISafeApiCall {
  ObservableQuery<Object?> safeWatchQuery(String document);
  Future<QueryResult> safeMutation({
    required String documentMutation,
    required String documentQuery,
    required Map<String, dynamic> variables,
    required String oldData,
    required String newData,
  });
}

@LazySingleton(as: ISafeApiCall)
class SafeApiCall implements ISafeApiCall {
  SafeApiCall(this._client);

  final GraphQLClient _client;

  @override
  ObservableQuery<Object?> safeWatchQuery(String document) {
    final observableQuery = _client.watchQuery(
      WatchQueryOptions(
        document: gql(document),
        fetchResults: true,
      ),
    );

    return observableQuery;
  }

  @override
  Future<QueryResult> safeMutation({
    required String documentMutation,
    /// Query to read query for caching
    required String documentQuery,
    required Map<String, dynamic> variables,
    required String oldData,
    required String newData,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(documentMutation),
        variables: variables,
        update: (cache, result) {
          // We don't wanna update cache nor handle error throwing here
          if (result != null && result.hasException) {
            return;
          }

          final queryRequest = Operation(
            document: parseString(documentQuery),
          ).asRequest();

          final data = _client.readQuery(queryRequest);

          cache.writeQuery(queryRequest, data: {
            oldData: [
              ...data?[oldData],
              result?.data?[newData],
            ],
          });
        },
      ),
    );

    if (result.hasException) {
      print('DEBUG: Exception ${result.exception}');
      throw Exception();
    }

    return result;
  }
}

/*
cache.writeQuery(queryRequest, data: {
  "todos": [
    ...data?['todos'],
    result?.data?['createTodo'],
  ],
});
*/