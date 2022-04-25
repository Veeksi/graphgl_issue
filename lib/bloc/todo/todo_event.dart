part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class FetchTodosEvent extends TodoEvent {}

class TodoListUpdateErrorEvent extends TodoEvent {}

class TodoListChangedEvent extends TodoEvent {
  const TodoListChangedEvent({
    required this.todos,
  });
  
  final List<Todo> todos;
}

class AddTodoEvent extends TodoEvent {
  const AddTodoEvent({
    required this.text,
    required this.userId,
  });

  final String text;
  final String userId;
}
