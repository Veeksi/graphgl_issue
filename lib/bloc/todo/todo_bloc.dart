import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_test/data/repository/todo_repository.dart';
import 'package:graphql_test/domain/todo.dart';
import 'package:injectable/injectable.dart';
import 'dart:developer' as developer;

part 'todo_event.dart';
part 'todo_state.dart';

@injectable
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(
    this._todoRepository,
  ) : super(const TodoState()) {
    _todoListSubscription = _todoRepository.todos.listen(
      (event) {
        add(TodoListChangedEvent(todos: event));
      },
      onError: (error) {
        if (error is QueryResult<Object?>) {
          developer.log(
            'DEBUG: Function ${error.exception?.linkException?.originalException}',
          );
          add(TodoListUpdateErrorEvent());
        }
      },
    );
    on<TodoListChangedEvent>(_onTodoListChanged);
    on<TodoListUpdateErrorEvent>(_onTodoListUpdateError);
    on<FetchTodosEvent>(_onFetchTodos);
    on<AddTodoEvent>(_onAddTodo);
  }

  final ITodoRepository _todoRepository;
  late StreamSubscription<List<Todo>> _todoListSubscription;

  @override
  Future<void> close() {
    _todoListSubscription.cancel();
    return super.close();
  }

  Future<void> _onTodoListChanged(
    TodoListChangedEvent event,
    Emitter<TodoState> emit,
  ) async {
    return emit(state.copyWith(status: TodoStatus.data, todos: event.todos));
  }

  Future<void> _onTodoListUpdateError(
    TodoListUpdateErrorEvent event,
    Emitter<TodoState> emit,
  ) async {
    return emit(state.copyWith(status: TodoStatus.updateError));
  }

  Future<void> _onFetchTodos(
    FetchTodosEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(state.copyWith(status: TodoStatus.loading));
    _todoRepository.getTodos();
  }

  Future<void> _onAddTodo(
    AddTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      emit(state.copyWith(status: TodoStatus.addingTodo));
      await _todoRepository.createTodo(event.text, event.userId);
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error));
    }
  }
}
