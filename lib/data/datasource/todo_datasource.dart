import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_test/data/util/safe_api_call.dart';
import 'package:graphql_test/domain/todo.dart';
import 'package:graphql_test/data/dtos/todo_dto.dart';
import 'package:graphql_test/main.dart';
import 'package:injectable/injectable.dart';

abstract class ITodoDatasource {
  ObservableQuery<Object?> getTodos();
  Future<Todo> createTodo(String text, String userId);
}

@LazySingleton(as: ITodoDatasource)
class CharacterDatasource implements ITodoDatasource {
  CharacterDatasource(this._safeApiCall);

  final ISafeApiCall _safeApiCall;

  @override
  ObservableQuery<Object?> getTodos() {
    return _safeApiCall.safeWatchQuery(GqlQuery.todoQuery);
  }

  @override
  Future<Todo> createTodo(String text, String userId) async {
    final result = await _safeApiCall.safeMutation(
      documentMutation: GqlQuery.todoMutation,
      documentQuery: GqlQuery.todoQuery,
      variables: {
        'text': text,
        'userId': userId,
      },
      oldData: 'todos',
      newData: 'createTodo',
    );

    final TodoDto model = TodoDto.fromJson(result.data?['createTodo']);

    final Todo entity = model.toEntity();

    return entity;
  }
}
