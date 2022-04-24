import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_test/data/repository/todo_repository.dart';
import 'package:graphql_test/domain/todo.dart';
import 'package:injectable/injectable.dart';

part 'todo_event.dart';
part 'todo_state.dart';

@injectable
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(
    this._todoRepository,
  ) : super(const TodoState()) {
    _todoRepository.todos.listen((event) {
      add(TodoListChangedEvent(todos: event));
    });
    on<TodoListChangedEvent>(_onTodoListChanged);
    on<FetchTodosEvent>(_onFetchTodos);
    on<AddTodoEvent>(_onAddTodo);
  }

  final ITodoRepository _todoRepository;

  Future<void> _onTodoListChanged(
    TodoListChangedEvent event,
    Emitter<TodoState> emit,
  ) async {
    return emit(state.copyWith(todos: event.todos));
  }

  Future<void> _onFetchTodos(
    FetchTodosEvent event,
    Emitter<TodoState> emit,
  ) async {
    _todoRepository.getTodos();
  }

  Future<void> _onAddTodo(
    AddTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    await _todoRepository.createTodo(event.text, event.userId);
  }
}
