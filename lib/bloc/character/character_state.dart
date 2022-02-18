part of 'character_bloc.dart';

enum CharacterStatus {
  loading,
  data,
  error,
  updated,
}

class CharacterState extends Equatable {
  const CharacterState({
    this.characters = const <Character>[],
    this.status = CharacterStatus.loading,
  });

  final List<Character> characters;
  final CharacterStatus status;

  CharacterState copyWith({
    List<Character>? characters,
    CharacterStatus? status,
  }) {
    return CharacterState(
      characters: characters ?? this.characters,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [characters, status];
}
