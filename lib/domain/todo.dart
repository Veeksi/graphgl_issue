import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  const Todo({
    required this.id,
    required this.text,
  });

  final String id;
  final String text;

  @override
  List<Object?> get props => [
        id,
        text,
      ];
}
