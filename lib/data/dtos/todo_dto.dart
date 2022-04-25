import 'package:graphql_test/domain/todo.dart';

class TodoDto {
  const TodoDto({
    required this.id,
    required this.text,
  });

  final String id;
  final String text;

  Todo toEntity() {
    return Todo(
      id: id,
      text: text,
    );
  }

  factory TodoDto.fromJson(Map<String, dynamic> json) {
    return TodoDto(
      id: json['id'],
      text: json['text'],
    );
  }
}
