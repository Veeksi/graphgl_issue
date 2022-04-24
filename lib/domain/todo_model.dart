import 'package:graphql_test/domain/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required String id,
    required String text,
  }) : super(
          id: id,
          text: text,
        );

  Todo toEntity() {
    return Todo(
      id: id,
      text: text,
    );
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      text: json['text'],
    );
  }
}
