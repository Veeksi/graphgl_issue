import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_test/domain/todo.dart';
import 'package:graphql_test/domain/todo_model.dart';
import 'package:graphql_test/main.dart';
import 'package:injectable/injectable.dart';

abstract class ITodoDatasource {
  Future<List<Todo>> getTodos();
  Future<Todo> createTodo(String text, String userId);
}

@LazySingleton(as: ITodoDatasource)
class CharacterDatasource implements ITodoDatasource {
  CharacterDatasource(this._client);

  final GraphQLClient _client;

  @override
  Future<List<Todo>> getTodos() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(GqlQuery.todoQuery),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    print('DEBUG: ${[result.source, result.exception]}');
    print('DEBUG: ----------------------------------------\n');
    print('DEBUG: ${[result.data, result.exception]}');

    if (result.data == null) {
      return [];
    }

    final List<TodoModel> models = result.data?['todos']
        .map((e) => TodoModel.fromJson(e))
        .cast<TodoModel>()
        .toList();

    final data = models.map<Todo>((e) => e.toEntity()).toList();

    return data;
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

    print('DEBUG: ${[result.source, result.exception]}');
    print('DEBUG: ----------------------------------------\n');
    print('DEBUG: ${[result.data, result.exception]}');

    if (result.data == null) {
      throw Exception();
    }

    final TodoModel model = TodoModel.fromJson(result.data?['createTodo']);

    final Todo entity = model.toEntity();

    return entity;
  }
}
