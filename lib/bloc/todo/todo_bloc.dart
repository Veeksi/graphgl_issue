import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_test/data/todo_datasource.dart';
import 'package:graphql_test/domain/todo.dart';
import 'package:injectable/injectable.dart';

part 'todo_event.dart';
part 'todo_state.dart';

@injectable
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(
    this._todoDatasource,
  ) : super(const TodoState()) {
    on<FetchTodosEvent>(_onFetchTodos);
    on<AddTodoEvent>(_onAddTodo);
  }

  Future<void> _onFetchTodos(
    FetchTodosEvent event,
    Emitter<TodoState> emit,
  ) async {
    final result = await _todoDatasource.getTodos();
    return emit(
      state.copyWith(
        todos: result,
      ),
    );
  }

  Future<void> _onAddTodo(
    AddTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    await _todoDatasource.createTodo(event.text, event.userId);

    // We want to emit state change but not add it to list because we add it with refresh
    return emit(
      state.copyWith(
        status: TodoStatus.todoAdded,
      ),
    );
  }

  final ITodoDatasource _todoDatasource;
}
