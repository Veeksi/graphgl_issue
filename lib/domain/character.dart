import 'package:equatable/equatable.dart';

class Character extends Equatable {
  const Character({
    required this.name,
  });

  final String name;

  @override
  List<Object?> get props => [name];
}
