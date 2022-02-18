import 'package:graphql_test/domain/character.dart';
import 'package:graphql_test/domain/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required String id,
    required String text,
    required bool done,
  }) : super(
          id: id,
          text: text,
          done: done,
        );

  Todo toEntity() {
    return Todo(
      id: id,
      text: text,
      done: done,
    );
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      text: json['text'],
      done: json['done'],
    );
  }
}
