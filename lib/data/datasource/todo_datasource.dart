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
        optimisticResult: QueryResultSource.optimisticResult,
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
      ),
    );

    if (result.data == null) {
      throw Exception();
    }

    final TodoModel model = TodoModel.fromJson(result.data?['createTodo']);

    final Todo entity = model.toEntity();

    return entity;
  }
}
