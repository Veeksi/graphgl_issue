// ignore_for_file: avoid_dynamic_calls

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_test/domain/character.dart';
import 'package:graphql_test/domain/character_model.dart';
import 'package:graphql_test/main.dart';
import 'package:injectable/injectable.dart';

abstract class ICharacterDatasource {
  Future<List<Character>> getCharacters();
}

@LazySingleton(as: ICharacterDatasource)
class CharacterDatasource implements ICharacterDatasource {
  CharacterDatasource(this._client);

  final GraphQLClient _client;

  @override
  Future<List<Character>> getCharacters() async {
    final result = await _client.query(
      QueryOptions(
        document: gql(GqlQuery.charactersQuery),
        variables: {'page': 1},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    print('DEBUG: ${[result.source, result.exception]}');
    print('DEBUG: ----------------------------------------\n');
    print('DEBUG: ${[result.data, result.exception]}');

    final List<CharacterModel> models = result.data?['characters']['results']
        .map((e) => CharacterModel.fromJson(e))
        .cast<CharacterModel>()
        .toList();

    final data = models.map<Character>((e) => e.toEntity()).toList();

    return data;
  }
}
