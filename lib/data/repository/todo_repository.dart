import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_test/data/datasource/todo_datasource.dart';
import 'package:graphql_test/domain/todo.dart';
import 'package:graphql_test/data/dtos/todo_dto.dart';
import 'package:injectable/injectable.dart';

abstract class ITodoRepository {
  Stream<List<Todo>> get todos;
  void getTodos();
  Future<Todo> createTodo(String text, String userId);
}

@LazySingleton(as: ITodoRepository)
class TodoRepository implements ITodoRepository {
  TodoRepository(
    this._todoDatasource,
  );

  final ITodoDatasource _todoDatasource;

  final _controller = StreamController<List<Todo>>();

  @override
  Stream<List<Todo>> get todos async* {
    yield* _controller.stream;
  }

  void dispose() {
    _controller.close();
  }

  @override
  void getTodos() {
    final query = _todoDatasource.getTodos();

    query.stream.listen((QueryResult result) {
      if (!result.isLoading && result.data != null) {
        if (result.hasException) {
          _controller.addError(result);
        }
        if (result.isLoading) {
          return;
        }

        final List<TodoDto> todoModels = result.data?['todos']
            .map((e) => TodoDto.fromJson(e))
            .cast<TodoDto>()
            .toList();

        final todoEntities = todoModels.map<Todo>((e) => e.toEntity()).toList();

        _controller.add(todoEntities);
      }
    });
  }

  @override
  Future<Todo> createTodo(String text, String userId) {
    final result = _todoDatasource.createTodo(text, userId);
    return result;
  }
}
