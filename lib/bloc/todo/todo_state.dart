part of 'todo_bloc.dart';

enum TodoStatus {
  loading,
  data,
  error,
  updateError,
  addingTodo,
  todoAdded,
}

class TodoState extends Equatable {
  const TodoState({
    this.todos = const <Todo>[],
    this.status = TodoStatus.loading,
  });

  final List<Todo> todos;
  final TodoStatus status;

  TodoState copyWith({
    List<Todo>? todos,
    TodoStatus? status,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [todos, status];
}
