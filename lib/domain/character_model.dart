import 'package:graphql_test/domain/character.dart';

class CharacterModel extends Character {
  const CharacterModel({
    required String name,
  }) : super(
          name: name,
        );

  Character toEntity() {
    return Character(
      name: name,
    );
  }

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      name: json['name'],
    );
  }
}