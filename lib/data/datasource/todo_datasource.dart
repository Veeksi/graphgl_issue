import 'package:gql/language.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_test/domain/todo.dart';
import 'package:graphql_test/domain/todo_model.dart';
import 'package:graphql_test/main.dart';
import 'package:injectable/injectable.dart';

abstract class ITodoDatasource {
  ObservableQuery<Object?> getTodos();
  Future<Todo> createTodo(String text, String userId);
}

@LazySingleton(as: ITodoDatasource)
class CharacterDatasource implements ITodoDatasource {
  CharacterDatasource(this._client);

  final GraphQLClient _client;

  @override
  ObservableQuery<Object?> getTodos() {
    final observableQuery = _client.watchQuery(
      WatchQueryOptions(
        document: gql(GqlQuery.todoQuery),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        fetchResults: true,
      ),
    );

    return observableQuery;
  }

  @override
  Future<Todo> createTodo(String text, String userId) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(GqlQuery.todoMutation),
        variables: {
          'text': text,
          'userId': userId,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        update: (cache, result) {
          if (result != null && result.hasException) {
            throw Exception();
          }
          final queryRequest = Operation(
            document: parseString(GqlQuery.todoQuery),
          ).asRequest();

          final data = _client.readQuery(queryRequest);

          cache.writeQuery(queryRequest, data: {
            "todos": [
              ...data?['todos'],
              result?.data?['createTodo'],
            ],
          });
        },
      ),
    );

    if (result.hasException) {
      throw Exception();
    }

    final TodoModel model = TodoModel.fromJson(result.data?['createTodo']);

    final Todo entity = model.toEntity();

    return entity;
  }
}
